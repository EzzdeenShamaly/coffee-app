import 'package:json_annotation/json_annotation.dart';

/// Cup size. Price deltas are added to a drink's base price.
enum DrinkSize {
  @JsonValue('small')
  small,
  @JsonValue('medium')
  medium,
  @JsonValue('large')
  large;

  String get label => switch (this) {
    DrinkSize.small => 'Small',
    DrinkSize.medium => 'Medium',
    DrinkSize.large => 'Large',
  };

  /// Added to the base price. Small is the reference size, so it costs nothing
  /// extra — the menu price is the small price.
  int get priceDeltaCents => switch (this) {
    DrinkSize.small => 0,
    DrinkSize.medium => 60,
    DrinkSize.large => 110,
  };
}

/// Milk choice. Non-dairy alternatives carry a surcharge.
enum MilkOption {
  @JsonValue('whole')
  whole,
  @JsonValue('skim')
  skim,
  @JsonValue('oat')
  oat,
  @JsonValue('almond')
  almond,
  @JsonValue('none')
  none;

  String get label => switch (this) {
    MilkOption.whole => 'Whole milk',
    MilkOption.skim => 'Skim milk',
    MilkOption.oat => 'Oat milk',
    MilkOption.almond => 'Almond milk',
    MilkOption.none => 'No milk',
  };

  int get priceDeltaCents => switch (this) {
    MilkOption.whole || MilkOption.skim || MilkOption.none => 0,
    MilkOption.oat || MilkOption.almond => 70,
  };
}

/// Optional additions. A configuration may hold any number of these.
enum DrinkExtra {
  @JsonValue('extra_shot')
  extraShot,
  @JsonValue('decaf')
  decaf,
  @JsonValue('vanilla_syrup')
  vanillaSyrup,
  @JsonValue('caramel_syrup')
  caramelSyrup,
  @JsonValue('whipped_cream')
  whippedCream;

  String get label => switch (this) {
    DrinkExtra.extraShot => 'Extra shot',
    DrinkExtra.decaf => 'Decaf',
    DrinkExtra.vanillaSyrup => 'Vanilla syrup',
    DrinkExtra.caramelSyrup => 'Caramel syrup',
    DrinkExtra.whippedCream => 'Whipped cream',
  };

  int get priceDeltaCents => switch (this) {
    DrinkExtra.extraShot => 90,
    DrinkExtra.whippedCream => 60,
    DrinkExtra.vanillaSyrup || DrinkExtra.caramelSyrup => 50,
    // Swapping to decaf is a preference, not an upsell.
    DrinkExtra.decaf => 0,
  };
}
