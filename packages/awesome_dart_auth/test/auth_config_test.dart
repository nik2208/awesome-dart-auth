import 'package:awesome_dart_auth/awesome_dart_auth.dart';
import 'package:test/test.dart';

void main() {
  group('AuthConfig', () {
    test('copyWith preserves and overrides values', () {
      final config = AuthConfig.development(jwtSecret: 'secret1234');

      final updated = config.copyWith(
        issuer: 'https://auth.example.com',
        supportedLocales: const {'en', 'it', 'fr'},
        defaultLocale: 'fr',
      );

      expect(updated.jwtSecret, 'secret1234');
      expect(updated.issuer, 'https://auth.example.com');
      expect(updated.defaultLocale, 'fr');
      expect(updated.supportedLocales, contains('fr'));
    });

    test('throws when no token transport is enabled', () {
      expect(
        () => AuthConfig(
          jwtSecret: 'secret1234',
          issuer: 'https://auth.example.com',
          allowBearerTokens: false,
          allowCookieTokens: false,
        ),
        throwsArgumentError,
      );
    });
  });
}
