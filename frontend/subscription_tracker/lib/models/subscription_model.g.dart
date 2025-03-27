// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) =>
    SubscriptionModel(
      id: json['id'] as String,
      caption: json['caption'] as String,
      supportLink: json['support_link'] as String?,
      category: json['category'] as String?,
      cost: (json['cost'] as num).toDouble(),
      currency: json['currency'] as String,
      firstPay: DateTime.parse(json['first_pay'] as String),
      interval: (json['interval'] as num).toInt(),
      comment: json['comment'] as String?,
      color: (json['color'] as num).toInt(),
    );
