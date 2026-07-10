import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/murdock_theme.dart';
import '../../theme/murdock_theme_data.dart';
import '../../tokens/murdock_radius.dart';
import '../../tokens/murdock_spacing.dart';
import '../../tokens/murdock_typography.dart';

/// Internal visual style — never exposed in the public API.
enum _MurdockTextFieldStyle { outlined, filled }

/// Internal semantic type — drives default validation, formatters, keyboard
/// type, and icons. Never exposed in the public API.
enum _MurdockSemanticType {
  none,
  email,
  password,
  phone,
  cpf,
  number,
  multiline,
  name,
  url,
  search,
}

/// A semantic, token-driven text field for Murdock UI.
///
/// Manages its own validation state internally. The parent only declares
/// **intent** — which named constructor to use — and the widget configures
/// keyboard type, input formatters, built-in validation, and visual feedback
/// automatically.
///
/// ## Style constructors (no built-in validation)
///
/// | Constructor | Use case |
/// |---|---|
/// | [MurdockTextField.outlined] | Generic form inputs, full manual control |
/// | [MurdockTextField.filled] | Generic search / chat inputs |
///
/// ## Semantic constructors (intent-driven defaults)
///
/// | Constructor | Built-in validator | Keyboard | Formatters |
/// |---|---|---|---|
/// | [MurdockTextField.email] | E-mail format | `emailAddress` | — |
/// | [MurdockTextField.password] | — | `visiblePassword` | — |
/// | [MurdockTextField.phone] | Min. length | `phone` | digits only |
/// | [MurdockTextField.cpf] | CPF algorithm | `number` | CPF mask |
/// | [MurdockTextField.number] | — | `number` | digits only |
/// | [MurdockTextField.multiline] | — | `multiline` | — |
/// | [MurdockTextField.name] | — | `name` | — |
/// | [MurdockTextField.url] | URL format | `url` | — |
/// | [MurdockTextField.search] | — | `text` | — |
///
/// All built-in validators can be overridden via the [validator] parameter.
///
/// ## Validation
///
/// Provide a [validator] function that returns `null` when the value is valid,
/// or an error message string when it is not. The field transitions between
/// idle, error, and success states automatically.
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
    _MurdockSemanticType semanticType = _MurdockSemanticType.none,
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
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.semanticLabel,
  })  : _style = style,
        _semanticType = semanticType;

  // ── Style constructors ─────────────────────────────────────────────────────

  /// Generic form input. Use when you need full manual control over validation.
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

  /// Generic search / filter input. Use when you need full manual control.
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

  // ── Semantic constructors ──────────────────────────────────────────────────

  /// E-mail input. Validates format automatically.
  ///
  /// Defaults: `emailAddress` keyboard, e-mail icon, e-mail validator.
  /// Pass [validator] to override the built-in validation.
  MurdockTextField.email({
    Key? key,
    String label = 'E-mail',
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    String? Function(String?)? validator,
    bool validateOnChange = false,
    String? errorText,
    String? helperText,
    bool readOnly = false,
    bool enabled = true,
    String? semanticLabel,
  }) : this._(
         _MurdockTextFieldStyle.outlined,
         semanticType: _MurdockSemanticType.email,
         key: key,
         label: label,
         hint: hint ?? 'nome@exemplo.com',
         controller: controller,
         onChanged: onChanged,
         onSubmitted: onSubmitted,
         validator: validator,
         validateOnChange: validateOnChange,
         errorText: errorText,
         helperText: helperText,
         leadingIcon: Icons.alternate_email,
         obscureText: false,
         readOnly: readOnly,
         enabled: enabled,
         keyboardType: TextInputType.emailAddress,
         textInputAction: TextInputAction.done,
         semanticLabel: semanticLabel,
       );

  /// Password input. Obscures text by default.
  ///
  /// Defaults: `visiblePassword` keyboard, lock icon, obscured text.
  MurdockTextField.password({
    Key? key,
    String label = 'Senha',
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    String? Function(String?)? validator,
    bool validateOnChange = false,
    String? errorText,
    String? helperText,
    bool readOnly = false,
    bool enabled = true,
    String? semanticLabel,
  }) : this._(
         _MurdockTextFieldStyle.outlined,
         semanticType: _MurdockSemanticType.password,
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
         leadingIcon: Icons.lock_outline,
         obscureText: true,
         readOnly: readOnly,
         enabled: enabled,
         keyboardType: TextInputType.visiblePassword,
         textInputAction: TextInputAction.done,
         semanticLabel: semanticLabel,
       );

  /// Phone number input. Accepts digits only.
  ///
  /// Defaults: `phone` keyboard, phone icon, digits-only formatter,
  /// minimum-length validator.
  MurdockTextField.phone({
    Key? key,
    String label = 'Telefone',
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    String? Function(String?)? validator,
    bool validateOnChange = false,
    String? errorText,
    String? helperText,
    bool readOnly = false,
    bool enabled = true,
    String? semanticLabel,
  }) : this._(
         _MurdockTextFieldStyle.outlined,
         semanticType: _MurdockSemanticType.phone,
         key: key,
         label: label,
         hint: hint ?? '(00) 00000-0000',
         controller: controller,
         onChanged: onChanged,
         onSubmitted: onSubmitted,
         validator: validator,
         validateOnChange: validateOnChange,
         errorText: errorText,
         helperText: helperText,
         leadingIcon: Icons.phone_outlined,
         obscureText: false,
         readOnly: readOnly,
         enabled: enabled,
         keyboardType: TextInputType.phone,
         textInputAction: TextInputAction.done,
         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
         maxLength: 11,
         semanticLabel: semanticLabel,
       );

  /// CPF input with mask and validation.
  ///
  /// Defaults: `number` keyboard, digits-only formatter with CPF mask
  /// (`###.###.###-##`), CPF check-digit validator.
  MurdockTextField.cpf({
    Key? key,
    String label = 'CPF',
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    String? Function(String?)? validator,
    bool validateOnChange = false,
    String? errorText,
    String? helperText,
    bool readOnly = false,
    bool enabled = true,
    String? semanticLabel,
  }) : this._(
         _MurdockTextFieldStyle.outlined,
         semanticType: _MurdockSemanticType.cpf,
         key: key,
         label: label,
         hint: hint ?? '000.000.000-00',
         controller: controller,
         onChanged: onChanged,
         onSubmitted: onSubmitted,
         validator: validator,
         validateOnChange: validateOnChange,
         errorText: errorText,
         helperText: helperText,
         leadingIcon: Icons.badge_outlined,
         obscureText: false,
         readOnly: readOnly,
         enabled: enabled,
         keyboardType: TextInputType.number,
         textInputAction: TextInputAction.done,
         inputFormatters: [
           FilteringTextInputFormatter.digitsOnly,
           _CpfInputFormatter(),
         ],
         maxLength: 14,
         semanticLabel: semanticLabel,
       );

  /// Numeric input. Accepts digits only.
  ///
  /// Defaults: `number` keyboard, digits-only formatter.
  MurdockTextField.number({
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
    bool readOnly = false,
    bool enabled = true,
    int? maxLength,
    String? semanticLabel,
  }) : this._(
         _MurdockTextFieldStyle.outlined,
         semanticType: _MurdockSemanticType.number,
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
         obscureText: false,
         readOnly: readOnly,
         enabled: enabled,
         keyboardType: TextInputType.number,
         textInputAction: TextInputAction.done,
         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
         maxLength: maxLength,
         semanticLabel: semanticLabel,
       );

  /// Multi-line text input.
  ///
  /// Defaults: `multiline` keyboard, `newline` action, unlimited lines.
  MurdockTextField.multiline({
    Key? key,
    required String label,
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
    bool validateOnChange = false,
    String? errorText,
    String? helperText,
    bool readOnly = false,
    bool enabled = true,
    int? maxLength,
    String? semanticLabel,
  }) : this._(
         _MurdockTextFieldStyle.outlined,
         semanticType: _MurdockSemanticType.multiline,
         key: key,
         label: label,
         hint: hint,
         controller: controller,
         onChanged: onChanged,
         validator: validator,
         validateOnChange: validateOnChange,
         errorText: errorText,
         helperText: helperText,
         obscureText: false,
         readOnly: readOnly,
         enabled: enabled,
         keyboardType: TextInputType.multiline,
         textInputAction: TextInputAction.newline,
         maxLength: maxLength,
         maxLines: null,
         semanticLabel: semanticLabel,
       );

  /// Full name input. Capitalises each word automatically.
  ///
  /// Defaults: `name` keyboard, `words` capitalisation, person icon.
  MurdockTextField.name({
    Key? key,
    String label = 'Nome completo',
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    String? Function(String?)? validator,
    bool validateOnChange = false,
    String? errorText,
    String? helperText,
    bool readOnly = false,
    bool enabled = true,
    String? semanticLabel,
  }) : this._(
         _MurdockTextFieldStyle.outlined,
         semanticType: _MurdockSemanticType.name,
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
         leadingIcon: Icons.person_outline,
         obscureText: false,
         readOnly: readOnly,
         enabled: enabled,
         keyboardType: TextInputType.name,
         textInputAction: TextInputAction.done,
         textCapitalization: TextCapitalization.words,
         semanticLabel: semanticLabel,
       );

  /// URL input. Validates format automatically.
  ///
  /// Defaults: `url` keyboard, link icon, URL validator.
  MurdockTextField.url({
    Key? key,
    String label = 'URL',
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    String? Function(String?)? validator,
    bool validateOnChange = false,
    String? errorText,
    String? helperText,
    bool readOnly = false,
    bool enabled = true,
    String? semanticLabel,
  }) : this._(
         _MurdockTextFieldStyle.outlined,
         semanticType: _MurdockSemanticType.url,
         key: key,
         label: label,
         hint: hint ?? 'https://exemplo.com',
         controller: controller,
         onChanged: onChanged,
         onSubmitted: onSubmitted,
         validator: validator,
         validateOnChange: validateOnChange,
         errorText: errorText,
         helperText: helperText,
         leadingIcon: Icons.link,
         obscureText: false,
         readOnly: readOnly,
         enabled: enabled,
         keyboardType: TextInputType.url,
         textInputAction: TextInputAction.go,
         semanticLabel: semanticLabel,
       );

  /// Search input. Filled style with search icon and action.
  MurdockTextField.search({
    Key? key,
    String label = 'Pesquisar',
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    String? errorText,
    bool readOnly = false,
    bool enabled = true,
    String? semanticLabel,
  }) : this._(
         _MurdockTextFieldStyle.filled,
         semanticType: _MurdockSemanticType.search,
         key: key,
         label: label,
         hint: hint,
         controller: controller,
         onChanged: onChanged,
         onSubmitted: onSubmitted,
         leadingIcon: Icons.search,
         obscureText: false,
         readOnly: readOnly,
         enabled: enabled,
         keyboardType: TextInputType.text,
         textInputAction: TextInputAction.search,
         semanticLabel: semanticLabel,
       );

  // ── Fields ─────────────────────────────────────────────────────────────────

  final _MurdockTextFieldStyle _style;
  final _MurdockSemanticType _semanticType;

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

  /// Custom validation function. Overrides the built-in validator of semantic
  /// constructors. Return `null` if valid, or an error message if invalid.
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

  /// Text capitalisation strategy.
  final TextCapitalization textCapitalization;

  /// Input formatters for masking or restricting input.
  final List<TextInputFormatter>? inputFormatters;

  /// Maximum number of characters allowed.
  final int? maxLength;

  /// Maximum number of lines. `null` means unlimited (multiline).
  final int? maxLines;

  /// Explicit accessibility label. Falls back to [label] when `null`.
  final String? semanticLabel;

  @override
  State<MurdockTextField> createState() => _MurdockTextFieldState();
}

