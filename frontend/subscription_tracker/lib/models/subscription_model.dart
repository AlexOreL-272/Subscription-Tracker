import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_model.freezed.dart';
part 'subscription_model.g.dart';

@Freezed(equal: true, toJson: false, fromJson: false)
@JsonSerializable(fieldRename: FieldRename.snake)
class SubscriptionModel with _$SubscriptionModel {
  const factory SubscriptionModel({
    required String id,

    required String caption,
    String? comment,

    required double cost,
    required String currency,
    required DateTime firstPay,
    required int interval,
    DateTime? endDate,
    int? notification,

    required int color,
    String? category,

    required bool isActive,

    required bool trialActive,
    int? trialInterval,
    double? trialCost,
    DateTime? trialEndDate,
    int? trialNotification,

    String? supportLink,
    String? supportPhone,
  }) = _SubscriptionModel;

  const SubscriptionModel._();

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionModelToJson(this);
}
