import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/murdock_theme.dart';
import '../../theme/murdock_theme_data.dart';
import '../../tokens/murdock_radius.dart';
import '../../tokens/murdock_spacing.dart';
import '../../tokens/murdock_typography.dart';

/// Internal style — never exposed in the public API.
enum _MurdockTextFieldStyle { outlined, filled }

/// A semantic, token-driven text field for Murdock UI.
///
/// Manages its own validation state internally. The parent only declares
/// **intent** — what to validate and when — and the widget handles all
/// visual feedback automatically.
///
/// ## Named constructors
///
/// | Constructor | Use case |
/// |---|---|
/// | [MurdockTextField.outlined] | Form inputs, settings, data entry |
/// | [MurdockTextField.filled] | Search bars, chat inputs, dense UIs |
///
/// ## Validation
///
/// Provide a [validator] function that returns `null` when the value is valid,
/// or an error message string when it is not. The field transitions between
/// [idle], [error], and [success] states automatically.
///
/// ```dart
/// MurdockTextField.outlined(
///   label: 'E-mail',
///   validator: (v) => v?.contains('@') == true ? null : 'E-mail inválido',
/// )
/// ```
///
/// By default, validation runs when the user submits the field. Set
/// [validateOnChange] to `true` to validate on every keystroke.
///
/// External errors (e.g. from a server response) can be injected via
/// [errorText]. When non-null, it forces the error state regardless of the
/// internal validator result.
///
/// ## Input formatting
///
/// Pass [inputFormatters] to restrict or mask the input (e.g. digits only,
/// CPF mask). Use [maxLength] to set a character limit.
///
/// ## Accessibility
///
/// The widget wraps the input in [Semantics] with `textField: true` and
/// exposes a dedicated [semanticLabel] parameter (falls back to [label]).
///
/// ## Usage
///
/// ```dart
/// // Self-validating form field
/// MurdockTextField.outlined(
///   label: 'Nome completo',
///   validator: (v) => (v?.isEmpty ?? true) ? 'Campo obrigatório' : null,
///   validateOnChange: true,
/// )
///
/// // Search bar — no validation needed
/// MurdockTextField.filled(
///   label: 'Pesquisar',
///   leadingIcon: Icons.search,
///   onSubmitted: _search,
/// )
///
/// // External server error
/// MurdockTextField.outlined(
///   label: 'E-mail',
///   errorText: _serverError, // null clears the error
/// )
/// ```
class MurdockTextField extends StatefulWidget {
  const MurdockTextField._(
    _MurdockTextFieldStyle style, {
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.validateOnChange = false,
    this.errorText,
    this.helperText,
    this.leadingIcon,
    this.trailingIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.maxLength,
    this.semanticLabel,
  }) : _style = style;

  /// Form input. Use for data entry, settings, and structured forms.
  const MurdockTextField.outlined({
    Key? key,
    required String label,
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    String? Function(String?)? validator,
    bool validateOnChange = false,
    String? errorText,
    String? helperText,
    IconData? leadingIcon,
    IconData? trailingIcon,
    bool obscureText = false,
    bool readOnly = false,
    bool enabled = true,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
    String? semanticLabel,
  }) : this._(
         _MurdockTextFieldStyle.outlined,
         key: key,
         label: label,
         hint: hint,
         controller: controller,
         onChanged: onChanged,
         onSubmitted: onSubmitted,
         validator: validator,
         validateOnChange: validateOnChange,
         errorText: errorText,
         helperText: helperText,
         leadingIcon: leadingIcon,
         trailingIcon: trailingIcon,
         obscureText: obscureText,
         readOnly: readOnly,
         enabled: enabled,
         keyboardType: keyboardType,
         textInputAction: textInputAction,
         inputFormatters: inputFormatters,
         maxLength: maxLength,
         semanticLabel: semanticLabel,
       );

  /// Search / filter input. Use for search bars, chat inputs, and dense UIs.
  const MurdockTextField.filled({
    Key? key,
    required String label,
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    String? Function(String?)? validator,
    bool validateOnChange = false,
    String? errorText,
    String? helperText,
    IconData? leadingIcon,
    IconData? trailingIcon,
    bool obscureText = false,
    bool readOnly = false,
    bool enabled = true,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
    String? semanticLabel,
  }) : this._(
         _MurdockTextFieldStyle.filled,
         key: key,
         label: label,
         hint: hint,
         controller: controller,
         onChanged: onChanged,
         onSubmitted: onSubmitted,
         validator: validator,
         validateOnChange: validateOnChange,
         errorText: errorText,
         helperText: helperText,
         leadingIcon: leadingIcon,
         trailingIcon: trailingIcon,
         obscureText: obscureText,
         readOnly: readOnly,
         enabled: enabled,
         keyboardType: keyboardType,
         textInputAction: textInputAction,
         inputFormatters: inputFormatters,
         maxLength: maxLength,
         semanticLabel: semanticLabel,
       );

  // ── Fields ─────────────────────────────────────────────────────────────────

  final _MurdockTextFieldStyle _style;

  /// Floating label. Also used as the accessibility label unless
  /// [semanticLabel] is provided.
  final String label;

