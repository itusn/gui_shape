import 'dart:ui';

import 'package:flutter/material.dart';
import '../geo/geo.dart';
import '../shape/i_gui_shape.dart';

/// The [GuiShapeCustom] class defines a custom shape defined by a set of points connected in sequence.
class GuiShapeCustom implements IGuiShape {
  /// A list of points defined by (x,y) where (0,0) is top left corner, and (n,m) are coordinates to the right and down.
  final List<GeoCoordinate2D> points;

  /// Angle of rotation.  During rendering, the [points] will be rotated by the angle of rotation [rotate].
  final GeoAngle rotate;

  /// Direction of rotation
  final bool clockwise;

  /// Resize custom shape to fit rendering area.
  final BoxFit boxFit;

  /// Radius of smoothing or curving corners of the shape.
  final double cornerRadius;

  /// Structure to hold user-defined custom points
  late final GeoCustomPoints _custom;

  GuiShapeCustom(
      {required this.points,
      required this.rotate,
      this.clockwise = false,
      this.boxFit = BoxFit.none,
      this.cornerRadius = 0}) {
    _custom = GeoCustomPoints(points);
  }

  /// Retrieve [Path] of shape
  @override
  Path getPath({required Size size}) {
    return _custom.getPath(
        rotate: rotate,
        clockwise: clockwise,
        size: size,
        boxFit: boxFit,
        cornerRadius: cornerRadius);
  }

  /// Linearly interpolate from other [shape] to this shape by an extrapolation factor `t`.
  @override
  IGuiShape lerpFrom(IGuiShape shape, double t) {
    if (shape is GuiShapeCustom) {
      return GuiShapeCustom(
          points: _lerp(shape.points, points, t),
          rotate: GeoAngle(
              radian: lerpDouble(shape.rotate.radian, rotate.radian, t)),
          clockwise: clockwise,
          boxFit: boxFit,
          cornerRadius: lerpDouble(shape.cornerRadius, cornerRadius, t)!);
    } else {
      return GuiShapeCustom(
          points: points,
          rotate: rotate,
          clockwise: clockwise,
          boxFit: boxFit,
          cornerRadius: cornerRadius);
    }
  }

  /// Linearly interpolate from this shape to other [shape] by an extrapolation factor `t`.
  @override
  IGuiShape lerpTo(IGuiShape shape, double t) {
    if (shape is GuiShapeCustom) {
      return GuiShapeCustom(
          points: _lerp(points, shape.points, t),
          rotate: GeoAngle(
              radian: lerpDouble(rotate.radian, shape.rotate.radian, t)),
          clockwise: clockwise,
          boxFit: boxFit,
          cornerRadius: lerpDouble(cornerRadius, shape.cornerRadius, t)!);
    } else {
      return GuiShapeCustom(
          points: points,
          rotate: rotate,
          clockwise: clockwise,
          boxFit: boxFit,
          cornerRadius: cornerRadius);
    }
  }

  /// Linearly interpolate from [from] shape to [to] shape by an extrapolation factor `t`.
  /// The dimensions of from and to must be the same, other [to] is returned
  static List<GeoCoordinate2D> _lerp(
      List<GeoCoordinate2D> from, List<GeoCoordinate2D> to, double t) {
    if (from.length == to.length) {
      // only if the lengths match
      List<GeoCoordinate2D> olist = <GeoCoordinate2D>[];
      for (int i = 0; i < from.length; i++) {
        olist.add(from[i].lerpTo2D(to[i], t));
      }
      return olist;
    } else {
      // else return destination array
      return to;
    }
  }
}
