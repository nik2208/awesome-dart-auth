import 'package:awesome_dart_auth/awesome_dart_auth.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:shelf/shelf.dart' as shelf;

/// Creates a Dart Frog handler that forwards requests to the core auth router.
Handler awesomeDartAuthHandler(AuthRouter router) {
  return (context) async {
    final request = await _toShelfRequest(context.request);
    final response = await router.handler(request);
    return _toDartFrogResponse(response);
  };
}

/// Creates middleware that injects the auth router before the downstream handler.
Middleware awesomeDartAuthMiddleware(AuthRouter router) {
  return (handler) {
    return (context) async {
      final response = await awesomeDartAuthHandler(router)(context);
      if (response.statusCode != 404) {
        return response;
      }
      return handler(context);
    };
  };
}

Future<shelf.Request> _toShelfRequest(Request request) async {
  return shelf.Request(
    request.method.value,
    request.uri,
    headers: request.headers,
    body: request.bytes(),
  );
}

Future<Response> _toDartFrogResponse(shelf.Response response) async {
  return Response.stream(
    statusCode: response.statusCode,
    body: response.read(),
    headers: Map<String, Object>.from(response.headers),
  );
}
