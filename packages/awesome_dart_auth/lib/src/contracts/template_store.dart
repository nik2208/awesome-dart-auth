/// Persistence contract for dynamic per-language email templates and UI i18n.
abstract interface class TemplateStore {
  /// Retrieves a template body by [locale] and [name].
  ///
  /// Returns `null` when no override exists (the built-in template is used).
  Future<String?> findTemplate({
    required String locale,
    required String name,
  });

  /// Retrieves all i18n translation keys for [locale].
  Future<Map<String, String>?> findI18n(String locale);

  /// Persists a template override.
  Future<void> saveTemplate({
    required String locale,
    required String name,
    required String body,
  });
}
