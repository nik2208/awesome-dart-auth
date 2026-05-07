import 'dart:convert';
import 'dart:math';

import 'package:bcrypt/bcrypt.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:otp/otp.dart';

import '../config/auth_config.dart';
import '../contracts/session_store.dart';
import '../contracts/telemetry_store.dart';
import '../contracts/user_store.dart';
import '../events/auth_event.dart';
import '../events/auth_event_bus.dart';
import '../models/auth_session.dart';
import '../models/auth_user.dart';
import '../models/token_pair.dart';

/// Core authentication service that encapsulates token issuance and utilities.
class AuthService {
  /// Creates the core authentication service.
  AuthService({
    required this.config,
    required this.userStore,
    required this.sessionStore,
    this.telemetryStore,
    this.eventBus,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  /// Static runtime configuration.
  final AuthConfig config;

  /// User persistence contract.
  final UserStore userStore;

  /// Session persistence contract.
  final SessionStore sessionStore;

  /// Optional telemetry sink.
  final TelemetryStore? telemetryStore;

  /// Optional event bus.
  final AuthEventBus? eventBus;

  final DateTime Function() _clock;

  /// Hashes a password using bcrypt.
  String hashPassword(String password) {
    if (password.trim().length < 8) {
      throw ArgumentError.value(
        password,
        'password',
        'Password must be at least 8 characters long.',
      );
    }
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  /// Verifies a plaintext password against a stored bcrypt hash.
  bool verifyPassword(String password, String passwordHash) =>
      BCrypt.checkpw(password, passwordHash);

  /// Generates an RFC 6238 TOTP code for [secret].
  String generateTotpCode(String secret, {DateTime? timestamp}) {
    final now = (timestamp ?? _clock()).millisecondsSinceEpoch;
    return OTP.generateTOTPCodeString(
      secret,
      now,
      algorithm: Algorithm.SHA1,
      interval: 30,
      isGoogle: true,
    );
  }

  /// Issues a new access and refresh token pair for [user].
  Future<TokenPair> issueTokenPair({
    required AuthUser user,
    Set<String> scopes = const <String>{},
    String? sessionId,
  }) async {
    final issuedAt = _clock().toUtc();
    final effectiveSessionId = sessionId ?? _randomId();
    final session = AuthSession(
      id: effectiveSessionId,
      userId: user.id,
      tenantId: user.tenantId,
      expiresAt: issuedAt.add(config.refreshTokenTtl),
      scopes: scopes,
    );
    await sessionStore.save(session);

    final accessJwt = JWT(<String, Object?>{
      'sub': user.id,
      'email': user.email,
      'roles': user.roles,
      'providers': user.providers,
      'tenantId': user.tenantId,
      'scope': scopes.join(' '),
      'iss': config.issuer,
      'aud': config.audience.toList(growable: false),
      'typ': 'access',
      'iat': issuedAt.millisecondsSinceEpoch ~/ 1000,
    });
    final refreshJwt = JWT(<String, Object?>{
      'sub': user.id,
      'sid': effectiveSessionId,
      'tenantId': user.tenantId,
      'scope': scopes.join(' '),
      'iss': config.issuer,
      'aud': config.audience.toList(growable: false),
      'typ': 'refresh',
      'iat': issuedAt.millisecondsSinceEpoch ~/ 1000,
    });

    final accessToken = accessJwt.sign(
      SecretKey(config.jwtSecret),
      expiresIn: config.accessTokenTtl,
    );
    final refreshToken = refreshJwt.sign(
      SecretKey(config.jwtSecret),
      expiresIn: config.refreshTokenTtl,
    );

    await _publishEvent(
      AuthEvent(
        type: 'auth.token.issued',
        occurredAt: issuedAt,
        userId: user.id,
        tenantId: user.tenantId,
        payload: <String, Object?>{
          'sessionId': effectiveSessionId,
          'scopes': scopes.toList(growable: false),
        },
      ),
    );

    return TokenPair(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresInSeconds: config.accessTokenTtl.inSeconds,
    );
  }

  /// Rotates a refresh-token session by revoking [oldSessionId] and issuing a new pair.
  Future<TokenPair> rotateRefreshToken({
    required String oldSessionId,
    required AuthUser user,
    Set<String> scopes = const <String>{},
  }) async {
    await sessionStore.revoke(oldSessionId);
    return issueTokenPair(user: user, scopes: scopes);
  }

  /// Verifies a JWT signed by the configured shared secret.
  Map<String, Object?> verifyToken(String token) {
    final jwt = JWT.verify(token, SecretKey(config.jwtSecret));
    return Map<String, Object?>.from(jwt.payload as Map<Object?, Object?>);
  }

  Future<void> _publishEvent(AuthEvent event) async {
    if (config.enableTelemetry && telemetryStore != null) {
      await telemetryStore!.persist(event);
    }
    if (eventBus != null) {
      await eventBus!.publish(event);
    }
  }

  String _randomId() {
    final random = Random.secure();
    final bytes = List<int>.generate(18, (_) => random.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }
}
