// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DrinkConfiguration _$DrinkConfigurationFromJson(Map<String, dynamic> json) =>
    _DrinkConfiguration(
      size:
          $enumDecodeNullable(_$DrinkSizeEnumMap, json['size']) ??
          DrinkSize.medium,
      milk:
          $enumDecodeNullable(_$MilkOptionEnumMap, json['milk']) ??
          MilkOption.whole,
      extras:
          (json['extras'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$DrinkExtraEnumMap, e))
              .toList() ??
          const <DrinkExtra>[],
    );

Map<String, dynamic> _$DrinkConfigurationToJson(_DrinkConfiguration instance) =>
    <String, dynamic>{
      'size': _$DrinkSizeEnumMap[instance.size]!,
      'milk': _$MilkOptionEnumMap[instance.milk]!,
      'extras': instance.extras.map((e) => _$DrinkExtraEnumMap[e]!).toList(),
    };

const _$DrinkSizeEnumMap = {
  DrinkSize.small: 'small',
  DrinkSize.medium: 'medium',
  DrinkSize.large: 'large',
};

const _$MilkOptionEnumMap = {
  MilkOption.whole: 'whole',
  MilkOption.skim: 'skim',
  MilkOption.oat: 'oat',
  MilkOption.almond: 'almond',
  MilkOption.none: 'none',
};

const _$DrinkExtraEnumMap = {
  DrinkExtra.extraShot: 'extra_shot',
  DrinkExtra.decaf: 'decaf',
  DrinkExtra.vanillaSyrup: 'vanilla_syrup',
  DrinkExtra.caramelSyrup: 'caramel_syrup',
  DrinkExtra.whippedCream: 'whipped_cream',
};
