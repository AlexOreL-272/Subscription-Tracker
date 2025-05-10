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
      firstPay: _formatDateFromJson(json['first_pay'] as String?),
      interval: (json['interval'] as num).toInt(),
      endDate: _formatDateFromJson(json['end_date'] as String?),
      notification: (json['notification'] as num?)?.toInt(),
      color: (json['color'] as num).toInt(),
      category: json['category'] as String?,
      isActive: json['is_active'] as bool? ?? false,
      trialActive: json['trial_active'] as bool? ?? false,
      trialInterval: (json['trial_interval'] as num?)?.toInt(),
      trialCost: (json['trial_cost'] as num?)?.toDouble(),
      trialEndDate: _formatDateFromJson(json['trial_end_date'] as String?),
      trialNotification: (json['trial_notification'] as num?)?.toInt(),
      supportLink: json['support_link'] as String?,
      supportPhone: json['support_phone'] as String?,
    );

Map<String, dynamic> _$SubscriptionModelToJson(SubscriptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'caption': instance.caption,
      'comment': instance.comment,
      'cost': instance.cost,
      'currency': instance.currency,
      'first_pay': _formatDatetoJson(instance.firstPay),
      'interval': instance.interval,
      'end_date': _formatDatetoJson(instance.endDate),
      'notification': instance.notification,
      'color': instance.color,
      'category': instance.category,
      'is_active': instance.isActive,
      'trial_active': instance.trialActive,
      'trial_interval': instance.trialInterval,
      'trial_cost': instance.trialCost,
      'trial_end_date': _formatDatetoJson(instance.trialEndDate),
      'trial_notification': instance.trialNotification,
      'support_link': instance.supportLink,
      'support_phone': instance.supportPhone,
    };
