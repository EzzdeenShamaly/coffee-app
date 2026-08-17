// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Order _$OrderFromJson(Map<String, dynamic> json) => _Order(
  id: json['id'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  totals: CartTotals.fromJson(json['totals'] as Map<String, dynamic>),
  status: $enumDecode(_$OrderStatusEnumMap, json['status']),
  placedAt: DateTime.parse(json['placed_at'] as String),
  pickupCode: json['pickup_code'] as String,
);

Map<String, dynamic> _$OrderToJson(_Order instance) => <String, dynamic>{
  'id': instance.id,
  'items': instance.items,
  'totals': instance.totals,
  'status': _$OrderStatusEnumMap[instance.status]!,
  'placed_at': instance.placedAt.toIso8601String(),
  'pickup_code': instance.pickupCode,
};

const _$OrderStatusEnumMap = {
  OrderStatus.placed: 'placed',
  OrderStatus.preparing: 'preparing',
  OrderStatus.ready: 'ready',
  OrderStatus.collected: 'collected',
  OrderStatus.cancelled: 'cancelled',
};
