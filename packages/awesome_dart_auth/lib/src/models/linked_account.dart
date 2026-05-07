import 'package:meta/meta.dart';

/// A linked OAuth / social-login account attached to a user.
@immutable
class LinkedAccount {
  /// Creates a linked account record.
  const LinkedAccount({
    required this.provider,
    required this.externalId,
    this.email,
    this.displayName,
    this.linkedAt,
  });

  /// The OAuth provider (e.g. `google`, `github`).
  final String provider;

  /// The external user identifier issued by the provider.
  final String externalId;

  /// Email address returned by the provider, if available.
  final String? email;

  /// Display name returned by the provider, if available.
  final String? displayName;

  /// When the account was linked.
  final DateTime? linkedAt;

  /// Converts this record to a JSON-compatible map.
  Map<String, Object?> toJson() => {
    'provider': provider,
    'externalId': externalId,
    'email': email,
    'displayName': displayName,
    'linkedAt': linkedAt?.toIso8601String(),
  };
}
