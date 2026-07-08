import 'package:flutter/material.dart';

/// Semantic border radius tokens for Murdock UI.
///
/// Consumers reference semantic names instead of raw [Radius] or [double] values.
abstract class MurdockRadius {
  MurdockRadius._();

  /// No rounding — sharp corners.
  static const double none = 0.0;

  /// 4dp — subtle rounding for dense components (chips, badges).
  static const double small = 4.0;

  /// 8dp — standard rounding for cards and containers.
  static const double medium = 8.0;

  /// 16dp — pronounced rounding for modals and sheets.
  static const double large = 16.0;

  /// 24dp — extra rounding for floating components.
  static const double xl = 24.0;

  /// Full pill shape — for buttons and tags.
  static const double full = 999.0;

  // ── BorderRadius helpers ───────────────────────────────────────────────────

  static const BorderRadius noneAll = BorderRadius.zero;

  static const BorderRadius smallAll = BorderRadius.all(Radius.circular(small));

  static const BorderRadius mediumAll = BorderRadius.all(
    Radius.circular(medium),
  );

  static const BorderRadius largeAll = BorderRadius.all(Radius.circular(large));

  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));

  static const BorderRadius fullAll = BorderRadius.all(Radius.circular(full));
}
