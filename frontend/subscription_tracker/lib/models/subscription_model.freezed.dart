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
  String? get comment => throw _privateConstructorUsedError;
  double get cost => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(toJson: _formatDatetoJson, fromJson: _formatDateFromJson)
  DateTime get firstPay => throw _privateConstructorUsedError;
  int get interval => throw _privateConstructorUsedError;
  @JsonKey(toJson: _formatDatetoJson, fromJson: _formatDateFromJson)
  DateTime? get endDate => throw _privateConstructorUsedError;
  int? get notification => throw _privateConstructorUsedError;
  int get color => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: false)
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: false)
  bool get trialActive => throw _privateConstructorUsedError;
  int? get trialInterval => throw _privateConstructorUsedError;
  double? get trialCost => throw _privateConstructorUsedError;
  @JsonKey(toJson: _formatDatetoJson, fromJson: _formatDateFromJson)
  DateTime? get trialEndDate => throw _privateConstructorUsedError;
  int? get trialNotification => throw _privateConstructorUsedError;
  String? get supportLink => throw _privateConstructorUsedError;
  String? get supportPhone => throw _privateConstructorUsedError;

  /// Create a copy of SubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionModelCopyWith<SubscriptionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionModelCopyWith<$Res> {
  factory $SubscriptionModelCopyWith(
    SubscriptionModel value,
    $Res Function(SubscriptionModel) then,
  ) = _$SubscriptionModelCopyWithImpl<$Res, SubscriptionModel>;
  @useResult
  $Res call({
    String id,
    String caption,
    String? comment,
    double cost,
    String currency,
    @JsonKey(toJson: _formatDatetoJson, fromJson: _formatDateFromJson)
    DateTime firstPay,
    int interval,
    @JsonKey(toJson: _formatDatetoJson, fromJson: _formatDateFromJson)
    DateTime? endDate,
    int? notification,
    int color,
    String? category,
    @JsonKey(defaultValue: false) bool isActive,
    @JsonKey(defaultValue: false) bool trialActive,
    int? trialInterval,
    double? trialCost,
    @JsonKey(toJson: _formatDatetoJson, fromJson: _formatDateFromJson)
    DateTime? trialEndDate,
    int? trialNotification,
    String? supportLink,
    String? supportPhone,
  });
}

/// @nodoc
class _$SubscriptionModelCopyWithImpl<$Res, $Val extends SubscriptionModel>
    implements $SubscriptionModelCopyWith<$Res> {
  _$SubscriptionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? caption = null,
    Object? comment = freezed,
    Object? cost = null,
    Object? currency = null,
    Object? firstPay = null,
    Object? interval = null,
    Object? endDate = freezed,
    Object? notification = freezed,
    Object? color = null,
    Object? category = freezed,
    Object? isActive = null,
    Object? trialActive = null,
    Object? trialInterval = freezed,
    Object? trialCost = freezed,
    Object? trialEndDate = freezed,
    Object? trialNotification = freezed,
    Object? supportLink = freezed,
    Object? supportPhone = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            caption:
                null == caption
                    ? _value.caption
                    : caption // ignore: cast_nullable_to_non_nullable
                        as String,
            comment:
                freezed == comment
                    ? _value.comment
                    : comment // ignore: cast_nullable_to_non_nullable
                        as String?,
            cost:
                null == cost
                    ? _value.cost
                    : cost // ignore: cast_nullable_to_non_nullable
                        as double,
            currency:
                null == currency
                    ? _value.currency
                    : currency // ignore: cast_nullable_to_non_nullable
                        as String,
            firstPay:
                null == firstPay
                    ? _value.firstPay
                    : firstPay // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            interval:
                null == interval
                    ? _value.interval
                    : interval // ignore: cast_nullable_to_non_nullable
                        as int,
            endDate:
                freezed == endDate
                    ? _value.endDate
                    : endDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            notification:
                freezed == notification
                    ? _value.notification
                    : notification // ignore: cast_nullable_to_non_nullable
                        as int?,
            color:
                null == color
                    ? _value.color
                    : color // ignore: cast_nullable_to_non_nullable
                        as int,
            category:
                freezed == category
                    ? _value.category
                    : category // ignore: cast_nullable_to_non_nullable
                        as String?,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
            trialActive:
                null == trialActive
                    ? _value.trialActive
                    : trialActive // ignore: cast_nullable_to_non_nullable
                        as bool,
            trialInterval:
                freezed == trialInterval
                    ? _value.trialInterval
                    : trialInterval // ignore: cast_nullable_to_non_nullable
                        as int?,
            trialCost:
                freezed == trialCost
                    ? _value.trialCost
                    : trialCost // ignore: cast_nullable_to_non_nullable
                        as double?,
            trialEndDate:
                freezed == trialEndDate
                    ? _value.trialEndDate
                    : trialEndDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            trialNotification:
                freezed == trialNotification
                    ? _value.trialNotification
                    : trialNotification // ignore: cast_nullable_to_non_nullable
                        as int?,
            supportLink:
                freezed == supportLink
                    ? _value.supportLink
                    : supportLink // ignore: cast_nullable_to_non_nullable
                        as String?,
            supportPhone:
                freezed == supportPhone
                    ? _value.supportPhone
                    : supportPhone // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SubscriptionModelImplCopyWith<$Res>
    implements $SubscriptionModelCopyWith<$Res> {
  factory _$$SubscriptionModelImplCopyWith(
    _$SubscriptionModelImpl value,
    $Res Function(_$SubscriptionModelImpl) then,
  ) = __$$SubscriptionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String caption,
    String? comment,
    double cost,
    String currency,
    @JsonKey(toJson: _formatDatetoJson, fromJson: _formatDateFromJson)
    DateTime firstPay,
    int interval,
    @JsonKey(toJson: _formatDatetoJson, fromJson: _formatDateFromJson)
    DateTime? endDate,
    int? notification,
    int color,
    String? category,
    @JsonKey(defaultValue: false) bool isActive,
    @JsonKey(defaultValue: false) bool trialActive,
    int? trialInterval,
    double? trialCost,
    @JsonKey(toJson: _formatDatetoJson, fromJson: _formatDateFromJson)
    DateTime? trialEndDate,
    int? trialNotification,
    String? supportLink,
    String? supportPhone,
  });
}

