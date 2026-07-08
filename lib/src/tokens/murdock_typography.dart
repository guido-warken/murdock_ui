import 'package:flutter/material.dart';

/// Semantic typography scale for Murdock UI.
///
/// Aligned with Material 3 type system. Consumers use semantic role names
/// (e.g. [displayLarge], [bodyMedium]) instead of raw font sizes or weights.
abstract class MurdockTypography {
  MurdockTypography._();

  // ── Display ────────────────────────────────────────────────────────────────

  /// 57 sp — largest display text; use for hero sections and splash screens.
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
  );

  /// 45 sp — large display text; use for promotional banners.
  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.16,
  );

  /// 36 sp — medium display text; use for feature headers.
  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.22,
  );

  // ── Headline ───────────────────────────────────────────────────────────────

  /// 32 sp — primary page title or top-level section header.
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.25,
  );

  /// 28 sp — secondary page title or prominent section header.
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.29,
  );

  /// 24 sp — tertiary headline or card title.
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.33,
  );

  // ── Title ──────────────────────────────────────────────────────────────────

  /// 22 sp — app bar title or dialog headline.
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.27,
  );

  /// 16 sp — list item title or form section label.
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.50,
  );

  /// 14 sp — subtitle or secondary list item text.
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  // ── Body ───────────────────────────────────────────────────────────────────

  /// 16 sp — primary reading text; use for article body and long descriptions.
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.50,
  );

  /// 14 sp — default reading text; use for most body copy.
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
  );

  /// 12 sp — supporting body text; use for supplementary descriptions.
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
  );

  // ── Label ──────────────────────────────────────────────────────────────────

  /// 14 sp — prominent label; use for button text and input labels.
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  /// 12 sp — standard label; use for chip text and captions.
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
  );

  /// 11 sp — small label; use for overlines and helper text.
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
  );
}
