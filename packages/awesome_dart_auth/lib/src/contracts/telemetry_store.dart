import '../events/auth_event.dart';

/// Persistence contract for recording telemetry about auth events.
abstract interface class TelemetryStore {
  /// Persists a single auth [event].
  Future<void> persist(AuthEvent event);
}
