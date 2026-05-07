import 'package:awesome_dart_auth/src/models/tenant_record.dart';

/// Persistence contract for multi-tenant applications.
abstract interface class TenantStore {
  /// Finds a tenant by its primary identifier.
  Future<TenantRecord?> findById(String id);

  /// Persists a tenant record.
  Future<TenantRecord> save(TenantRecord tenant);

  /// Deletes a tenant by identifier.
  Future<void> delete(String id);

  /// Lists all tenants.
  Future<List<TenantRecord>> listAll();
}
