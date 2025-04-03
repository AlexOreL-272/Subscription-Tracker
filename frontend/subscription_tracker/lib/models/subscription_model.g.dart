// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) =>
    SubscriptionModel(
      id: json['id'] as String,
      caption: json['caption'] as String,
      comment: json['comment'] as String?,
      cost: (json['cost'] as num).toDouble(),
      currency: json['currency'] as String,
      firstPay: DateTime.parse(json['first_pay'] as String),
      interval: (json['interval'] as num).toInt(),
      endDate:
          json['end_date'] == null
              ? null
              : DateTime.parse(json['end_date'] as String),
      notification: (json['notification'] as num?)?.toInt(),
      color: (json['color'] as num).toInt(),
      category: json['category'] as String?,
      isActive: json['is_active'] as bool,
      trialActive: json['trial_active'] as bool,
      trialInterval: (json['trial_interval'] as num?)?.toInt(),
      trialCost: (json['trial_cost'] as num?)?.toDouble(),
      trialEndDate:
          json['trial_end_date'] == null
              ? null
              : DateTime.parse(json['trial_end_date'] as String),
      trialNotification: (json['trial_notification'] as num?)?.toInt(),
      supportLink: json['support_link'] as String?,
      supportPhone: json['support_phone'] as String?,
    );
