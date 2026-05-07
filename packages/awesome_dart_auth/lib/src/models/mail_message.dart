import 'package:meta/meta.dart';

/// Outbound mail request sent through the configured transport.
@immutable
class MailMessage {
  /// Creates a mail message.
  const MailMessage({
    required this.to,
    required this.subject,
    required this.html,
    this.text,
    this.headers = const <String, String>{},
  });

  /// Target recipient address.
  final String to;

  /// Subject line.
  final String subject;

  /// HTML body.
  final String html;

  /// Plain-text body.
  final String? text;

  /// Additional HTTP headers for transport-specific metadata.
  final Map<String, String> headers;
}
