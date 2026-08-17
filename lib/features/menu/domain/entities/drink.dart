import 'package:coffee_app/core/money/money.dart';
import 'package:coffee_app/features/menu/domain/entities/drink_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'drink.freezed.dart';
part 'drink.g.dart';

/// A single item on the menu, before any customisation.
///
/// Price is stored in minor units (`basePriceCents`) rather than as a `double`
/// or a `Money` — an `int` field keeps JSON round-tripping trivial while
/// `basePrice` gives the domain a proper value object to compute with.
@freezed
abstract class Drink with _$Drink {
  const factory Drink({
    required String id,
    required String name,
    required String description,
    @JsonKey(name: 'base_price_cents') required int basePriceCents,
    required DrinkCategory category,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'is_available') @Default(true) bool isAvailable,
  }) = _Drink;

  const Drink._();

  factory Drink.fromJson(Map<String, dynamic> json) => _$DrinkFromJson(json);

  /// The starting price, before size, milk, and extras are applied.
  Money get basePrice => Money(basePriceCents);
}
