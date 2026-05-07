import 'package:awesome_dart_auth/awesome_dart_auth.dart';
import 'package:shelf/shelf.dart';

/// Returns a Shelf [Handler] for the supplied auth [router].
Handler awesomeDartAuthShelfHandler(AuthRouter router) => router.handler;

/// Prepends the auth router before the next Shelf handler in the chain.
Middleware awesomeDartAuthShelfMiddleware(AuthRouter router) {
  return (innerHandler) {
    return (request) async {
      final authResponse = await router.handler(request);
      if (authResponse.statusCode != 404) {
        return authResponse;
      }
      return innerHandler(request);
    };
  };
}
