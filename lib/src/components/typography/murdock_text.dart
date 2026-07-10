import 'package:flutter/material.dart';

import '../../theme/murdock_theme.dart';
import '../../theme/murdock_theme_data.dart';
import '../../tokens/murdock_typography.dart';

/// Semantic color role for [MurdockText].
///
/// Maps to the active [MurdockThemeData] color tokens. Consumers declare
/// intent — the widget resolves the actual [Color] at build time.
enum MurdockTextColor {
  /// Default text on surface. Use for body copy and most reading contexts.
  onSurface,

  /// Primary brand color. Use for links, active labels, and emphasis.
  primary,

  /// Positive feedback color. Use to reinforce successful states.
  success,

  /// Destructive / error color. Use to communicate danger or failure.
  danger,

  /// Caution color. Use to communicate warnings or advisory states.
  warning,

  /// Muted color. Use for secondary labels, placeholders, and hints.
  neutral,

  /// Contrasting color for text placed on a [MurdockColors.primary] surface.
  onPrimary,

  /// Contrasting color for text placed on a [MurdockColors.success] surface.
  onSuccess,

  /// Contrasting color for text placed on a [MurdockColors.danger] surface.
  onDanger,

  /// Contrasting color for text placed on a [MurdockColors.warning] surface.
  onWarning,
}

/// Semantic role that maps to a [TextStyle] from [MurdockTypography].
enum _MurdockTextRole { heading, body, caption, label }

/// A semantic, token-driven text component for Murdock UI.
///
/// Use the named constructors to declare the **role** of the text, not its
/// visual appearance. Typography scale and color are resolved from the active
/// [MurdockThemeData] — no raw font size, weight, or hex values are exposed.
///
/// ## Named constructors
///
/// | Constructor | Material 3 style | Typical use |
/// |---|---|---|
/// | [MurdockText.heading] | `headlineMedium` | Page titles, section headers |
/// | [MurdockText.body] | `bodyLarge` | Paragraphs, prose, reading content |
/// | [MurdockText.caption] | `bodySmall` | Helper text, metadata, timestamps |
/// | [MurdockText.label] | `labelLarge` | Tags, badges, form labels |
///
/// ## Accessibility
///
/// Provide [semanticLabel] when the displayed text needs to be overridden
/// for screen readers (e.g. abbreviations, icon labels).
///
/// ## Usage
///
/// ```dart
/// MurdockText.heading('Bem-vindo ao Murdock UI')
///
/// MurdockText.body(
///   'Descreva sua intenção, não a aparência.',
///   color: MurdockTextColor.neutral,
/// )
///
/// MurdockText.caption('Atualizado há 2 minutos')
///
/// MurdockText.label('NOVO', color: MurdockTextColor.success)
/// ```
class MurdockText extends StatelessWidget {
  const MurdockText._(
    this.text, {
    super.key,
    required _MurdockTextRole role,
    this.color = MurdockTextColor.onSurface,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.semanticLabel,
  }) : _role = role;

  /// Creates a heading-level text widget ([MurdockTypography.headlineMedium]).
  const MurdockText.heading(
    String text, {
    Key? key,
    MurdockTextColor color = MurdockTextColor.onSurface,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    String? semanticLabel,
  }) : this._(
         text,
         key: key,
         role: _MurdockTextRole.heading,
         color: color,
         textAlign: textAlign,
         maxLines: maxLines,
         overflow: overflow,
         semanticLabel: semanticLabel,
       );

  /// Creates a body-level text widget ([MurdockTypography.bodyLarge]).
  const MurdockText.body(
    String text, {
    Key? key,
    MurdockTextColor color = MurdockTextColor.onSurface,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    String? semanticLabel,
  }) : this._(
         text,
         key: key,
         role: _MurdockTextRole.body,
         color: color,
         textAlign: textAlign,
         maxLines: maxLines,
         overflow: overflow,
         semanticLabel: semanticLabel,
       );

  /// Creates a caption-level text widget ([MurdockTypography.bodySmall]).
  const MurdockText.caption(
    String text, {
    Key? key,
    MurdockTextColor color = MurdockTextColor.neutral,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    String? semanticLabel,
  }) : this._(
         text,
         key: key,
         role: _MurdockTextRole.caption,
         color: color,
         textAlign: textAlign,
         maxLines: maxLines,
         overflow: overflow,
         semanticLabel: semanticLabel,
       );

  /// Creates a label-level text widget ([MurdockTypography.labelLarge]).
  const MurdockText.label(
    String text, {
    Key? key,
    MurdockTextColor color = MurdockTextColor.onSurface,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    String? semanticLabel,
  }) : this._(
         text,
         key: key,
         role: _MurdockTextRole.label,
         color: color,
         textAlign: textAlign,
         maxLines: maxLines,
         overflow: overflow,
         semanticLabel: semanticLabel,
       );

  /// The text content to display.
  final String text;

  /// Semantic color role. Resolved to an actual [Color] from the active theme.
  final MurdockTextColor color;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// Maximum number of lines before truncation.
  final int? maxLines;

  /// How text overflow is handled when [maxLines] is exceeded.
  final TextOverflow? overflow;

  /// Override the text announced by screen readers.
  /// Falls back to [text] when `null`.
  final String? semanticLabel;

  final _MurdockTextRole _role;

  // ── Style resolution ───────────────────────────────────────────────────────

  static const Map<_MurdockTextRole, TextStyle> _styleMap = {
    _MurdockTextRole.heading: MurdockTypography.headlineMedium,
    _MurdockTextRole.body: MurdockTypography.bodyLarge,
    _MurdockTextRole.caption: MurdockTypography.bodySmall,
    _MurdockTextRole.label: MurdockTypography.labelLarge,
  };

  Color _resolveColor(MurdockThemeData theme) {
    return switch (color) {
      MurdockTextColor.onSurface => theme.onSurface,
      MurdockTextColor.primary => theme.primary,
      MurdockTextColor.success => theme.success,
      MurdockTextColor.danger => theme.danger,
      MurdockTextColor.warning => theme.warning,
      MurdockTextColor.neutral => theme.neutral,
      MurdockTextColor.onPrimary => theme.onPrimary,
      MurdockTextColor.onSuccess => theme.onSuccess,
      MurdockTextColor.onDanger => theme.onDanger,
      MurdockTextColor.onWarning => theme.onWarning,
    };
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = MurdockTheme.of(context);
    final resolvedColor = _resolveColor(theme);
    final style = _styleMap[_role]!.copyWith(color: resolvedColor);

    return Semantics(
      label: semanticLabel,
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}
