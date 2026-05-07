import 'package:meta/meta.dart';

/// Session metadata persisted for refresh-token rotation and revocation.
@immutable
class AuthSession {
  /// Creates an immutable auth session record.
  const AuthSession({
    required this.id,
    required this.userId,
    required this.expiresAt,
    this.tenantId,
    this.revoked = false,
    this.scopes = const <String>{},
  });

  /// Unique session identifier.
  final String id;

  /// User that owns the session.
  final String userId;

  /// Tenant scope, if any.
  final String? tenantId;

  /// Expiration timestamp.
  final DateTime expiresAt;

  /// Whether the refresh session is revoked.
  final bool revoked;

  /// Authorized scopes associated with the session.
  final Set<String> scopes;

  /// Returns a modified copy of this session.
  AuthSession copyWith({
    String? id,
    String? userId,
    Object? tenantId = _sentinel,
    DateTime? expiresAt,
    bool? revoked,
    Set<String>? scopes,
  }) {
    return AuthSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tenantId: identical(tenantId, _sentinel)
          ? this.tenantId
          : tenantId as String?,
      expiresAt: expiresAt ?? this.expiresAt,
      revoked: revoked ?? this.revoked,
      scopes: scopes ?? this.scopes,
    );
  }

  /// Converts the session to a JSON-compatible map.
  Map<String, Object?> toJson() => {
    'id': id,
    'userId': userId,
    'tenantId': tenantId,
    'expiresAt': expiresAt.toIso8601String(),
    'revoked': revoked,
    'scopes': scopes.toList(growable: false),
  };
}

const Object _sentinel = Object();
