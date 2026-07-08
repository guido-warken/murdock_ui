import 'package:flutter/material.dart';

import '../../theme/murdock_theme.dart';
import '../../tokens/murdock_radius.dart';
import '../../tokens/murdock_spacing.dart';
import '../../tokens/murdock_typography.dart';

/// Visual style of a [MurdockButton].
enum MurdockButtonVariant {
  /// Filled background — use for primary actions.
  filled,

  /// Transparent background with a border — use for secondary actions.
  outlined,

  /// No background or border — use for tertiary or inline actions.
  text,
}

/// Size scale of a [MurdockButton].
enum MurdockButtonSize {
  /// Compact button — use in dense UIs or tool bars.
  small,

  /// Standard button — default for most use cases.
  medium,

  /// Prominent button — use for hero or call-to-action sections.
  large,
}

/// A semantic, token-driven button component for Murdock UI.
///
/// Colors, padding, typography, and shape are all resolved from the active
/// [MurdockThemeData] and the static design token classes, ensuring visual
/// consistency across the entire application.
///
/// ## Variants
///
/// - [MurdockButtonVariant.filled] — primary action, filled background.
/// - [MurdockButtonVariant.outlined] — secondary action, transparent with border.
/// - [MurdockButtonVariant.text] — tertiary/inline action, no background.
///
/// ## Sizes
///
/// - [MurdockButtonSize.small] — compact (11 sp label, 4/8 dp padding).
/// - [MurdockButtonSize.medium] — standard default (14 sp label, 8/16 dp padding).
/// - [MurdockButtonSize.large] — prominent (14 sp label, 16/24 dp padding).
///
/// ## Accessibility
///
/// The widget wraps its content in [Semantics] with `button: true` and
/// enforces a minimum touch target of [MurdockTheme.minTouchTargetSize] ×
/// [MurdockTheme.minTouchTargetSize] dp, satisfying WCAG 2.5.5 (AAA) and
/// the Material Design 48 dp touch-target guideline.
///
/// ## Disabled state
///
/// Pass `null` to [onPressed] to disable the button. All interactive
/// feedback is suppressed and colors shift to a muted palette.
///
/// ## Loading state
///
/// Set [isLoading] to `true` to replace the button content with a
/// [CircularProgressIndicator] and prevent any interaction while an
/// async operation is in progress.
///
/// ## Usage
///
/// ```dart
/// // Primary action
/// MurdockButton(
///   label: 'Confirmar',
///   onPressed: _submit,
/// )
///
/// // Secondary action
/// MurdockButton(
///   label: 'Cancelar',
///   onPressed: _cancel,
///   variant: MurdockButtonVariant.outlined,
/// )
///
/// // With icons
/// MurdockButton(
///   label: 'Adicionar',
///   onPressed: _add,
///   leadingIcon: Icons.add,
/// )
///
/// // Loading state
/// MurdockButton(
///   label: 'Salvando…',
///   onPressed: null,
///   isLoading: true,
/// )
/// ```
class MurdockButton extends StatelessWidget {
  const MurdockButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = MurdockButtonVariant.filled,
    this.size = MurdockButtonSize.medium,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
  });

  /// The text displayed inside the button.
  final String label;

  /// Called when the button is tapped. Pass `null` to disable the button.
  final VoidCallback? onPressed;

  /// Visual style variant. Defaults to [MurdockButtonVariant.filled].
  final MurdockButtonVariant variant;

  /// Size scale. Defaults to [MurdockButtonSize.medium].
  final MurdockButtonSize size;

  /// Optional icon displayed before [label].
  final IconData? leadingIcon;

  /// Optional icon displayed after [label].
  final IconData? trailingIcon;

  /// When `true`, replaces the button content with a [CircularProgressIndicator]
  /// and prevents any interaction. Defaults to `false`.
  final bool isLoading;

  // ── Size tokens ────────────────────────────────────────────────────────────

  static const Map<MurdockButtonSize, double> _vPad = {
    MurdockButtonSize.small: MurdockSpacing.xs,
    MurdockButtonSize.medium: MurdockSpacing.small,
    MurdockButtonSize.large: MurdockSpacing.medium,
  };

  static const Map<MurdockButtonSize, double> _hPad = {
    MurdockButtonSize.small: MurdockSpacing.small,
    MurdockButtonSize.medium: MurdockSpacing.medium,
    MurdockButtonSize.large: MurdockSpacing.large,
  };

  static const Map<MurdockButtonSize, TextStyle> _labelStyle = {
    MurdockButtonSize.small: MurdockTypography.labelSmall,
    MurdockButtonSize.medium: MurdockTypography.labelLarge,
    MurdockButtonSize.large: MurdockTypography.labelLarge,
  };

  static const Map<MurdockButtonSize, double> _iconSize = {
    MurdockButtonSize.small: 14.0,
    MurdockButtonSize.medium: 18.0,
    MurdockButtonSize.large: 20.0,
  };

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = MurdockTheme.of(context);
    final bool isDisabled = onPressed == null;
    final VoidCallback? effectiveOnTap = isDisabled || isLoading
        ? null
        : onPressed;

    // ── Resolve colors per variant / state ─────────────────────────────────

    final Color foreground;
    final Color background;
    final Color? ripple;
    final BorderSide borderSide;

    if (isDisabled) {
      foreground = theme.onNeutralContainer.withValues(alpha: 0.38);
      background = variant == MurdockButtonVariant.filled
          ? theme.neutralContainer.withValues(alpha: 0.38)
          : Colors.transparent;
      ripple = null;
      borderSide = variant == MurdockButtonVariant.outlined
          ? BorderSide(color: theme.outline.withValues(alpha: 0.38), width: 1.5)
          : BorderSide.none;
    } else {
      switch (variant) {
        case MurdockButtonVariant.filled:
          foreground = theme.onPrimary;
          background = theme.primary;
          ripple = theme.onPrimary.withValues(alpha: 0.12);
          borderSide = BorderSide.none;
        case MurdockButtonVariant.outlined:
          foreground = theme.primary;
          background = Colors.transparent;
          ripple = theme.primary.withValues(alpha: 0.08);
          borderSide = BorderSide(color: theme.primary, width: 1.5);
        case MurdockButtonVariant.text:
          foreground = theme.primary;
          background = Colors.transparent;
          ripple = theme.primary.withValues(alpha: 0.08);
          borderSide = BorderSide.none;
      }
    }

    // ── Shape ──────────────────────────────────────────────────────────────

    final shape = RoundedRectangleBorder(
      borderRadius: MurdockRadius.fullAll,
      side: borderSide,
    );

    // ── Content ────────────────────────────────────────────────────────────

    final double iconPx = _iconSize[size]!;
    final EdgeInsets padding = EdgeInsets.symmetric(
      vertical: _vPad[size]!,
      horizontal: _hPad[size]!,
    );

    Widget content;

    if (isLoading) {
      content = SizedBox(
        width: iconPx,
        height: iconPx,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(foreground),
        ),
      );
    } else {
      final labelWidget = Text(
        label,
        style: _labelStyle[size]!.copyWith(color: foreground),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );

      if (leadingIcon == null && trailingIcon == null) {
        content = labelWidget;
      } else {
        content = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, size: iconPx, color: foreground),
              const SizedBox(width: MurdockSpacing.xs),
            ],
            labelWidget,
            if (trailingIcon != null) ...[
              const SizedBox(width: MurdockSpacing.xs),
              Icon(trailingIcon, size: iconPx, color: foreground),
            ],
          ],
        );
      }
    }

    // ── Compose ────────────────────────────────────────────────────────────

    return Semantics(
      button: true,
      enabled: !isDisabled,
      label: label,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: MurdockTheme.minTouchTargetSize,
          minHeight: MurdockTheme.minTouchTargetSize,
        ),
        child: Material(
          color: background,
          shape: shape,
          child: InkWell(
            onTap: effectiveOnTap,
            customBorder: shape,
            splashColor: ripple,
            highlightColor: ripple?.withValues(alpha: 0.04),
            child: Padding(
              padding: padding,
              child: Align(
                alignment: Alignment.center,
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
