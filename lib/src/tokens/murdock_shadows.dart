import 'package:flutter/material.dart';

/// Semantic elevation/shadow tokens for Murdock UI.
///
/// Consumers declare the perceived depth of a surface using semantic names
/// instead of raw [BoxShadow] values.
abstract class MurdockShadows {
  MurdockShadows._();

  /// No elevation — flat surface.
  static const List<BoxShadow> none = [];

  /// Level 1 — subtle lift (cards at rest).
  static const List<BoxShadow> low = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 4, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x0F000000), blurRadius: 2, offset: Offset(0, 1)),
  ];

  /// Level 2 — medium elevation (dropdowns, popovers).
  static const List<BoxShadow> medium = [
    BoxShadow(color: Color(0x1F000000), blurRadius: 8, offset: Offset(0, 2)),
    BoxShadow(color: Color(0x14000000), blurRadius: 4, offset: Offset(0, 1)),
  ];

  /// Level 3 — strong elevation (modals, dialogs).
  static const List<BoxShadow> high = [
    BoxShadow(color: Color(0x29000000), blurRadius: 16, offset: Offset(0, 4)),
    BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 2)),
  ];
}
