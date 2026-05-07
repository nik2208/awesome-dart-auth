import 'dart:isolate';

/// Function signature used by inbound webhook actions.
typedef WebhookAction =
    Future<Map<String, Object?>> Function(
      Map<String, Object?> payload,
    );

/// Registry for dynamic inbound webhook actions executed in an isolate.
class WebhookActionRegistry {
  /// Creates an empty registry.
  WebhookActionRegistry();

  final Map<String, WebhookAction> _actions = <String, WebhookAction>{};

  /// Registers an [action] under [name].
  void register(String name, WebhookAction action) {
    _actions[name] = action;
  }

  /// Executes a registered action in an isolate-backed sandbox.
  Future<Map<String, Object?>> execute(
    String name,
    Map<String, Object?> payload,
  ) async {
    final action = _actions[name];
    if (action == null) {
      throw ArgumentError.value(name, 'name', 'No webhook action registered');
    }
    return Isolate.run(() => action(payload));
  }
}
