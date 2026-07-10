import 'dart:async';

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

    // ── onPressedAsync ─────────────────────────────────────────────────────

    testWidgets('shows spinner automatically during onPressedAsync', (
      tester,
    ) async {
      final completer = Completer<void>();
      await tester.pumpWidget(
        _wrap(
          MurdockButton.primary(
            label: 'Salvar',
            onPressedAsync: () => completer.future,
          ),
        ),
      );

      // Tap — future is still pending
      await tester.tap(find.byType(MurdockButton));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete the future — spinner should disappear
      completer.complete();
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('prevents double-tap while onPressedAsync is running', (
      tester,
    ) async {
      var callCount = 0;
      final completer = Completer<void>();
      await tester.pumpWidget(
        _wrap(
          MurdockButton.primary(
            label: 'Salvar',
            onPressedAsync: () async {
              callCount++;
              await completer.future;
            },
          ),
        ),
      );

      await tester.tap(find.byType(MurdockButton));
      await tester.pump();
      await tester.tap(find.byType(MurdockButton), warnIfMissed: false);
      await tester.pump();

      expect(callCount, 1); // Second tap is ignored
      completer.complete();
      await tester.pumpAndSettle();
    });

    // ── semanticLabel ──────────────────────────────────────────────────────

    testWidgets('announces semanticLabel to screen readers when provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          MurdockButton.danger(
            label: 'Excluir',
            semanticLabel: 'Excluir produto Camiseta Azul',
            onPressed: () {},
          ),
        ),
      );
      expect(
        find.bySemanticsLabel('Excluir produto Camiseta Azul'),
        findsOneWidget,
      );
    });

    testWidgets('falls back to label when semanticLabel is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(MurdockButton.primary(label: 'Confirmar', onPressed: () {})),
      );
      expect(find.bySemanticsLabel('Confirmar'), findsOneWidget);
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

    testWidgets('renders errorText immediately when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MurdockTextField.outlined(
            label: 'E-mail',
            errorText: 'E-mail inválido',
          ),
        ),
      );
      expect(find.text('E-mail inválido'), findsOneWidget);
    });

    testWidgets('does not render errorText when null', (tester) async {
      await tester.pumpWidget(
        _wrap(const MurdockTextField.outlined(label: 'E-mail')),
      );
      expect(find.text('E-mail inválido'), findsNothing);
    });

    testWidgets('renders helper text when no error is active', (tester) async {
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

    // ── Validation ─────────────────────────────────────────────────────────

    testWidgets('shows validator error after submit with invalid input', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          MurdockTextField.outlined(
            label: 'E-mail',
            validator: (v) =>
                v?.contains('@') == true ? null : 'E-mail inválido',
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'nao-é-email');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(find.text('E-mail inválido'), findsOneWidget);
    });

    testWidgets('clears validator error after submit with valid input', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          MurdockTextField.outlined(
            label: 'E-mail',
            validator: (v) =>
                v?.contains('@') == true ? null : 'E-mail inválido',
          ),
        ),
      );

      // Submit invalid — error appears
      await tester.enterText(find.byType(TextField), 'invalido');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(find.text('E-mail inválido'), findsOneWidget);

      // Submit valid — error clears
      await tester.enterText(find.byType(TextField), 'ok@ok.com');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(find.text('E-mail inválido'), findsNothing);
    });

    testWidgets('validates on change when validateOnChange is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          MurdockTextField.outlined(
            label: 'Campo',
            validateOnChange: true,
            validator: (v) => (v?.isEmpty ?? true) ? 'Obrigatório' : null,
          ),
        ),
      );

      // Type nothing meaningful — still triggers onChange with ''
      await tester.enterText(find.byType(TextField), '');
      await tester.pump();
      // No error yet because enterText fires with the whole string at once;
      // type a char then clear to force empty change
      await tester.enterText(find.byType(TextField), 'x');
      await tester.pump();
      expect(find.text('Obrigatório'), findsNothing); // 'x' is valid

      await tester.enterText(find.byType(TextField), '');
      await tester.pump();
      expect(find.text('Obrigatório'), findsOneWidget);
    });

    testWidgets('external errorText overrides validator success', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          MurdockTextField.outlined(
            label: 'E-mail',
            errorText: 'Erro do servidor',
            validator: (v) => null, // always valid
          ),
        ),
      );
      expect(find.text('Erro do servidor'), findsOneWidget);
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

    // ── Semantic constructors ──────────────────────────────────────────────

    testWidgets('.email() renders with email icon', (tester) async {
      await tester.pumpWidget(_wrap(MurdockTextField.email()));
      expect(find.byIcon(Icons.alternate_email), findsOneWidget);
    });

    testWidgets('.email() shows built-in error for invalid email on submit', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(MurdockTextField.email()));
      await tester.enterText(find.byType(TextField), 'nao-e-email');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(find.text('E-mail inválido'), findsOneWidget);
    });

    testWidgets('.email() passes for valid email', (tester) async {
      await tester.pumpWidget(_wrap(MurdockTextField.email()));
      await tester.enterText(find.byType(TextField), 'ok@ok.com');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(find.text('E-mail inválido'), findsNothing);
    });

    testWidgets('.email() custom validator overrides built-in', (tester) async {
      await tester.pumpWidget(
        _wrap(MurdockTextField.email(validator: (_) => 'Erro customizado')),
      );
      await tester.enterText(find.byType(TextField), 'ok@ok.com');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(find.text('Erro customizado'), findsOneWidget);
    });

    testWidgets('.password() obscures text', (tester) async {
      await tester.pumpWidget(_wrap(MurdockTextField.password()));
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.obscureText, isTrue);
    });

    testWidgets('.password() renders with lock icon', (tester) async {
      await tester.pumpWidget(_wrap(MurdockTextField.password()));
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('.phone() renders with phone icon', (tester) async {
      await tester.pumpWidget(_wrap(MurdockTextField.phone()));
      expect(find.byIcon(Icons.phone_outlined), findsOneWidget);
    });

    testWidgets('.phone() shows error when digits are too few', (tester) async {
      await tester.pumpWidget(_wrap(MurdockTextField.phone()));
      await tester.enterText(find.byType(TextField), '123');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(find.text('Telefone incompleto'), findsOneWidget);
    });

    testWidgets('.number() accepts only digits', (tester) async {
      await tester.pumpWidget(_wrap(MurdockTextField.number(label: 'Qtd')));
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.keyboardType, TextInputType.number);
      expect(field.inputFormatters, isNotNull);
    });

    testWidgets('.name() renders with person icon', (tester) async {
      await tester.pumpWidget(_wrap(MurdockTextField.name()));
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('.search() renders with search icon', (tester) async {
      await tester.pumpWidget(_wrap(MurdockTextField.search()));
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('.cpf() renders with badge icon', (tester) async {
      await tester.pumpWidget(_wrap(MurdockTextField.cpf()));
      expect(find.byIcon(Icons.badge_outlined), findsOneWidget);
    });

    testWidgets('.cpf() shows error for invalid CPF', (tester) async {
      await tester.pumpWidget(_wrap(MurdockTextField.cpf()));
      await tester.enterText(find.byType(TextField), '000.000.000-00');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(find.text('CPF inválido'), findsOneWidget);
    });

    testWidgets('.cpf() passes for valid CPF', (tester) async {
      await tester.pumpWidget(_wrap(MurdockTextField.cpf()));
      // CPF válido: 529.982.247-25
      await tester.enterText(find.byType(TextField), '529.982.247-25');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(find.text('CPF inválido'), findsNothing);
      expect(find.text('CPF incompleto'), findsNothing);
    });

    testWidgets('.url() shows error for invalid URL', (tester) async {
      await tester.pumpWidget(_wrap(MurdockTextField.url()));
      await tester.enterText(find.byType(TextField), 'nao-e-url');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(find.text('URL inválida'), findsOneWidget);
    });

    testWidgets('.multiline() allows unlimited lines', (tester) async {
      await tester.pumpWidget(
        _wrap(MurdockTextField.multiline(label: 'Comentário')),
      );
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.maxLines, isNull);
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

    // ── onPrimary / onSuccess / onDanger / onWarning colors ────────────────

    testWidgets('onPrimary color resolves without error', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MurdockText.label('NOVO', color: MurdockTextColor.onPrimary),
        ),
      );
      expect(find.text('NOVO'), findsOneWidget);
    });

    testWidgets('onSuccess color resolves without error', (tester) async {
      await tester.pumpWidget(
        _wrap(const MurdockText.label('OK', color: MurdockTextColor.onSuccess)),
      );
      expect(find.text('OK'), findsOneWidget);
    });

    testWidgets('onDanger color resolves without error', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MurdockText.label('ERRO', color: MurdockTextColor.onDanger),
        ),
      );
      expect(find.text('ERRO'), findsOneWidget);
    });

    testWidgets('onWarning color resolves without error', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MurdockText.label('AVISO', color: MurdockTextColor.onWarning),
        ),
      );
      expect(find.text('AVISO'), findsOneWidget);
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

    testWidgets(
      'exposes semanticLabel on static card via Semantics container',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            MurdockCard.raised(
              semanticLabel: 'Produto: Camiseta Azul',
              child: const Text('Camiseta Azul'),
            ),
          ),
        );
        final card = tester.widget<MurdockCard>(find.byType(MurdockCard));
        expect(card.semanticLabel, 'Produto: Camiseta Azul');
        // Semantics container wraps the card when label is set
        expect(find.byType(Semantics), findsWidgets);
      },
    );

    testWidgets('no semanticLabel field when not provided', (tester) async {
      await tester.pumpWidget(
        _wrap(MurdockCard.raised(child: const Text('Sem label'))),
      );
      final card = tester.widget<MurdockCard>(find.byType(MurdockCard));
      expect(card.semanticLabel, isNull);
    });
  });

  // ── MurdockRow ─────────────────────────────────────────────────────────────

  group('MurdockRow', () {
    testWidgets('renders all children', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MurdockRow(
            children: [const Text('A'), const Text('B'), const Text('C')],
          ),
        ),
      );
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
    });

    testWidgets('inserts gap widgets between children', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MurdockRow(
            gap: MurdockSpacing.small,
            children: [const Text('X'), const Text('Y')],
          ),
        ),
      );
      // 1 SizedBox gap between 2 children
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('no gap widget for single child', (tester) async {
      await tester.pumpWidget(
        _wrap(MurdockRow(children: [const Text('Solo')])),
      );
      expect(find.byType(SizedBox), findsNothing);
    });

    testWidgets('wraps children in Flexible when expand is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: 300,
            child: MurdockRow(
              expand: true,
              children: [const Text('A'), const Text('B')],
            ),
          ),
        ),
      );
      expect(find.byType(Flexible), findsNWidgets(2));
    });

    testWidgets('does not wrap children in Flexible when expand is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(MurdockRow(children: [const Text('A'), const Text('B')])),
      );
      expect(find.byType(Flexible), findsNothing);
    });
  });

  // ── MurdockColumn ──────────────────────────────────────────────────────────

  group('MurdockColumn', () {
    testWidgets('renders all children', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MurdockColumn(
            children: [const Text('A'), const Text('B'), const Text('C')],
          ),
        ),
      );
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
    });

    testWidgets('inserts gap widgets between children', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MurdockColumn(
            gap: MurdockSpacing.large,
            children: [const Text('X'), const Text('Y')],
          ),
        ),
      );
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('wraps children in Flexible when expand is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            height: 300,
            child: MurdockColumn(
              expand: true,
              children: [const Text('A'), const Text('B')],
            ),
          ),
        ),
      );
      expect(find.byType(Flexible), findsNWidgets(2));
    });

    testWidgets('does not wrap children in Flexible when expand is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(MurdockColumn(children: [const Text('A'), const Text('B')])),
      );
      expect(find.byType(Flexible), findsNothing);
    });
  });

  // ── MurdockExpanded ────────────────────────────────────────────────────────

  group('MurdockExpanded', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: 200,
            child: Row(
              children: [MurdockExpanded(child: const Text('Conteúdo'))],
            ),
          ),
        ),
      );
      expect(find.text('Conteúdo'), findsOneWidget);
    });

    testWidgets('applies weight as flex factor', (tester) async {
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: 300,
            child: Row(
              children: [
                MurdockExpanded(weight: 2, child: const Text('Maior')),
                MurdockExpanded(weight: 1, child: const Text('Menor')),
              ],
            ),
          ),
        ),
      );
      final flexWidgets = tester.widgetList<Flexible>(find.byType(Flexible));
      final weights = flexWidgets.map((f) => f.flex).toList();
      expect(weights, containsAll([2, 1]));
    });
  });
}
