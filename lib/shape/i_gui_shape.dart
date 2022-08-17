import 'package:flutter/material.dart';

/// Interface for defining custom shape
abstract class IGuiShape {
  /// Retrieve [Path] of shape
  Path getPath({required Size size});

  /// Linearly interpolate from other [shape] to this shape by an extrapolation factor `t`.
  IGuiShape lerpFrom(IGuiShape shape, double t);

  /// Linearly interpolate from this shape to other [shape] by an extrapolation factor `t`.
  IGuiShape lerpTo(IGuiShape shape, double t);
}
