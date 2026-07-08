import 'package:flutter/material.dart';

import 'murdock_theme_data.dart';

/// Provides a [MurdockThemeData] to all descendant widgets in the tree.
///
/// Wrap your application root (or any subtree) with [MurdockTheme] to
/// enable Murdock UI components. Internally, components resolve their
/// visual style by calling [MurdockTheme.of(context)].
///
/// ## Basic usage
///
/// ```dart
/// MurdockTheme(
///   data: const MurdockThemeData(),
///   child: MaterialApp(home: MyHomePage()),
/// )
/// ```
///
/// ## MaterialApp integration
///
/// Use [toMaterialTheme] to produce a [ThemeData] that maps Murdock UI
/// semantic colors to Flutter's [ColorScheme], so both Flutter widgets and
/// Murdock UI components share the same palette:
///
/// ```dart
/// MaterialApp(
///   theme: MurdockTheme.toMaterialTheme(const MurdockThemeData()),
///   home: MyHomePage(),
/// );
/// ```
///
/// ## WCAG compliance
///
/// Every built-in color pair in [MurdockThemeData] (e.g. [MurdockThemeData.primary]
/// / [MurdockThemeData.onPrimary]) satisfies **WCAG AA** contrast — 4.5:1 for
/// normal text and 3:1 for large text and UI components.
///
/// ## Touch targets
///
/// All interactive Murdock UI components enforce a minimum touch target of
/// [MurdockTheme.minTouchTargetSize] × [MurdockTheme.minTouchTargetSize] dp,
/// satisfying **WCAG 2.5.5 (AAA)** and Material Design guidelines.
class MurdockTheme extends InheritedWidget {
  const MurdockTheme({super.key, required this.data, required super.child});

  /// The theme configuration provided to descendant widgets.
  final MurdockThemeData data;

  // ── Touch-target contract ──────────────────────────────────────────────────

  /// Minimum interactive touch target size in logical pixels (dp).
  ///
  /// All Murdock UI interactive components enforce this constraint
  /// automatically, regardless of the visual size of the widget.
  ///
  /// Complies with **WCAG 2.5.5 (AAA)** and the Material Design
  /// 48 dp touch-target guideline.
  static const double minTouchTargetSize = 48.0;

  // ── Theme resolution ───────────────────────────────────────────────────────

  /// Returns the nearest [MurdockThemeData] from the widget tree.
  ///
  /// Resolution order:
  /// 1. Nearest [MurdockTheme] ancestor widget.
  /// 2. A [MurdockThemeData] [ThemeExtension] on the nearest [Theme] ancestor
  ///    (set via [toMaterialTheme]).
  ///
  /// Throws a [FlutterError] if neither is found. Use [maybeOf] for a
  /// non-throwing alternative.
  static MurdockThemeData of(BuildContext context) {
    final result = maybeOf(context);
    if (result != null) return result;
    throw FlutterError.fromParts([
      ErrorSummary(
        'MurdockTheme.of() called with a context that has no MurdockTheme in scope.',
      ),
      ErrorDescription(
        'No MurdockTheme ancestor was found, and no MurdockThemeData '
        'ThemeExtension is present in the nearest Theme.',
      ),
      ErrorHint(
        'Wrap your widget tree with a MurdockTheme widget:\n\n'
        '  MurdockTheme(\n'
        '    data: const MurdockThemeData(),\n'
        '    child: YourApp(),\n'
        '  )\n\n'
        'Or pass a MurdockThemeData extension via MaterialApp:\n\n'
        '  MaterialApp(\n'
        '    theme: MurdockTheme.toMaterialTheme(const MurdockThemeData()),\n'
        '    home: YourApp(),\n'
        '  )',
      ),
    ]);
  }

  /// Returns the nearest [MurdockThemeData], or `null` if none is found.
  ///
  /// Unlike [of], this method does not throw when no theme is in scope.
  static MurdockThemeData? maybeOf(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<MurdockTheme>();
    if (widget != null) return widget.data;
    return Theme.of(context).extension<MurdockThemeData>();
  }

  // ── MaterialApp integration ────────────────────────────────────────────────

  /// Converts a [MurdockThemeData] into a Flutter [ThemeData].
  ///
  /// The resulting [ThemeData]:
  /// - Maps Murdock UI semantic colors to Flutter's [ColorScheme].
  /// - Embeds [data] as a [ThemeExtension] for direct access via
  ///   `Theme.of(context).extension<MurdockThemeData>()`.
  /// - Enables Material 3 (`useMaterial3: true`).
  static ThemeData toMaterialTheme(
    MurdockThemeData data, {
    Brightness brightness = Brightness.light,
  }) {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: data.primary,
          brightness: brightness,
        ).copyWith(
          primary: data.primary,
          onPrimary: data.onPrimary,
          primaryContainer: data.primaryContainer,
          onPrimaryContainer: data.onPrimaryContainer,
          error: data.danger,
          onError: data.onDanger,
          errorContainer: data.dangerContainer,
          onErrorContainer: data.onDangerContainer,
          surface: data.surface,
          onSurface: data.onSurface,
          outline: data.outline,
          outlineVariant: data.outlineVariant,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      extensions: [data],
    );
  }

  @override
  bool updateShouldNotify(MurdockTheme oldWidget) => data != oldWidget.data;
}
