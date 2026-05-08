import 'dart:convert';
import 'dart:io';

import 'package:awesome_dart_auth/awesome_dart_auth.dart';
import 'package:test/test.dart';

void main() {
  group('NotificationService', () {
    test('sendEmail posts JSON with bearer auth', () async {
      late HttpRequest capturedRequest;
      late Map<String, Object?> capturedBody;
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((request) async {
        capturedRequest = request;
        capturedBody =
            jsonDecode(await utf8.decoder.bind(request).join())
                as Map<String, Object?>;
        request.response.statusCode = HttpStatus.ok;
        await request.response.close();
      });

      addTearDown(() => server.close(force: true));

      final service = NotificationService(
        email: MailerConfig(
          endpoint: 'http://${server.address.host}:${server.port}/email',
          apiKey: 'mailer-key',
          fromAddress: 'no-reply@example.com',
        ),
      );

      await service.sendEmail(
        const SendEmailOptions(
          to: 'user@example.com',
          subject: 'Hello',
          html: '<p>Hi</p>',
        ),
      );

      expect(capturedRequest.method, 'POST');
      expect(capturedRequest.uri.path, '/email');
      expect(capturedRequest.headers.value('authorization'), 'Bearer mailer-key');
      expect(capturedBody['to'], 'user@example.com');
      expect(capturedBody['subject'], 'Hello');
      expect(capturedBody['from'], 'no-reply@example.com');
      expect(capturedBody['html'], '<p>Hi</p>');
    });

    test('sendSms uses basic auth + x-api-key when credentials are provided', () async {
      late HttpRequest capturedRequest;
      late Map<String, Object?> capturedBody;
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((request) async {
        capturedRequest = request;
        capturedBody =
            jsonDecode(await utf8.decoder.bind(request).join())
                as Map<String, Object?>;
        request.response.statusCode = HttpStatus.ok;
        await request.response.close();
      });

      addTearDown(() => server.close(force: true));

      final service = NotificationService(
        sms: SmsConfig(
          endpoint: 'http://${server.address.host}:${server.port}/sms',
          apiKey: 'sms-key',
          username: 'alice',
          password: 'secret',
        ),
      );

      await service.sendSms(
        const SendSmsOptions(to: '+39123456789', message: 'ciao'),
      );

      expect(capturedRequest.method, 'POST');
      expect(capturedRequest.uri.path, '/sms');
      expect(capturedRequest.headers.value('x-api-key'), 'sms-key');
      expect(
        capturedRequest.headers.value('authorization'),
        'Basic ${base64Encode(utf8.encode('alice:secret'))}',
      );
      expect(capturedBody['to'], '+39123456789');
      expect(capturedBody['message'], 'ciao');
    });

    test('sendEmail throws StateError on non-2xx response', () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((request) async {
        request.response.statusCode = HttpStatus.badGateway;
        await request.response.close();
      });

      addTearDown(() => server.close(force: true));

      final service = NotificationService(
        email: MailerConfig(
          endpoint: 'http://${server.address.host}:${server.port}/email',
          apiKey: 'mailer-key',
          fromAddress: 'no-reply@example.com',
        ),
      );

      expect(
        () => service.sendEmail(
          const SendEmailOptions(
            to: 'user@example.com',
            subject: 'Hello',
          ),
        ),
        throwsA(isA<StateError>()),
      );
    });
  });
}
