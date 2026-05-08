/// Outgoing webhook registration metadata.
class WebhookConfig {
  /// Creates a webhook registration.
  const WebhookConfig({
    required this.id,
    required this.url,
    required this.events,
    this.secret,
    this.isActive = true,
    this.tenantId,
    this.maxRetries,
    this.retryDelayMs,
  });

  /// Registration identifier.
  final String id;

  /// Target URL for webhook deliveries.
  final String url;

  /// Event name patterns (e.g. `*`, `identity.auth.login.success`).
  final List<String> events;

  /// Optional HMAC secret for signatures.
  final String? secret;

  /// Whether this registration is active.
  final bool isActive;

  /// Optional tenant scope.
  final String? tenantId;

  /// Optional max retry attempts.
  final int? maxRetries;

  /// Optional initial retry delay.
  final Duration? retryDelayMs;
}

/// Payload delivered to outgoing webhook endpoints.
class OutgoingWebhookEvent {
  /// Creates an outgoing webhook event payload.
  const OutgoingWebhookEvent({
    required this.event,
    required this.version,
    required this.timestamp,
    this.data,
    this.metadata,
  });

  /// Standard event name.
  final String event;

  /// Event schema version.
  final String version;

  /// Event timestamp.
  final DateTime timestamp;

  /// Arbitrary payload.
  final Object? data;

  /// Optional metadata.
  final Map<String, Object?>? metadata;

  /// JSON map representation.
  Map<String, Object?> toJson() => <String, Object?>{
    'event': event,
    'version': version,
    'timestamp': timestamp.toIso8601String(),
    'data': data,
    if (metadata != null) 'metadata': metadata,
  };
}

/// Persistence contract for webhook registrations.
abstract interface class WebhookStore {
  /// Returns active webhook configs matching [event] and optional [tenantId].
  Future<List<WebhookConfig>> findByEvent(String event, {String? tenantId});
}
