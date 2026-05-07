import 'package:meta/meta.dart';

/// Record used while linking an additional identity provider to a user.
@immutable
class PendingLinkRecord {
  /// Creates a pending link record.
  const PendingLinkRecord({
    required this.id,
    required this.userId,
    required this.provider,
    required this.externalUserId,
    required this.expiresAt,
  });

  /// Unique pending-link identifier.
  final String id;

  /// Target user identifier.
  final String userId;

  /// Provider being linked.
  final String provider;

  /// External provider user identifier.
  final String externalUserId;

  /// Expiration timestamp.
  final DateTime expiresAt;
}
