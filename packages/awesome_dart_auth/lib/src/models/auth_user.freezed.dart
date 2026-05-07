// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuthUser _$AuthUserFromJson(Map<String, dynamic> json) {
  return _AuthUser.fromJson(json);
}

/// @nodoc
mixin _$AuthUser {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get passwordHash => throw _privateConstructorUsedError;
  String? get tenantId => throw _privateConstructorUsedError;
  String? get firstName => throw _privateConstructorUsedError;
  String? get lastName => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  String? get totpSecret => throw _privateConstructorUsedError;
  List<String> get providers => throw _privateConstructorUsedError;
  List<String> get roles => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get emailVerified => throw _privateConstructorUsedError;
  bool get totpEnabled => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this AuthUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthUserCopyWith<AuthUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthUserCopyWith<$Res> {
  factory $AuthUserCopyWith(AuthUser value, $Res Function(AuthUser) then) =
      _$AuthUserCopyWithImpl<$Res, AuthUser>;
  @useResult
  $Res call({
    String id,
    String email,
    String? passwordHash,
    String? tenantId,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? totpSecret,
    List<String> providers,
    List<String> roles,
    bool isActive,
    bool emailVerified,
    bool totpEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$AuthUserCopyWithImpl<$Res, $Val extends AuthUser>
    implements $AuthUserCopyWith<$Res> {
  _$AuthUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? passwordHash = freezed,
    Object? tenantId = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? phoneNumber = freezed,
    Object? totpSecret = freezed,
    Object? providers = null,
    Object? roles = null,
    Object? isActive = null,
    Object? emailVerified = null,
    Object? totpEnabled = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            passwordHash: freezed == passwordHash
                ? _value.passwordHash
                : passwordHash // ignore: cast_nullable_to_non_nullable
                      as String?,
            tenantId: freezed == tenantId
                ? _value.tenantId
                : tenantId // ignore: cast_nullable_to_non_nullable
                      as String?,
            firstName: freezed == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastName: freezed == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String?,
            phoneNumber: freezed == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            totpSecret: freezed == totpSecret
                ? _value.totpSecret
                : totpSecret // ignore: cast_nullable_to_non_nullable
                      as String?,
            providers: null == providers
                ? _value.providers
                : providers // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            roles: null == roles
                ? _value.roles
                : roles // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            emailVerified: null == emailVerified
                ? _value.emailVerified
                : emailVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            totpEnabled: null == totpEnabled
                ? _value.totpEnabled
                : totpEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthUserImplCopyWith<$Res>
    implements $AuthUserCopyWith<$Res> {
  factory _$$AuthUserImplCopyWith(
    _$AuthUserImpl value,
    $Res Function(_$AuthUserImpl) then,
  ) = __$$AuthUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String email,
    String? passwordHash,
    String? tenantId,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? totpSecret,
    List<String> providers,
    List<String> roles,
    bool isActive,
    bool emailVerified,
    bool totpEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$AuthUserImplCopyWithImpl<$Res>
    extends _$AuthUserCopyWithImpl<$Res, _$AuthUserImpl>
    implements _$$AuthUserImplCopyWith<$Res> {
  __$$AuthUserImplCopyWithImpl(
    _$AuthUserImpl _value,
    $Res Function(_$AuthUserImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? passwordHash = freezed,
    Object? tenantId = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? phoneNumber = freezed,
    Object? totpSecret = freezed,
    Object? providers = null,
    Object? roles = null,
    Object? isActive = null,
    Object? emailVerified = null,
    Object? totpEnabled = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$AuthUserImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        passwordHash: freezed == passwordHash
            ? _value.passwordHash
            : passwordHash // ignore: cast_nullable_to_non_nullable
                  as String?,
        tenantId: freezed == tenantId
            ? _value.tenantId
            : tenantId // ignore: cast_nullable_to_non_nullable
                  as String?,
        firstName: freezed == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastName: freezed == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String?,
        phoneNumber: freezed == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        totpSecret: freezed == totpSecret
            ? _value.totpSecret
            : totpSecret // ignore: cast_nullable_to_non_nullable
                  as String?,
        providers: null == providers
            ? _value._providers
            : providers // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        roles: null == roles
            ? _value._roles
            : roles // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        emailVerified: null == emailVerified
            ? _value.emailVerified
            : emailVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        totpEnabled: null == totpEnabled
            ? _value.totpEnabled
            : totpEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthUserImpl implements _AuthUser {
  const _$AuthUserImpl({
    required this.id,
    required this.email,
    this.passwordHash,
    this.tenantId,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.totpSecret,
    final List<String> providers = const <String>[],
    final List<String> roles = const <String>[],
    this.isActive = true,
    this.emailVerified = false,
    this.totpEnabled = false,
    this.createdAt,
    this.updatedAt,
  }) : _providers = providers,
       _roles = roles;

  factory _$AuthUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthUserImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String? passwordHash;
  @override
  final String? tenantId;
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String? phoneNumber;
  @override
  final String? totpSecret;
  final List<String> _providers;
  @override
  @JsonKey()
  List<String> get providers {
    if (_providers is EqualUnmodifiableListView) return _providers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_providers);
  }

  final List<String> _roles;
  @override
  @JsonKey()
  List<String> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool emailVerified;
  @override
  @JsonKey()
  final bool totpEnabled;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'AuthUser(id: $id, email: $email, passwordHash: $passwordHash, tenantId: $tenantId, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, totpSecret: $totpSecret, providers: $providers, roles: $roles, isActive: $isActive, emailVerified: $emailVerified, totpEnabled: $totpEnabled, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.passwordHash, passwordHash) ||
                other.passwordHash == passwordHash) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.totpSecret, totpSecret) ||
                other.totpSecret == totpSecret) &&
            const DeepCollectionEquality().equals(
              other._providers,
              _providers,
            ) &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.emailVerified, emailVerified) ||
                other.emailVerified == emailVerified) &&
            (identical(other.totpEnabled, totpEnabled) ||
                other.totpEnabled == totpEnabled) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    email,
    passwordHash,
    tenantId,
    firstName,
    lastName,
    phoneNumber,
    totpSecret,
    const DeepCollectionEquality().hash(_providers),
    const DeepCollectionEquality().hash(_roles),
    isActive,
    emailVerified,
    totpEnabled,
    createdAt,
    updatedAt,
  );

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthUserImplCopyWith<_$AuthUserImpl> get copyWith =>
      __$$AuthUserImplCopyWithImpl<_$AuthUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthUserImplToJson(this);
  }
}

abstract class _AuthUser implements AuthUser {
  const factory _AuthUser({
    required final String id,
    required final String email,
    final String? passwordHash,
    final String? tenantId,
    final String? firstName,
    final String? lastName,
    final String? phoneNumber,
    final String? totpSecret,
    final List<String> providers,
    final List<String> roles,
    final bool isActive,
    final bool emailVerified,
    final bool totpEnabled,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$AuthUserImpl;

  factory _AuthUser.fromJson(Map<String, dynamic> json) =
      _$AuthUserImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String? get passwordHash;
  @override
  String? get tenantId;
  @override
  String? get firstName;
  @override
  String? get lastName;
  @override
  String? get phoneNumber;
  @override
  String? get totpSecret;
  @override
  List<String> get providers;
  @override
  List<String> get roles;
  @override
  bool get isActive;
  @override
  bool get emailVerified;
  @override
  bool get totpEnabled;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthUserImplCopyWith<_$AuthUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
