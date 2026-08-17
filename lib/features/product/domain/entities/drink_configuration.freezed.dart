// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drink_configuration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DrinkConfiguration {

 DrinkSize get size; MilkOption get milk; List<DrinkExtra> get extras;
/// Create a copy of DrinkConfiguration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrinkConfigurationCopyWith<DrinkConfiguration> get copyWith => _$DrinkConfigurationCopyWithImpl<DrinkConfiguration>(this as DrinkConfiguration, _$identity);

  /// Serializes this DrinkConfiguration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrinkConfiguration&&(identical(other.size, size) || other.size == size)&&(identical(other.milk, milk) || other.milk == milk)&&const DeepCollectionEquality().equals(other.extras, extras));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,size,milk,const DeepCollectionEquality().hash(extras));

@override
String toString() {
  return 'DrinkConfiguration(size: $size, milk: $milk, extras: $extras)';
}


}

/// @nodoc
abstract mixin class $DrinkConfigurationCopyWith<$Res>  {
  factory $DrinkConfigurationCopyWith(DrinkConfiguration value, $Res Function(DrinkConfiguration) _then) = _$DrinkConfigurationCopyWithImpl;
@useResult
$Res call({
 DrinkSize size, MilkOption milk, List<DrinkExtra> extras
});




}
/// @nodoc
class _$DrinkConfigurationCopyWithImpl<$Res>
    implements $DrinkConfigurationCopyWith<$Res> {
  _$DrinkConfigurationCopyWithImpl(this._self, this._then);

  final DrinkConfiguration _self;
  final $Res Function(DrinkConfiguration) _then;

/// Create a copy of DrinkConfiguration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? size = null,Object? milk = null,Object? extras = null,}) {
  return _then(_self.copyWith(
size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as DrinkSize,milk: null == milk ? _self.milk : milk // ignore: cast_nullable_to_non_nullable
as MilkOption,extras: null == extras ? _self.extras : extras // ignore: cast_nullable_to_non_nullable
as List<DrinkExtra>,
  ));
}

}


/// Adds pattern-matching-related methods to [DrinkConfiguration].
extension DrinkConfigurationPatterns on DrinkConfiguration {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DrinkConfiguration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DrinkConfiguration() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DrinkConfiguration value)  $default,){
final _that = this;
switch (_that) {
case _DrinkConfiguration():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DrinkConfiguration value)?  $default,){
final _that = this;
switch (_that) {
case _DrinkConfiguration() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DrinkSize size,  MilkOption milk,  List<DrinkExtra> extras)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DrinkConfiguration() when $default != null:
return $default(_that.size,_that.milk,_that.extras);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DrinkSize size,  MilkOption milk,  List<DrinkExtra> extras)  $default,) {final _that = this;
switch (_that) {
case _DrinkConfiguration():
return $default(_that.size,_that.milk,_that.extras);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DrinkSize size,  MilkOption milk,  List<DrinkExtra> extras)?  $default,) {final _that = this;
switch (_that) {
case _DrinkConfiguration() when $default != null:
return $default(_that.size,_that.milk,_that.extras);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DrinkConfiguration extends DrinkConfiguration {
  const _DrinkConfiguration({this.size = DrinkSize.medium, this.milk = MilkOption.whole, final  List<DrinkExtra> extras = const <DrinkExtra>[]}): _extras = extras,super._();
  factory _DrinkConfiguration.fromJson(Map<String, dynamic> json) => _$DrinkConfigurationFromJson(json);

@override@JsonKey() final  DrinkSize size;
@override@JsonKey() final  MilkOption milk;
 final  List<DrinkExtra> _extras;
@override@JsonKey() List<DrinkExtra> get extras {
  if (_extras is EqualUnmodifiableListView) return _extras;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_extras);
}


/// Create a copy of DrinkConfiguration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrinkConfigurationCopyWith<_DrinkConfiguration> get copyWith => __$DrinkConfigurationCopyWithImpl<_DrinkConfiguration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DrinkConfigurationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DrinkConfiguration&&(identical(other.size, size) || other.size == size)&&(identical(other.milk, milk) || other.milk == milk)&&const DeepCollectionEquality().equals(other._extras, _extras));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,size,milk,const DeepCollectionEquality().hash(_extras));

@override
String toString() {
  return 'DrinkConfiguration(size: $size, milk: $milk, extras: $extras)';
}


}

/// @nodoc
abstract mixin class _$DrinkConfigurationCopyWith<$Res> implements $DrinkConfigurationCopyWith<$Res> {
  factory _$DrinkConfigurationCopyWith(_DrinkConfiguration value, $Res Function(_DrinkConfiguration) _then) = __$DrinkConfigurationCopyWithImpl;
@override @useResult
$Res call({
 DrinkSize size, MilkOption milk, List<DrinkExtra> extras
});




}
/// @nodoc
class __$DrinkConfigurationCopyWithImpl<$Res>
    implements _$DrinkConfigurationCopyWith<$Res> {
  __$DrinkConfigurationCopyWithImpl(this._self, this._then);

  final _DrinkConfiguration _self;
  final $Res Function(_DrinkConfiguration) _then;

/// Create a copy of DrinkConfiguration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? size = null,Object? milk = null,Object? extras = null,}) {
  return _then(_DrinkConfiguration(
size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as DrinkSize,milk: null == milk ? _self.milk : milk // ignore: cast_nullable_to_non_nullable
as MilkOption,extras: null == extras ? _self._extras : extras // ignore: cast_nullable_to_non_nullable
as List<DrinkExtra>,
  ));
}


}

// dart format on
