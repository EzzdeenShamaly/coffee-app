// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartItem _$CartItemFromJson(Map<String, dynamic> json) => _CartItem(
  id: json['id'] as String,
  drink: Drink.fromJson(json['drink'] as Map<String, dynamic>),
  configuration: DrinkConfiguration.fromJson(
    json['configuration'] as Map<String, dynamic>,
  ),
  quantity: (json['quantity'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$CartItemToJson(_CartItem instance) => <String, dynamic>{
  'id': instance.id,
  'drink': instance.drink,
  'configuration': instance.configuration,
  'quantity': instance.quantity,
};
