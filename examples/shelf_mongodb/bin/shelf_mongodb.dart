import 'dart:io';

import 'package:awesome_dart_auth/awesome_dart_auth.dart';
import 'package:awesome_dart_auth_shelf/awesome_dart_auth_shelf.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

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

Future<void> main() async {
  final config = AuthConfig.development(jwtSecret: 'development-secret');
  final router = AuthRouter(
    config: config,
    authService: AuthService(
      config: config,
      userStore: _UserStore(),
      sessionStore: _SessionStore(),
    ),
  );
  final app = Router()
    ..get('/', (_) => Response.ok('Shelf example is running'));
  final handler = const Pipeline()
      .addMiddleware(awesomeDartAuthShelfMiddleware(router))
      .addHandler(app.call);

  final server = await shelf_io.serve(
    handler,
    InternetAddress.loopbackIPv4,
    8080,
  );
  stdout.writeln('Listening on http://${server.address.host}:${server.port}');
}
