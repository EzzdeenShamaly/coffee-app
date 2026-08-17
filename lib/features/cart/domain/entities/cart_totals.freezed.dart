// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_totals.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CartTotals {

@JsonKey(name: 'subtotal_cents') int get subtotalCents;@JsonKey(name: 'tax_cents') int get taxCents;@JsonKey(name: 'total_cents') int get totalCents;@JsonKey(name: 'item_count') int get itemCount;
/// Create a copy of CartTotals
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartTotalsCopyWith<CartTotals> get copyWith => _$CartTotalsCopyWithImpl<CartTotals>(this as CartTotals, _$identity);

  /// Serializes this CartTotals to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartTotals&&(identical(other.subtotalCents, subtotalCents) || other.subtotalCents == subtotalCents)&&(identical(other.taxCents, taxCents) || other.taxCents == taxCents)&&(identical(other.totalCents, totalCents) || other.totalCents == totalCents)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subtotalCents,taxCents,totalCents,itemCount);

@override
String toString() {
  return 'CartTotals(subtotalCents: $subtotalCents, taxCents: $taxCents, totalCents: $totalCents, itemCount: $itemCount)';
}


}

/// @nodoc
abstract mixin class $CartTotalsCopyWith<$Res>  {
  factory $CartTotalsCopyWith(CartTotals value, $Res Function(CartTotals) _then) = _$CartTotalsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'subtotal_cents') int subtotalCents,@JsonKey(name: 'tax_cents') int taxCents,@JsonKey(name: 'total_cents') int totalCents,@JsonKey(name: 'item_count') int itemCount
});




}
/// @nodoc
class _$CartTotalsCopyWithImpl<$Res>
    implements $CartTotalsCopyWith<$Res> {
  _$CartTotalsCopyWithImpl(this._self, this._then);

  final CartTotals _self;
  final $Res Function(CartTotals) _then;

/// Create a copy of CartTotals
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subtotalCents = null,Object? taxCents = null,Object? totalCents = null,Object? itemCount = null,}) {
  return _then(_self.copyWith(
subtotalCents: null == subtotalCents ? _self.subtotalCents : subtotalCents // ignore: cast_nullable_to_non_nullable
as int,taxCents: null == taxCents ? _self.taxCents : taxCents // ignore: cast_nullable_to_non_nullable
as int,totalCents: null == totalCents ? _self.totalCents : totalCents // ignore: cast_nullable_to_non_nullable
as int,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CartTotals].
extension CartTotalsPatterns on CartTotals {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartTotals value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartTotals() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartTotals value)  $default,){
final _that = this;
switch (_that) {
case _CartTotals():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartTotals value)?  $default,){
final _that = this;
switch (_that) {
case _CartTotals() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'subtotal_cents')  int subtotalCents, @JsonKey(name: 'tax_cents')  int taxCents, @JsonKey(name: 'total_cents')  int totalCents, @JsonKey(name: 'item_count')  int itemCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartTotals() when $default != null:
return $default(_that.subtotalCents,_that.taxCents,_that.totalCents,_that.itemCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'subtotal_cents')  int subtotalCents, @JsonKey(name: 'tax_cents')  int taxCents, @JsonKey(name: 'total_cents')  int totalCents, @JsonKey(name: 'item_count')  int itemCount)  $default,) {final _that = this;
switch (_that) {
case _CartTotals():
return $default(_that.subtotalCents,_that.taxCents,_that.totalCents,_that.itemCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'subtotal_cents')  int subtotalCents, @JsonKey(name: 'tax_cents')  int taxCents, @JsonKey(name: 'total_cents')  int totalCents, @JsonKey(name: 'item_count')  int itemCount)?  $default,) {final _that = this;
switch (_that) {
case _CartTotals() when $default != null:
return $default(_that.subtotalCents,_that.taxCents,_that.totalCents,_that.itemCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CartTotals extends CartTotals {
  const _CartTotals({@JsonKey(name: 'subtotal_cents') required this.subtotalCents, @JsonKey(name: 'tax_cents') required this.taxCents, @JsonKey(name: 'total_cents') required this.totalCents, @JsonKey(name: 'item_count') required this.itemCount}): super._();
  factory _CartTotals.fromJson(Map<String, dynamic> json) => _$CartTotalsFromJson(json);

@override@JsonKey(name: 'subtotal_cents') final  int subtotalCents;
@override@JsonKey(name: 'tax_cents') final  int taxCents;
@override@JsonKey(name: 'total_cents') final  int totalCents;
@override@JsonKey(name: 'item_count') final  int itemCount;

/// Create a copy of CartTotals
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartTotalsCopyWith<_CartTotals> get copyWith => __$CartTotalsCopyWithImpl<_CartTotals>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CartTotalsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartTotals&&(identical(other.subtotalCents, subtotalCents) || other.subtotalCents == subtotalCents)&&(identical(other.taxCents, taxCents) || other.taxCents == taxCents)&&(identical(other.totalCents, totalCents) || other.totalCents == totalCents)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subtotalCents,taxCents,totalCents,itemCount);

@override
String toString() {
  return 'CartTotals(subtotalCents: $subtotalCents, taxCents: $taxCents, totalCents: $totalCents, itemCount: $itemCount)';
}


}

/// @nodoc
abstract mixin class _$CartTotalsCopyWith<$Res> implements $CartTotalsCopyWith<$Res> {
  factory _$CartTotalsCopyWith(_CartTotals value, $Res Function(_CartTotals) _then) = __$CartTotalsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'subtotal_cents') int subtotalCents,@JsonKey(name: 'tax_cents') int taxCents,@JsonKey(name: 'total_cents') int totalCents,@JsonKey(name: 'item_count') int itemCount
});




}
/// @nodoc
class __$CartTotalsCopyWithImpl<$Res>
    implements _$CartTotalsCopyWith<$Res> {
  __$CartTotalsCopyWithImpl(this._self, this._then);

  final _CartTotals _self;
  final $Res Function(_CartTotals) _then;

/// Create a copy of CartTotals
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subtotalCents = null,Object? taxCents = null,Object? totalCents = null,Object? itemCount = null,}) {
  return _then(_CartTotals(
subtotalCents: null == subtotalCents ? _self.subtotalCents : subtotalCents // ignore: cast_nullable_to_non_nullable
as int,taxCents: null == taxCents ? _self.taxCents : taxCents // ignore: cast_nullable_to_non_nullable
as int,totalCents: null == totalCents ? _self.totalCents : totalCents // ignore: cast_nullable_to_non_nullable
as int,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
