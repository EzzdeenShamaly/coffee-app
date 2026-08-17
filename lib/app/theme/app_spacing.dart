/// Spacing and sizing scale.
///
/// A 4dp-based scale keeps padding decisions out of individual widgets. Prefer
/// these over ad-hoc numbers so a density change is one edit, not fifty.
abstract final class AppSpacing {
  const AppSpacing._();

  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;

  /// Corner radius for cards and sheets.
  static const radiusMd = 12.0;
  static const radiusLg = 20.0;

  /// Minimum interactive size. Material's accessibility floor is 48x48 dp and
  /// `/flutter-accessibility-audit` flags anything smaller.
  static const minTapTarget = 48.0;
}
