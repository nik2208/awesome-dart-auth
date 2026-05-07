import 'dart:convert';
import 'dart:math';

import 'package:awesome_dart_auth/src/config/auth_callbacks.dart';
import 'package:awesome_dart_auth/src/config/auth_config.dart';
import 'package:awesome_dart_auth/src/idp/openid_endpoints.dart';
import 'package:awesome_dart_auth/src/models/auth_user.dart';
import 'package:awesome_dart_auth/src/routing/openapi_document.dart';
import 'package:awesome_dart_auth/src/services/auth_service.dart';
import 'package:awesome_dart_auth/src/templates/template_renderer.dart';
import 'package:awesome_dart_auth/src/ui/embedded_assets.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// Shelf router exposing the built-in awesome-dart-auth endpoints.
class AuthRouter {
  /// Creates the auth router.
  AuthRouter({
    required this.config,
    required this.authService,
    TemplateRenderer? templateRenderer,
    AuthCallbacks? callbacks,
  }) : templateRenderer =
           templateRenderer ?? TemplateRenderer(config: config),
       callbacks = callbacks ?? const AuthCallbacks() {
    _registerRoutes();
  }

  /// Runtime auth configuration.
  final AuthConfig config;

  /// Core auth service.
  final AuthService authService;

  /// Template renderer backing localized mail rendering.
  final TemplateRenderer templateRenderer;

  /// Optional side-effect callbacks for auth flows.
  final AuthCallbacks callbacks;

  final Router _router = Router();

  /// Returns the underlying Shelf handler.
  Handler get handler => _router.call;

  void _registerRoutes() {
    _router
      ..get('/health', (_) => _ok({'status': 'ok'}))
      ..get(config.adminUiPath, (_) {
        if (!config.enableAdminUi) {
          return Response.notFound('admin ui disabled');
        }
        return Response.ok(
          embeddedAdminUi,
          headers: const {'content-type': 'text/html; charset=utf-8'},
        );
      })
      ..get(config.authUiPath, (_) {
        if (!config.enableAuthUi) {
          return Response.notFound('auth ui disabled');
        }
        return Response.ok(
          embeddedAuthUi,
          headers: const {'content-type': 'text/html; charset=utf-8'},
        );
      })
      ..get(
        config.authJsPath,
        (_) => Response.ok(
          embeddedAuthJs,
          headers: const {
            'content-type': 'application/javascript; charset=utf-8',
          },
        ),
      )
      ..get('${config.apiBasePath}/ui/config', (_) => _ok(config.uiConfig))
      ..get(config.openApiPath, (_) => _ok(buildOpenApiDocument(config)))
      ..get(config.discoveryPath, (_) {
        if (!config.enableIdpMode) {
          return Response.notFound('idp mode disabled');
        }
        return _ok(openIdDiscoveryDocument(config));
      })
      ..get(config.jwksPath, (_) => _ok(jsonWebKeySet()))
      ..get(config.userInfoPath, (Request request) {
        final token = _extractBearer(request);
        if (token == null) return Response.forbidden('missing bearer token');
        final claims = authService.verifyToken(token);
        return _ok(<String, Object?>{
          'sub': claims['sub'],
          'email': claims['email'],
          'tenantId': claims['tenantId'],
          'roles': claims['roles'] is List
              ? claims['roles']! as List<Object?>
              : const <Object?>[],
        });
      })
      ..post(config.tokenPath, (Request request) async {
        final payload = await _readJson(request);
        final user = AuthUser(
          id: (payload['userId'] as String?) ?? 'demo-user',
          email: (payload['email'] as String?) ?? 'demo@example.com',
          tenantId: payload['tenantId'] as String?,
          roles: _stringList(payload['roles']),
          providers: _stringList(payload['providers']),
        );
        final tokenPair = await authService.issueTokenPair(
          user: user,
          scopes: Set<String>.from(_stringList(payload['scopes'])),
        );
        return _ok(tokenPair.toJson());
      });

    _registerSessionRoutes();
    _registerAccountRoutes();
    _register2faRoutes();
    _registerMagicLinkRoutes();
    _registerSmsRoutes();
    _registerDeviceSessionRoutes();
    _registerOAuthRoutes();
    _registerLinkingRoutes();
  }

