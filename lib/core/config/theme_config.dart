// lib/core/theme_config.dart
import 'package:flutter/material.dart';

class ThemeConfig {
  static const chartColors = [
    Color(0xFF5470C6),
    Color(0xFF91CC75),
    Color(0xFFFAC858),
    Color(0xFFEE6666),
    Color(0xFF73C0DE),
    Color(0xFF3BA272),
    Color(0xFFFC8452),
    Color(0xFF9A60B4),
    Color(0xFFEA7CCC),
  ];

  static const cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(8)),
    boxShadow: [
      BoxShadow(
        color: Color(0x1A000000),
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  );

  static const chartPadding = EdgeInsets.all(16);

  static const dropTargetDecoration = BoxDecoration(
    color: Color(0xFFF5F5F5),
    borderRadius: BorderRadius.all(Radius.circular(8)),
    border: Border.fromBorderSide(
      BorderSide(
        color: Color(0xFFE0E0E0),
        width: 1,
      ),
    ),
  );
}