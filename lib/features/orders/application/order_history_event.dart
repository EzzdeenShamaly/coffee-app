import 'package:equatable/equatable.dart';

sealed class OrderHistoryEvent extends Equatable {
  const OrderHistoryEvent();

  @override
  List<Object?> get props => const [];
}

/// Initial load, the retry action, and pull-to-refresh all use this.
final class OrderHistoryRequested extends OrderHistoryEvent {
  const OrderHistoryRequested();
}
