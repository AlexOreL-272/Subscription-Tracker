// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateSubscriptionRequest _$CreateSubscriptionRequestFromJson(
  Map<String, dynamic> json,
) => CreateSubscriptionRequest(
  userId: json['user_id'] as String,
  subscription: SubscriptionModel.fromJson(
    json['subscription'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$CreateSubscriptionRequestToJson(
  CreateSubscriptionRequest instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'subscription': instance.subscription,
};
