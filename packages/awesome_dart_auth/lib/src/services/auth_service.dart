import 'dart:convert';
import 'dart:math';

import 'package:awesome_dart_auth/src/config/auth_config.dart';
import 'package:awesome_dart_auth/src/contracts/session_store.dart';
import 'package:awesome_dart_auth/src/contracts/telemetry_store.dart';
import 'package:awesome_dart_auth/src/contracts/user_store.dart';
import 'package:awesome_dart_auth/src/events/auth_event.dart';
import 'package:awesome_dart_auth/src/events/auth_event_bus.dart';
import 'package:awesome_dart_auth/src/models/auth_session.dart';
import 'package:awesome_dart_auth/src/models/auth_user.dart';
import 'package:awesome_dart_auth/src/models/token_pair.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:otp/otp.dart';

/// Thrown when authentication credentials are invalid.
class AuthenticationException implements Exception {
  /// Creates an authentication exception with a human-readable [message].
  const AuthenticationException(this.message);

  /// Human-readable description of the failure.
  final String message;

  @override
  String toString() => 'AuthenticationException: $message';
}

/// Thrown when a registration attempt fails (e.g. duplicate email).
class RegistrationException implements Exception {
  /// Creates a registration exception with a human-readable [message].
  const RegistrationException(this.message);

  /// Human-readable description of the failure.
  final String message;

  @override
  String toString() => 'RegistrationException: $message';
}

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
    );
  }

  /// Generates a random TOTP secret suitable for use with authenticator apps.
  String generateTotpSecret() {
    const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    final random = Random.secure();
    return List<String>.generate(
      32,
      (_) => alphabet[random.nextInt(alphabet.length)],
    ).join();
  }

  /// Verifies that [code] is a valid TOTP code for [secret].
  bool verifyTotpCode(String secret, String code, {DateTime? timestamp}) {
    final expected = generateTotpCode(secret, timestamp: timestamp);
    return expected == code;
  }

  /// Generates a cryptographically random URL-safe token.
  String generateRandomToken({int byteLength = 32}) {
    final random = Random.secure();
    final bytes = List<int>.generate(byteLength, (_) => random.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  /// Registers a new user with [email] and [password].
  ///
  /// Throws a [StateError] if a user with the same email already exists.
  Future<AuthUser> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
    String? tenantId,
    List<String> roles = const <String>[],
  }) async {
    final existing = await userStore.findByEmail(email);
    if (existing != null) {
      throw const RegistrationException('Email already in use');
    }
    final hash = hashPassword(password);
    final now = _clock().toUtc();
    final user = AuthUser(
      id: _randomId(),
      email: email,
      passwordHash: hash,
      firstName: firstName,
      lastName: lastName,
      tenantId: tenantId,
      roles: roles,
      createdAt: now,
      updatedAt: now,
    );
    final saved = await userStore.save(user);
    await _publishEvent(
      AuthEvent(
        type: 'identity.user.created',
        occurredAt: now,
        userId: saved.id,
        tenantId: tenantId,
      ),
    );
    return saved;
  }

  /// Authenticates [email] + [password] and returns the matching user.
  ///
  /// Throws [AuthenticationException] on failure.
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    final user = await userStore.findByEmail(email);
    if (user == null) {
      throw const AuthenticationException('Invalid email or password.');
    }
    if (!user.isActive) {
      throw const AuthenticationException('Account is inactive.');
    }
    final hash = user.passwordHash;
    if (hash == null || !verifyPassword(password, hash)) {
      await _publishEvent(
        AuthEvent(
          type: 'identity.auth.login.failed',
          occurredAt: _clock().toUtc(),
          userId: user.id,
          tenantId: user.tenantId,
        ),
      );
      throw const AuthenticationException('Invalid email or password.');
    }
    await _publishEvent(
      AuthEvent(
        type: 'identity.auth.login.success',
        occurredAt: _clock().toUtc(),
        userId: user.id,
        tenantId: user.tenantId,
      ),
    );
    return user;
  }

  /// Issues a new access and refresh token pair for [user].
  Future<TokenPair> issueTokenPair({
    required AuthUser user,
    Set<String> scopes = const <String>{},
    String? sessionId,
    String? userAgent,
    String? ipAddress,
  }) async {
    final issuedAt = _clock().toUtc();
    final effectiveSessionId = sessionId ?? _randomId();
    final session = AuthSession(
      id: effectiveSessionId,
      userId: user.id,
      tenantId: user.tenantId,
      handle: _sessionHandle(userAgent),
      userAgent: userAgent,
      ipAddress: ipAddress,
      createdAt: issuedAt,
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
        type: 'identity.session.created',
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

  /// Rotates a refresh-token session by revoking [oldSessionId] and issuing
  /// a new pair.
  Future<TokenPair> rotateRefreshToken({
    required String oldSessionId,
    required AuthUser user,
    Set<String> scopes = const <String>{},
  }) async {
    await sessionStore.revoke(oldSessionId);
    await _publishEvent(
      AuthEvent(
        type: 'identity.session.revoked',
        occurredAt: _clock().toUtc(),
        userId: user.id,
        tenantId: user.tenantId,
        payload: <String, Object?>{'sessionId': oldSessionId},
      ),
    );
    return issueTokenPair(user: user, scopes: scopes);
  }

  /// Verifies a refresh token and returns a fresh token pair.
  ///
  /// Validates the refresh token signature and optionally checks that the
  /// underlying session is still active (per [AuthConfig.sessionCheckOn]).
  Future<TokenPair> refreshTokenPair(String refreshToken) async {
    final claims = verifyToken(refreshToken);
    if (claims['typ'] != 'refresh') {
      throw const AuthenticationException('Invalid token type.');
    }
    final userId = claims['sub'] as String?;
    final sessionId = claims['sid'] as String?;
    if (userId == null || sessionId == null) {
      throw const AuthenticationException('Malformed refresh token.');
    }

    // Check session validity unless the caller opted out.
    if (config.sessionCheckOn != SessionCheckOn.none) {
      final session = await sessionStore.findById(sessionId);
      if (session == null || session.revoked) {
        throw const AuthenticationException('Session has been revoked.');
      }
      if (session.expiresAt.isBefore(_clock().toUtc())) {
        throw const AuthenticationException('Session has expired.');
      }
    }

    final user = await userStore.findById(userId);
    if (user == null) {
      throw const AuthenticationException('User not found.');
    }
    if (!user.isActive) {
      throw const AuthenticationException('Account is inactive.');
    }

    return rotateRefreshToken(
      oldSessionId: sessionId,
      user: user,
      scopes: {
        if (claims['scope'] is String)
          ...(claims['scope']! as String)
              .split(' ')
              .where((s) => s.isNotEmpty),
      },
    );
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

  String _sessionHandle(String? userAgent) {
    if (userAgent == null) return 'unknown';
    final ua = userAgent.toLowerCase();
    if (ua.contains('flutter')) return 'Flutter';
    if (ua.contains('dart')) return 'Dart';
    if (ua.contains('android')) return 'Android';
    if (ua.contains('iphone') || ua.contains('ipad')) return 'iOS';
    if (ua.contains('mac')) return 'macOS';
    if (ua.contains('windows')) return 'Windows';
    if (ua.contains('linux')) return 'Linux';
    return 'Browser';
  }
}
