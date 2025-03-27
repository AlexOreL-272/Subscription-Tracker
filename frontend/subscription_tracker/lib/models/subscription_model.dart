import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_model.freezed.dart';
part 'subscription_model.g.dart';

@Freezed(equal: false, copyWith: false, toJson: false, fromJson: false)
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class SubscriptionModel with _$SubscriptionModel {
  // not final version of model, but it is not important for the task
  const factory SubscriptionModel({
    required String id,
    required String caption,
    String? supportLink,
    String? category,
    required double cost,
    required String currency,
    required DateTime firstPay,
    required int interval,
    String? comment,
    required int color,
  }) = _SubscriptionModel;

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);
}
