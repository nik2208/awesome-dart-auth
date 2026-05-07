import 'package:awesome_dart_auth/src/models/auth_user.dart';

/// Persistence contract for user identities.
abstract interface class UserStore {
  /// Finds a user by its primary identifier.
  Future<AuthUser?> findById(String id);

  /// Finds a user by email address.
  Future<AuthUser?> findByEmail(String email);

  /// Persists the supplied [user] (create or update).
  Future<AuthUser> save(AuthUser user);

  /// Updates an existing user record.
  Future<AuthUser> update(AuthUser user);

  /// Deletes a user by identifier.
  Future<void> delete(String id);
}
