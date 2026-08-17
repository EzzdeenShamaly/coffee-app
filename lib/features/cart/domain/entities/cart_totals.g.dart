// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_totals.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartTotals _$CartTotalsFromJson(Map<String, dynamic> json) => _CartTotals(
  subtotalCents: (json['subtotal_cents'] as num).toInt(),
  taxCents: (json['tax_cents'] as num).toInt(),
  totalCents: (json['total_cents'] as num).toInt(),
  itemCount: (json['item_count'] as num).toInt(),
);

Map<String, dynamic> _$CartTotalsToJson(_CartTotals instance) =>
    <String, dynamic>{
      'subtotal_cents': instance.subtotalCents,
      'tax_cents': instance.taxCents,
      'total_cents': instance.totalCents,
      'item_count': instance.itemCount,
    };
