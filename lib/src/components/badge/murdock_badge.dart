import 'package:flutter/material.dart';

import '../../theme/murdock_theme.dart';
import '../../tokens/murdock_radius.dart';
import '../../tokens/murdock_spacing.dart';
import '../../tokens/murdock_typography.dart';

/// Internal intent — never exposed in the public API.
enum _MurdockBadgeIntent { primary, success, danger, warning, neutral }

/// A semantic, token-driven status badge for Murdock UI.
///
/// Use the named constructors to declare the **intent** of the badge — the
/// color palette and contrast are resolved from the active [MurdockThemeData]
/// automatically. No raw hex values are exposed.
///
/// ## Named constructors
///
/// | Constructor | Intent | Typical labels |
/// |---|---|---|
/// | [MurdockBadge.primary] | Brand / highlight | "NOVO", "PRO" |
/// | [MurdockBadge.success] | Positive status | "Aprovado", "Ativo" |
/// | [MurdockBadge.danger] | Negative status | "Erro", "Bloqueado" |
/// | [MurdockBadge.warning] | Caution status | "Pendente", "Atenção" |
/// | [MurdockBadge.neutral] | Neutral / count | "42", "Rascunho" |
///
/// ## Accessibility
///
/// The badge is wrapped in [Semantics] with the visible [label] text. Provide
/// [semanticLabel] to override the announced text when the label alone lacks
/// context for screen readers (e.g. a badge showing "3" should be announced
/// as "3 notificações pendentes").
///
/// ## Usage
///
/// ```dart
/// MurdockBadge.success(label: 'Aprovado')
///
/// MurdockBadge.danger(label: 'Erro')
///
/// MurdockBadge.neutral(
///   label: '3',
///   semanticLabel: '3 notificações pendentes',
/// )
/// ```
class MurdockBadge extends StatelessWidget {
  const MurdockBadge._(
    _MurdockBadgeIntent intent, {
    super.key,
    required this.label,
    this.semanticLabel,
  }) : _intent = intent;

  /// Brand or highlight badge. Use for features like "NOVO" or "PRO".
  ///
  /// Renders with a [MurdockColors.primary] background.
  const MurdockBadge.primary({
    Key? key,
    required String label,
    String? semanticLabel,
  }) : this._(
         _MurdockBadgeIntent.primary,
         key: key,
         label: label,
         semanticLabel: semanticLabel,
       );

  /// Positive status badge. Use to communicate success or active state.
  ///
  /// Renders with a [MurdockColors.success] background.
  const MurdockBadge.success({
    Key? key,
    required String label,
    String? semanticLabel,
  }) : this._(
         _MurdockBadgeIntent.success,
         key: key,
         label: label,
         semanticLabel: semanticLabel,
       );

  /// Negative status badge. Use to communicate errors or blocked state.
  ///
  /// Renders with a [MurdockColors.danger] background.
  const MurdockBadge.danger({
    Key? key,
    required String label,
    String? semanticLabel,
  }) : this._(
         _MurdockBadgeIntent.danger,
         key: key,
         label: label,
         semanticLabel: semanticLabel,
       );

  /// Caution status badge. Use to communicate pending or warning state.
  ///
  /// Renders with a [MurdockColors.warning] background.
  const MurdockBadge.warning({
    Key? key,
    required String label,
    String? semanticLabel,
  }) : this._(
         _MurdockBadgeIntent.warning,
         key: key,
         label: label,
         semanticLabel: semanticLabel,
       );

  /// Neutral badge. Use for counts, drafts, or unclassified statuses.
  ///
  /// Renders with a [MurdockColors.neutralContainer] background.
  const MurdockBadge.neutral({
    Key? key,
    required String label,
    String? semanticLabel,
  }) : this._(
         _MurdockBadgeIntent.neutral,
         key: key,
         label: label,
         semanticLabel: semanticLabel,
       );

  // ── Fields ─────────────────────────────────────────────────────────────────

  /// The text displayed inside the badge.
  final String label;

  /// Label announced by screen readers. Falls back to [label] when `null`.
  ///
  /// Use when [label] alone lacks context:
  /// ```dart
  /// MurdockBadge.neutral(label: '3', semanticLabel: '3 notificações')
  /// ```
  final String? semanticLabel;

  final _MurdockBadgeIntent _intent;

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = MurdockTheme.of(context);

    final (Color bg, Color fg) = switch (_intent) {
      _MurdockBadgeIntent.primary => (theme.primary, theme.onPrimary),
      _MurdockBadgeIntent.success => (theme.success, theme.onSuccess),
      _MurdockBadgeIntent.danger => (theme.danger, theme.onDanger),
      _MurdockBadgeIntent.warning => (theme.warning, theme.onWarning),
      _MurdockBadgeIntent.neutral => (
        theme.neutralContainer,
        theme.onNeutralContainer,
      ),
    };

    return Semantics(
      label: semanticLabel ?? label,
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: MurdockSpacing.small,
          vertical: MurdockSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: MurdockRadius.fullAll,
        ),
        child: Text(
          label,
          style: MurdockTypography.labelSmall.copyWith(color: fg),
        ),
      ),
    );
  }
}
