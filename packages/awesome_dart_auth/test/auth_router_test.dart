import 'dart:convert';

import 'package:awesome_dart_auth/awesome_dart_auth.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

class _UserStore implements UserStore {
  @override
  Future<AuthUser?> findByEmail(String email) async => null;

  @override
  Future<AuthUser?> findById(String id) async => null;

  @override
  Future<AuthUser> save(AuthUser user) async => user;
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

void main() {
  group('AuthRouter', () {
    late AuthRouter router;

    setUp(() {
      final config = AuthConfig.development(jwtSecret: 'secret1234');
      router = AuthRouter(
        config: config,
        authService: AuthService(
          config: config,
          userStore: _UserStore(),
          sessionStore: _SessionStore(),
        ),
      );
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
      final body =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;

      expect(response.statusCode, 200);
      expect(body['accessToken'], isA<String>());
      expect(body['refreshToken'], isA<String>());
      expect(body['tokenType'], 'Bearer');
    });
  });
}
