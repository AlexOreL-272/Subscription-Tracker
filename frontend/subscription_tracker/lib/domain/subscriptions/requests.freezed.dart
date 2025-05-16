// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'requests.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CreateSubscriptionRequest {
  String get userId => throw _privateConstructorUsedError;
  SubscriptionModel get subscription => throw _privateConstructorUsedError;

  /// Create a copy of CreateSubscriptionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateSubscriptionRequestCopyWith<CreateSubscriptionRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateSubscriptionRequestCopyWith<$Res> {
  factory $CreateSubscriptionRequestCopyWith(
    CreateSubscriptionRequest value,
    $Res Function(CreateSubscriptionRequest) then,
  ) = _$CreateSubscriptionRequestCopyWithImpl<$Res, CreateSubscriptionRequest>;
  @useResult
  $Res call({String userId, SubscriptionModel subscription});

  $SubscriptionModelCopyWith<$Res> get subscription;
}

/// @nodoc
class _$CreateSubscriptionRequestCopyWithImpl<
  $Res,
  $Val extends CreateSubscriptionRequest
>
    implements $CreateSubscriptionRequestCopyWith<$Res> {
  _$CreateSubscriptionRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateSubscriptionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? userId = null, Object? subscription = null}) {
    return _then(
      _value.copyWith(
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
            subscription:
                null == subscription
                    ? _value.subscription
                    : subscription // ignore: cast_nullable_to_non_nullable
                        as SubscriptionModel,
          )
          as $Val,
    );
  }

  /// Create a copy of CreateSubscriptionRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SubscriptionModelCopyWith<$Res> get subscription {
    return $SubscriptionModelCopyWith<$Res>(_value.subscription, (value) {
      return _then(_value.copyWith(subscription: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CreateSubscriptionRequestImplCopyWith<$Res>
    implements $CreateSubscriptionRequestCopyWith<$Res> {
  factory _$$CreateSubscriptionRequestImplCopyWith(
    _$CreateSubscriptionRequestImpl value,
    $Res Function(_$CreateSubscriptionRequestImpl) then,
  ) = __$$CreateSubscriptionRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId, SubscriptionModel subscription});

  @override
  $SubscriptionModelCopyWith<$Res> get subscription;
}

/// @nodoc
class __$$CreateSubscriptionRequestImplCopyWithImpl<$Res>
    extends
        _$CreateSubscriptionRequestCopyWithImpl<
          $Res,
          _$CreateSubscriptionRequestImpl
        >
    implements _$$CreateSubscriptionRequestImplCopyWith<$Res> {
  __$$CreateSubscriptionRequestImplCopyWithImpl(
    _$CreateSubscriptionRequestImpl _value,
    $Res Function(_$CreateSubscriptionRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateSubscriptionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? userId = null, Object? subscription = null}) {
    return _then(
      _$CreateSubscriptionRequestImpl(
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String,
        subscription:
            null == subscription
                ? _value.subscription
                : subscription // ignore: cast_nullable_to_non_nullable
                    as SubscriptionModel,
      ),
    );
  }
}

/// @nodoc

class _$CreateSubscriptionRequestImpl extends _CreateSubscriptionRequest {
  const _$CreateSubscriptionRequestImpl({
    required this.userId,
    required this.subscription,
  }) : super._();

  @override
  final String userId;
  @override
  final SubscriptionModel subscription;

  @override
  String toString() {
    return 'CreateSubscriptionRequest(userId: $userId, subscription: $subscription)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateSubscriptionRequestImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.subscription, subscription) ||
                other.subscription == subscription));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId, subscription);

  /// Create a copy of CreateSubscriptionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateSubscriptionRequestImplCopyWith<_$CreateSubscriptionRequestImpl>
  get copyWith => __$$CreateSubscriptionRequestImplCopyWithImpl<
    _$CreateSubscriptionRequestImpl
  >(this, _$identity);
}

abstract class _CreateSubscriptionRequest extends CreateSubscriptionRequest {
  const factory _CreateSubscriptionRequest({
    required final String userId,
    required final SubscriptionModel subscription,
  }) = _$CreateSubscriptionRequestImpl;
  const _CreateSubscriptionRequest._() : super._();

  @override
  String get userId;
  @override
  SubscriptionModel get subscription;

  /// Create a copy of CreateSubscriptionRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateSubscriptionRequestImplCopyWith<_$CreateSubscriptionRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}
