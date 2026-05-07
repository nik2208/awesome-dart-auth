import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../config/auth_config.dart';
import '../idp/openid_endpoints.dart';
import '../models/auth_user.dart';
import '../services/auth_service.dart';
import '../templates/template_renderer.dart';
import '../ui/embedded_assets.dart';
import 'openapi_document.dart';

/// Shelf router exposing the built-in awesome-dart-auth endpoints.
class AuthRouter {
  /// Creates the auth router.
  AuthRouter({
    required this.config,
    required this.authService,
    TemplateRenderer? templateRenderer,
  }) : templateRenderer = templateRenderer ?? TemplateRenderer(config: config) {
    _registerRoutes();
  }

  /// Runtime auth configuration.
  final AuthConfig config;

  /// Core auth service.
  final AuthService authService;

  /// Template renderer backing localized mail rendering.
  final TemplateRenderer templateRenderer;

  final Router _router = Router();

  /// Returns the underlying Shelf handler.
  Handler get handler => _router.call;

  void _registerRoutes() {
    _router.get('/health', (_) => _json(<String, Object?>{'status': 'ok'}));

    _router.get(config.adminUiPath, (_) {
      if (!config.enableAdminUi) {
        return Response.notFound('admin ui disabled');
      }
      return Response.ok(
        embeddedAdminUi,
        headers: const {'content-type': 'text/html; charset=utf-8'},
      );
    });

    _router.get(config.authUiPath, (_) {
      if (!config.enableAuthUi) {
        return Response.notFound('auth ui disabled');
      }
      return Response.ok(
        embeddedAuthUi,
        headers: const {'content-type': 'text/html; charset=utf-8'},
      );
    });

    _router.get(
      config.authJsPath,
      (_) => Response.ok(
        embeddedAuthJs,
        headers: const {
          'content-type': 'application/javascript; charset=utf-8',
        },
      ),
    );

    _router.get(
      config.openApiPath,
      (_) => _json(buildOpenApiDocument(config)),
    );

    _router.get(config.discoveryPath, (_) {
      if (!config.enableIdpMode) {
        return Response.notFound('idp mode disabled');
      }
      return _json(openIdDiscoveryDocument(config));
    });

    _router.get(config.jwksPath, (_) => _json(jsonWebKeySet()));

    _router.get(config.userInfoPath, (Request request) {
      final authorization = request.headers['authorization'];
      if (authorization == null || !authorization.startsWith('Bearer ')) {
        return Response.forbidden('missing bearer token');
      }
      final claims = authService.verifyToken(
        authorization.substring('Bearer '.length),
      );
      return _json(<String, Object?>{
        'sub': claims['sub'],
        'email': claims['email'],
        'tenantId': claims['tenantId'],
        'roles': claims['roles'] is List
            ? claims['roles'] as List<Object?>
            : const <Object?>[],
      });
    });

    _router.post(config.tokenPath, (Request request) async {
      final body = await request.readAsString();
      final payload = body.isEmpty
          ? const <String, Object?>{}
          : Map<String, Object?>.from(
              jsonDecode(body) as Map<dynamic, dynamic>,
            );
      final user = AuthUser(
        id: (payload['userId'] as String?) ?? 'demo-user',
        email: (payload['email'] as String?) ?? 'demo@example.com',
        tenantId: payload['tenantId'] as String?,
        roles: (payload['roles'] as List<dynamic>? ?? const <dynamic>[])
            .whereType<String>()
            .toList(growable: false),
        providers: (payload['providers'] as List<dynamic>? ?? const <dynamic>[])
            .whereType<String>()
            .toList(growable: false),
      );
      final tokenPair = await authService.issueTokenPair(
        user: user,
        scopes: (payload['scopes'] as List<dynamic>? ?? const <dynamic>[])
            .whereType<String>()
            .toSet(),
      );
      return _json(tokenPair.toJson());
    });
  }

  Response _json(Map<String, Object?> payload) => Response.ok(
    jsonEncode(payload),
    headers: const {'content-type': 'application/json; charset=utf-8'},
  );
}
