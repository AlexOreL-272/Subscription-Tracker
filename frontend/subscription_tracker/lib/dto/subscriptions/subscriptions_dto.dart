import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscriptions_dto.freezed.dart';
part 'subscriptions_dto.g.dart';

@Freezed(equal: true, toJson: false, fromJson: false)
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class CreateSubscriptionDto with _$CreateSubscriptionDto {
  const factory CreateSubscriptionDto({required String id}) =
      _CreateSubscriptionDto;

  factory CreateSubscriptionDto.fromJson(Map<String, dynamic> json) =>
      _$CreateSubscriptionDtoFromJson(json);
}

@Freezed(equal: true, toJson: false, fromJson: false)
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class UpdateSubscriptionDto with _$UpdateSubscriptionDto {
  const factory UpdateSubscriptionDto() = _UpdateSubscriptionDto;

  factory UpdateSubscriptionDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateSubscriptionDtoFromJson(json);
}

@Freezed(equal: true, toJson: false, fromJson: false)
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class DeleteSubscriptionDto with _$DeleteSubscriptionDto {
  const factory DeleteSubscriptionDto({required String id}) =
      _DeleteSubscriptionDto;

  factory DeleteSubscriptionDto.fromJson(Map<String, dynamic> json) =>
      _$DeleteSubscriptionDtoFromJson(json);
}
