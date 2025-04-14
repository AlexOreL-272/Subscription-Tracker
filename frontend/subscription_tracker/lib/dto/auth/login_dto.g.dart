// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginDto _$LoginDtoFromJson(Map<String, dynamic> json) => LoginDto(
  id: json['id'] as String,
  accessToken: json['access_token'] as String,
);

Map<String, dynamic> _$LoginRequestDtoToJson(LoginRequestDto instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
  id: json['id'] as String,
  surname: json['surname'] as String,
  fullName: json['full_name'] as String,
  email: json['email'] as String,
);
