import 'dart:convert';

import 'package:awesome_dart_auth/awesome_dart_auth.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

// ---------------------------------------------------------------------------
// In-memory test stores
// ---------------------------------------------------------------------------

class _UserStore implements UserStore {
  final Map<String, AuthUser> _users = {};

  @override
  Future<AuthUser?> findByEmail(String email) async =>
      _users.values.where((u) => u.email == email).firstOrNull;

  @override
  Future<AuthUser?> findById(String id) async => _users[id];

  @override
  Future<AuthUser> save(AuthUser user) async {
    _users[user.id] = user;
    return user;
  }

  @override
  Future<AuthUser> update(AuthUser user) async {
    _users[user.id] = user;
    return user;
  }

  @override
  Future<void> delete(String id) async => _users.remove(id);
}

class _SessionStore implements SessionStore {
  final Map<String, AuthSession> sessions = <String, AuthSession>{};

  @override
  Future<AuthSession?> findById(String id) async => sessions[id];

  @override
  Future<void> revoke(String id) async {
    final session = sessions[id];
    if (session != null) {
      sessions[id] = session.copyWith(revoked: true);
    }
  }

  @override
  Future<void> save(AuthSession session) async {
    sessions[session.id] = session;
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Map<String, dynamic> _jsonBody(String body) =>
    jsonDecode(body) as Map<String, dynamic>;

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('AuthRouter', () {
    late AuthConfig config;
    late _UserStore userStore;
    late _SessionStore sessionStore;
    late AuthService service;
    late AuthRouter router;

    setUp(() {
      config = AuthConfig.development(jwtSecret: 'secret1234');
      userStore = _UserStore();
      sessionStore = _SessionStore();
      service = AuthService(
        config: config,
        userStore: userStore,
        sessionStore: sessionStore,
      );
      router = AuthRouter(config: config, authService: service);
    });

    test('serves embedded auth UI', () async {
      final response = await router.handler(
        Request('GET', Uri.parse('http://localhost/auth/ui')),
      );
      final body = await response.readAsString();

      expect(response.statusCode, 200);
      expect(body, contains('awesome-dart-auth'));
    });

    test('issues a token pair from POST /auth/token', () async {
      final response = await router.handler(
        Request(
          'POST',
          Uri.parse('http://localhost/auth/token'),
          body: jsonEncode(const {
            'userId': 'user-1',
            'email': 'user@example.com',
          }),
          headers: const {'content-type': 'application/json'},
        ),
      );
      final body = _jsonBody(await response.readAsString());

      expect(response.statusCode, 200);
      expect(body['accessToken'], isA<String>());
      expect(body['refreshToken'], isA<String>());
      expect(body['tokenType'], 'Bearer');
    });

    test('registers a new user via POST /auth/register', () async {
      final response = await router.handler(
        Request(
          'POST',
          Uri.parse('http://localhost/auth/register'),
          body: jsonEncode({
            'email': 'alice@example.com',
            'password': 'SecurePass1!',
          }),
          headers: const {'content-type': 'application/json'},
        ),
      );
      final body = _jsonBody(await response.readAsString());

      expect(response.statusCode, 200);
      expect(body['accessToken'], isA<String>());
      expect((body['user'] as Map<String, dynamic>)['email'], 'alice@example.com');
    });

    test('returns 400 when registering duplicate email', () async {
      const payload = {'email': 'bob@example.com', 'password': 'Password123'};
      await router.handler(
        Request(
          'POST',
          Uri.parse('http://localhost/auth/register'),
          body: jsonEncode(payload),
          headers: const {'content-type': 'application/json'},
        ),
      );
      final response = await router.handler(
        Request(
          'POST',
          Uri.parse('http://localhost/auth/register'),
          body: jsonEncode(payload),
          headers: const {'content-type': 'application/json'},
        ),
      );
      expect(response.statusCode, 400);
    });

    test('logs in and returns tokens via POST /auth/login', () async {
      await router.handler(
        Request(
          'POST',
          Uri.parse('http://localhost/auth/register'),
          body: jsonEncode({
            'email': 'carol@example.com',
            'password': 'MySecret99!',
          }),
          headers: const {'content-type': 'application/json'},
        ),
      );

      final response = await router.handler(
        Request(
          'POST',
          Uri.parse('http://localhost/auth/login'),
          body: jsonEncode({
            'email': 'carol@example.com',
            'password': 'MySecret99!',
          }),
          headers: const {'content-type': 'application/json'},
        ),
      );
      final body = _jsonBody(await response.readAsString());

      expect(response.statusCode, 200);
      expect(body['accessToken'], isA<String>());
    });

    test('returns 401 for wrong password via POST /auth/login', () async {
      await router.handler(
        Request(
          'POST',
          Uri.parse('http://localhost/auth/register'),
          body: jsonEncode({
            'email': 'dave@example.com',
            'password': 'CorrectPw1!',
          }),
          headers: const {'content-type': 'application/json'},
        ),
      );

      final response = await router.handler(
        Request(
          'POST',
          Uri.parse('http://localhost/auth/login'),
          body: jsonEncode({
            'email': 'dave@example.com',
            'password': 'WrongPw!',
          }),
          headers: const {'content-type': 'application/json'},
        ),
      );
      expect(response.statusCode, 401);
    });

    test('refreshes tokens via POST /auth/refresh', () async {
      final regResponse = await router.handler(
        Request(
          'POST',
          Uri.parse('http://localhost/auth/register'),
          body: jsonEncode({
            'email': 'eve@example.com',
            'password': 'StrongPw1!',
          }),
          headers: const {'content-type': 'application/json'},
        ),
      );
      final regBody = _jsonBody(await regResponse.readAsString());
      final refreshToken = regBody['refreshToken'] as String;

      final response = await router.handler(
        Request(
          'POST',
          Uri.parse('http://localhost/auth/refresh'),
          body: jsonEncode({'refreshToken': refreshToken}),
          headers: const {'content-type': 'application/json'},
        ),
      );
      final body = _jsonBody(await response.readAsString());

      expect(response.statusCode, 200);
      expect(body['accessToken'], isA<String>());
    });

    test('returns 401 from GET /auth/me when unauthenticated', () async {
      final response = await router.handler(
        Request('GET', Uri.parse('http://localhost/auth/me')),
      );
      expect(response.statusCode, 401);
    });

    test('returns user from GET /auth/me with valid token', () async {
      final regResponse = await router.handler(
        Request(
          'POST',
          Uri.parse('http://localhost/auth/register'),
          body: jsonEncode({
            'email': 'frank@example.com',
            'password': 'SecretPw1!',
          }),
          headers: const {'content-type': 'application/json'},
        ),
      );
      final regBody = _jsonBody(await regResponse.readAsString());
      final accessToken = regBody['accessToken'] as String;

      final meResponse = await router.handler(
        Request(
          'GET',
          Uri.parse('http://localhost/auth/me'),
          headers: {'authorization': 'Bearer $accessToken'},
        ),
      );
      final meBody = _jsonBody(await meResponse.readAsString());

      expect(meResponse.statusCode, 200);
      expect(meBody['email'], 'frank@example.com');
    });

    test('logouts via POST /auth/logout', () async {
      final regResponse = await router.handler(
        Request(
          'POST',
          Uri.parse('http://localhost/auth/register'),
          body: jsonEncode({
            'email': 'grace@example.com',
            'password': 'Password99!',
          }),
          headers: const {'content-type': 'application/json'},
        ),
      );
      final regBody = _jsonBody(await regResponse.readAsString());
      final accessToken = regBody['accessToken'] as String;

      final response = await router.handler(
        Request(
          'POST',
          Uri.parse('http://localhost/auth/logout'),
          headers: {'authorization': 'Bearer $accessToken'},
        ),
      );
      final body = _jsonBody(await response.readAsString());

      expect(response.statusCode, 200);
      expect(body['ok'], true);
    });

    test('TOTP setup returns secret + otpAuthUrl', () async {
      final regResponse = await router.handler(
        Request(
          'POST',
          Uri.parse('http://localhost/auth/register'),
          body: jsonEncode({
            'email': 'henry@example.com',
            'password': 'SafePw123!',
          }),
          headers: const {'content-type': 'application/json'},
        ),
      );
      final regBody = _jsonBody(await regResponse.readAsString());
      final accessToken = regBody['accessToken'] as String;

      final setupResponse = await router.handler(
        Request(
          'POST',
          Uri.parse('http://localhost/auth/2fa/setup'),
          headers: {'authorization': 'Bearer $accessToken'},
        ),
      );
      final setupBody = _jsonBody(await setupResponse.readAsString());

      expect(setupResponse.statusCode, 200);
      expect(setupBody['secret'], isA<String>());
      expect(setupBody['otpAuthUrl'], contains('otpauth://totp/'));
    });

    test('serves UI config from GET /auth/ui/config', () async {
      final customConfig = config.copyWith(
        uiConfig: {'theme': 'dark', 'brand': 'ACME'},
      );
      final customRouter = AuthRouter(
        config: customConfig,
        authService: service,
      );

      final response = await customRouter.handler(
        Request('GET', Uri.parse('http://localhost/auth/ui/config')),
      );
      final body = _jsonBody(await response.readAsString());

      expect(response.statusCode, 200);
      expect(body['theme'], 'dark');
    });

    test('openapi.json lists the full route surface', () async {
      final response = await router.handler(
        Request('GET', Uri.parse('http://localhost/auth/openapi.json')),
      );
      final body = _jsonBody(await response.readAsString());
      final paths = body['paths'] as Map<String, dynamic>;

      expect(paths.keys, contains('/auth/login'));
      expect(paths.keys, contains('/auth/register'));
      expect(paths.keys, contains('/auth/refresh'));
      expect(paths.keys, contains('/auth/me'));
      expect(paths.keys, contains('/auth/logout'));
      expect(paths.keys, contains('/auth/2fa/setup'));
      expect(paths.keys, contains('/auth/magic-link/send'));
    });
  });
}
