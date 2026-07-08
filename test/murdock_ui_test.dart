import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:murdock_ui/murdock_ui.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

/// Wraps [child] with the minimum tree required by [MurdockButton]:
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
}
