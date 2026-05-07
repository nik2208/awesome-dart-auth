import '../models/auth_user.dart';

/// Persistence contract for user identities.
abstract interface class UserStore {
  /// Finds a user by its primary identifier.
  Future<AuthUser?> findById(String id);

  /// Finds a user by email address.
  Future<AuthUser?> findByEmail(String email);

  /// Persists the supplied [user].
  Future<AuthUser> save(AuthUser user);
}
