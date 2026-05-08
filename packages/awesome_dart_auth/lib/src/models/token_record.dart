import 'package:meta/meta.dart';

/// Persisted token record used by password reset and email-verification flows.
@immutable
class TokenRecord {
  /// Creates a token record.
  const TokenRecord({
    required this.token,
    required this.purpose,
    required this.userId,
    required this.expiresAt,
    this.email,
    this.newEmail,
    this.createdAt,
    this.consumedAt,
  });

  /// Unique opaque token value.
  final String token;

  /// Token purpose (`password_reset`, `verify_email`, `change_email`).
  final String purpose;

  /// Owner user identifier.
  final String userId;

  /// Optional email related to the flow.
  final String? email;

  /// Optional target email used for change-email confirmation.
  final String? newEmail;

  /// Token creation timestamp.
  final DateTime? createdAt;

  /// Token expiration timestamp.
  final DateTime expiresAt;

  /// Token consumption timestamp.
  final DateTime? consumedAt;

  /// Returns whether the token has already been consumed.
  bool get isConsumed => consumedAt != null;

  /// Returns whether the token is expired at [now].
  bool isExpiredAt(DateTime now) => expiresAt.isBefore(now);

  /// Returns a modified copy of this record.
  TokenRecord copyWith({
    String? token,
    String? purpose,
    String? userId,
    Object? email = _sentinel,
    Object? newEmail = _sentinel,
    DateTime? createdAt,
    DateTime? expiresAt,
    Object? consumedAt = _sentinel,
  }) =>
      TokenRecord(
        token: token ?? this.token,
        purpose: purpose ?? this.purpose,
        userId: userId ?? this.userId,
        email: identical(email, _sentinel) ? this.email : email as String?,
        newEmail: identical(newEmail, _sentinel)
            ? this.newEmail
            : newEmail as String?,
        createdAt: createdAt ?? this.createdAt,
        expiresAt: expiresAt ?? this.expiresAt,
        consumedAt: identical(consumedAt, _sentinel)
            ? this.consumedAt
            : consumedAt as DateTime?,
      );
}

const Object _sentinel = Object();
