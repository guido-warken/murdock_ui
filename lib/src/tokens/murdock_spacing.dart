/// Abstract spacing scale for Murdock UI.
///
/// Consumers reference semantic names instead of raw `double` values.
/// All values follow a 4dp base grid for visual consistency.
abstract class MurdockSpacing {
  MurdockSpacing._();

  /// 4dp — micro gaps, icon padding.
  static const double xs = 4.0;

  /// 8dp — tight spacing between related elements.
  static const double small = 8.0;

  /// 16dp — standard spacing between components.
  static const double medium = 16.0;

  /// 24dp — loose spacing between sections.
  static const double large = 24.0;

  /// 32dp — structural spacing between major layout areas.
  static const double xl = 32.0;

  /// 48dp — hero-level spacing.
  static const double xxl = 48.0;
}
