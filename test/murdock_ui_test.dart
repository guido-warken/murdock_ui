import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:murdock_ui/murdock_ui.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

/// Wraps [child] with the minimum tree required by Murdock UI components:
/// a [MaterialApp] that provides [Material] and [MurdockTheme].
Widget _wrap(Widget child) {
  return MaterialApp(
    home: MurdockTheme(
      data: const MurdockThemeData(),
      child: Scaffold(body: Center(child: child)),
    ),
  );
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('MurdockButton', () {
    // ── Rendering ──────────────────────────────────────────────────────────

    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(
        _wrap(MurdockButton(label: 'Confirmar', onPressed: () {})),
      );

      expect(find.text('Confirmar'), findsOneWidget);
    });

    testWidgets('renders leading icon when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MurdockButton(
            label: 'Adicionar',
            onPressed: () {},
            leadingIcon: Icons.add,
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('renders trailing icon when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MurdockButton(
            label: 'Próximo',
            onPressed: () {},
            trailingIcon: Icons.arrow_forward,
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('renders CircularProgressIndicator when isLoading is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          MurdockButton(label: 'Salvando', onPressed: null, isLoading: true),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Salvando'), findsNothing);
    });

    // ── Variants ───────────────────────────────────────────────────────────

    testWidgets('renders filled variant by default', (tester) async {
      await tester.pumpWidget(
        _wrap(MurdockButton(label: 'OK', onPressed: () {})),
      );

      final button = tester.widget<MurdockButton>(find.byType(MurdockButton));
      expect(button.variant, MurdockButtonVariant.filled);
    });

    testWidgets('renders outlined variant', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MurdockButton(
            label: 'Cancelar',
            onPressed: () {},
            variant: MurdockButtonVariant.outlined,
          ),
        ),
      );

      final button = tester.widget<MurdockButton>(find.byType(MurdockButton));
      expect(button.variant, MurdockButtonVariant.outlined);
    });

    testWidgets('renders text variant', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MurdockButton(
            label: 'Saiba mais',
            onPressed: () {},
            variant: MurdockButtonVariant.text,
          ),
        ),
      );

      final button = tester.widget<MurdockButton>(find.byType(MurdockButton));
      expect(button.variant, MurdockButtonVariant.text);
    });

    // ── Sizes ──────────────────────────────────────────────────────────────

    testWidgets('defaults to medium size', (tester) async {
      await tester.pumpWidget(
        _wrap(MurdockButton(label: 'OK', onPressed: () {})),
      );

      final button = tester.widget<MurdockButton>(find.byType(MurdockButton));
      expect(button.size, MurdockButtonSize.medium);
    });

    testWidgets('renders small size', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MurdockButton(
            label: 'OK',
            onPressed: () {},
            size: MurdockButtonSize.small,
          ),
        ),
      );

      final button = tester.widget<MurdockButton>(find.byType(MurdockButton));
      expect(button.size, MurdockButtonSize.small);
    });

    // ── Interaction ────────────────────────────────────────────────────────

    testWidgets('calls onPressed when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        _wrap(MurdockButton(label: 'Tap me', onPressed: () => tapped = true)),
      );

      await tester.tap(find.byType(MurdockButton));
      expect(tapped, isTrue);
    });

    testWidgets('does not call onPressed when disabled (onPressed is null)', (
      tester,
    ) async {
      var tapped = false;

      await tester.pumpWidget(
        _wrap(MurdockButton(label: 'Desabilitado', onPressed: null)),
      );

      await tester.tap(find.byType(MurdockButton), warnIfMissed: false);
      expect(tapped, isFalse);
    });

    testWidgets('does not call onPressed when isLoading is true', (
      tester,
    ) async {
      var tapped = false;

      await tester.pumpWidget(
        _wrap(
          MurdockButton(
            label: 'Carregando',
            onPressed: () => tapped = true,
            isLoading: true,
          ),
        ),
      );

      await tester.tap(find.byType(MurdockButton), warnIfMissed: false);
      expect(tapped, isFalse);
    });

    // ── Accessibility ──────────────────────────────────────────────────────

    testWidgets('has button semantics role', (tester) async {
      await tester.pumpWidget(
        _wrap(MurdockButton(label: 'Ação', onPressed: () {})),
      );

      final semantics = tester.getSemantics(find.byType(MurdockButton));
      expect(semantics.hasFlag(SemanticsFlag.isButton), isTrue);
    });

    testWidgets('semantics is disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        _wrap(MurdockButton(label: 'Desabilitado', onPressed: null)),
      );

      final semantics = tester.getSemantics(find.byType(MurdockButton));
      expect(semantics.hasFlag(SemanticsFlag.isEnabled), isFalse);
    });

    testWidgets('enforces minimum touch target of 48dp', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MurdockButton(
            label: 'X',
            onPressed: () {},
            size: MurdockButtonSize.small,
          ),
        ),
      );

      final renderBox = tester.renderObject<RenderBox>(
        find.byType(MurdockButton),
      );
      expect(renderBox.size.width, greaterThanOrEqualTo(48.0));
      expect(renderBox.size.height, greaterThanOrEqualTo(48.0));
    });
  });

  // ── MurdockTextField ───────────────────────────────────────────────────────

  group('MurdockTextField', () {
    // ── Rendering ──────────────────────────────────────────────────────────

    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(_wrap(const MurdockTextField(label: 'Nome')));

      expect(find.text('Nome'), findsOneWidget);
    });

    testWidgets('renders hint text when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MurdockTextField(label: 'E-mail', hint: 'Ex.: joao@email.com'),
        ),
      );

      expect(find.text('Ex.: joao@email.com'), findsOneWidget);
    });

    testWidgets('renders leading icon when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MurdockTextField(label: 'Busca', leadingIcon: Icons.search),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('renders trailing icon when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MurdockTextField(
            label: 'Senha',
            trailingIcon: Icons.visibility_off,
          ),
        ),
      );

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets(
      'renders error text when state is error and errorText is given',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            const MurdockTextField(
              label: 'E-mail',
              state: MurdockTextFieldState.error,
              errorText: 'E-mail inválido',
            ),
          ),
        );

        expect(find.text('E-mail inválido'), findsOneWidget);
      },
    );

    testWidgets('does not render error text when state is idle', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const MurdockTextField(
            label: 'E-mail',
            state: MurdockTextFieldState.idle,
            errorText: 'E-mail inválido',
          ),
        ),
      );

      expect(find.text('E-mail inválido'), findsNothing);
    });

    testWidgets('renders helper text in idle state', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MurdockTextField(
            label: 'Usuário',
            helperText: 'Mínimo 8 caracteres',
          ),
        ),
      );

      expect(find.text('Mínimo 8 caracteres'), findsOneWidget);
    });

    // ── Defaults ───────────────────────────────────────────────────────────

    testWidgets('defaults to outlined variant', (tester) async {
      await tester.pumpWidget(_wrap(const MurdockTextField(label: 'Campo')));

      final field = tester.widget<MurdockTextField>(
        find.byType(MurdockTextField),
      );
      expect(field.variant, MurdockTextFieldVariant.outlined);
    });

    testWidgets('defaults to idle state', (tester) async {
      await tester.pumpWidget(_wrap(const MurdockTextField(label: 'Campo')));

      final field = tester.widget<MurdockTextField>(
        find.byType(MurdockTextField),
      );
      expect(field.state, MurdockTextFieldState.idle);
    });

    // ── Interaction ────────────────────────────────────────────────────────

    testWidgets('calls onChanged when text is entered', (tester) async {
      String? captured;

      await tester.pumpWidget(
        _wrap(
          MurdockTextField(
            label: 'Nome',
            onChanged: (value) => captured = value,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Olá');
      expect(captured, 'Olá');
    });

    testWidgets('does not allow editing when enabled is false', (tester) async {
      await tester.pumpWidget(
        _wrap(const MurdockTextField(label: 'Somente leitura', enabled: false)),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, isFalse);
    });

    testWidgets('does not allow editing when readOnly is true', (tester) async {
      await tester.pumpWidget(
        _wrap(const MurdockTextField(label: 'Somente leitura', readOnly: true)),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.readOnly, isTrue);
    });

    // ── Accessibility ──────────────────────────────────────────────────────

    testWidgets('has textField semantics role', (tester) async {
      await tester.pumpWidget(_wrap(const MurdockTextField(label: 'E-mail')));

      final semantics = tester.getSemantics(find.byType(MurdockTextField));
      expect(semantics.hasFlag(SemanticsFlag.isTextField), isTrue);
    });

    testWidgets('uses semanticLabel when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MurdockTextField(
            label: 'E-mail',
            semanticLabel: 'Campo de e-mail corporativo',
          ),
        ),
      );

      final field = tester.widget<MurdockTextField>(
        find.byType(MurdockTextField),
      );
      expect(field.semanticLabel, 'Campo de e-mail corporativo');
    });

    testWidgets('semantics is disabled when enabled is false', (tester) async {
      await tester.pumpWidget(
        _wrap(const MurdockTextField(label: 'Desabilitado', enabled: false)),
      );

      final semantics = tester.getSemantics(find.byType(MurdockTextField));
      expect(semantics.hasFlag(SemanticsFlag.isEnabled), isFalse);
    });
  });
}
