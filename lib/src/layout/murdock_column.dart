import 'package:flutter/material.dart';

import '../tokens/murdock_spacing.dart';

/// Semantic vertical alignment of children inside a [MurdockColumn].
enum MurdockColumnAlignment {
  /// Pack children at the top of the main axis.
  start,

  /// Center children along the main axis.
  center,

  /// Pack children at the bottom of the main axis.
  end,

  /// Place free space evenly between children, with no space at the edges.
  spaceBetween,

  /// Place free space evenly between and around children.
  spaceAround,

  /// Place free space evenly between, before, and after children.
  spaceEvenly,
}

/// Semantic horizontal alignment of children inside a [MurdockColumn].
enum MurdockColumnCrossAlignment {
  /// Align children to the leading edge of the cross axis.
  start,

  /// Center children along the cross axis.
  center,

  /// Align children to the trailing edge of the cross axis.
  end,

  /// Stretch children to fill the cross axis.
  stretch,
}

/// A semantic, token-driven vertical layout component for Murdock UI.
///
/// Part of the **Radar Layout** system. [MurdockColumn] arranges its children
/// vertically, separating them with a consistent gap from [MurdockSpacing]
/// tokens. No raw pixel values are exposed in the public API.
///
/// ## Proportional distribution
///
/// When [expand] is `true`, all children receive equal proportional space
/// along the main axis via `Flexible(flex: 1)`. Use this for symmetric
/// vertical grids.
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
/// MurdockColumn(
///   gap: MurdockSpacing.large,
///   children: [...],
/// )
/// ```
///
/// ## Usage
///
/// ```dart
/// // Natural-size children with a gap
/// MurdockColumn(
///   gap: MurdockSpacing.medium,
///   children: [
///     MurdockText.heading('Título'),
///     MurdockText.body('Subtítulo descritivo'),
///     MurdockButton.primary(label: 'Ação', onPressed: _act),
///   ],
/// )
///
/// // Equal proportional distribution
/// MurdockColumn(
///   expand: true,
///   gap: MurdockSpacing.small,
///   children: [header, content, footer],
/// )
/// ```
class MurdockColumn extends StatelessWidget {
  const MurdockColumn({
    super.key,
    required this.children,
    this.gap = MurdockSpacing.medium,
    this.alignment = MurdockColumnAlignment.start,
    this.crossAlignment = MurdockColumnCrossAlignment.stretch,
    this.expand = false,
  });

  /// The widgets laid out vertically.
  final List<Widget> children;

  /// Space between each child. Use [MurdockSpacing] tokens.
  /// Defaults to [MurdockSpacing.medium] (16 dp).
  final double gap;

  /// Main-axis alignment. Defaults to [MurdockColumnAlignment.start].
  final MurdockColumnAlignment alignment;

  /// Cross-axis alignment. Defaults to [MurdockColumnCrossAlignment.stretch].
  final MurdockColumnCrossAlignment crossAlignment;

  /// When `true`, each child is wrapped in `Flexible(flex: 1)` so all
  /// children share the available vertical space equally.
  /// Defaults to `false`.
  final bool expand;

  // ── Alignment mapping ──────────────────────────────────────────────────────

  static const _mainAxisMap = {
    MurdockColumnAlignment.start: MainAxisAlignment.start,
    MurdockColumnAlignment.center: MainAxisAlignment.center,
    MurdockColumnAlignment.end: MainAxisAlignment.end,
    MurdockColumnAlignment.spaceBetween: MainAxisAlignment.spaceBetween,
    MurdockColumnAlignment.spaceAround: MainAxisAlignment.spaceAround,
    MurdockColumnAlignment.spaceEvenly: MainAxisAlignment.spaceEvenly,
  };

  static const _crossAxisMap = {
    MurdockColumnCrossAlignment.start: CrossAxisAlignment.start,
    MurdockColumnCrossAlignment.center: CrossAxisAlignment.center,
    MurdockColumnCrossAlignment.end: CrossAxisAlignment.end,
    MurdockColumnCrossAlignment.stretch: CrossAxisAlignment.stretch,
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
        resolvedChildren.add(SizedBox(height: gap));
      }
    }

    return Column(
      mainAxisAlignment: _mainAxisMap[alignment]!,
      crossAxisAlignment: _crossAxisMap[crossAlignment]!,
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      children: resolvedChildren,
    );
  }
}
