import '../models/token_record.dart';

/// Persistence contract for temporary authentication tokens.
abstract interface class TokenStore {
  /// Persists or updates a temporary [record].
  Future<void> save(TokenRecord record);

  /// Finds a record by opaque [token].
  Future<TokenRecord?> findByToken(String token);

  /// Marks a [token] as consumed.
  Future<void> consume(String token);
}