  // ---------------------------------------------------------------------------
  // Session (login / register / logout / me / refresh)
  // ---------------------------------------------------------------------------

  void _registerSessionRoutes() {
    _router
      ..post('${config.apiBasePath}/register', (Request request) async {
        final body = await _readJson(request);
        final email = body['email'] as String?;
        final password = body['password'] as String?;
        if (email == null || email.isEmpty) {
          return _badRequest('email is required');
        }
        if (password == null || password.isEmpty) {
          return _badRequest('password is required');
        }
        try {
          var user = await authService.register(
            email: email,
            password: password,
            firstName: body['firstName'] as String?,
            lastName: body['lastName'] as String?,
          );
          final onRegister = callbacks.onRegister;
          if (onRegister != null) user = await onRegister(user);
          final tokenPair = await authService.issueTokenPair(
            user: user,
            userAgent: request.headers['user-agent'],
          );
          return _ok(<String, Object?>{
            'user': _userPayload(user),
            ...tokenPair.toJson(),
          });
        } on RegistrationException catch (e) {
          return _badRequest(e.message);
        }
      })
      ..post('${config.apiBasePath}/login', (Request request) async {
        final body = await _readJson(request);
        final email = body['email'] as String?;
        final password = body['password'] as String?;
        if (email == null || password == null) {
          return _badRequest('email and password are required');
        }
        try {
          final user =
              await authService.login(email: email, password: password);
          if (user.totpEnabled) {
            return _ok(<String, Object?>{
              'requiresTwoFactor': true,
              'userId': user.id,
            });
          }
          final tokenPair = await authService.issueTokenPair(
            user: user,
            userAgent: request.headers['user-agent'],
          );
          return _ok(<String, Object?>{
            'user': _userPayload(user),
            ...tokenPair.toJson(),
          });
        } on AuthenticationException catch (e) {
          return _authError(e.message);
        }
      })
      ..post('${config.apiBasePath}/logout', (Request request) async {
        final token = _extractBearer(request);
        if (token != null) {
          try {
            final claims = authService.verifyToken(token);
            final sid = claims['sid'] as String?;
            if (sid != null) await authService.sessionStore.revoke(sid);
          } on JWTException {
            // Ignore invalid tokens during logout.
          }
        }
        return _ok({'ok': true});
      })
      ..get('${config.apiBasePath}/me', (Request request) async {
        final user = await _requireAuth(request);
        if (user == null) return _unauthorized();
        return _ok(_userPayload(user));
      })
      ..post('${config.apiBasePath}/refresh', (Request request) async {
        final body = await _readJson(request);
        final refreshToken = body['refreshToken'] as String?;
        if (refreshToken == null || refreshToken.isEmpty) {
          return _badRequest('refreshToken is required');
        }
        try {
          final tokenPair =
              await authService.refreshTokenPair(refreshToken);
          return _ok(tokenPair.toJson());
        } on AuthenticationException catch (e) {
          return _authError(e.message);
        }
      });
  }

  // ---------------------------------------------------------------------------
  // Account management
  // ---------------------------------------------------------------------------

