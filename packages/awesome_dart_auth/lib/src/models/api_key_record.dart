import 'package:meta/meta.dart';

/// API key material used for machine-to-machine authentication.
@immutable
class ApiKeyRecord {
  /// Creates an API key record.
  const ApiKeyRecord({
    required this.id,
    required this.keyHash,
    required this.scopes,
    this.ipAllowlist = const <String>[],
    this.tenantId,
    this.revoked = false,
  });

  /// Unique identifier for the API key.
  final String id;

  /// Persisted key hash.
  final String keyHash;

  /// Granted scopes.
  final Set<String> scopes;

  /// Allowed IP CIDRs or addresses.
  final List<String> ipAllowlist;

  /// Tenant that owns the key.
  final String? tenantId;

  /// Whether the key is revoked.
  final bool revoked;
}
