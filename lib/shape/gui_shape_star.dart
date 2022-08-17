import 'dart:ui';

import 'package:flutter/material.dart';
import '../geo/geo.dart';
import '../shape/i_gui_shape.dart';

/// The [GuiShapeStar] class defines a star's properties.
class GuiShapeStar implements IGuiShape {
  /// Number of points or sides of a star
  final int sides;

  /// Starting angle of star
  final GeoAngle startAngle;

  /// Direction of rotation
  final bool clockwise;

  /// Resize custom shape to fit rendering area.
  final BoxFit boxFit;

  /// Radius of smoothing or curving corners of the shape.
  final double cornerRadius;

  /// A number ranging from 0 to 1.0 defining how much indentation on the sides to produce the inner
  /// corner of the star.  A value of 0 means inner corner is at center.  A value of 1 means inner corner
  /// is closer to the outer side and makes the star look more like a circle.
  /// Default is 0.5 (half-way between center and outer edge)
  final double indentSideFactor;

  /// Class that generates coordinates for a star
  late final GeoStar _shape;

  GuiShapeStar(
      {required this.sides,
      required this.startAngle,
      this.indentSideFactor = 0.5,
      this.clockwise = false,
      this.boxFit = BoxFit.none,
      this.cornerRadius = 0}) {
    _shape = GeoStar(sides);
  }

  /// Retrieve [Path] of shape
  @override
  Path getPath({required Size size}) {
    return _shape.getPath(
        startAngle: startAngle,
        clockwise: clockwise,
        indentSideFactor: indentSideFactor,
        size: size,
        boxFit: boxFit,
        cornerRadius: cornerRadius);
  }

  /// Linearly interpolate from other [shape] to this shape by an extrapolation factor `t`.
  @override
  IGuiShape lerpFrom(IGuiShape shape, double t) {
    if (shape is GuiShapeStar) {
      return GuiShapeStar(
          sides: lerpDouble(shape.sides, sides, t)!.toInt(),
          startAngle: GeoAngle(
              radian:
                  lerpDouble(shape.startAngle.radian, startAngle.radian, t)),
          indentSideFactor:
              lerpDouble(shape.indentSideFactor, indentSideFactor, t)!,
          clockwise: clockwise,
          boxFit: boxFit,
          cornerRadius: lerpDouble(shape.cornerRadius, cornerRadius, t)!);
    } else {
      return GuiShapeStar(
          sides: sides,
          startAngle: startAngle,
          indentSideFactor: indentSideFactor,
          clockwise: clockwise,
          boxFit: boxFit,
          cornerRadius: cornerRadius);
    }
  }

  /// Linearly interpolate from this shape to other [shape] by an extrapolation factor `t`.
  @override
  IGuiShape lerpTo(IGuiShape shape, double t) {
    if (shape is GuiShapeStar) {
      return GuiShapeStar(
          sides: lerpDouble(sides, shape.sides, t)!.toInt(),
          startAngle: GeoAngle(
              radian:
                  lerpDouble(startAngle.radian, shape.startAngle.radian, t)),
          indentSideFactor:
              lerpDouble(indentSideFactor, shape.indentSideFactor, t)!,
          clockwise: clockwise,
          boxFit: boxFit,
          cornerRadius: lerpDouble(cornerRadius, shape.cornerRadius, t)!);
    } else {
      return GuiShapeStar(
          sides: sides,
          startAngle: startAngle,
          indentSideFactor: indentSideFactor,
          clockwise: clockwise,
          boxFit: boxFit,
          cornerRadius: cornerRadius);
    }
  }
}
