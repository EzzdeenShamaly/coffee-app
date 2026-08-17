import 'package:equatable/equatable.dart';

/// A currency amount held in **minor units** (cents).
///
/// Prices are integers on purpose: `0.1 + 0.2 != 0.3` in binary floating point,
/// and a cart that sums doubles drifts by a cent on a long enough order. All
/// arithmetic stays in `int` and formatting happens only at the edge.
class Money extends Equatable implements Comparable<Money> {
  const Money(this.cents);

  const Money.zero() : cents = 0;

  /// The amount in minor units. 1234 is $12.34.
  final int cents;

  Money operator +(Money other) => Money(cents + other.cents);

  Money operator -(Money other) => Money(cents - other.cents);

  /// Multiply by a whole quantity — the only multiplication a cart needs.
  Money operator *(int quantity) => Money(cents * quantity);

  bool get isZero => cents == 0;

  /// Applies a rate (e.g. 0.08 tax) and rounds to the nearest cent.
  ///
  /// Rounding once, here, is what keeps `subtotal + tax == total` true.
  Money percentage(double rate) => Money((cents * rate).round());

  /// Sums a collection without the caller needing a zero seed.
  static Money sum(Iterable<Money> amounts) =>
      amounts.fold(const Money.zero(), (total, next) => total + next);

  @override
  int compareTo(Money other) => cents.compareTo(other.cents);

  /// `$12.34`. Single-locale on purpose — swap for `intl`'s `NumberFormat` when
  /// the app localises currency (`/flutter-l10n-gen`).
  String get formatted {
    final sign = cents < 0 ? '-' : '';
    final abs = cents.abs();
    return '$sign\$${(abs ~/ 100)}.${(abs % 100).toString().padLeft(2, '0')}';
  }

  @override
  List<Object?> get props => [cents];

  @override
  String toString() => formatted;
}
