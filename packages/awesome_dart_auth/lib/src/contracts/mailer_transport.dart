import '../models/mail_message.dart';

/// Transport used to send rendered mail through an HTTP endpoint.
abstract interface class MailerTransport {
  /// Sends an outbound [message].
  Future<void> send(MailMessage message);
}