  void _registerAccountRoutes() {
    _router
      ..patch('${config.apiBasePath}/profile', (Request request) async {
        final user = await _requireAuth(request);
        if (user == null) return _unauthorized();
        final body = await _readJson(request);
        final updated = user.copyWith(
          firstName: body.containsKey('firstName')
              ? body['firstName'] as String?
              : user.firstName,
          lastName: body.containsKey('lastName')
              ? body['lastName'] as String?
              : user.lastName,
          updatedAt: DateTime.now().toUtc(),
        );
        final saved = await authService.userStore.update(updated);
        return _ok(_userPayload(saved));
      })
      ..delete('${config.apiBasePath}/account', (Request request) async {
        final user = await _requireAuth(request);
        if (user == null) return _unauthorized();
        await authService.userStore.delete(user.id);
        return _ok({'ok': true});
      })
      ..post(
        '${config.apiBasePath}/forgot-password',
        (Request request) async {
          final body = await _readJson(request);
          final email = body['email'] as String?;
          if (email == null) return _badRequest('email is required');
          final user = await authService.userStore.findByEmail(email);
          if (user != null) {
            final token = authService.generateRandomToken();
            final cb = callbacks.onForgotPassword;
            if (cb == null) {
              return _notImplemented(
                'onForgotPassword callback not configured',
              );
            }
            await cb(user, token);
          }
          return _ok({'ok': true});
        },
      )
      ..post('${config.apiBasePath}/reset-password', (_) => _notImplemented(
        'Supply a token verification store to enable password reset.',
      ))
      ..post(
        '${config.apiBasePath}/change-password',
        (Request request) async {
          final user = await _requireAuth(request);
          if (user == null) return _unauthorized();
          final body = await _readJson(request);
          final currentPassword = body['currentPassword'] as String?;
          final newPassword = body['newPassword'] as String?;
          if (currentPassword == null || newPassword == null) {
            return _badRequest(
              'currentPassword and newPassword are required',
            );
          }
          final hash = user.passwordHash;
          if (hash == null ||
              !authService.verifyPassword(currentPassword, hash)) {
            return _authError('Current password is incorrect.');
          }
          final updated = user.copyWith(
            passwordHash: authService.hashPassword(newPassword),
            updatedAt: DateTime.now().toUtc(),
          );
          await authService.userStore.update(updated);
          return _ok({'ok': true});
        },
      )
      ..post(
        '${config.apiBasePath}/send-verification-email',
        (Request request) async {
          final user = await _requireAuth(request);
          if (user == null) return _unauthorized();
          final cb = callbacks.onSendVerificationEmail;
          if (cb == null) {
            return _notImplemented(
              'onSendVerificationEmail callback not configured',
            );
          }
          await cb(user, authService.generateRandomToken());
          return _ok({'ok': true});
        },
      )
      ..get(
        '${config.apiBasePath}/verify-email',
        (_) => _notImplemented(
          'Supply a token verification store to enable email verification.',
        ),
      )
      ..post(
        '${config.apiBasePath}/change-email/request',
        (Request request) async {
          final user = await _requireAuth(request);
          if (user == null) return _unauthorized();
          final body = await _readJson(request);
          final newEmail = body['newEmail'] as String?;
          if (newEmail == null) return _badRequest('newEmail is required');
          final cb = callbacks.onSendVerificationEmail;
          if (cb == null) {
            return _notImplemented(
              'onSendVerificationEmail callback not configured',
            );
          }
          await cb(user, authService.generateRandomToken());
          return _ok({'ok': true});
        },
      )
      ..post(
        '${config.apiBasePath}/change-email/confirm',
        (_) => _notImplemented(
          'Supply a token verification store to enable email-change '
          'confirmation.',
        ),
      );
  }

  // ---------------------------------------------------------------------------
  // TOTP / 2FA
  // ---------------------------------------------------------------------------

