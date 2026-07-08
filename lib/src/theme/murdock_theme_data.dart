import 'package:flutter/material.dart';

import '../tokens/theme_tokens.dart';

/// Immutable configuration object that bundles all Murdock UI semantic color
/// tokens into a single, cohesive theme unit.
///
/// Extends [ThemeExtension] so it can be embedded in Flutter's native
/// [ThemeData.extensions], enabling seamless [MaterialApp] integration.
///
/// All built-in color pairs (e.g. [primary] / [onPrimary]) satisfy
/// **WCAG AA** contrast requirements (4.5:1 for normal text, 3:1 for large
/// text and UI components).
///
/// ### Usage with [MurdockTheme] widget
///
/// ```dart
/// MurdockTheme(
///   data: const MurdockThemeData(),
///   child: MyApp(),
/// )
/// ```
///
/// ### Usage with [MaterialApp]
///
/// ```dart
/// MaterialApp(
///   theme: MurdockTheme.toMaterialTheme(const MurdockThemeData()),
///   home: MyHomePage(),
/// );
/// ```
///
/// ### Customisation
///
/// ```dart
/// const MurdockThemeData().copyWith(primary: Color(0xFF6200EE))
/// ```
@immutable
class MurdockThemeData extends ThemeExtension<MurdockThemeData> {
  const MurdockThemeData({
    this.primary = MurdockColors.primary,
    this.onPrimary = MurdockColors.onPrimary,
    this.primaryContainer = MurdockColors.primaryContainer,
    this.onPrimaryContainer = MurdockColors.onPrimaryContainer,
    this.success = MurdockColors.success,
    this.onSuccess = MurdockColors.onSuccess,
    this.successContainer = MurdockColors.successContainer,
    this.onSuccessContainer = MurdockColors.onSuccessContainer,
    this.danger = MurdockColors.danger,
    this.onDanger = MurdockColors.onDanger,
    this.dangerContainer = MurdockColors.dangerContainer,
    this.onDangerContainer = MurdockColors.onDangerContainer,
    this.warning = MurdockColors.warning,
    this.onWarning = MurdockColors.onWarning,
    this.warningContainer = MurdockColors.warningContainer,
    this.onWarningContainer = MurdockColors.onWarningContainer,
    this.neutral = MurdockColors.neutral,
    this.onNeutral = MurdockColors.onNeutral,
    this.neutralContainer = MurdockColors.neutralContainer,
    this.onNeutralContainer = MurdockColors.onNeutralContainer,
    this.surface = MurdockColors.surface,
    this.onSurface = MurdockColors.onSurface,
    this.surfaceVariant = MurdockColors.surfaceVariant,
    this.outline = MurdockColors.outline,
    this.outlineVariant = MurdockColors.outlineVariant,
  });

  // ── Static shorthands ──────────────────────────────────────────────────────

  /// Default light theme backed by the built-in Murdock UI token set.
  ///
  /// Equivalent to `const MurdockThemeData()`.
  static const MurdockThemeData light = MurdockThemeData();

  // ── Primary ────────────────────────────────────────────────────────────────

  /// Brand colour — use for primary actions and key UI elements.
  final Color primary;

  /// Content colour rendered on top of [primary] surfaces.
  final Color onPrimary;

  /// Tinted container colour associated with the primary intent.
  final Color primaryContainer;

  /// Content colour rendered on top of [primaryContainer] surfaces.
  final Color onPrimaryContainer;

  // ── Success ────────────────────────────────────────────────────────────────

  /// Colour communicating a successful state or positive action.
  final Color success;

  /// Content colour rendered on top of [success] surfaces.
  final Color onSuccess;

  /// Tinted container colour associated with the success intent.
  final Color successContainer;

  /// Content colour rendered on top of [successContainer] surfaces.
  final Color onSuccessContainer;

  // ── Danger ─────────────────────────────────────────────────────────────────

  /// Colour communicating an error, destructive action, or critical state.
  final Color danger;

