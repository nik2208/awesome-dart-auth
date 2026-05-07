import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

/// Represents a persisted end user known to the authentication system.
@freezed
class AuthUser with _$AuthUser {
  /// Creates an immutable auth user model.
  const factory AuthUser({
    required String id,
    required String email,
    String? passwordHash,
    String? tenantId,
    @Default(<String>[]) List<String> providers,
    @Default(<String>[]) List<String> roles,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AuthUser;

  /// Deserializes an [AuthUser] from JSON.
  factory AuthUser.fromJson(Map<String, Object?> json) =>
      _$AuthUserFromJson(json);
}