  void _register2faRoutes() {
    _router
      ..post('${config.apiBasePath}/2fa/setup', (Request request) async {
        final user = await _requireAuth(request);
        if (user == null) return _unauthorized();
        final secret = authService.generateTotpSecret();
        return _ok(<String, Object?>{
          'secret': secret,
          'otpAuthUrl':
              'otpauth://totp/'
              '${Uri.encodeComponent(config.issuer)}'
              ':${Uri.encodeComponent(user.email)}'
              '?secret=$secret'
              '&issuer=${Uri.encodeComponent(config.issuer)}',
        });
      })
      ..post(
        '${config.apiBasePath}/2fa/verify-setup',
        (Request request) async {
          final user = await _requireAuth(request);
          if (user == null) return _unauthorized();
          final body = await _readJson(request);
          final secret = body['secret'] as String?;
          final code = body['code'] as String?;
          if (secret == null || code == null) {
            return _badRequest('secret and code are required');
          }
          if (!authService.verifyTotpCode(secret, code)) {
            return _badRequest('Invalid TOTP code');
          }
          await authService.userStore.update(
            user.copyWith(
              totpSecret: secret,
              totpEnabled: true,
              updatedAt: DateTime.now().toUtc(),
            ),
          );
          return _ok({'ok': true});
        },
      )
      ..post('${config.apiBasePath}/2fa/verify', (Request request) async {
        final body = await _readJson(request);
        final userId = body['userId'] as String?;
        final code = body['code'] as String?;
        if (userId == null || code == null) {
          return _badRequest('userId and code are required');
        }
        final user = await authService.userStore.findById(userId);
        if (user == null) return _unauthorized();
        final secret = user.totpSecret;
        if (secret == null || !user.totpEnabled) {
          return _badRequest('TOTP not enabled for this user');
        }
        if (!authService.verifyTotpCode(secret, code)) {
          return _authError('Invalid TOTP code.');
        }
        final tokenPair = await authService.issueTokenPair(
          user: user,
          userAgent: request.headers['user-agent'],
        );
        return _ok(<String, Object?>{
          'user': _userPayload(user),
          ...tokenPair.toJson(),
        });
      })
      ..post('${config.apiBasePath}/2fa/disable', (Request request) async {
        final user = await _requireAuth(request);
        if (user == null) return _unauthorized();
        await authService.userStore.update(
          user.copyWith(
            totpSecret: null,
            totpEnabled: false,
            updatedAt: DateTime.now().toUtc(),
          ),
        );
        return _ok({'ok': true});
      });
  }

  // ---------------------------------------------------------------------------
  // Magic link
  // ---------------------------------------------------------------------------

  void _registerMagicLinkRoutes() {
    _router
      ..post(
        '${config.apiBasePath}/magic-link/send',
        (Request request) async {
          final body = await _readJson(request);
          final email = body['email'] as String?;
          if (email == null) return _badRequest('email is required');
          final user = await authService.userStore.findByEmail(email);
          if (user != null) {
            final cb = callbacks.onMagicLinkSend;
            if (cb == null) {
              return _notImplemented(
                'onMagicLinkSend callback not configured',
              );
            }
            await cb(user, authService.generateRandomToken());
          }
          return _ok({'ok': true});
        },
      )
      ..post(
        '${config.apiBasePath}/magic-link/verify',
        (Request request) async {
          final body = await _readJson(request);
          final token = body['token'] as String?;
          final mode = (body['mode'] as String?) ?? 'login';
          if (token == null) return _badRequest('token is required');
          final cb = callbacks.onMagicLinkVerify;
          if (cb == null) {
            return _notImplemented(
              'onMagicLinkVerify callback not configured',
            );
          }
          final userId = await cb(token, mode);
          if (userId == null) {
            return _authError('Invalid or expired magic link.');
          }
          final user = await authService.userStore.findById(userId);
          if (user == null) return _unauthorized();
          final tokenPair = await authService.issueTokenPair(
            user: user,
            userAgent: request.headers['user-agent'],
          );
          return _ok(<String, Object?>{
            'user': _userPayload(user),
            ...tokenPair.toJson(),
          });
        },
      );
  }

  // ---------------------------------------------------------------------------
  // SMS OTP
  // ---------------------------------------------------------------------------

  void _registerSmsRoutes() {
    _router
      ..post('${config.apiBasePath}/sms/send', (Request request) async {
        final body = await _readJson(request);
        final email = body['email'] as String?;
        if (email == null) return _badRequest('email is required');
        final user = await authService.userStore.findByEmail(email);
        if (user != null) {
          final cb = callbacks.onSmsSend;
          if (cb == null) {
            return _notImplemented('onSmsSend callback not configured');
          }
          await cb(user, _sixDigitOtp());
        }
        return _ok({'ok': true});
      })
      ..post('${config.apiBasePath}/sms/verify', (Request request) async {
        final body = await _readJson(request);
        final email = body['email'] as String?;
        final code = body['code'] as String?;
        if (email == null || code == null) {
          return _badRequest('email and code are required');
        }
        final user = await authService.userStore.findByEmail(email);
        if (user == null) return _unauthorized();
        final cb = callbacks.onSmsVerify;
        if (cb == null) {
          return _notImplemented('onSmsVerify callback not configured');
        }
        if (!await cb(user, code)) return _authError('Invalid OTP code.');
        final tokenPair = await authService.issueTokenPair(
          user: user,
          userAgent: request.headers['user-agent'],
        );
        return _ok(<String, Object?>{
          'user': _userPayload(user),
          ...tokenPair.toJson(),
        });
      })
      ..post('${config.apiBasePath}/add-phone', (Request request) async {
        final user = await _requireAuth(request);
        if (user == null) return _unauthorized();
        final body = await _readJson(request);
        final phone = body['phoneNumber'] as String?;
        if (phone == null) return _badRequest('phoneNumber is required');
        await authService.userStore.update(
          user.copyWith(
            phoneNumber: phone,
            updatedAt: DateTime.now().toUtc(),
          ),
        );
        return _ok({'ok': true});
      });
  }

