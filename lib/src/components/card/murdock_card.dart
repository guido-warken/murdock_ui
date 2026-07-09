import 'package:flutter/material.dart';

import '../../theme/murdock_theme.dart';
import '../../tokens/murdock_radius.dart';
import '../../tokens/murdock_shadows.dart';
import '../../tokens/murdock_spacing.dart';

/// Semantic elevation level of a [MurdockCard].
///
/// Maps to [MurdockShadows] tokens. Consumers declare perceived depth by
/// intent — no raw [BoxShadow] values are exposed.
enum MurdockCardElevation {
  /// No shadow — flat, borderless surface. Use for inline content areas.
  flat,

  /// Subtle lift — use for cards at rest in a list or grid.
  low,

  /// Medium shadow — use for interactive or selected cards.
  medium,

  /// Strong shadow — use for featured or pinned cards.
  high,
}

/// A semantic, token-driven surface container for Murdock UI.
///
/// [MurdockCard] provides a consistent, elevated surface with rounded
/// corners, semantic padding, and optional press feedback. All visual
/// properties (color, radius, shadow, spacing) are resolved from design
/// tokens — no raw values are exposed in the constructor.
///
/// ## Elevation
///
/// Use [elevation] to declare the perceived depth of the card:
///
/// - [MurdockCardElevation.flat] — no shadow, borderless.
/// - [MurdockCardElevation.low] — subtle lift (default, cards at rest).
/// - [MurdockCardElevation.medium] — medium shadow (interactive/selected).
/// - [MurdockCardElevation.high] — strong shadow (featured/pinned).
///
/// ## Padding
///
/// Use [padding] with [MurdockSpacing] tokens to keep spacing consistent:
///
/// ```dart
/// MurdockCard(
///   padding: MurdockSpacing.large,
///   child: ...,
/// )
/// ```
///
/// ## Press feedback
///
/// Provide [onPressed] to make the card tappable. An ink ripple and
/// pointer cursor are applied automatically.
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
/// MurdockCard(
///   child: MurdockText.body('Conteúdo do card'),
/// )
///
/// // Interactive card
/// MurdockCard(
///   onPressed: () => _openDetail(),
///   semanticLabel: 'Abrir detalhes do produto',
///   elevation: MurdockCardElevation.medium,
///   child: MurdockText.body('Toque para mais detalhes'),
/// )
/// ```
class MurdockCard extends StatelessWidget {
  const MurdockCard({
    super.key,
    required this.child,
    this.elevation = MurdockCardElevation.low,
    this.padding = MurdockSpacing.medium,
    this.onPressed,
    this.semanticLabel,
  });

  /// The widget displayed inside the card.
  final Widget child;

  /// Perceived depth of the card surface. Defaults to [MurdockCardElevation.low].
  final MurdockCardElevation elevation;

  /// Inner padding applied around [child]. Use [MurdockSpacing] tokens.
  /// Defaults to [MurdockSpacing.medium] (16 dp).
  final double padding;

  /// Called when the card is tapped. Pass `null` for a static, non-interactive card.
  final VoidCallback? onPressed;

  /// Label announced by screen readers when [onPressed] is set.
  /// Falls back to the child's own semantics when `null`.
  final String? semanticLabel;

  // ── Shadow resolution ──────────────────────────────────────────────────────

  static const Map<MurdockCardElevation, List<BoxShadow>> _shadowMap = {
    MurdockCardElevation.flat: MurdockShadows.none,
    MurdockCardElevation.low: MurdockShadows.low,
    MurdockCardElevation.medium: MurdockShadows.medium,
    MurdockCardElevation.high: MurdockShadows.high,
  };

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = MurdockTheme.of(context);
    final shadows = _shadowMap[elevation]!;
    final borderColor =
        elevation == MurdockCardElevation.flat ? theme.outline : null;

    final decoration = BoxDecoration(
      color: theme.surface,
      borderRadius: MurdockRadius.mediumAll,
      boxShadow: shadows,
      border: borderColor != null ? Border.all(color: borderColor) : null,
    );

    final content = Padding(
      padding: EdgeInsets.all(padding),
      child: child,
    );

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
