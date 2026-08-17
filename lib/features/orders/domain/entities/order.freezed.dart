// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Order {

 String get id; List<CartItem> get items; CartTotals get totals; OrderStatus get status;@JsonKey(name: 'placed_at') DateTime get placedAt;// Short code the customer shows at the counter.
@JsonKey(name: 'pickup_code') String get pickupCode;
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCopyWith<Order> get copyWith => _$OrderCopyWithImpl<Order>(this as Order, _$identity);

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Order&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.totals, totals) || other.totals == totals)&&(identical(other.status, status) || other.status == status)&&(identical(other.placedAt, placedAt) || other.placedAt == placedAt)&&(identical(other.pickupCode, pickupCode) || other.pickupCode == pickupCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(items),totals,status,placedAt,pickupCode);

@override
String toString() {
  return 'Order(id: $id, items: $items, totals: $totals, status: $status, placedAt: $placedAt, pickupCode: $pickupCode)';
}


}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res>  {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) = _$OrderCopyWithImpl;
@useResult
$Res call({
 String id, List<CartItem> items, CartTotals totals, OrderStatus status,@JsonKey(name: 'placed_at') DateTime placedAt,@JsonKey(name: 'pickup_code') String pickupCode
});


$CartTotalsCopyWith<$Res> get totals;

}
/// @nodoc
class _$OrderCopyWithImpl<$Res>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._self, this._then);

  final Order _self;
  final $Res Function(Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? items = null,Object? totals = null,Object? status = null,Object? placedAt = null,Object? pickupCode = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CartItem>,totals: null == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as CartTotals,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,placedAt: null == placedAt ? _self.placedAt : placedAt // ignore: cast_nullable_to_non_nullable
as DateTime,pickupCode: null == pickupCode ? _self.pickupCode : pickupCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CartTotalsCopyWith<$Res> get totals {
  
  return $CartTotalsCopyWith<$Res>(_self.totals, (value) {
    return _then(_self.copyWith(totals: value));
  });
}
}


/// Adds pattern-matching-related methods to [Order].
extension OrderPatterns on Order {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Order value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Order value)  $default,){
final _that = this;
switch (_that) {
case _Order():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Order value)?  $default,){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  List<CartItem> items,  CartTotals totals,  OrderStatus status, @JsonKey(name: 'placed_at')  DateTime placedAt, @JsonKey(name: 'pickup_code')  String pickupCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.items,_that.totals,_that.status,_that.placedAt,_that.pickupCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  List<CartItem> items,  CartTotals totals,  OrderStatus status, @JsonKey(name: 'placed_at')  DateTime placedAt, @JsonKey(name: 'pickup_code')  String pickupCode)  $default,) {final _that = this;
switch (_that) {
case _Order():
return $default(_that.id,_that.items,_that.totals,_that.status,_that.placedAt,_that.pickupCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  List<CartItem> items,  CartTotals totals,  OrderStatus status, @JsonKey(name: 'placed_at')  DateTime placedAt, @JsonKey(name: 'pickup_code')  String pickupCode)?  $default,) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.items,_that.totals,_that.status,_that.placedAt,_that.pickupCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Order extends Order {
  const _Order({required this.id, required final  List<CartItem> items, required this.totals, required this.status, @JsonKey(name: 'placed_at') required this.placedAt, @JsonKey(name: 'pickup_code') required this.pickupCode}): _items = items,super._();
  factory _Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

@override final  String id;
 final  List<CartItem> _items;
@override List<CartItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  CartTotals totals;
@override final  OrderStatus status;
@override@JsonKey(name: 'placed_at') final  DateTime placedAt;
// Short code the customer shows at the counter.
@override@JsonKey(name: 'pickup_code') final  String pickupCode;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderCopyWith<_Order> get copyWith => __$OrderCopyWithImpl<_Order>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Order&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.totals, totals) || other.totals == totals)&&(identical(other.status, status) || other.status == status)&&(identical(other.placedAt, placedAt) || other.placedAt == placedAt)&&(identical(other.pickupCode, pickupCode) || other.pickupCode == pickupCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_items),totals,status,placedAt,pickupCode);

@override
String toString() {
  return 'Order(id: $id, items: $items, totals: $totals, status: $status, placedAt: $placedAt, pickupCode: $pickupCode)';
}


}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) = __$OrderCopyWithImpl;
@override @useResult
$Res call({
 String id, List<CartItem> items, CartTotals totals, OrderStatus status,@JsonKey(name: 'placed_at') DateTime placedAt,@JsonKey(name: 'pickup_code') String pickupCode
});


@override $CartTotalsCopyWith<$Res> get totals;

}
/// @nodoc
class __$OrderCopyWithImpl<$Res>
    implements _$OrderCopyWith<$Res> {
  __$OrderCopyWithImpl(this._self, this._then);

  final _Order _self;
  final $Res Function(_Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? items = null,Object? totals = null,Object? status = null,Object? placedAt = null,Object? pickupCode = null,}) {
  return _then(_Order(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CartItem>,totals: null == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as CartTotals,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,placedAt: null == placedAt ? _self.placedAt : placedAt // ignore: cast_nullable_to_non_nullable
as DateTime,pickupCode: null == pickupCode ? _self.pickupCode : pickupCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CartTotalsCopyWith<$Res> get totals {
  
  return $CartTotalsCopyWith<$Res>(_self.totals, (value) {
    return _then(_self.copyWith(totals: value));
  });
}
}

// dart format on
