import 'package:meta/meta.dart';

/// Immutable auth-domain event emitted by the core service.
@immutable
class AuthEvent {
  /// Creates an auth event.
  const AuthEvent({
    required this.type,
    required this.occurredAt,
    this.userId,
    this.tenantId,
    this.payload = const <String, Object?>{},
  });

  /// Event type name.
  final String type;

  /// Event timestamp.
  final DateTime occurredAt;

  /// Related user identifier, if any.
  final String? userId;

  /// Related tenant identifier, if any.
  final String? tenantId;

  /// Additional structured payload.
  final Map<String, Object?> payload;

  /// Converts the event into a serializable map.
  Map<String, Object?> toJson() => {
    'type': type,
    'occurredAt': occurredAt.toIso8601String(),
    'userId': userId,
    'tenantId': tenantId,
    'payload': payload,
  };
}
