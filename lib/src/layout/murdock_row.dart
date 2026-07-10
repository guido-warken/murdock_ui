import 'package:flutter/material.dart';

import '../tokens/murdock_spacing.dart';

/// Semantic horizontal alignment of children inside a [MurdockRow].
enum MurdockRowAlignment {
  /// Pack children at the start of the main axis.
  start,

  /// Center children along the main axis.
  center,

  /// Pack children at the end of the main axis.
  end,

  /// Place free space evenly between children, with no space at the edges.
  spaceBetween,

  /// Place free space evenly between and around children.
  spaceAround,

  /// Place free space evenly between, before, and after children.
  spaceEvenly,
}

/// Semantic vertical alignment of children inside a [MurdockRow].
enum MurdockRowCrossAlignment {
  /// Align children at the top of the cross axis.
  start,

  /// Center children along the cross axis.
  center,

  /// Align children at the bottom of the cross axis.
  end,

  /// Stretch children to fill the cross axis.
  stretch,
}

/// A semantic, token-driven horizontal layout component for Murdock UI.
///
/// Part of the **Radar Layout** system. [MurdockRow] arranges its children
/// horizontally, separating them with a consistent gap from [MurdockSpacing]
/// tokens. No raw pixel values are exposed in the public API.
///
/// ## Proportional distribution
///
/// When [expand] is `true`, all children receive equal proportional space
/// along the main axis via `Flexible(flex: 1)`. Use this for grids and
/// symmetric layouts.
///
/// When [expand] is `false` (default), children take their natural size.
///
/// For asymmetric proportional layouts, wrap individual children in
/// [MurdockExpanded] and set a custom [MurdockExpanded.weight].
///
/// ## Gap
///
/// Use [gap] with [MurdockSpacing] tokens to control spacing between children:
///
/// ```dart
/// MurdockRow(
///   gap: MurdockSpacing.small,
///   children: [...],
/// )
/// ```
///
/// ## Usage
///
/// ```dart
/// // Natural-size children with a gap
/// MurdockRow(
///   gap: MurdockSpacing.medium,
///   children: [
///     MurdockText.label('Nome'),
///     MurdockText.body('João Silva'),
///   ],
/// )
///
/// // Equal proportional distribution
/// MurdockRow(
///   expand: true,
///   gap: MurdockSpacing.small,
///   children: [
///     MurdockButton.action(label: 'Cancelar', onPressed: _cancel),
///     MurdockButton.primary(label: 'Confirmar', onPressed: _confirm),
///   ],
/// )
/// ```
class MurdockRow extends StatelessWidget {
  const MurdockRow({
    super.key,
    required this.children,
    this.gap = MurdockSpacing.medium,
    this.alignment = MurdockRowAlignment.start,
    this.crossAlignment = MurdockRowCrossAlignment.center,
    this.expand = false,
  });

  /// The widgets laid out horizontally.
  final List<Widget> children;

  /// Space between each child. Use [MurdockSpacing] tokens.
  /// Defaults to [MurdockSpacing.medium] (16 dp).
  final double gap;

  /// Main-axis alignment. Defaults to [MurdockRowAlignment.start].
  final MurdockRowAlignment alignment;

  /// Cross-axis alignment. Defaults to [MurdockRowCrossAlignment.center].
  final MurdockRowCrossAlignment crossAlignment;

  /// When `true`, each child is wrapped in `Flexible(flex: 1)` so all
  /// children share the available horizontal space equally.
  /// Defaults to `false`.
  final bool expand;

  // ── Alignment mapping ──────────────────────────────────────────────────────

  static const _mainAxisMap = {
    MurdockRowAlignment.start: MainAxisAlignment.start,
    MurdockRowAlignment.center: MainAxisAlignment.center,
    MurdockRowAlignment.end: MainAxisAlignment.end,
    MurdockRowAlignment.spaceBetween: MainAxisAlignment.spaceBetween,
    MurdockRowAlignment.spaceAround: MainAxisAlignment.spaceAround,
    MurdockRowAlignment.spaceEvenly: MainAxisAlignment.spaceEvenly,
  };

  static const _crossAxisMap = {
    MurdockRowCrossAlignment.start: CrossAxisAlignment.start,
    MurdockRowCrossAlignment.center: CrossAxisAlignment.center,
    MurdockRowCrossAlignment.end: CrossAxisAlignment.end,
    MurdockRowCrossAlignment.stretch: CrossAxisAlignment.stretch,
  };

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final resolvedChildren = <Widget>[];

    for (var i = 0; i < children.length; i++) {
      final child = expand
          ? Flexible(flex: 1, child: children[i])
          : children[i];
      resolvedChildren.add(child);

      if (i < children.length - 1) {
        resolvedChildren.add(SizedBox(width: gap));
      }
    }

    return Row(
      mainAxisAlignment: _mainAxisMap[alignment]!,
      crossAxisAlignment: _crossAxisMap[crossAlignment]!,
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      children: resolvedChildren,
    );
  }
}

/// A proportional cell for use inside [MurdockRow] or [MurdockColumn].
///
/// Wraps its [child] in a `Flexible` widget with the given [weight],
/// allowing asymmetric proportional distribution in a Radar Layout:
///
/// ```dart
/// MurdockRow(
///   children: [
///     MurdockExpanded(weight: 2, child: MurdockText.body('Maior')),
///     MurdockExpanded(weight: 1, child: MurdockText.body('Menor')),
///   ],
/// )
/// ```
class MurdockExpanded extends StatelessWidget {
  const MurdockExpanded({super.key, required this.child, this.weight = 1});

  /// The widget to wrap proportionally.
  final Widget child;

  /// Flex factor relative to sibling [MurdockExpanded] widgets.
  /// Defaults to `1` (equal share).
  final int weight;

  @override
  Widget build(BuildContext context) => Flexible(flex: weight, child: child);
}
