import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_pair.freezed.dart';
part 'token_pair.g.dart';

/// Access and refresh tokens returned by the auth service.
@freezed
class TokenPair with _$TokenPair {
  /// Creates a token pair.
  const factory TokenPair({
    required String accessToken,
    required String refreshToken,
    required int expiresInSeconds,
    @Default('Bearer') String tokenType,
  }) = _TokenPair;

  /// Deserializes a [TokenPair] from JSON.
  factory TokenPair.fromJson(Map<String, Object?> json) =>
      _$TokenPairFromJson(json);
}
