import 'package:json_annotation/json_annotation.dart';

/// The menu sections a drink can belong to.
///
/// `@JsonValue` pins the wire format so renaming a Dart identifier never
/// silently breaks deserialization.
enum DrinkCategory {
  @JsonValue('espresso')
  espresso,
  @JsonValue('brewed')
  brewed,
  @JsonValue('cold_brew')
  coldBrew,
  @JsonValue('tea')
  tea,
  @JsonValue('pastry')
  pastry;

  /// Display label for the category filter bar.
  String get label => switch (this) {
    DrinkCategory.espresso => 'Espresso',
    DrinkCategory.brewed => 'Brewed',
    DrinkCategory.coldBrew => 'Cold Brew',
    DrinkCategory.tea => 'Tea',
    DrinkCategory.pastry => 'Pastry',
  };

  /// True for categories that support milk and shot customisation. A pastry has
  /// no size or milk options, so the product screen hides those selectors.
  bool get isCustomisable => switch (this) {
    DrinkCategory.espresso ||
    DrinkCategory.brewed ||
    DrinkCategory.coldBrew ||
    DrinkCategory.tea => true,
    DrinkCategory.pastry => false,
  };
}
