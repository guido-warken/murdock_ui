import 'package:flutter/material.dart';

import '../../theme/murdock_theme.dart';
import '../../theme/murdock_theme_data.dart';
import '../../tokens/murdock_radius.dart';
import '../../tokens/murdock_spacing.dart';
import '../../tokens/murdock_typography.dart';

/// Visual variant of a [MurdockTextField].
enum MurdockTextFieldVariant {
  /// Transparent background with a surrounding border.
  outlined,

  /// Light background fill without a surrounding border.
  filled,
}

/// Semantic state of a [MurdockTextField].
///
/// Controls the border color and any supplemental feedback indicators.
enum MurdockTextFieldState {
  /// Default neutral state — no extra visual feedback.
  idle,

  /// Input has a validation error — shows a danger-colored border and, when
  /// provided, renders [MurdockTextField.errorText] below the field.
  error,

  /// Input value has been validated — shows a success-colored border.
  success,

  /// Input requires attention but is not blocking — shows a warning-colored
  /// border.
  warning,
}

/// A semantic, token-driven text field for Murdock UI.
///
/// Visual properties (colors, typography, spacing, border radius) are resolved
/// entirely from the active [MurdockThemeData] and the static token classes,
/// ensuring visual consistency across the entire application. No raw values
/// (hex, dp, sp) are exposed in the constructor.
///
/// ## Variants
///
/// - [MurdockTextFieldVariant.outlined] — transparent background, bordered.
/// - [MurdockTextFieldVariant.filled] — light fill background, no full border.
///
/// ## States
///
/// - [MurdockTextFieldState.idle] — neutral default.
/// - [MurdockTextFieldState.error] — danger palette; pass [errorText] for
///   inline feedback.
/// - [MurdockTextFieldState.success] — success palette.
/// - [MurdockTextFieldState.warning] — warning palette.
///
/// ## Accessibility
///
/// The widget wraps the input in [Semantics] with `textField: true` and
/// exposes a dedicated [semanticLabel] parameter (falls back to [label]).
/// The [label] is also rendered as a floating label inside the field to
/// support low-vision users who rely on persistent on-screen descriptions.
///
/// ## Usage
///
/// ```dart
/// // Simple text field
/// MurdockTextField(
///   label: 'Nome completo',
///   hint: 'Ex.: João Silva',
///   onChanged: (value) => _name = value,
/// )
///
/// // With validation error
/// MurdockTextField(
///   label: 'E-mail',
///   state: MurdockTextFieldState.error,
///   errorText: 'E-mail inválido',
///   controller: _emailController,
/// )
///
/// // Password field
/// MurdockTextField(
///   label: 'Senha',
///   obscureText: true,
///   trailingIcon: Icons.visibility_off,
///   keyboardType: TextInputType.visiblePassword,
/// )
/// ```
class MurdockTextField extends StatelessWidget {
  const MurdockTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.variant = MurdockTextFieldVariant.outlined,
    this.state = MurdockTextFieldState.idle,
    this.errorText,
    this.helperText,
    this.leadingIcon,
    this.trailingIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.semanticLabel,
  });

  // ── Required ───────────────────────────────────────────────────────────────

  /// Floating label text displayed inside (and above, when focused) the field.
  ///
  /// Also used as the accessibility label unless [semanticLabel] is provided.
  final String label;

  // ── Optional content ───────────────────────────────────────────────────────

  /// Placeholder text shown when the field is empty.
  final String? hint;

  /// Controls the text being edited. When `null`, the field manages its own
  /// internal state.
  final TextEditingController? controller;

  /// Called with the new value whenever the text changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits the field (e.g., presses the keyboard action
  /// key).
  final ValueChanged<String>? onSubmitted;

  // ── Appearance ─────────────────────────────────────────────────────────────

  /// Visual variant. Defaults to [MurdockTextFieldVariant.outlined].
  final MurdockTextFieldVariant variant;

  /// Semantic state that drives border color and feedback. Defaults to
  /// [MurdockTextFieldState.idle].
  final MurdockTextFieldState state;

  // ── Feedback text ──────────────────────────────────────────────────────────

  /// Error message rendered below the field when
  /// [state] is [MurdockTextFieldState.error].
  final String? errorText;

  /// Supplemental helper text rendered below the field in all non-error states.
  final String? helperText;

  // ── Icons ──────────────────────────────────────────────────────────────────

  /// Optional icon displayed at the start of the input area.
  final IconData? leadingIcon;

  /// Optional icon displayed at the end of the input area.
  final IconData? trailingIcon;

  // ── Behaviour ──────────────────────────────────────────────────────────────

  /// When `true`, the text is obscured (e.g., for password fields).
  final bool obscureText;

  /// When `true`, the field is read-only — focus is still possible but
  /// editing is disabled.
  final bool readOnly;

  /// When `false`, the field is disabled and cannot receive focus.
  final bool enabled;

  /// Keyboard type hint. Uses platform default when `null`.
  final TextInputType? keyboardType;

  /// Action key label/behaviour on the software keyboard.
  final TextInputAction? textInputAction;

  // ── Accessibility ──────────────────────────────────────────────────────────

  /// Explicit accessibility label. Falls back to [label] when `null`.
  final String? semanticLabel;

  // ── Helpers ────────────────────────────────────────────────────────────────

  Color _stateColor(MurdockThemeData theme) => switch (state) {
    MurdockTextFieldState.idle => theme.outline,
    MurdockTextFieldState.error => theme.danger,
    MurdockTextFieldState.success => theme.success,
    MurdockTextFieldState.warning => theme.warning,
  };

  InputBorder _outlinedBorder(Color color) => OutlineInputBorder(
    borderRadius: MurdockRadius.smallAll,
    borderSide: BorderSide(color: color, width: 1.5),
  );

  InputBorder _filledBorder(Color color) => UnderlineInputBorder(
    borderSide: BorderSide(color: color, width: 1.5),
  );

  InputBorder _buildBorder(Color color) =>
      variant == MurdockTextFieldVariant.outlined
          ? _outlinedBorder(color)
          : _filledBorder(color);

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = MurdockTheme.of(context);
    final stateColor = _stateColor(theme);

    final Color focusedBorderColor =
        state == MurdockTextFieldState.idle ? theme.primary : stateColor;

    final Color labelColor = enabled ? theme.neutral : theme.outline;

    return Semantics(
      label: semanticLabel ?? label,
      textField: true,
      enabled: enabled,
      readOnly: readOnly,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        obscureText: obscureText,
        readOnly: readOnly,
        enabled: enabled,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        style: MurdockTypography.bodyMedium.copyWith(
          color: enabled ? theme.onSurface : theme.neutral,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          errorText: state == MurdockTextFieldState.error ? errorText : null,
          helperText:
              state != MurdockTextFieldState.error ? helperText : null,
          prefixIcon: leadingIcon != null
              ? Icon(leadingIcon, color: labelColor)
              : null,
          suffixIcon: trailingIcon != null
              ? Icon(trailingIcon, color: labelColor)
              : null,
          filled: variant == MurdockTextFieldVariant.filled,
          fillColor: enabled
              ? theme.surfaceVariant
              : theme.surfaceVariant.withValues(alpha: 0.38),
          // ── Borders ───────────────────────────────────────────────────────
          border: _buildBorder(theme.outline),
          enabledBorder: _buildBorder(stateColor),
          focusedBorder: _buildBorder(focusedBorderColor),
          disabledBorder: _buildBorder(
            theme.outline.withValues(alpha: 0.38),
          ),
          errorBorder: _buildBorder(theme.danger),
          focusedErrorBorder: _buildBorder(theme.danger),
          // ── Typography ────────────────────────────────────────────────────
          labelStyle: MurdockTypography.bodyMedium.copyWith(
            color: labelColor,
          ),
          hintStyle: MurdockTypography.bodyMedium.copyWith(
            color: theme.neutral.withValues(alpha: 0.6),
          ),
          errorStyle: MurdockTypography.labelSmall.copyWith(
            color: theme.danger,
          ),
          helperStyle: MurdockTypography.labelSmall.copyWith(
            color: theme.neutral,
          ),
          // ── Spacing ───────────────────────────────────────────────────────
          contentPadding: const EdgeInsets.symmetric(
            horizontal: MurdockSpacing.medium,
            vertical: MurdockSpacing.small,
          ),
        ),
      ),
    );
  }
}