  /// Content colour rendered on top of [danger] surfaces.
  final Color onDanger;

  /// Tinted container colour associated with the danger intent.
  final Color dangerContainer;

  /// Content colour rendered on top of [dangerContainer] surfaces.
  final Color onDangerContainer;

  // ── Warning ────────────────────────────────────────────────────────────────

  /// Colour communicating a warning or cautionary state.
  final Color warning;

  /// Content colour rendered on top of [warning] surfaces.
  final Color onWarning;

  /// Tinted container colour associated with the warning intent.
  final Color warningContainer;

  /// Content colour rendered on top of [warningContainer] surfaces.
  final Color onWarningContainer;

  // ── Neutral ────────────────────────────────────────────────────────────────

  /// Colour for secondary or de-emphasised UI elements.
  final Color neutral;

  /// Content colour rendered on top of [neutral] surfaces.
  final Color onNeutral;

  /// Tinted container colour associated with the neutral intent.
  final Color neutralContainer;

  /// Content colour rendered on top of [neutralContainer] surfaces.
  final Color onNeutralContainer;

  // ── Surface ────────────────────────────────────────────────────────────────

  /// Background colour for cards, sheets, and menus.
  final Color surface;

  /// Content colour rendered on top of [surface] backgrounds.
  final Color onSurface;

  /// Alternative surface colour for slightly elevated or distinct areas.
  final Color surfaceVariant;

  /// Colour for borders and dividers.
  final Color outline;

  /// Colour for subtle, decorative borders.
  final Color outlineVariant;

  // ── ThemeExtension API ─────────────────────────────────────────────────────

  @override
  MurdockThemeData copyWith({
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? danger,
    Color? onDanger,
    Color? dangerContainer,
    Color? onDangerContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? neutral,
    Color? onNeutral,
    Color? neutralContainer,
    Color? onNeutralContainer,
    Color? surface,
    Color? onSurface,
    Color? surfaceVariant,
    Color? outline,
    Color? outlineVariant,
  }) {
    return MurdockThemeData(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      danger: danger ?? this.danger,
      onDanger: onDanger ?? this.onDanger,
      dangerContainer: dangerContainer ?? this.dangerContainer,
      onDangerContainer: onDangerContainer ?? this.onDangerContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      neutral: neutral ?? this.neutral,
      onNeutral: onNeutral ?? this.onNeutral,
      neutralContainer: neutralContainer ?? this.neutralContainer,
      onNeutralContainer: onNeutralContainer ?? this.onNeutralContainer,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
    );
  }

  @override
  MurdockThemeData lerp(ThemeExtension<MurdockThemeData>? other, double t) {
    if (other is! MurdockThemeData) return this;
    return MurdockThemeData(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      primaryContainer: Color.lerp(
        primaryContainer,
        other.primaryContainer,
        t,
      )!,
      onPrimaryContainer: Color.lerp(
        onPrimaryContainer,
        other.onPrimaryContainer,
        t,
      )!,
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      onSuccessContainer: Color.lerp(
        onSuccessContainer,
        other.onSuccessContainer,
        t,
      )!,
      danger: Color.lerp(danger, other.danger, t)!,
      onDanger: Color.lerp(onDanger, other.onDanger, t)!,
      dangerContainer: Color.lerp(dangerContainer, other.dangerContainer, t)!,
      onDangerContainer: Color.lerp(
        onDangerContainer,
        other.onDangerContainer,
        t,
      )!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      onWarningContainer: Color.lerp(
        onWarningContainer,
        other.onWarningContainer,
        t,
      )!,
      neutral: Color.lerp(neutral, other.neutral, t)!,
      onNeutral: Color.lerp(onNeutral, other.onNeutral, t)!,
      neutralContainer: Color.lerp(
        neutralContainer,
        other.neutralContainer,
        t,
      )!,
      onNeutralContainer: Color.lerp(
        onNeutralContainer,
        other.onNeutralContainer,
        t,
      )!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
    );
  }
}
