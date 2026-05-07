import '../models/auth_session.dart';

/// Persistence contract for auth sessions and refresh-token rotation.
abstract interface class SessionStore {
  /// Saves or updates a refresh-token session.
  Future<void> save(AuthSession session);

  /// Looks up a session by identifier.
  Future<AuthSession?> findById(String id);

  /// Marks a session as revoked.
  Future<void> revoke(String id);
}
