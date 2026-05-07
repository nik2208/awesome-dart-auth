import 'dart:async';

import 'auth_event.dart';

/// Publish/subscribe abstraction for auth-domain events.
abstract interface class AuthEventBus {
  /// Publishes an [event] to all subscribers.
  Future<void> publish(AuthEvent event);

  /// Subscribes to the auth event stream.
  Stream<AuthEvent> subscribe();
}

/// In-memory event bus implementation suitable for development and tests.
final class InMemoryAuthEventBus implements AuthEventBus {
  final StreamController<AuthEvent> _controller =
      StreamController<AuthEvent>.broadcast();

  @override
  Future<void> publish(AuthEvent event) async {
    _controller.add(event);
  }

  @override
  Stream<AuthEvent> subscribe() => _controller.stream;

  /// Disposes the underlying stream controller.
  Future<void> close() => _controller.close();
}
