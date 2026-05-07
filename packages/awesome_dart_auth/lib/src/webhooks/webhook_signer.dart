import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';

/// Signs outbound webhook payloads with an HMAC SHA-256 digest.
@immutable
class WebhookSigner {
  /// Creates a signer backed by the shared [secret].
  const WebhookSigner(this.secret);

  /// Shared secret used for signature generation.
  final String secret;

  /// Returns a hexadecimal HMAC signature for [payload].
  String sign(String payload) {
    final digest = Hmac(
      sha256,
      utf8.encode(secret),
    ).convert(utf8.encode(payload));
    return digest.toString();
  }

  /// Verifies that [signature] matches [payload].
  bool verify(String payload, String signature) {
    final expected = sign(payload);
    if (expected.length != signature.length) {
      return false;
    }
    var mismatch = 0;
    for (var index = 0; index < expected.length; index++) {
      mismatch |= expected.codeUnitAt(index) ^ signature.codeUnitAt(index);
    }
    return mismatch == 0;
  }
}
