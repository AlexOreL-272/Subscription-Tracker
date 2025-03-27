// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SubscriptionModel {
  String get id => throw _privateConstructorUsedError;
  String get caption => throw _privateConstructorUsedError;
  String? get supportLink => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  double get cost => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  DateTime get firstPay => throw _privateConstructorUsedError;
  int get interval => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  int get color => throw _privateConstructorUsedError;
}

/// @nodoc

class _$SubscriptionModelImpl implements _SubscriptionModel {
  const _$SubscriptionModelImpl({
    required this.id,
    required this.caption,
    this.supportLink,
    this.category,
    required this.cost,
    required this.currency,
    required this.firstPay,
    required this.interval,
    this.comment,
    required this.color,
  });

  @override
  final String id;
  @override
  final String caption;
  @override
  final String? supportLink;
  @override
  final String? category;
  @override
  final double cost;
  @override
  final String currency;
  @override
  final DateTime firstPay;
  @override
  final int interval;
  @override
  final String? comment;
  @override
  final int color;

  @override
  String toString() {
    return 'SubscriptionModel(id: $id, caption: $caption, supportLink: $supportLink, category: $category, cost: $cost, currency: $currency, firstPay: $firstPay, interval: $interval, comment: $comment, color: $color)';
  }
}

abstract class _SubscriptionModel implements SubscriptionModel {
  const factory _SubscriptionModel({
    required final String id,
    required final String caption,
    final String? supportLink,
    final String? category,
    required final double cost,
    required final String currency,
    required final DateTime firstPay,
    required final int interval,
    final String? comment,
    required final int color,
  }) = _$SubscriptionModelImpl;

  @override
  String get id;
  @override
  String get caption;
  @override
  String? get supportLink;
  @override
  String? get category;
  @override
  double get cost;
  @override
  String get currency;
  @override
  DateTime get firstPay;
  @override
  int get interval;
  @override
  String? get comment;
  @override
  int get color;
}
