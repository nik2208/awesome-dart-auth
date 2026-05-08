import 'package:awesome_dart_auth/awesome_dart_auth.dart';
import 'package:test/test.dart';

void main() {
  test('falls back to the default locale', () {
    final renderer = TemplateRenderer(
      config: AuthConfig.development(jwtSecret: 'secret1234'),
    );

    final result = renderer.render(
      templateName: 'welcome',
      locale: 'fr',
      context: const {'name': 'Ada'},
    );

    expect(result, contains('Ada'));
    expect(result, contains('Welcome'));
  });

  test('renders newly ported built-in templates', () {
    final renderer = TemplateRenderer(
      config: AuthConfig.development(jwtSecret: 'secret1234'),
    );

    final reset = renderer.render(
      templateName: 'password_reset',
      context: const {'link': 'https://example.com/reset?token=abc'},
    );
    final verify = renderer.render(
      templateName: 'verify_email',
      locale: 'it',
      context: const {'link': 'https://example.com/verify?token=xyz'},
    );

    expect(reset, contains('password reset'));
    expect(verify, contains('Verifica'));
  });
}
