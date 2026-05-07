import 'package:meta/meta.dart';

/// A tenant record used for multi-tenant deployments.
@immutable
class TenantRecord {
  /// Creates a tenant record.
  const TenantRecord({
    required this.id,
    required this.name,
    this.isActive = true,
    this.metadata = const <String, Object?>{},
  });

  /// Unique tenant identifier.
  final String id;

  /// Human-readable tenant name.
  final String name;

  /// Whether the tenant is active.
  final bool isActive;

  /// Arbitrary tenant-level metadata.
  final Map<String, Object?> metadata;

  /// Returns a modified copy of this record.
  TenantRecord copyWith({
    String? id,
    String? name,
    bool? isActive,
    Map<String, Object?>? metadata,
  }) =>
      TenantRecord(
        id: id ?? this.id,
        name: name ?? this.name,
        isActive: isActive ?? this.isActive,
        metadata: metadata ?? this.metadata,
      );

  /// Converts this record to a JSON-compatible map.
  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'isActive': isActive,
    'metadata': metadata,
  };
}
