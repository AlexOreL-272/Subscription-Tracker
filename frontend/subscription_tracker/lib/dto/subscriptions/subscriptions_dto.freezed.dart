// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscriptions_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CreateSubscriptionDto {
  String get id => throw _privateConstructorUsedError;

  /// Create a copy of CreateSubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateSubscriptionDtoCopyWith<CreateSubscriptionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateSubscriptionDtoCopyWith<$Res> {
  factory $CreateSubscriptionDtoCopyWith(
    CreateSubscriptionDto value,
    $Res Function(CreateSubscriptionDto) then,
  ) = _$CreateSubscriptionDtoCopyWithImpl<$Res, CreateSubscriptionDto>;
  @useResult
  $Res call({String id});
}

/// @nodoc
class _$CreateSubscriptionDtoCopyWithImpl<
  $Res,
  $Val extends CreateSubscriptionDto
>
    implements $CreateSubscriptionDtoCopyWith<$Res> {
  _$CreateSubscriptionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateSubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null}) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateSubscriptionDtoImplCopyWith<$Res>
    implements $CreateSubscriptionDtoCopyWith<$Res> {
  factory _$$CreateSubscriptionDtoImplCopyWith(
    _$CreateSubscriptionDtoImpl value,
    $Res Function(_$CreateSubscriptionDtoImpl) then,
  ) = __$$CreateSubscriptionDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id});
}

/// @nodoc
class __$$CreateSubscriptionDtoImplCopyWithImpl<$Res>
    extends
        _$CreateSubscriptionDtoCopyWithImpl<$Res, _$CreateSubscriptionDtoImpl>
    implements _$$CreateSubscriptionDtoImplCopyWith<$Res> {
  __$$CreateSubscriptionDtoImplCopyWithImpl(
    _$CreateSubscriptionDtoImpl _value,
    $Res Function(_$CreateSubscriptionDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateSubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null}) {
    return _then(
      _$CreateSubscriptionDtoImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc

class _$CreateSubscriptionDtoImpl implements _CreateSubscriptionDto {
  const _$CreateSubscriptionDtoImpl({required this.id});

  @override
  final String id;

  @override
  String toString() {
    return 'CreateSubscriptionDto(id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateSubscriptionDtoImpl &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id);

  /// Create a copy of CreateSubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateSubscriptionDtoImplCopyWith<_$CreateSubscriptionDtoImpl>
  get copyWith =>
      __$$CreateSubscriptionDtoImplCopyWithImpl<_$CreateSubscriptionDtoImpl>(
        this,
        _$identity,
      );
}

abstract class _CreateSubscriptionDto implements CreateSubscriptionDto {
  const factory _CreateSubscriptionDto({required final String id}) =
      _$CreateSubscriptionDtoImpl;

  @override
  String get id;

  /// Create a copy of CreateSubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateSubscriptionDtoImplCopyWith<_$CreateSubscriptionDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UpdateSubscriptionDto {}

/// @nodoc
abstract class $UpdateSubscriptionDtoCopyWith<$Res> {
  factory $UpdateSubscriptionDtoCopyWith(
    UpdateSubscriptionDto value,
    $Res Function(UpdateSubscriptionDto) then,
  ) = _$UpdateSubscriptionDtoCopyWithImpl<$Res, UpdateSubscriptionDto>;
}

/// @nodoc
class _$UpdateSubscriptionDtoCopyWithImpl<
  $Res,
  $Val extends UpdateSubscriptionDto
>
    implements $UpdateSubscriptionDtoCopyWith<$Res> {
  _$UpdateSubscriptionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateSubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$UpdateSubscriptionDtoImplCopyWith<$Res> {
  factory _$$UpdateSubscriptionDtoImplCopyWith(
    _$UpdateSubscriptionDtoImpl value,
    $Res Function(_$UpdateSubscriptionDtoImpl) then,
  ) = __$$UpdateSubscriptionDtoImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UpdateSubscriptionDtoImplCopyWithImpl<$Res>
    extends
        _$UpdateSubscriptionDtoCopyWithImpl<$Res, _$UpdateSubscriptionDtoImpl>
    implements _$$UpdateSubscriptionDtoImplCopyWith<$Res> {
  __$$UpdateSubscriptionDtoImplCopyWithImpl(
    _$UpdateSubscriptionDtoImpl _value,
    $Res Function(_$UpdateSubscriptionDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateSubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UpdateSubscriptionDtoImpl implements _UpdateSubscriptionDto {
  const _$UpdateSubscriptionDtoImpl();

  @override
  String toString() {
    return 'UpdateSubscriptionDto()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateSubscriptionDtoImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

abstract class _UpdateSubscriptionDto implements UpdateSubscriptionDto {
  const factory _UpdateSubscriptionDto() = _$UpdateSubscriptionDtoImpl;
}

/// @nodoc
mixin _$DeleteSubscriptionDto {
  String get id => throw _privateConstructorUsedError;

  /// Create a copy of DeleteSubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeleteSubscriptionDtoCopyWith<DeleteSubscriptionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeleteSubscriptionDtoCopyWith<$Res> {
  factory $DeleteSubscriptionDtoCopyWith(
    DeleteSubscriptionDto value,
    $Res Function(DeleteSubscriptionDto) then,
  ) = _$DeleteSubscriptionDtoCopyWithImpl<$Res, DeleteSubscriptionDto>;
  @useResult
  $Res call({String id});
}

/// @nodoc
class _$DeleteSubscriptionDtoCopyWithImpl<
  $Res,
  $Val extends DeleteSubscriptionDto
>
    implements $DeleteSubscriptionDtoCopyWith<$Res> {
  _$DeleteSubscriptionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeleteSubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null}) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DeleteSubscriptionDtoImplCopyWith<$Res>
    implements $DeleteSubscriptionDtoCopyWith<$Res> {
  factory _$$DeleteSubscriptionDtoImplCopyWith(
    _$DeleteSubscriptionDtoImpl value,
    $Res Function(_$DeleteSubscriptionDtoImpl) then,
  ) = __$$DeleteSubscriptionDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id});
}

/// @nodoc
class __$$DeleteSubscriptionDtoImplCopyWithImpl<$Res>
    extends
        _$DeleteSubscriptionDtoCopyWithImpl<$Res, _$DeleteSubscriptionDtoImpl>
    implements _$$DeleteSubscriptionDtoImplCopyWith<$Res> {
  __$$DeleteSubscriptionDtoImplCopyWithImpl(
    _$DeleteSubscriptionDtoImpl _value,
    $Res Function(_$DeleteSubscriptionDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeleteSubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null}) {
    return _then(
      _$DeleteSubscriptionDtoImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc

class _$DeleteSubscriptionDtoImpl implements _DeleteSubscriptionDto {
  const _$DeleteSubscriptionDtoImpl({required this.id});

  @override
  final String id;

  @override
  String toString() {
    return 'DeleteSubscriptionDto(id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteSubscriptionDtoImpl &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id);

  /// Create a copy of DeleteSubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteSubscriptionDtoImplCopyWith<_$DeleteSubscriptionDtoImpl>
  get copyWith =>
      __$$DeleteSubscriptionDtoImplCopyWithImpl<_$DeleteSubscriptionDtoImpl>(
        this,
        _$identity,
      );
}

abstract class _DeleteSubscriptionDto implements DeleteSubscriptionDto {
  const factory _DeleteSubscriptionDto({required final String id}) =
      _$DeleteSubscriptionDtoImpl;

  @override
  String get id;

  /// Create a copy of DeleteSubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteSubscriptionDtoImplCopyWith<_$DeleteSubscriptionDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
