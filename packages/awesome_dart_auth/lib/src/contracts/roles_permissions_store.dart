/// Persistence contract for tenant-aware roles and permissions.
abstract interface class RolesPermissionsStore {
  /// Resolves role names for a user within an optional tenant scope.
  Future<Set<String>> rolesForUser({required String userId, String? tenantId});

  /// Resolves granted permissions for the supplied [roles].
  Future<Set<String>> permissionsForRoles(Set<String> roles);
}
