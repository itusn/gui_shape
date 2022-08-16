import 'package:flutter/material.dart';

/// Specification of a shadow consisting of [color] and [elevation].
class GuiShadow {
  final Color color;
  final double elevation;

  /// Define a shadow with [color] and [elevation].
  const GuiShadow({
    required this.color,
    required this.elevation,
  });
}