import 'dart:ui';

import 'package:flutter/material.dart';
import '../geo/geo.dart';
import '../shape/i_gui_shape.dart';

/// The [GuiShapePolygon] class defines a polygon's properties.
class GuiShapePolygon implements IGuiShape {
  /// Number of sides of a polygon
  final int sides;

  /// Starting angle of polygon
  final GeoAngle startAngle;

  /// Direction of rotation
  final bool clockwise;

  /// Resize custom shape to fit rendering area.
  final BoxFit boxFit;

  /// Radius of smoothing or curving corners of the shape.
  final double cornerRadius;

  /// Class that generates coordinates for a polygon
  late final GeoPolygon _polygon;

  GuiShapePolygon(
      {required this.sides,
      required this.startAngle,
      this.clockwise = false,
      this.boxFit = BoxFit.none,
      this.cornerRadius = 0}) {
    _polygon = GeoPolygon(sides);
  }

  /// Retrieve [Path] of shape
  @override
  Path getPath({required Size size}) {
    return _polygon.getPath(
        startAngle: startAngle,
        clockwise: clockwise,
        size: size,
        boxFit: boxFit,
        cornerRadius: cornerRadius);
  }

  /// Linearly interpolate from other [shape] to this shape by an extrapolation factor `t`.
  @override
  IGuiShape lerpFrom(IGuiShape shape, double t) {
    if (shape is GuiShapePolygon) {
      return GuiShapePolygon(
          sides: lerpDouble(shape.sides, sides, t)!.toInt(),
          startAngle: GeoAngle(
              radian:
                  lerpDouble(shape.startAngle.radian, startAngle.radian, t)),
          clockwise: clockwise,
          boxFit: boxFit,
          cornerRadius: lerpDouble(shape.cornerRadius, cornerRadius, t)!);
    } else {
      return GuiShapePolygon(
          sides: sides,
          startAngle: startAngle,
          clockwise: clockwise,
          boxFit: boxFit,
          cornerRadius: cornerRadius);
    }
  }

  /// Linearly interpolate from this shape to other [shape] by an extrapolation factor `t`.
  @override
  IGuiShape lerpTo(IGuiShape shape, double t) {
    if (shape is GuiShapePolygon) {
      return GuiShapePolygon(
          sides: lerpDouble(sides, shape.sides, t)!.toInt(),
          startAngle: GeoAngle(
              radian:
                  lerpDouble(startAngle.radian, shape.startAngle.radian, t)),
          clockwise: clockwise,
          boxFit: boxFit,
          cornerRadius: lerpDouble(cornerRadius, shape.cornerRadius, t)!);
    } else {
      return GuiShapePolygon(
          sides: sides,
          startAngle: startAngle,
          clockwise: clockwise,
          boxFit: boxFit,
          cornerRadius: cornerRadius);
    }
  }
}