  /// Placeholder text shown when the field is empty.
  final String? hint;

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// Called when the text changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits the field.
  final ValueChanged<String>? onSubmitted;

  /// Validation function. Return `null` if valid, or an error message string
  /// if invalid. The field manages error/success state automatically.
  final String? Function(String?)? validator;

  /// When `true`, [validator] runs on every keystroke.
  /// When `false` (default), it runs only on submit.
  final bool validateOnChange;

  /// External error message (e.g. server-side). Forces error state when
  /// non-null, regardless of [validator] result.
  final String? errorText;

  /// Supplemental helper text shown below the field in non-error states.
  final String? helperText;

  /// Optional icon at the start of the input area.
  final IconData? leadingIcon;

  /// Optional icon at the end of the input area.
  final IconData? trailingIcon;

  /// When `true`, the text is obscured (e.g. password fields).
  final bool obscureText;

  /// When `true`, the field is read-only.
  final bool readOnly;

  /// When `false`, the field is disabled and cannot receive focus.
  final bool enabled;

  /// Keyboard type hint.
  final TextInputType? keyboardType;

  /// Action key behaviour on the software keyboard.
  final TextInputAction? textInputAction;

  /// Input formatters for masking or restricting input.
  final List<TextInputFormatter>? inputFormatters;

  /// Maximum number of characters allowed.
  final int? maxLength;

  /// Explicit accessibility label. Falls back to [label] when `null`.
  final String? semanticLabel;

  @override
  State<MurdockTextField> createState() => _MurdockTextFieldState();
}

// ── State ──────────────────────────────────────────────────────────────────────

class _MurdockTextFieldState extends State<MurdockTextField> {
  String? _validatorError;
  bool _touched = false;

  void _runValidator(String value) {
    if (widget.validator == null) return;
    final error = widget.validator!(value);
    setState(() {
      _touched = true;
      _validatorError = error;
    });
  }

  void _handleChanged(String value) {
    if (widget.validateOnChange) _runValidator(value);
    widget.onChanged?.call(value);
  }

  void _handleSubmitted(String value) {
    _runValidator(value);
    widget.onSubmitted?.call(value);
  }

  String? get _effectiveErrorText => widget.errorText ?? _validatorError;

  _FieldState get _fieldState {
    if (_effectiveErrorText != null) return _FieldState.error;
    if (_touched && widget.validator != null) return _FieldState.success;
    return _FieldState.idle;
  }

  Color _stateColor(MurdockThemeData theme) => switch (_fieldState) {
    _FieldState.idle => theme.outline,
    _FieldState.error => theme.danger,
    _FieldState.success => theme.success,
  };

  InputBorder _outlinedBorder(Color color) => OutlineInputBorder(
    borderRadius: MurdockRadius.smallAll,
    borderSide: BorderSide(color: color, width: 1.5),
  );

  InputBorder _filledBorder(Color color) =>
      UnderlineInputBorder(borderSide: BorderSide(color: color, width: 1.5));

  InputBorder _buildBorder(Color color) =>
      widget._style == _MurdockTextFieldStyle.outlined
          ? _outlinedBorder(color)
          : _filledBorder(color);

  @override
  Widget build(BuildContext context) {
    final theme = MurdockTheme.of(context);
    final stateColor = _stateColor(theme);
    final focusedColor =
        _fieldState == _FieldState.idle ? theme.primary : stateColor;
    final labelColor = widget.enabled ? theme.neutral : theme.outline;

    return Semantics(
      label: widget.semanticLabel ?? widget.label,
      textField: true,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      child: TextField(
        controller: widget.controller,
        onChanged: _handleChanged,
        onSubmitted: _handleSubmitted,
        obscureText: widget.obscureText,
        readOnly: widget.readOnly,
        enabled: widget.enabled,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        inputFormatters: widget.inputFormatters,
        maxLength: widget.maxLength,
        style: MurdockTypography.bodyMedium.copyWith(
          color: widget.enabled ? theme.onSurface : theme.neutral,
        ),
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          errorText: _effectiveErrorText,
          helperText:
              _effectiveErrorText == null ? widget.helperText : null,
          prefixIcon: widget.leadingIcon != null
              ? Icon(widget.leadingIcon, color: labelColor)
              : null,
          suffixIcon: widget.trailingIcon != null
              ? Icon(widget.trailingIcon, color: labelColor)
              : null,
          filled: widget._style == _MurdockTextFieldStyle.filled,
          fillColor: widget.enabled
              ? theme.surfaceVariant
              : theme.surfaceVariant.withValues(alpha: 0.38),
          border: _buildBorder(theme.outline),
          enabledBorder: _buildBorder(stateColor),
          focusedBorder: _buildBorder(focusedColor),
          disabledBorder: _buildBorder(
            theme.outline.withValues(alpha: 0.38),
          ),
          errorBorder: _buildBorder(theme.danger),
          focusedErrorBorder: _buildBorder(theme.danger),
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: MurdockSpacing.medium,
            vertical: MurdockSpacing.small,
          ),
        ),
      ),
    );
  }
}

/// Internal derived state — not part of the public API.
enum _FieldState { idle, error, success }

