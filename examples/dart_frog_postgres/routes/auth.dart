import 'package:awesome_dart_auth/awesome_dart_auth.dart';
import 'package:awesome_dart_auth_dart_frog/awesome_dart_auth_dart_frog.dart';
import 'package:dart_frog/dart_frog.dart';

class _UserStore implements UserStore {
  @override
  Future<AuthUser?> findByEmail(String email) async => null;

  @override
  Future<AuthUser?> findById(String id) async => null;

  @override
  Future<AuthUser> save(AuthUser user) async => user;
}

class _SessionStore implements SessionStore {
  @override
  Future<AuthSession?> findById(String id) async => null;

  @override
  Future<void> revoke(String id) async {}

  @override
  Future<void> save(AuthSession session) async {}
}

final _config = AuthConfig.development(jwtSecret: 'development-secret');
final _router = AuthRouter(
  config: _config,
  authService: AuthService(
    config: _config,
    userStore: _UserStore(),
    sessionStore: _SessionStore(),
  ),
);

Future<Response> onRequest(RequestContext context) async =>
    await awesomeDartAuthHandler(_router)(context);
