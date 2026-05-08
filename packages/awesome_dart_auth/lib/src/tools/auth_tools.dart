import 'package:awesome_dart_auth/src/contracts/sse_distributor.dart';
import 'package:awesome_dart_auth/src/contracts/user_store.dart';
import 'package:awesome_dart_auth/src/contracts/webhook_store.dart';
import 'package:awesome_dart_auth/src/events/auth_event.dart';
import 'package:awesome_dart_auth/src/events/auth_event_bus.dart';
import 'package:awesome_dart_auth/src/tools/notification_service.dart';
import 'package:awesome_dart_auth/src/webhooks/webhook_sender.dart';

/// Delivery channel identifiers for [AuthTools.notify].
class NotifyChannel {
  /// Server-Sent Events channel.
  static const sse = 'sse';

  /// Email channel (requires a [MailerConfig] in [NotificationService]).
  static const email = 'email';

  /// SMS channel (requires an [SmsConfig] in [NotificationService]).
  static const sms = 'sms';
}

/// Higher-level toolkit that combines telemetry tracking and multi-channel
/// push notifications.
///
/// ```dart
/// final tools = AuthTools(
///   sse: mySseDistributor,
///   notificationService: NotificationService(email: myMailer),
///   userStore: myUserStore,
///   eventBus: myBus,
/// );
///
/// // Emit an SSE event to a connected user.
/// await tools.notify(
///   'user:123',
///   type: 'subscription_expiring',
///   data: {'days': 3},
/// );
///
/// // Track a domain event (publishes on the event bus + telemetry).
/// await tools.track('identity.auth.login.success', userId: 'user-123');
/// ```
class AuthTools {
  /// Creates an auth-tools instance.
  AuthTools({
    this.sse,
    this.notificationService,
    this.userStore,
    this.eventBus,
    this.webhookStore,
    this.webhookVersion = '1',
    WebhookSender? webhookSender,
  }) : webhookSender = webhookSender ?? WebhookSender();

  /// SSE distributor used by the `sse` channel.
  final SseDistributor? sse;

  /// Notification service used by the `email` and `sms` channels.
  final NotificationService? notificationService;

  /// User store used to look up contact details for email/SMS delivery.
  final UserStore? userStore;

  /// Event bus that receives [track] events.
  final AuthEventBus? eventBus;

  /// Webhook store used to resolve outgoing webhook subscribers.
  final WebhookStore? webhookStore;

  /// Schema version sent in outgoing webhook payloads.
  final String webhookVersion;

  /// Sender used for webhook deliveries.
  final WebhookSender webhookSender;

  /// Publishes [eventName] with optional [userId] and [payload] on the
  /// configured [eventBus].
  Future<void> track(
    String eventName, {
    String? userId,
    String? tenantId,
    Map<String, Object?> payload = const <String, Object?>{},
  }) async {
    final event = AuthEvent(
      type: eventName,
      occurredAt: DateTime.now().toUtc(),
      userId: userId,
      tenantId: tenantId,
      payload: payload,
    );
    await eventBus?.publish(event);

    final store = webhookStore;
    if (store == null) return;

    final subscribers = await store.findByEvent(eventName, tenantId: tenantId);
    if (subscribers.isEmpty) return;

    final outgoing = OutgoingWebhookEvent(
      event: eventName,
      version: webhookVersion,
      timestamp: event.occurredAt,
      data: payload,
      metadata: <String, Object?>{
        if (userId != null) 'userId': userId,
        if (tenantId != null) 'tenantId': tenantId,
      },
    );
    for (final subscriber in subscribers) {
      await webhookSender.send(subscriber, outgoing);
    }
  }

  /// Sends a push notification to [channel] over one or more [channels].
  ///
  /// [channel] is the SSE channel name (usually `user:<id>`).
  /// [type] is a short event-type label understood by the client.
  /// [data] is the arbitrary payload.
  ///
  /// When [channels] contains [NotifyChannel.email] or [NotifyChannel.sms],
  /// [userId] is required and [userStore] must be configured so that the
  /// user's contact details can be looked up.
  Future<void> notify(
    String channel, {
    required String type,
    Object? data,
    String? userId,
    List<String> channels = const [NotifyChannel.sse],
    String? emailSubject,
    String? smsMessage,
  }) async {
    for (final ch in channels) {
      switch (ch) {
        case NotifyChannel.sse:
          await _notifySse(channel, type, data);
        case NotifyChannel.email:
          await _notifyEmail(userId, emailSubject, data);
        case NotifyChannel.sms:
          await _notifySms(userId, smsMessage ?? type);
        default:
          break;
      }
    }
  }

  Future<void> _notifySse(String channel, String type, Object? data) async {
    final distributor = sse;
    if (distributor == null) return;
    final event = AuthEvent(
      type: type,
      occurredAt: DateTime.now().toUtc(),
      payload: data is Map<String, Object?>
          ? data
          : <String, Object?>{'data': data},
    );
    await distributor.publish(channel, event);
  }

  Future<void> _notifyEmail(
    String? userId,
    String? subject,
    Object? data,
  ) async {
    if (userId == null) return;
    final store = userStore;
    if (store == null) return;
    final user = await store.findById(userId);
    if (user == null) return;
    await notificationService?.sendEmail(
      SendEmailOptions(
        to: user.email,
        subject: subject ?? 'Notification',
        html: data?.toString(),
      ),
    );
  }

  Future<void> _notifySms(String? userId, String message) async {
    if (userId == null) return;
    final store = userStore;
    if (store == null) return;
    final user = await store.findById(userId);
    if (user == null) return;
    final phone = user.phoneNumber;
    if (phone == null) return;
    await notificationService?.sendSms(
      SendSmsOptions(to: phone, message: message),
    );
  }
}