  // ---------------------------------------------------------------------------
  // Device / session management
  // ---------------------------------------------------------------------------

  void _registerDeviceSessionRoutes() {
    _router
      ..get('${config.apiBasePath}/sessions', (Request request) async {
        final user = await _requireAuth(request);
        if (user == null) return _unauthorized();
        return _ok(<String, Object?>{
          'sessions': <Object?>[],
          'note':
              'Implement listByUserId on your SessionStore to populate '
              'this list.',
        });
      })
      ..delete(
        '${config.apiBasePath}/sessions/<handle>',
        (Request request, String handle) async {
          final user = await _requireAuth(request);
          if (user == null) return _unauthorized();
          await authService.sessionStore.revoke(handle);
          return _ok({'ok': true});
        },
      );
  }

  // ---------------------------------------------------------------------------
  // OAuth
  // ---------------------------------------------------------------------------

  void _registerOAuthRoutes() {
    _router
      ..get(
        '${config.apiBasePath}/oauth/<provider>',
        (Request request, String provider) async {
          final cb = callbacks.onOAuthStart;
          if (cb == null) {
            return _notImplemented('onOAuthStart callback not configured');
          }
          final redirectUri =
              request.url.queryParameters['redirect_uri'] ?? '';
          return Response.found(await cb(provider, redirectUri));
        },
      )
      ..get(
        '${config.apiBasePath}/oauth/<provider>/callback',
        (Request request, String provider) async {
          final cb = callbacks.onOAuthCallback;
          if (cb == null) {
            return _notImplemented(
              'onOAuthCallback callback not configured',
            );
          }
          final code = request.url.queryParameters['code'] ?? '';
          final redirectUri =
              request.url.queryParameters['redirect_uri'] ?? '';
          final profile = await cb(provider, code, redirectUri);
          AuthUser? user;
          if (profile.email != null) {
            user = await authService.userStore.findByEmail(profile.email!);
          }
          user ??= await authService.userStore.save(
            AuthUser(
              id: authService.generateRandomToken(byteLength: 12),
              email: profile.email ??
                  '${profile.externalId}@${profile.provider}.oauth',
              providers: [profile.provider],
              createdAt: DateTime.now().toUtc(),
            ),
          );
          final tokenPair = await authService.issueTokenPair(
            user: user,
            userAgent: request.headers['user-agent'],
          );
          return _ok(<String, Object?>{
            'user': _userPayload(user),
            ...tokenPair.toJson(),
          });
        },
      );
  }

  // ---------------------------------------------------------------------------
  // Account linking
  // ---------------------------------------------------------------------------

