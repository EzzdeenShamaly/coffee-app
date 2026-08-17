// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drink.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Drink {

 String get id; String get name; String get description;@JsonKey(name: 'base_price_cents') int get basePriceCents; DrinkCategory get category;@JsonKey(name: 'image_url') String? get imageUrl;@JsonKey(name: 'is_available') bool get isAvailable;
/// Create a copy of Drink
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrinkCopyWith<Drink> get copyWith => _$DrinkCopyWithImpl<Drink>(this as Drink, _$identity);

  /// Serializes this Drink to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Drink&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.basePriceCents, basePriceCents) || other.basePriceCents == basePriceCents)&&(identical(other.category, category) || other.category == category)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,basePriceCents,category,imageUrl,isAvailable);

@override
String toString() {
  return 'Drink(id: $id, name: $name, description: $description, basePriceCents: $basePriceCents, category: $category, imageUrl: $imageUrl, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class $DrinkCopyWith<$Res>  {
  factory $DrinkCopyWith(Drink value, $Res Function(Drink) _then) = _$DrinkCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description,@JsonKey(name: 'base_price_cents') int basePriceCents, DrinkCategory category,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'is_available') bool isAvailable
});




}
/// @nodoc
class _$DrinkCopyWithImpl<$Res>
    implements $DrinkCopyWith<$Res> {
  _$DrinkCopyWithImpl(this._self, this._then);

  final Drink _self;
  final $Res Function(Drink) _then;

/// Create a copy of Drink
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? basePriceCents = null,Object? category = null,Object? imageUrl = freezed,Object? isAvailable = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,basePriceCents: null == basePriceCents ? _self.basePriceCents : basePriceCents // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as DrinkCategory,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Drink].
extension DrinkPatterns on Drink {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Drink value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Drink() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Drink value)  $default,){
final _that = this;
switch (_that) {
case _Drink():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Drink value)?  $default,){
final _that = this;
switch (_that) {
case _Drink() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description, @JsonKey(name: 'base_price_cents')  int basePriceCents,  DrinkCategory category, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'is_available')  bool isAvailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Drink() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.basePriceCents,_that.category,_that.imageUrl,_that.isAvailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description, @JsonKey(name: 'base_price_cents')  int basePriceCents,  DrinkCategory category, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'is_available')  bool isAvailable)  $default,) {final _that = this;
switch (_that) {
case _Drink():
return $default(_that.id,_that.name,_that.description,_that.basePriceCents,_that.category,_that.imageUrl,_that.isAvailable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description, @JsonKey(name: 'base_price_cents')  int basePriceCents,  DrinkCategory category, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'is_available')  bool isAvailable)?  $default,) {final _that = this;
switch (_that) {
case _Drink() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.basePriceCents,_that.category,_that.imageUrl,_that.isAvailable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Drink extends Drink {
  const _Drink({required this.id, required this.name, required this.description, @JsonKey(name: 'base_price_cents') required this.basePriceCents, required this.category, @JsonKey(name: 'image_url') this.imageUrl, @JsonKey(name: 'is_available') this.isAvailable = true}): super._();
  factory _Drink.fromJson(Map<String, dynamic> json) => _$DrinkFromJson(json);

@override final  String id;
@override final  String name;
@override final  String description;
@override@JsonKey(name: 'base_price_cents') final  int basePriceCents;
@override final  DrinkCategory category;
@override@JsonKey(name: 'image_url') final  String? imageUrl;
@override@JsonKey(name: 'is_available') final  bool isAvailable;

/// Create a copy of Drink
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrinkCopyWith<_Drink> get copyWith => __$DrinkCopyWithImpl<_Drink>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DrinkToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Drink&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.basePriceCents, basePriceCents) || other.basePriceCents == basePriceCents)&&(identical(other.category, category) || other.category == category)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,basePriceCents,category,imageUrl,isAvailable);

@override
String toString() {
  return 'Drink(id: $id, name: $name, description: $description, basePriceCents: $basePriceCents, category: $category, imageUrl: $imageUrl, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class _$DrinkCopyWith<$Res> implements $DrinkCopyWith<$Res> {
  factory _$DrinkCopyWith(_Drink value, $Res Function(_Drink) _then) = __$DrinkCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description,@JsonKey(name: 'base_price_cents') int basePriceCents, DrinkCategory category,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'is_available') bool isAvailable
});




}
/// @nodoc
class __$DrinkCopyWithImpl<$Res>
    implements _$DrinkCopyWith<$Res> {
  __$DrinkCopyWithImpl(this._self, this._then);

  final _Drink _self;
  final $Res Function(_Drink) _then;

/// Create a copy of Drink
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? basePriceCents = null,Object? category = null,Object? imageUrl = freezed,Object? isAvailable = null,}) {
  return _then(_Drink(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,basePriceCents: null == basePriceCents ? _self.basePriceCents : basePriceCents // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as DrinkCategory,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
