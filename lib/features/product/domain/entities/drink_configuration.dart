import 'package:coffee_app/features/product/domain/entities/drink_options.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'drink_configuration.freezed.dart';
part 'drink_configuration.g.dart';

/// How one drink was customised.
///
/// Value-equal by design: two cart lines with the same drink *and* the same
/// configuration are the same line with quantity 2, which is what
/// `CartRepository.addItem` relies on to merge duplicates.
@freezed
abstract class DrinkConfiguration with _$DrinkConfiguration {
  const factory DrinkConfiguration({
    @Default(DrinkSize.medium) DrinkSize size,
    @Default(MilkOption.whole) MilkOption milk,
    @Default(<DrinkExtra>[]) List<DrinkExtra> extras,
  }) = _DrinkConfiguration;

  const DrinkConfiguration._();

  factory DrinkConfiguration.fromJson(Map<String, dynamic> json) =>
      _$DrinkConfigurationFromJson(json);

  /// The configuration for an item with no options at all (a pastry).
  static const DrinkConfiguration none = DrinkConfiguration(
    size: DrinkSize.small,
    milk: MilkOption.none,
  );

  /// One-line summary for a cart row, e.g. "Large · Oat milk · Extra shot".
  ///
  /// Formatting only — no pricing logic, which lives in `CalculateDrinkPrice`.
  String get summary => [
    size.label,
    if (milk != MilkOption.none) milk.label,
    ...extras.map((e) => e.label),
  ].join(' · ');

  bool get hasExtras => extras.isNotEmpty;
}
