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
  // ── MurdockButton ──────────────────────────────────────────────────────────

  group('MurdockButton', () {
    // ── Named constructors ─────────────────────────────────────────────────

    testWidgets('.primary() renders label', (tester) async {
      await tester.pumpWidget(
        _wrap(MurdockButton.primary(label: 'Confirmar', onPressed: () {})),
      );
      expect(find.text('Confirmar'), findsOneWidget);
    });

    testWidgets('.success() renders label', (tester) async {
      await tester.pumpWidget(
        _wrap(MurdockButton.success(label: 'Salvar', onPressed: () {})),
      );
      expect(find.text('Salvar'), findsOneWidget);
    });

    testWidgets('.danger() renders label', (tester) async {
      await tester.pumpWidget(
        _wrap(MurdockButton.danger(label: 'Excluir', onPressed: () {})),
      );
      expect(find.text('Excluir'), findsOneWidget);
    });

    testWidgets('.action() renders label', (tester) async {
      await tester.pumpWidget(
        _wrap(MurdockButton.action(label: 'Cancelar', onPressed: () {})),
      );
      expect(find.text('Cancelar'), findsOneWidget);
    });

    // ── Icons ──────────────────────────────────────────────────────────────

    testWidgets('renders leading icon when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MurdockButton.primary(
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
          MurdockButton.primary(
            label: 'Próximo',
            onPressed: () {},
            trailingIcon: Icons.arrow_forward,
          ),
        ),
      );
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    // ── Loading state ──────────────────────────────────────────────────────

    testWidgets('renders CircularProgressIndicator when isLoading is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          MurdockButton.primary(
            label: 'Salvando',
            onPressed: null,
            isLoading: true,
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Salvando'), findsNothing);
    });

    // ── Sizes ──────────────────────────────────────────────────────────────

    testWidgets('defaults to medium size', (tester) async {
      await tester.pumpWidget(
        _wrap(MurdockButton.primary(label: 'OK', onPressed: () {})),
      );
      final button = tester.widget<MurdockButton>(find.byType(MurdockButton));
      expect(button.size, MurdockButtonSize.medium);
    });

    testWidgets('renders small size', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MurdockButton.primary(
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
        _wrap(
          MurdockButton.primary(
            label: 'Tap me',
            onPressed: () => tapped = true,
          ),
        ),
      );
      await tester.tap(find.byType(MurdockButton));
      expect(tapped, isTrue);
    });

    testWidgets('does not call onPressed when disabled', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(MurdockButton.primary(label: 'Desabilitado', onPressed: null)),
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
          MurdockButton.primary(
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
        _wrap(MurdockButton.primary(label: 'Ação', onPressed: () {})),
      );
      final semantics = tester.getSemantics(find.byType(MurdockButton));
      expect(semantics.hasFlag(SemanticsFlag.isButton), isTrue);
    });

    testWidgets('semantics is disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        _wrap(MurdockButton.primary(label: 'Desabilitado', onPressed: null)),
      );
      final semantics = tester.getSemantics(find.byType(MurdockButton));
      expect(semantics.hasFlag(SemanticsFlag.isEnabled), isFalse);
    });

    testWidgets('enforces minimum touch target of 48dp', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MurdockButton.primary(
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
    // ── Named constructors ─────────────────────────────────────────────────

    testWidgets('.outlined() renders label', (tester) async {
      await tester.pumpWidget(
        _wrap(const MurdockTextField.outlined(label: 'Nome')),
      );
      expect(find.text('Nome'), findsOneWidget);
    });

    testWidgets('.filled() renders label', (tester) async {
      await tester.pumpWidget(
        _wrap(const MurdockTextField.filled(label: 'Pesquisar')),
      );
      expect(find.text('Pesquisar'), findsOneWidget);
    });

    // ── Rendering ──────────────────────────────────────────────────────────

    testWidgets('renders hint text when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MurdockTextField.outlined(
            label: 'E-mail',
            hint: 'Ex.: joao@email.com',
          ),
        ),
      );
      expect(find.text('Ex.: joao@email.com'), findsOneWidget);
    });

    testWidgets('renders leading icon when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MurdockTextField.filled(
            label: 'Busca',
            leadingIcon: Icons.search,
          ),
        ),
      );
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('renders trailing icon when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MurdockTextField.outlined(
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
            const MurdockTextField.outlined(
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
          const MurdockTextField.outlined(
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
          const MurdockTextField.outlined(
            label: 'Usuário',
            helperText: 'Mínimo 8 caracteres',
          ),
        ),
      );
      expect(find.text('Mínimo 8 caracteres'), findsOneWidget);
    });

    // ── Defaults ───────────────────────────────────────────────────────────

    testWidgets('defaults to idle state', (tester) async {
      await tester.pumpWidget(
        _wrap(const MurdockTextField.outlined(label: 'Campo')),
      );
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
          MurdockTextField.outlined(
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
        _wrap(
          const MurdockTextField.outlined(
            label: 'Somente leitura',
            enabled: false,
          ),
        ),
      );
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, isFalse);
    });

    testWidgets('does not allow editing when readOnly is true', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MurdockTextField.outlined(
            label: 'Somente leitura',
            readOnly: true,
          ),
        ),
      );
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.readOnly, isTrue);
    });

    // ── Accessibility ──────────────────────────────────────────────────────

    testWidgets('has textField semantics role', (tester) async {
      await tester.pumpWidget(
        _wrap(const MurdockTextField.outlined(label: 'E-mail')),
      );
      final semantics = tester.getSemantics(find.byType(MurdockTextField));
      expect(semantics.hasFlag(SemanticsFlag.isTextField), isTrue);
    });

    testWidgets('uses semanticLabel when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MurdockTextField.outlined(
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
        _wrap(
          const MurdockTextField.outlined(
            label: 'Desabilitado',
            enabled: false,
          ),
        ),
      );
      final semantics = tester.getSemantics(find.byType(MurdockTextField));
      expect(semantics.hasFlag(SemanticsFlag.isEnabled), isFalse);
    });
  });

  // ── MurdockText ────────────────────────────────────────────────────────────

  group('MurdockText', () {
    // ── Named constructors ─────────────────────────────────────────────────

    testWidgets('.heading() renders text', (tester) async {
      await tester.pumpWidget(_wrap(const MurdockText.heading('Título')));
      expect(find.text('Título'), findsOneWidget);
    });

    testWidgets('.body() renders text', (tester) async {
      await tester.pumpWidget(
        _wrap(const MurdockText.body('Parágrafo de conteúdo')),
      );
      expect(find.text('Parágrafo de conteúdo'), findsOneWidget);
    });

    testWidgets('.caption() renders text', (tester) async {
      await tester.pumpWidget(
        _wrap(const MurdockText.caption('Atualizado há 2 min')),
      );
      expect(find.text('Atualizado há 2 min'), findsOneWidget);
    });

    testWidgets('.label() renders text', (tester) async {
      await tester.pumpWidget(_wrap(const MurdockText.label('NOVO')));
      expect(find.text('NOVO'), findsOneWidget);
    });

    // ── Typography scale ───────────────────────────────────────────────────

    testWidgets('.heading() uses headlineMedium style', (tester) async {
      await tester.pumpWidget(_wrap(const MurdockText.heading('Título')));
      final text = tester.widget<Text>(find.text('Título'));
      expect(text.style?.fontSize, MurdockTypography.headlineMedium.fontSize);
    });

    testWidgets('.body() uses bodyLarge style', (tester) async {
      await tester.pumpWidget(_wrap(const MurdockText.body('Texto')));
      final text = tester.widget<Text>(find.text('Texto'));
      expect(text.style?.fontSize, MurdockTypography.bodyLarge.fontSize);
    });

    testWidgets('.caption() uses bodySmall style', (tester) async {
      await tester.pumpWidget(_wrap(const MurdockText.caption('Legenda')));
      final text = tester.widget<Text>(find.text('Legenda'));
      expect(text.style?.fontSize, MurdockTypography.bodySmall.fontSize);
    });

    // ── Accessibility ──────────────────────────────────────────────────────

    testWidgets('uses semanticLabel when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MurdockText.body(
            'R\$ 1.200,00',
            semanticLabel: 'Um mil e duzentos reais',
          ),
        ),
      );
      final widget = tester.widget<MurdockText>(find.byType(MurdockText));
      expect(widget.semanticLabel, 'Um mil e duzentos reais');
    });
  });

  // ── MurdockCard ────────────────────────────────────────────────────────────

  group('MurdockCard', () {
    // ── Named constructors ─────────────────────────────────────────────────

    testWidgets('.flat() renders child', (tester) async {
      await tester.pumpWidget(
        _wrap(const MurdockCard.flat(child: Text('Conteúdo'))),
      );
      expect(find.text('Conteúdo'), findsOneWidget);
    });

    testWidgets('.raised() renders child', (tester) async {
      await tester.pumpWidget(
        _wrap(const MurdockCard.raised(child: Text('Conteúdo'))),
      );
      expect(find.text('Conteúdo'), findsOneWidget);
    });

    testWidgets('.elevated() renders child', (tester) async {
      await tester.pumpWidget(
        _wrap(const MurdockCard.elevated(child: Text('Conteúdo'))),
      );
      expect(find.text('Conteúdo'), findsOneWidget);
    });

    testWidgets('.floating() renders child', (tester) async {
      await tester.pumpWidget(
        _wrap(const MurdockCard.floating(child: Text('Conteúdo'))),
      );
      expect(find.text('Conteúdo'), findsOneWidget);
    });

    // ── Interaction ────────────────────────────────────────────────────────

    testWidgets('calls onPressed when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          MurdockCard.raised(
            onPressed: () => tapped = true,
            child: const Text('Toque aqui'),
          ),
        ),
      );
      await tester.tap(find.byType(MurdockCard));
      expect(tapped, isTrue);
    });

    testWidgets('does not call onPressed when null', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          MurdockCard.raised(onPressed: null, child: const Text('Estático')),
        ),
      );
      await tester.tap(find.byType(MurdockCard), warnIfMissed: false);
      expect(tapped, isFalse);
    });

    // ── Accessibility ──────────────────────────────────────────────────────

    testWidgets('has button semantics when onPressed is set', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MurdockCard.raised(
            onPressed: () {},
            semanticLabel: 'Abrir detalhes',
            child: const Text('Card'),
          ),
        ),
      );
      final semantics = tester.getSemantics(find.byType(MurdockCard));
      expect(semantics.hasFlag(SemanticsFlag.isButton), isTrue);
    });
  });
}
