import 'package:flutter/material.dart';

import '../../theme/murdock_theme.dart';
import '../../tokens/murdock_radius.dart';
import '../../tokens/murdock_shadows.dart';
import '../../tokens/murdock_spacing.dart';

/// Internal elevation level — never exposed in the public API.
enum _MurdockCardLevel { flat, raised, elevated, floating }

/// A semantic, token-driven surface container for Murdock UI.
///
/// [MurdockCard] provides a consistent, elevated surface with rounded
/// corners, semantic padding, and optional press feedback. All visual
/// properties (color, radius, shadow, spacing) are resolved from design
/// tokens — no raw values are exposed in the constructor.
///
/// ## Elevation
///
/// Use the named constructors to declare the **role** of the card surface —
/// not its visual depth. Shadow, border, and color are resolved from
/// [MurdockShadows] tokens automatically.
///
/// ## Named constructors
///
/// | Constructor | Depth | Typical use |
/// |---|---|---|
/// | [MurdockCard.flat] | No shadow | Inline sections, borderless containers |
/// | [MurdockCard.raised] | Subtle lift | List items, grid cards (default) |
/// | [MurdockCard.elevated] | Medium shadow | Interactive or selected cards |
/// | [MurdockCard.floating] | Strong shadow | Featured, pinned, or hero cards |
///
/// ## Padding
///
/// Use [padding] with [MurdockSpacing] tokens to keep spacing consistent:
///
/// ```dart
/// MurdockCard.raised(
///   padding: MurdockSpacing.large,
///   child: ...,
/// )
/// ```
///
/// ## Press feedback
///
/// Provide [onPressed] to make the card tappable.
///
/// ## Accessibility
///
/// When [onPressed] is set, the card is wrapped in [Semantics] with
/// `button: true`. Provide [semanticLabel] to override the announced text.
///
/// ## Usage
///
/// ```dart
/// // Static card
/// MurdockCard.raised(
///   child: MurdockText.body('Conteúdo do card'),
/// )
///
/// // Interactive card
/// MurdockCard.elevated(
///   onPressed: () => _openDetail(),
///   semanticLabel: 'Abrir detalhes do produto',
///   child: MurdockText.body('Toque para mais detalhes'),
/// )
/// ```
class MurdockCard extends StatelessWidget {
  const MurdockCard._({
    required _MurdockCardLevel level,
    super.key,
    required this.child,
    this.padding = MurdockSpacing.medium,
    this.onPressed,
    this.semanticLabel,
  }) : _level = level;

  /// Flat surface — no shadow. Use for inline content areas.
  const MurdockCard.flat({
    Key? key,
    required Widget child,
    double padding = MurdockSpacing.medium,
    VoidCallback? onPressed,
    String? semanticLabel,
  }) : this._(
         level: _MurdockCardLevel.flat,
         key: key,
         child: child,
         padding: padding,
         onPressed: onPressed,
         semanticLabel: semanticLabel,
       );

  /// Subtle lift — use for cards at rest in lists or grids.
  const MurdockCard.raised({
    Key? key,
    required Widget child,
    double padding = MurdockSpacing.medium,
    VoidCallback? onPressed,
    String? semanticLabel,
  }) : this._(
         level: _MurdockCardLevel.raised,
         key: key,
         child: child,
         padding: padding,
         onPressed: onPressed,
         semanticLabel: semanticLabel,
       );

  /// Medium shadow — use for interactive or selected cards.
  const MurdockCard.elevated({
    Key? key,
    required Widget child,
    double padding = MurdockSpacing.medium,
    VoidCallback? onPressed,
    String? semanticLabel,
  }) : this._(
         level: _MurdockCardLevel.elevated,
         key: key,
         child: child,
         padding: padding,
         onPressed: onPressed,
         semanticLabel: semanticLabel,
       );

  /// Strong shadow — use for featured, pinned, or hero cards.
  const MurdockCard.floating({
    Key? key,
    required Widget child,
    double padding = MurdockSpacing.medium,
    VoidCallback? onPressed,
    String? semanticLabel,
  }) : this._(
         level: _MurdockCardLevel.floating,
         key: key,
         child: child,
         padding: padding,
         onPressed: onPressed,
         semanticLabel: semanticLabel,
       );

  /// The widget displayed inside the card.
  final Widget child;

  /// Inner padding applied around [child]. Use [MurdockSpacing] tokens.
  /// Defaults to [MurdockSpacing.medium] (16 dp).
  final double padding;

  /// Called when the card is tapped. Pass `null` for a static card.
  final VoidCallback? onPressed;

  /// Label announced by screen readers when [onPressed] is set.
  final String? semanticLabel;

  final _MurdockCardLevel _level;

  // ── Shadow resolution ──────────────────────────────────────────────────────

  static const Map<_MurdockCardLevel, List<BoxShadow>> _shadowMap = {
    _MurdockCardLevel.flat: MurdockShadows.none,
    _MurdockCardLevel.raised: MurdockShadows.low,
    _MurdockCardLevel.elevated: MurdockShadows.medium,
    _MurdockCardLevel.floating: MurdockShadows.high,
  };

  // ── Build ────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = MurdockTheme.of(context);
    final shadows = _shadowMap[_level]!;
    final borderColor = _level == _MurdockCardLevel.flat ? theme.outline : null;

    final decoration = BoxDecoration(
      color: theme.surface,
      borderRadius: MurdockRadius.mediumAll,
      boxShadow: shadows,
      border: borderColor != null ? Border.all(color: borderColor) : null,
    );

    final content = Padding(padding: EdgeInsets.all(padding), child: child);

    if (onPressed == null) {
      return DecoratedBox(decoration: decoration, child: content);
    }

    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: Colors.transparent,
        borderRadius: MurdockRadius.mediumAll,
        child: InkWell(
          onTap: onPressed,
          borderRadius: MurdockRadius.mediumAll,
          splashColor: theme.primary.withValues(alpha: 0.08),
          highlightColor: theme.primary.withValues(alpha: 0.04),
          child: DecoratedBox(decoration: decoration, child: content),
        ),
      ),
    );
  }
}