  void _registerLinkingRoutes() {
    _router
      ..post(
        '${config.apiBasePath}/link-request',
        (Request request) async {
          final user = await _requireAuth(request);
          if (user == null) return _unauthorized();
          final body = await _readJson(request);
          final provider = body['provider'] as String?;
          if (provider == null) return _badRequest('provider is required');
          final cb = callbacks.onLinkRequest;
          if (cb == null) {
            return _notImplemented('onLinkRequest callback not configured');
          }
          return _ok({'token': await cb(user, provider, body)});
        },
      )
      ..post(
        '${config.apiBasePath}/link-verify',
        (Request request) async {
          final user = await _requireAuth(request);
          if (user == null) return _unauthorized();
          final body = await _readJson(request);
          final token = body['token'] as String?;
          final provider = body['provider'] as String?;
          if (token == null || provider == null) {
            return _badRequest('token and provider are required');
          }
          final cb = callbacks.onLinkVerify;
          if (cb == null) {
            return _notImplemented('onLinkVerify callback not configured');
          }
          if (!await cb(user, token, provider)) {
            return _badRequest('Invalid or expired link token');
          }
          return _ok({'ok': true});
        },
      )
      ..get(
        '${config.apiBasePath}/linked-accounts',
        (Request request) async {
          final user = await _requireAuth(request);
          if (user == null) return _unauthorized();
          return _ok({'providers': user.providers});
        },
      )
      ..delete(
        '${config.apiBasePath}/linked-accounts/<provider>/<id>',
        (Request request, String provider, String id) async {
          final user = await _requireAuth(request);
          if (user == null) return _unauthorized();
          await authService.userStore.update(
            user.copyWith(
              providers: user.providers
                  .where((p) => p != provider)
                  .toList(growable: false),
              updatedAt: DateTime.now().toUtc(),
            ),
          );
          return _ok({'ok': true});
        },
      );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Response _ok(Map<String, Object?> payload) => Response.ok(
    jsonEncode(payload),
    headers: const {'content-type': 'application/json; charset=utf-8'},
  );

  Response _badRequest(String message) => Response(
    400,
    body: jsonEncode({'error': message}),
    headers: const {'content-type': 'application/json; charset=utf-8'},
  );

  Response _unauthorized() => Response.unauthorized(
    jsonEncode({'error': 'Unauthorized'}),
    headers: const {'content-type': 'application/json; charset=utf-8'},
  );

  Response _authError(String message) => Response.unauthorized(
    jsonEncode({'error': message}),
    headers: const {'content-type': 'application/json; charset=utf-8'},
  );

  Response _notImplemented(String message) => Response(
    501,
    body: jsonEncode({'error': message}),
    headers: const {'content-type': 'application/json; charset=utf-8'},
  );

  Future<Map<String, Object?>> _readJson(Request request) async {
    final body = await request.readAsString();
    if (body.isEmpty) return const <String, Object?>{};
    try {
      return Map<String, Object?>.from(
        jsonDecode(body) as Map<dynamic, dynamic>,
      );
    } on FormatException {
      return const <String, Object?>{};
    }
  }

  String? _extractBearer(Request request) {
    final auth = request.headers['authorization'];
    if (auth == null || !auth.startsWith('Bearer ')) return null;
    return auth.substring('Bearer '.length);
  }

  Future<AuthUser?> _requireAuth(Request request) async {
    final token = _extractBearer(request);
    if (token == null) return null;
    try {
      final claims = authService.verifyToken(token);
      if (claims['typ'] != 'access') return null;
      final userId = claims['sub'] as String?;
      if (userId == null) return null;
      return authService.userStore.findById(userId);
    } on JWTException {
      return null;
    }
  }

  Map<String, Object?> _userPayload(AuthUser user) => <String, Object?>{
    'id': user.id,
    'email': user.email,
    if (user.firstName != null) 'firstName': user.firstName,
    if (user.lastName != null) 'lastName': user.lastName,
    if (user.phoneNumber != null) 'phoneNumber': user.phoneNumber,
    'providers': user.providers,
    'roles': user.roles,
    'isActive': user.isActive,
    'emailVerified': user.emailVerified,
    'totpEnabled': user.totpEnabled,
    'tenantId': user.tenantId,
    'createdAt': user.createdAt?.toIso8601String(),
    'updatedAt': user.updatedAt?.toIso8601String(),
  };

  List<String> _stringList(Object? value) =>
      (value as List<dynamic>? ?? const <dynamic>[])
          .whereType<String>()
          .toList(growable: false);

  String _sixDigitOtp() {
    final n = Random.secure().nextInt(1000000);
    return n.toString().padLeft(6, '0');
  }
}
