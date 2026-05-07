import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) => Response(
  body: 'Dart Frog example is running on ${context.request.uri.path}',
);