/// @nodoc
class __$$SubscriptionModelImplCopyWithImpl<$Res>
    extends _$SubscriptionModelCopyWithImpl<$Res, _$SubscriptionModelImpl>
    implements _$$SubscriptionModelImplCopyWith<$Res> {
  __$$SubscriptionModelImplCopyWithImpl(
    _$SubscriptionModelImpl _value,
    $Res Function(_$SubscriptionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? caption = null,
    Object? comment = freezed,
    Object? cost = null,
    Object? currency = null,
    Object? firstPay = null,
    Object? interval = null,
    Object? endDate = freezed,
    Object? notification = freezed,
    Object? color = null,
    Object? category = freezed,
    Object? isActive = null,
    Object? trialActive = null,
    Object? trialInterval = freezed,
    Object? trialCost = freezed,
    Object? trialEndDate = freezed,
    Object? trialNotification = freezed,
    Object? supportLink = freezed,
    Object? supportPhone = freezed,
  }) {
    return _then(
      _$SubscriptionModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        caption:
            null == caption
                ? _value.caption
                : caption // ignore: cast_nullable_to_non_nullable
                    as String,
        comment:
            freezed == comment
                ? _value.comment
                : comment // ignore: cast_nullable_to_non_nullable
                    as String?,
        cost:
            null == cost
                ? _value.cost
                : cost // ignore: cast_nullable_to_non_nullable
                    as double,
        currency:
            null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                    as String,
        firstPay:
            null == firstPay
                ? _value.firstPay
                : firstPay // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        interval:
            null == interval
                ? _value.interval
                : interval // ignore: cast_nullable_to_non_nullable
                    as int,
        endDate:
            freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        notification:
            freezed == notification
                ? _value.notification
                : notification // ignore: cast_nullable_to_non_nullable
                    as int?,
        color:
            null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                    as int,
        category:
            freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                    as String?,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        trialActive:
            null == trialActive
                ? _value.trialActive
                : trialActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        trialInterval:
            freezed == trialInterval
                ? _value.trialInterval
                : trialInterval // ignore: cast_nullable_to_non_nullable
                    as int?,
        trialCost:
            freezed == trialCost
                ? _value.trialCost
                : trialCost // ignore: cast_nullable_to_non_nullable
                    as double?,
        trialEndDate:
            freezed == trialEndDate
                ? _value.trialEndDate
                : trialEndDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        trialNotification:
            freezed == trialNotification
                ? _value.trialNotification
                : trialNotification // ignore: cast_nullable_to_non_nullable
                    as int?,
        supportLink:
            freezed == supportLink
                ? _value.supportLink
                : supportLink // ignore: cast_nullable_to_non_nullable
                    as String?,
        supportPhone:
            freezed == supportPhone
                ? _value.supportPhone
                : supportPhone // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$SubscriptionModelImpl extends _SubscriptionModel {
  const _$SubscriptionModelImpl({
    required this.id,
    required this.caption,
    this.comment,
    required this.cost,
    required this.currency,
    @JsonKey(toJson: _formatDatetoJson, fromJson: _formatDateFromJson)
    required this.firstPay,
    required this.interval,
    @JsonKey(toJson: _formatDatetoJson, fromJson: _formatDateFromJson)
    this.endDate,
    this.notification,
    required this.color,
    this.category,
    @JsonKey(defaultValue: false) required this.isActive,
    @JsonKey(defaultValue: false) required this.trialActive,
    this.trialInterval,
    this.trialCost,
    @JsonKey(toJson: _formatDatetoJson, fromJson: _formatDateFromJson)
    this.trialEndDate,
    this.trialNotification,
    this.supportLink,
    this.supportPhone,
  }) : super._();

  @override
  final String id;
  @override
  final String caption;
  @override
  final String? comment;
  @override
  final double cost;
  @override
  final String currency;
  @override
  @JsonKey(toJson: _formatDatetoJson, fromJson: _formatDateFromJson)
  final DateTime firstPay;
  @override
  final int interval;
  @override
  @JsonKey(toJson: _formatDatetoJson, fromJson: _formatDateFromJson)
  final DateTime? endDate;
  @override
  final int? notification;
  @override
  final int color;
  @override
  final String? category;
  @override
  @JsonKey(defaultValue: false)
  final bool isActive;
  @override
  @JsonKey(defaultValue: false)
  final bool trialActive;
  @override
  final int? trialInterval;
  @override
  final double? trialCost;
  @override
  @JsonKey(toJson: _formatDatetoJson, fromJson: _formatDateFromJson)
  final DateTime? trialEndDate;
  @override
  final int? trialNotification;
  @override
  final String? supportLink;
  @override
  final String? supportPhone;

  @override
  String toString() {
    return 'SubscriptionModel(id: $id, caption: $caption, comment: $comment, cost: $cost, currency: $currency, firstPay: $firstPay, interval: $interval, endDate: $endDate, notification: $notification, color: $color, category: $category, isActive: $isActive, trialActive: $trialActive, trialInterval: $trialInterval, trialCost: $trialCost, trialEndDate: $trialEndDate, trialNotification: $trialNotification, supportLink: $supportLink, supportPhone: $supportPhone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.firstPay, firstPay) ||
                other.firstPay == firstPay) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.notification, notification) ||
                other.notification == notification) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.trialActive, trialActive) ||
                other.trialActive == trialActive) &&
            (identical(other.trialInterval, trialInterval) ||
                other.trialInterval == trialInterval) &&
            (identical(other.trialCost, trialCost) ||
                other.trialCost == trialCost) &&
            (identical(other.trialEndDate, trialEndDate) ||
                other.trialEndDate == trialEndDate) &&
            (identical(other.trialNotification, trialNotification) ||
                other.trialNotification == trialNotification) &&
            (identical(other.supportLink, supportLink) ||
                other.supportLink == supportLink) &&
            (identical(other.supportPhone, supportPhone) ||
                other.supportPhone == supportPhone));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    caption,
    comment,
    cost,
    currency,
    firstPay,
    interval,
    endDate,
    notification,
    color,
    category,
    isActive,
    trialActive,
    trialInterval,
    trialCost,
    trialEndDate,
    trialNotification,
    supportLink,
    supportPhone,
  ]);

  /// Create a copy of SubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionModelImplCopyWith<_$SubscriptionModelImpl> get copyWith =>
      __$$SubscriptionModelImplCopyWithImpl<_$SubscriptionModelImpl>(
        this,
        _$identity,
      );
}

