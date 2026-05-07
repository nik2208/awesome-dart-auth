import '../events/auth_event.dart';

/// Scaling contract for distributing SSE auth events across instances.
abstract interface class SseDistributor {
  /// Publishes an auth [event] to the named [channel].
  Future<void> publish(String channel, AuthEvent event);

  /// Subscribes to events from the named [channel].
  Stream<AuthEvent> subscribe(String channel);
}
