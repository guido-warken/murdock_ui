import 'package:flutter/material.dart';

import '../theme/murdock_theme.dart';
import '../tokens/murdock_spacing.dart';
import '../tokens/murdock_typography.dart';

/// A semantic, token-driven page scaffold for Murdock UI.
///
/// [MurdockScaffold] wraps Flutter's [Scaffold] and pre-applies Murdock UI
/// tokens to the app bar, background, and bottom bar. No raw colors, font
/// sizes, or edge insets are exposed — every visual decision is resolved
/// from the active [MurdockThemeData].
///
/// ## Structure
///
/// | Parameter | Role |
/// |---|---|
/// | [title] | App bar headline (optional) |
/// | [body] | Main scrollable/interactive content (required) |
/// | [actions] | App bar trailing action widgets |
/// | [leading] | App bar leading widget (defaults to back button when applicable) |
/// | [bottomBar] | Bottom persistent bar — ideal for [MurdockButton] or [MurdockRow] |
/// | [floatingAction] | Floating action widget — ideal for [MurdockButton] |
///
/// ## Accessibility
///
/// Provide [semanticLabel] to give the page a meaningful name for assistive
/// technologies. Screen readers will announce it when the page gains focus.
///
/// ## Usage
///
/// ```dart
/// MurdockScaffold(
///   title: 'Meus Pedidos',
///   body: OrderListView(),
///   actions: [
///     MurdockButton.action(label: 'Filtrar', onPressed: _openFilter),
///   ],
///   bottomBar: MurdockRow(
///     expand: true,
///     children: [
///       MurdockButton.action(label: 'Cancelar', onPressed: _cancel),
///       MurdockButton.primary(label: 'Confirmar', onPressed: _confirm),
///     ],
///   ),
/// )
/// ```
class MurdockScaffold extends StatelessWidget {
  const MurdockScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.leading,
    this.bottomBar,
    this.floatingAction,
    this.semanticLabel,
  });

  /// The main content of the page. Required.
  final Widget body;

  /// Optional headline text displayed in the app bar.
  /// Styled with [MurdockTypography.titleLarge] automatically.
  final String? title;

  /// Optional trailing widgets placed in the app bar (e.g. action buttons).
  final List<Widget>? actions;

  /// Optional leading widget in the app bar.
  /// When `null`, Flutter shows a back button automatically if applicable.
  final Widget? leading;

  /// Optional persistent bottom bar (e.g. confirmation buttons, navigation).
  /// Padded with [MurdockSpacing.medium] and separated by a top border.
  final Widget? bottomBar;

  /// Optional floating widget anchored above the bottom-right corner.
  final Widget? floatingAction;

  /// Semantic label for the page, announced by screen readers when the
  /// page gains focus. Useful to orient users on navigation.
  final String? semanticLabel;

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = MurdockTheme.of(context);

    final hasAppBar = title != null || actions != null || leading != null;

    final PreferredSizeWidget? appBar = hasAppBar
        ? AppBar(
            backgroundColor: theme.surface,
            foregroundColor: theme.onSurface,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            scrolledUnderElevation: 1,
            elevation: 0,
            leading: leading,
            title: title != null
                ? Text(
                    title!,
                    style: MurdockTypography.titleLarge.copyWith(
                      color: theme.onSurface,
                    ),
                  )
                : null,
            actions: actions != null
                ? [
                    ...actions!,
                    const SizedBox(width: MurdockSpacing.small),
                  ]
                : null,
          )
        : null;

    final Widget? bottomNavigationBar = bottomBar != null
        ? DecoratedBox(
            decoration: BoxDecoration(
              color: theme.surface,
              border: Border(
                top: BorderSide(color: theme.outline, width: 1),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: MurdockSpacing.medium,
                  vertical: MurdockSpacing.medium,
                ),
                child: bottomBar,
              ),
            ),
          )
        : null;

    final scaffold = Scaffold(
      backgroundColor: theme.surface,
      appBar: appBar,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingAction,
    );

    if (semanticLabel == null) return scaffold;

    return Semantics(
      label: semanticLabel,
      child: scaffold,
    );
  }
}