abstract class _SubscriptionModel extends SubscriptionModel {
  const factory _SubscriptionModel({
    required final String id,
    required final String caption,
    final String? comment,
    required final double cost,
    required final String currency,
    @JsonKey(toJson: _formatDatetoJson, fromJson: _formatDateFromJson)
    required final DateTime firstPay,
    required final int interval,
    @JsonKey(toJson: _formatDatetoJson, fromJson: _formatDateFromJson)
    final DateTime? endDate,
    final int? notification,
    required final int color,
    final String? category,
    @JsonKey(defaultValue: false) required final bool isActive,
    @JsonKey(defaultValue: false) required final bool trialActive,
    final int? trialInterval,
    final double? trialCost,
    @JsonKey(toJson: _formatDatetoJson, fromJson: _formatDateFromJson)
    final DateTime? trialEndDate,
    final int? trialNotification,
    final String? supportLink,
    final String? supportPhone,
  }) = _$SubscriptionModelImpl;
  const _SubscriptionModel._() : super._();

  @override
  String get id;
  @override
  String get caption;
  @override
  String? get comment;
  @override
  double get cost;
  @override
  String get currency;
  @override
  @JsonKey(toJson: _formatDatetoJson, fromJson: _formatDateFromJson)
  DateTime get firstPay;
  @override
  int get interval;
  @override
  @JsonKey(toJson: _formatDatetoJson, fromJson: _formatDateFromJson)
  DateTime? get endDate;
  @override
  int? get notification;
  @override
  int get color;
  @override
  String? get category;
  @override
  @JsonKey(defaultValue: false)
  bool get isActive;
  @override
  @JsonKey(defaultValue: false)
  bool get trialActive;
  @override
  int? get trialInterval;
  @override
  double? get trialCost;
  @override
  @JsonKey(toJson: _formatDatetoJson, fromJson: _formatDateFromJson)
  DateTime? get trialEndDate;
  @override
  int? get trialNotification;
  @override
  String? get supportLink;
  @override
  String? get supportPhone;

  /// Create a copy of SubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionModelImplCopyWith<_$SubscriptionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
