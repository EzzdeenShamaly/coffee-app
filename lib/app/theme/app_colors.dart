import 'package:flutter/material.dart';

/// Raw brand colours. Widgets should read `Theme.of(context).colorScheme`
/// rather than these constants directly — this class exists to seed the theme
/// in one place, not to be referenced from the widget tree.
abstract final class AppColors {
  const AppColors._();

  /// Dark roast — primary brand colour.
  static const espresso = Color(0xFF4A2C2A);

  /// Mid-roast brown, used for primary containers.
  static const mocha = Color(0xFF7B4B3A);

  /// Warm cream, the light-theme surface tint.
  static const crema = Color(0xFFF5EBE0);

  /// Steamed-milk white for cards on the light theme.
  static const steamedMilk = Color(0xFFFFFBF7);

  /// Caramel accent for highlights and badges.
  static const caramel = Color(0xFFC98A4B);

  /// Matcha green, used for "ready for pickup" success states.
  static const matcha = Color(0xFF5B8C5A);

  /// Error red, warm enough to sit with the brown palette.
  static const berry = Color(0xFFB3261E);

  /// Near-black used for text on light surfaces.
  static const roastedBean = Color(0xFF1F1512);
}
