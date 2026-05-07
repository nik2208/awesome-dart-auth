import 'package:meta/meta.dart';

/// Standardised OAuth profile returned after a provider callback.
@immutable
class OAuthProfile {
  /// Creates an OAuth profile.
  const OAuthProfile({
    required this.provider,
    required this.externalId,
    this.email,
    this.displayName,
    this.raw = const <String, Object?>{},
  });

  /// The OAuth provider name (e.g. `google`, `github`).
  final String provider;

  /// The external user identifier issued by the provider.
  final String externalId;

  /// Email address returned by the provider, if available.
  final String? email;

  /// Display name returned by the provider, if available.
  final String? displayName;

  /// Raw provider-specific payload for custom processing.
  final Map<String, Object?> raw;
}
