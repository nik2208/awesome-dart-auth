import '../models/api_key_record.dart';

/// Persistence contract for API keys, scopes, and audit metadata.
abstract interface class ApiKeyStore {
  /// Finds an API key record by identifier.
  Future<ApiKeyRecord?> findById(String id);

  /// Persists or updates an API key record.
  Future<void> save(ApiKeyRecord apiKey);

  /// Revokes an API key by identifier.
  Future<void> revoke(String id);
}
