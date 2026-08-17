import 'package:json_annotation/json_annotation.dart';

/// Lifecycle of a placed order.
enum OrderStatus {
  @JsonValue('placed')
  placed,
  @JsonValue('preparing')
  preparing,
  @JsonValue('ready')
  ready,
  @JsonValue('collected')
  collected,
  @JsonValue('cancelled')
  cancelled;

  String get label => switch (this) {
    OrderStatus.placed => 'Order placed',
    OrderStatus.preparing => 'Preparing',
    OrderStatus.ready => 'Ready for pickup',
    OrderStatus.collected => 'Collected',
    OrderStatus.cancelled => 'Cancelled',
  };

  /// True while the order is still moving — drives whether the history row
  /// shows a live indicator.
  bool get isActive => switch (this) {
    OrderStatus.placed || OrderStatus.preparing || OrderStatus.ready => true,
    OrderStatus.collected || OrderStatus.cancelled => false,
  };
}
