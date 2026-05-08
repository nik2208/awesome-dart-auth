import 'package:awesome_dart_auth/awesome_dart_auth.dart';
import 'package:test/test.dart';

class _WebhookStore implements WebhookStore {
  _WebhookStore(this._configs);

  final List<WebhookConfig> _configs;

  @override
  Future<List<WebhookConfig>> findByEvent(String event, {String? tenantId}) async {
    return _configs.where((config) {
      final matchesEvent = config.events.contains('*') || config.events.contains(event);
      final matchesTenant = config.tenantId == null || config.tenantId == tenantId;
      return config.isActive && matchesEvent && matchesTenant;
    }).toList();
  }
}

class _RecordingWebhookSender extends WebhookSender {
  _RecordingWebhookSender();

  final List<(WebhookConfig, OutgoingWebhookEvent)> deliveries = [];

  @override
  Future<void> send(WebhookConfig config, OutgoingWebhookEvent event) async {
    deliveries.add((config, event));
  }
}

void main() {
  test('AuthTools.track dispatches outgoing webhooks for matching events', () async {
    final sender = _RecordingWebhookSender();
    final tools = AuthTools(
      webhookStore: _WebhookStore(const [
        WebhookConfig(
          id: 'wh-1',
          url: 'https://hooks.example.com/auth',
          events: ['identity.auth.login.success'],
          tenantId: 'tenant-a',
        ),
      ]),
      webhookSender: sender,
      webhookVersion: '2',
    );

    await tools.track(
      'identity.auth.login.success',
      userId: 'user-1',
      tenantId: 'tenant-a',
      payload: const {'ip': '127.0.0.1'},
    );

    expect(sender.deliveries, hasLength(1));
    final delivery = sender.deliveries.single;
    expect(delivery.$1.id, 'wh-1');
    expect(delivery.$2.event, 'identity.auth.login.success');
    expect(delivery.$2.version, '2');
    expect(delivery.$2.metadata?['tenantId'], 'tenant-a');
    expect(delivery.$2.metadata?['userId'], 'user-1');
  });
}
