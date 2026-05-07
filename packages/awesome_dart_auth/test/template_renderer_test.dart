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
}
