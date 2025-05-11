import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:subscription_tracker/models/subscription_model.dart';

part 'requests.freezed.dart';
part 'requests.g.dart';

@Freezed(equal: true, toJson: false, fromJson: false)
@JsonSerializable(fieldRename: FieldRename.snake)
class CreateSubscriptionRequest with _$CreateSubscriptionRequest {
  const factory CreateSubscriptionRequest({
    required String userId,
    required SubscriptionModel subscription,
  }) = _CreateSubscriptionRequest;

  const CreateSubscriptionRequest._();

  factory CreateSubscriptionRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateSubscriptionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateSubscriptionRequestToJson(this);
}
