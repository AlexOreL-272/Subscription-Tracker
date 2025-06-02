import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_model.freezed.dart';
part 'subscription_model.g.dart';

String _formatDatetoJson(DateTime? date) {
  if (date == null) {
    return '0001-01-01T00:00:00Z';
  }

  return date.toUtc().toIso8601String().replaceFirst(' ', 'T');
}

DateTime _formatDateFromJson(String? date) {
  if (date == null) {
    return DateTime.parse('0001-01-01T00:00:00');
  }

  final zoneIndex = date.indexOf('Z');
  if (zoneIndex == -1) {
    return DateTime.parse(date);
  }

  return DateTime.parse(date.substring(0, zoneIndex));
}

@Freezed(equal: true, toJson: false, fromJson: false)
@JsonSerializable(fieldRename: FieldRename.snake)
class SubscriptionModel with _$SubscriptionModel {
  const factory SubscriptionModel({
    required String id,

    required String caption,
    String? comment,

    @JsonKey(defaultValue: 0.0) required double cost,
    required String currency,

    @JsonKey(toJson: _formatDatetoJson, fromJson: _formatDateFromJson)
    required DateTime firstPay,
    required int interval,
    @JsonKey(toJson: _formatDatetoJson, fromJson: _formatDateFromJson)
    DateTime? endDate,
    int? notification,

    required int color,
    String? category,

    @JsonKey(defaultValue: false) required bool isActive,

    @JsonKey(defaultValue: false) required bool trialActive,
    int? trialInterval,
    double? trialCost,
    @JsonKey(toJson: _formatDatetoJson, fromJson: _formatDateFromJson)
    DateTime? trialEndDate,
    int? trialNotification,

    String? supportLink,
    String? supportPhone,
  }) = _SubscriptionModel;

  const SubscriptionModel._();

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);

  Map<String, dynamic> toJson() {
    return _$SubscriptionModelToJson(this);
  }
}
