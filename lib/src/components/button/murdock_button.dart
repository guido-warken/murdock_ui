import 'package:flutter/material.dart';

import '../../theme/murdock_theme.dart';
import '../../tokens/murdock_radius.dart';
import '../../tokens/murdock_spacing.dart';
import '../../tokens/murdock_typography.dart';

/// Size scale of a [MurdockButton].
///
/// Controls padding and typography density — not color or shape.
enum MurdockButtonSize {
  /// Compact — use in dense UIs, toolbars, or inline actions.
  small,

  /// Standard — default for most use cases.
  medium,

  /// Prominent — use for hero sections or primary call-to-action areas.
  large,
}

/// Internal color intent — never exposed in the public API.
enum _MurdockButtonIntent { primary, success, danger, action }

/// A semantic, token-driven button component for Murdock UI.
///
/// Use the named constructors to declare the **intent** of the action —
/// never its visual appearance. Color palette, shape, and typography are
/// resolved from the active [MurdockThemeData] automatically.
///
/// ## Named constructors
///
/// | Constructor | Intent | Typical labels |
/// |---|---|---|
/// | [MurdockButton.primary] | Main CTA | "Confirmar", "Enviar", "Continuar" |
/// | [MurdockButton.success] | Positive action | "Salvar", "Aprovar", "Concluir" |
/// | [MurdockButton.danger] | Destructive action | "Excluir", "Remover", "Cancelar plano" |
/// | [MurdockButton.action] | Secondary action | "Voltar", "Fechar", "Ignorar" |
///
/// ## Sizes
///
/// - [MurdockButtonSize.small] — compact (dense UIs, toolbars).
/// - [MurdockButtonSize.medium] — standard default.
/// - [MurdockButtonSize.large] — prominent (hero, call-to-action areas).
///
/// ## Accessibility
///
/// The widget wraps its content in [Semantics] with `button: true` and
/// enforces a minimum touch target of [MurdockTheme.minTouchTargetSize] dp,
/// satisfying WCAG 2.5.5 (AAA) and the Material Design 48 dp guideline.
///
/// ## Disabled state
///
/// Pass `null` to [onPressed] to disable the button.
///
/// ## Loading state
///
/// Set [isLoading] to `true` to replace the content with a spinner and
/// prevent interaction while an async operation is in progress.
///
/// ## Usage
///
/// ```dart
/// MurdockButton.primary(label: 'Confirmar', onPressed: _submit)
///
/// MurdockButton.danger(label: 'Excluir conta', onPressed: _delete)
///
/// MurdockButton.success(
///   label: 'Salvar',
///   onPressed: _save,
///   leadingIcon: Icons.check,
/// )
///
/// MurdockButton.action(label: 'Cancelar', onPressed: _cancel)
///
/// // Loading state
/// MurdockButton.primary(label: 'Salvando…', onPressed: null, isLoading: true)
/// ```
class MurdockButton extends StatefulWidget {
  const MurdockButton._(
    _MurdockButtonIntent intent, {
    super.key,
    required this.label,
    this.onPressed,
    this.onPressedAsync,
    this.size = MurdockButtonSize.medium,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.semanticLabel,
  }) : _intent = intent;

