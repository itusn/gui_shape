import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import '../geo/geo.dart';
import '../shape/i_gui_shape.dart';

/// A callback function for calculating amplitude at an angle in a polar function
typedef GuiPolarFunction = double Function(GeoAngle angle);

/// The [GuiShapePolar] class defines a polar graph's properties.
class GuiShapePolar implements IGuiShape {
  /// A formula that takes [angle] and returns a amplitude factor (usually between -1.0 and 1.0).
  /// If values less than -1.0 or greater than 1.0 are returned, then shape may go beyond the
  /// rendering region.  To ensure that it fits in the rendering region, set boxFit to BoxFit.fill
  /// to resize resulting shape within the rendering region.
  final GuiPolarFunction formula;

  /// # of sampling for polar chart (equates to # of times formula is called between 0 and 2pi.  Default = 64
  final int sampling;

  /// Starting angle of polygon
  final GeoAngle startAngle;

  /// Direction of rotation
  final bool clockwise;

  /// Resize custom shape to fit rendering area.
  final BoxFit boxFit;

  /// Radius of smoothing or curving corners of the shape.
  final double cornerRadius;

  /// Start polar sweep at angle (default: 0)
  final double polarBeginAngle;

  /// End polar sweep at angle (default: 2pi)
  final double polarEndAngle;

  GuiShapePolar(
      {required this.formula,
      this.sampling = 64,
      required this.startAngle,
      this.clockwise = false,
      this.boxFit = BoxFit.none,
      this.cornerRadius = 0,
      this.polarBeginAngle = 0.0,
      this.polarEndAngle = 2 * pi});

  /// Retrieve [Path] of shape
  @override
  Path getPath({required Size size}) {
    return GeoCustomPoints(getCoordinates(size: size)).getPath(
        rotate: GeoAngle.zero,
        clockwise: clockwise,
        size: size,
        boxFit: boxFit,
        cornerRadius: cornerRadius);
  }

  /// generate coordinate for polar chart based on rectangular region.  An ellipse is used to distort the
  /// polar chart to resemble the shape of the region.  For a more circular look, the size width and height
  /// should be the same.
  List<GeoCoordinate2D> getCoordinates({required Size size}) {
    GeoAngle samplingAngle =
        GeoAngle(radian: (polarEndAngle - polarBeginAngle) / sampling);
    GeoEllipse ellipse = GeoEllipse(size.width / 2, size.height / 2);
    List<GeoCoordinate2D> coords = <GeoCoordinate2D>[];
    GeoAngle polarAngle = GeoAngle(radian: polarBeginAngle);
    double currentAngle = clockwise ? startAngle.radian : -startAngle.radian;

    bool hasBoxFit = (boxFit != BoxFit.none);
    GeoCoordinate2D? center = GeoCoordinate2D(size.width / 2, size.height / 2);
    for (int i = 0; i < sampling; i++) {
      coords.add(ellipse.coordinateByRadian(
          currentAngle, center, formula(polarAngle)));
      currentAngle += clockwise ? samplingAngle.radian : -samplingAngle.radian;
      polarAngle += samplingAngle;
    }
    if (hasBoxFit) {
      GeoUtility.scaleToFit(size, boxFit, coords, true, true);
      GeoUtility.recenter(
          GeoCoordinate2D(size.width / 2, size.height / 2), coords, true);
    }
    return coords;
  }

  /// Linearly interpolate from other [shape] to this shape by an extrapolation factor `t`.
  @override
  IGuiShape lerpFrom(IGuiShape shape, double t) {
    if (shape is GuiShapePolar) {
      return GuiShapePolar(
          formula: formula,
          sampling: lerpDouble(shape.sampling, sampling, t)!.toInt(),
          startAngle: GeoAngle(
              radian:
                  lerpDouble(shape.startAngle.radian, startAngle.radian, t)),
          clockwise: clockwise,
          boxFit: boxFit,
          cornerRadius: lerpDouble(shape.cornerRadius, cornerRadius, t)!);
    } else {
      return GuiShapePolar(
          formula: formula,
          sampling: sampling,
          startAngle: startAngle,
          clockwise: clockwise,
          boxFit: boxFit,
          cornerRadius: cornerRadius);
    }
  }

  /// Linearly interpolate from this shape to other [shape] by an extrapolation factor `t`.
  @override
  IGuiShape lerpTo(IGuiShape shape, double t) {
    if (shape is GuiShapePolar) {
      return GuiShapePolar(
          formula: formula,
          sampling: lerpDouble(sampling, shape.sampling, t)!.toInt(),
          startAngle: GeoAngle(
              radian:
                  lerpDouble(startAngle.radian, shape.startAngle.radian, t)),
          clockwise: clockwise,
          boxFit: boxFit,
          cornerRadius: lerpDouble(cornerRadius, shape.cornerRadius, t)!);
    } else {
      return GuiShapePolar(
          formula: formula,
          sampling: sampling,
          startAngle: startAngle,
          clockwise: clockwise,
          boxFit: boxFit,
          cornerRadius: cornerRadius);
    }
  }
}
