import 'package:flutter/material.dart';

/// Semantic color tokens for Murdock UI.
///
/// Colors are organized by intent, not by visual appearance.
/// Consumers must never use raw hex values — always reference a token.
abstract class MurdockColors {
  MurdockColors._();

  // ── Primary ────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF1A73E8);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFD2E3FC);
  static const Color onPrimaryContainer = Color(0xFF041E49);

  // ── Success ────────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF1E8E3E);
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color successContainer = Color(0xFFC6F6D5);
  static const Color onSuccessContainer = Color(0xFF0A3622);

  // ── Danger ─────────────────────────────────────────────────────────────────
  static const Color danger = Color(0xFFD93025);
  static const Color onDanger = Color(0xFFFFFFFF);
  static const Color dangerContainer = Color(0xFFFCE8E6);
  static const Color onDangerContainer = Color(0xFF410E0B);

  // ── Warning ────────────────────────────────────────────────────────────────
  static const Color warning = Color(0xFFF9AB00);
  static const Color onWarning = Color(0xFF202124);
  static const Color warningContainer = Color(0xFFFEF9C3);
  static const Color onWarningContainer = Color(0xFF3E2A00);

  // ── Neutral ────────────────────────────────────────────────────────────────
  static const Color neutral = Color(0xFF5F6368);
  static const Color onNeutral = Color(0xFFFFFFFF);
  static const Color neutralContainer = Color(0xFFF1F3F4);
  static const Color onNeutralContainer = Color(0xFF202124);

  // ── Surface ────────────────────────────────────────────────────────────────
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF202124);
  static const Color surfaceVariant = Color(0xFFF1F3F4);
  static const Color outline = Color(0xFFDADCE0);
  static const Color outlineVariant = Color(0xFFEEEEEE);
}