  /// Main call-to-action. Use for the primary, most important action on screen.
  ///
  /// Renders with a filled [MurdockColors.primary] background.
  const MurdockButton.primary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    Future<void> Function()? onPressedAsync,
    MurdockButtonSize size = MurdockButtonSize.medium,
    IconData? leadingIcon,
    IconData? trailingIcon,
    bool isLoading = false,
    String? semanticLabel,
  }) : this._(
         _MurdockButtonIntent.primary,
         key: key,
         label: label,
         onPressed: onPressed,
         onPressedAsync: onPressedAsync,
         size: size,
         leadingIcon: leadingIcon,
         trailingIcon: trailingIcon,
         isLoading: isLoading,
         semanticLabel: semanticLabel,
       );

  /// Positive action. Use to confirm, save, approve, or complete a task.
  ///
  /// Renders with a filled [MurdockColors.success] background.
  const MurdockButton.success({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    Future<void> Function()? onPressedAsync,
    MurdockButtonSize size = MurdockButtonSize.medium,
    IconData? leadingIcon,
    IconData? trailingIcon,
    bool isLoading = false,
    String? semanticLabel,
  }) : this._(
         _MurdockButtonIntent.success,
         key: key,
         label: label,
         onPressed: onPressed,
         onPressedAsync: onPressedAsync,
         size: size,
         leadingIcon: leadingIcon,
         trailingIcon: trailingIcon,
         isLoading: isLoading,
         semanticLabel: semanticLabel,
       );

  /// Destructive action. Use to delete, remove, or perform irreversible operations.
  ///
  /// Renders with a filled [MurdockColors.danger] background.
  const MurdockButton.danger({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    Future<void> Function()? onPressedAsync,
    MurdockButtonSize size = MurdockButtonSize.medium,
    IconData? leadingIcon,
    IconData? trailingIcon,
    bool isLoading = false,
    String? semanticLabel,
  }) : this._(
         _MurdockButtonIntent.danger,
         key: key,
         label: label,
         onPressed: onPressed,
         onPressedAsync: onPressedAsync,
         size: size,
         leadingIcon: leadingIcon,
         trailingIcon: trailingIcon,
         isLoading: isLoading,
         semanticLabel: semanticLabel,
       );

  /// Secondary or neutral action. Use to cancel, dismiss, or navigate back.
  ///
  /// Renders as outlined with [MurdockColors.primary] border and label text.
  const MurdockButton.action({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    Future<void> Function()? onPressedAsync,
    MurdockButtonSize size = MurdockButtonSize.medium,
    IconData? leadingIcon,
    IconData? trailingIcon,
    bool isLoading = false,
    String? semanticLabel,
  }) : this._(
         _MurdockButtonIntent.action,
         key: key,
         label: label,
         onPressed: onPressed,
         onPressedAsync: onPressedAsync,
         size: size,
         leadingIcon: leadingIcon,
         trailingIcon: trailingIcon,
         isLoading: isLoading,
         semanticLabel: semanticLabel,
       );

  // ── Fields ─────────────────────────────────────────────────────────────────

  /// The text displayed inside the button.
  final String label;

  /// Called when the button is tapped synchronously.
  /// Pass `null` (with [onPressedAsync] also null) to disable the button.
  final VoidCallback? onPressed;

  /// Called when the button is tapped. The button automatically shows a
  /// loading spinner while the future is pending and prevents double-taps.
  /// Takes priority over [onPressed] when both are provided.
  final Future<void> Function()? onPressedAsync;

  /// Size scale. Defaults to [MurdockButtonSize.medium].
  final MurdockButtonSize size;

  /// Optional icon displayed before [label].
  final IconData? leadingIcon;

  /// Optional icon displayed after [label].
  final IconData? trailingIcon;

  /// When `true`, externally forces the loading state. Prefer [onPressedAsync]
  /// for automatic loading management. Defaults to `false`.
  final bool isLoading;

  /// Label announced by screen readers. Falls back to [label] when `null`.
  ///
  /// Use this when [label] alone lacks enough context for a screen-reader user:
  /// ```dart
  /// MurdockButton.danger(
  ///   label: 'Excluir',
  ///   semanticLabel: 'Excluir produto Camiseta Azul',
  ///   onPressed: _delete,
  /// )
  /// ```
  final String? semanticLabel;

  final _MurdockButtonIntent _intent;

  @override
  State<MurdockButton> createState() => _MurdockButtonState();

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
}

// ── State ───────────────────────────────────────────────────────────────────────────

class _MurdockButtonState extends State<MurdockButton> {
  bool _isRunning = false;