// ── State ──────────────────────────────────────────────────────────────────────

class _MurdockTextFieldState extends State<MurdockTextField> {
  String? _validatorError;
  bool _touched = false;

  // ── Built-in validators ────────────────────────────────────────────────────

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final _urlRegex = RegExp(
    r'^https?://[^\s/$.?#].[^\s]*$',
    caseSensitive: false,
  );

  String? _builtInValidator(String? value) {
    if (value == null || value.isEmpty) return null;
    return switch (widget._semanticType) {
      _MurdockSemanticType.email =>
        _emailRegex.hasMatch(value) ? null : 'E-mail inválido',
      _MurdockSemanticType.phone =>
        value.length >= 10 ? null : 'Telefone incompleto',
      _MurdockSemanticType.cpf => _validateCpf(value),
      _MurdockSemanticType.url =>
        _urlRegex.hasMatch(value) ? null : 'URL inválida',
      _ => null,
    };
  }

  static String? _validateCpf(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 11) return 'CPF incompleto';
    if (RegExp(r'^(\d)\1{10}$').hasMatch(digits)) return 'CPF inválido';
    int sum(int end, int start) {
      var s = 0;
      for (var i = 0; i < end; i++) s += int.parse(digits[i]) * (start - i);
      return s;
    }
    int digit(int s) { final r = 11 - (s % 11); return r > 9 ? 0 : r; }
    if (digit(sum(9, 10)) != int.parse(digits[9])) return 'CPF inválido';
    if (digit(sum(10, 11)) != int.parse(digits[10])) return 'CPF inválido';
    return null;
  }

  // ── Validation logic ───────────────────────────────────────────────────────

  void _runValidator(String value) {
    final error = widget.validator != null
        ? widget.validator!(value)
        : _builtInValidator(value);
    setState(() { _touched = true; _validatorError = error; });
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
    if (_touched &&
        (widget.validator != null ||
            widget._semanticType != _MurdockSemanticType.none)) {
      return _FieldState.success;
    }
    return _FieldState.idle;
  }

  // ── Border helpers ─────────────────────────────────────────────────────────

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

  // ── Build ──────────────────────────────────────────────────────────────────

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
        textCapitalization: widget.textCapitalization,
        inputFormatters: widget.inputFormatters,
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
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

// ── Internal helpers ───────────────────────────────────────────────────────────

/// Internal derived visual state.
enum _FieldState { idle, error, success }

/// CPF mask formatter: applies `###.###.###-##` as the user types.
class _CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length && i < 11; i++) {
      if (i == 3 || i == 6) buffer.write('.');
      if (i == 9) buffer.write('-');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
