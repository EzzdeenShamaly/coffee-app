// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Drink _$DrinkFromJson(Map<String, dynamic> json) => _Drink(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  basePriceCents: (json['base_price_cents'] as num).toInt(),
  category: $enumDecode(_$DrinkCategoryEnumMap, json['category']),
  imageUrl: json['image_url'] as String?,
  isAvailable: json['is_available'] as bool? ?? true,
);

Map<String, dynamic> _$DrinkToJson(_Drink instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'base_price_cents': instance.basePriceCents,
  'category': _$DrinkCategoryEnumMap[instance.category]!,
  'image_url': instance.imageUrl,
  'is_available': instance.isAvailable,
};

const _$DrinkCategoryEnumMap = {
  DrinkCategory.espresso: 'espresso',
  DrinkCategory.brewed: 'brewed',
  DrinkCategory.coldBrew: 'cold_brew',
  DrinkCategory.tea: 'tea',
  DrinkCategory.pastry: 'pastry',
};