  // ── Async handling ──────────────────────────────────────────────────────────

  Future<void> _handlePress() async {
    if (widget.onPressedAsync != null) {
      setState(() => _isRunning = true);
      try {
        await widget.onPressedAsync!();
      } finally {
        if (mounted) setState(() => _isRunning = false);
      }
    } else {
      widget.onPressed?.call();
    }
  }

  bool get _isEffectivelyLoading => _isRunning || widget.isLoading;

  bool get _isEffectivelyDisabled =>
      (widget.onPressed == null && widget.onPressedAsync == null) ||
      _isEffectivelyLoading;

  // ── Build ───────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = MurdockTheme.of(context);
    final bool isDisabled = _isEffectivelyDisabled;
    final VoidCallback? effectiveOnTap = isDisabled ? null : _handlePress;

    // ── Resolve colors per intent / state ─────────────────────────────────────

    final Color foreground;
    final Color background;
    final Color? ripple;
    final BorderSide borderSide;

    if (isDisabled) {
      foreground = theme.onNeutralContainer.withValues(alpha: 0.38);
      background = widget._intent != _MurdockButtonIntent.action
          ? theme.neutralContainer.withValues(alpha: 0.38)
          : Colors.transparent;
      ripple = null;
      borderSide = widget._intent == _MurdockButtonIntent.action
          ? BorderSide(color: theme.outline.withValues(alpha: 0.38), width: 1.5)
          : BorderSide.none;
    } else {
      switch (widget._intent) {
        case _MurdockButtonIntent.primary:
          foreground = theme.onPrimary;
          background = theme.primary;
          ripple = theme.onPrimary.withValues(alpha: 0.12);
          borderSide = BorderSide.none;
        case _MurdockButtonIntent.success:
          foreground = theme.onSuccess;
          background = theme.success;
          ripple = theme.onSuccess.withValues(alpha: 0.12);
          borderSide = BorderSide.none;
        case _MurdockButtonIntent.danger:
          foreground = theme.onDanger;
          background = theme.danger;
          ripple = theme.onDanger.withValues(alpha: 0.12);
          borderSide = BorderSide.none;
        case _MurdockButtonIntent.action:
          foreground = theme.primary;
          background = Colors.transparent;
          ripple = theme.primary.withValues(alpha: 0.08);
          borderSide = BorderSide(color: theme.primary, width: 1.5);
      }
    }

    // ── Shape ──────────────────────────────────────────────────────────────────

    final shape = RoundedRectangleBorder(
      borderRadius: MurdockRadius.fullAll,
      side: borderSide,
    );

    // ── Content ──────────────────────────────────────────────────────────────────

    final double iconPx = MurdockButton._iconSize[widget.size]!;
    final EdgeInsets padding = EdgeInsets.symmetric(
      vertical: MurdockButton._vPad[widget.size]!,
      horizontal: MurdockButton._hPad[widget.size]!,
    );

    Widget content;

    if (_isEffectivelyLoading) {
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
        widget.label,
        style: MurdockButton._labelStyle[widget.size]!.copyWith(
          color: foreground,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );

      if (widget.leadingIcon == null && widget.trailingIcon == null) {
        content = labelWidget;
      } else {
        content = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.leadingIcon != null) ...[
              Icon(widget.leadingIcon, size: iconPx, color: foreground),
              const SizedBox(width: MurdockSpacing.xs),
            ],
            labelWidget,
            if (widget.trailingIcon != null) ...[
              const SizedBox(width: MurdockSpacing.xs),
              Icon(widget.trailingIcon, size: iconPx, color: foreground),
            ],
          ],
        );
      }
    }

    // ── Compose ──────────────────────────────────────────────────────────────────

    return Semantics(
      button: true,
      enabled: !isDisabled,
      label: widget.semanticLabel ?? widget.label,
      excludeSemantics: true,
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
