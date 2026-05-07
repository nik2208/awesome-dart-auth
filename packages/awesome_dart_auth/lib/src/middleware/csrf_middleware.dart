import 'dart:math';

import 'package:shelf/shelf.dart';

const _csrfCookieName = 'csrf-token';
const _csrfHeaderName = 'x-csrf-token';
const _bearerStrategyHeader = 'x-auth-strategy';

/// Middleware implementing the double-submit cookie CSRF pattern.
///
/// On every response a `csrf-token` cookie is set that is readable by
/// JavaScript.  For state-mutating requests (POST, PATCH, PUT, DELETE)
/// the middleware validates that the incoming `X-CSRF-Token` header value
/// matches the cookie.  Browser-flow-exempted endpoints (login, register,
/// etc.) and bearer-token requests from native clients are automatically
/// skipped.
///
/// ```dart
/// final handler = const Pipeline()
///     .addMiddleware(csrfMiddleware(apiBasePath: '/auth'))
///     .addHandler(myRouter.call);
/// ```
Middleware csrfMiddleware({
  String apiBasePath = '/auth',
  bool cookieSecure = true,
  String cookieSameSite = 'lax',
}) {
  // Endpoints that must remain exempt (login/register/etc. accept
  // unauthenticated requests and cannot send the header yet).
  const exemptSuffixes = <String>{
    '/login',
    '/register',
    '/forgot-password',
    '/reset-password',
    '/verify-email',
    '/magic-link/verify',
    '/sms/verify',
    '/2fa/verify',
    '/refresh',
    '/oauth/',
  };

  bool isExempt(String path) {
    final relative = path.startsWith(apiBasePath)
        ? path.substring(apiBasePath.length)
        : path;
    for (final suffix in exemptSuffixes) {
      if (relative == suffix || relative.startsWith(suffix)) return true;
    }
    return false;
  }

  bool isMutating(String method) {
    final upper = method.toUpperCase();
    return upper == 'POST' ||
        upper == 'PATCH' ||
        upper == 'PUT' ||
        upper == 'DELETE';
  }

  String generateToken() {
    final random = Random.secure();
    final bytes = List<int>.generate(24, (_) => random.nextInt(256));
    const chars = '0123456789abcdef';
    final buffer = StringBuffer();
    for (final b in bytes) {
      buffer
        ..write(chars[(b >> 4) & 0xf])
        ..write(chars[b & 0xf]);
    }
    return buffer.toString();
  }

  String buildCookieAttributes({required bool secure}) {
    final sb = StringBuffer('Path=/; HttpOnly=false; SameSite=$cookieSameSite');
    if (secure) sb.write('; Secure');
    return sb.toString();
  }

  return (Handler inner) {
    return (Request request) async {
      // Native clients using bearer tokens skip CSRF entirely.
      final strategy = request.headers[_bearerStrategyHeader];
      if (strategy == 'bearer') {
        return inner(request);
      }

      // Read (or generate) the CSRF token from the incoming cookie.
      final cookieHeader = request.headers['cookie'] ?? '';
      String? existingToken;
      for (final part in cookieHeader.split(';')) {
        final trimmed = part.trim();
        if (trimmed.startsWith('$_csrfCookieName=')) {
          existingToken = trimmed.substring('$_csrfCookieName='.length).trim();
          break;
        }
      }
      final token = (existingToken?.isNotEmpty ?? false)
          ? existingToken!
          : generateToken();

      // Validate mutating requests unless the endpoint is exempt.
      if (isMutating(request.method) &&
          request.url.path.startsWith(
            apiBasePath.startsWith('/')
                ? apiBasePath.substring(1)
                : apiBasePath,
          ) &&
          !isExempt(request.requestedUri.path)) {
        final sentToken = request.headers[_csrfHeaderName];
        if (sentToken == null || sentToken != token) {
          return Response(403, body: 'invalid csrf token');
        }
      }

      final response = await inner(request);
      final cookieValue =
          '$_csrfCookieName=$token; '
          '${buildCookieAttributes(secure: cookieSecure)}';
      return response.change(
        headers: {'set-cookie': cookieValue},
      );
    };
  };
}
