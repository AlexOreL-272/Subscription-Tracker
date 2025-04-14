import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_dto.freezed.dart';
part 'login_dto.g.dart';

@Freezed(equal: true, toJson: false, fromJson: false)
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class LoginDto with _$LoginDto {
  const factory LoginDto({required String id, required String accessToken}) =
      _LoginDto;

  factory LoginDto.fromJson(Map<String, dynamic> json) =>
      _$LoginDtoFromJson(json);
}

@Freezed(equal: true, toJson: false, fromJson: false)
@JsonSerializable(fieldRename: FieldRename.snake, createFactory: false)
class LoginRequestDto with _$LoginRequestDto {
  const factory LoginRequestDto({
    required String email,
    required String password,
  }) = _LoginRequestDto;

  const LoginRequestDto._();

  Map<String, dynamic> toJson() => _$LoginRequestDtoToJson(this);
}

@Freezed(equal: true, toJson: false, fromJson: false)
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    required String surname,
    required String fullName,
    required String email,
  }) = _UserDto;

  const UserDto._();

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}
