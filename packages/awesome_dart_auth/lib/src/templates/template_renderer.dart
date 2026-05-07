import 'package:mustache_template/mustache.dart';

import '../config/auth_config.dart';
import 'builtin_templates.dart';

/// Renders localized mail templates using Mustache.
class TemplateRenderer {
  /// Creates a renderer with the supplied [config] and optional locale map.
  TemplateRenderer({
    required AuthConfig config,
    Map<String, Map<String, String>>? templates,
  }) : _config = config,
       _templates = {
         for (final entry in builtInTemplates.entries)
           entry.key: Map<String, String>.from(entry.value),
         if (templates != null)
           for (final entry in templates.entries)
             entry.key: Map<String, String>.from(entry.value),
       };

  final AuthConfig _config;
  final Map<String, Map<String, String>> _templates;

  /// Registers or replaces all [templates] for a locale.
  void registerLocale(String locale, Map<String, String> templates) {
    _templates[locale] = Map<String, String>.from(templates);
  }

  /// Renders the named template with the provided [context].
  String render({
    required String templateName,
    String? locale,
    Map<String, Object?> context = const <String, Object?>{},
  }) {
    final requestedLocale = locale ?? _config.defaultLocale;
    final source =
        _templates[requestedLocale]?[templateName] ??
        _templates[_config.defaultLocale]?[templateName];
    if (source == null) {
      throw ArgumentError.value(
        templateName,
        'templateName',
        'No template found for locale $requestedLocale',
      );
    }
    return Template(source).renderString(context);
  }
}
