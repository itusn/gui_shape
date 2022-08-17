import 'package:flutter/material.dart';
import 'geo_common.dart';
import 'geo_path.dart';
import 'geo_utility.dart';

/// The [GeoStar] class defines a star pattern with n-leaves.
/// The class may be used to calculate coordinates and paths of a polygon.
class GeoStar {
  final int sides; // number of sides of a polygon
  late final GeoAngle
      interiorAngle; // angle between adjacent vertices w/ origin at the center
  late final GeoAngle halfInteriorAngle; // half of interior angle
  late final GeoAngle
      internalAngle; // angle between adjacent sides of a polygon

  /// Creates a new instance of [GeoStar] with n-sides
  GeoStar(this.sides) : assert(sides >= 3) {
    interiorAngle = GeoAngle(degree: 360 / sides);
    halfInteriorAngle = GeoAngle(degree: 180 / sides);
    internalAngle = GeoAngle(degree: 180 - 360 / sides);
  }

  /// Get list of coordinates starting at angle [startAngle] inside a rectangle defined by [size].
  /// For regular n-sided star, make sure [size] defines a square with equal dimensions.
  /// Note: Depending on resolution, a rectangle may be defined to create the visual appearance of a regular polygon.
  /// Angle [startAngle] is defined as start from east direction, and moving counter-clockwise (towards north, west, then south)
  List<GeoCoordinate2D> getCoordinates(
      {required GeoAngle startAngle,
      bool clockwise = false,
      required Size size,
      double indentSideFactor = 0.5,
      BoxFit boxFit = BoxFit.none}) {
    GeoEllipse outerEllipse = GeoEllipse(size.width / 2, size.height / 2);
    indentSideFactor = indentSideFactor.clamp(0, 1);
    GeoEllipse innerEllipse = GeoEllipse(
        outerEllipse.xRadius * indentSideFactor,
        outerEllipse.yRadius * indentSideFactor);

    List<GeoCoordinate2D> coords = <GeoCoordinate2D>[];
    double currentAngle = clockwise ? startAngle.radian : -startAngle.radian;
    double currentInnerAngle = 0;

    bool hasBoxFit = (boxFit != BoxFit.none);
    for (int i = 0; i < sides; i++) {
      coords.add(outerEllipse.coordinateByRadian(currentAngle));
      currentInnerAngle = currentAngle +
          (clockwise ? -halfInteriorAngle.radian : halfInteriorAngle.radian);
      coords.add(innerEllipse.coordinateByRadian(currentInnerAngle));
      currentAngle += clockwise ? -interiorAngle.radian : interiorAngle.radian;
    }
    if (hasBoxFit) {
      GeoUtility.scaleToFit(size, boxFit, coords, true, true);
    }
    GeoUtility.recenter(
        GeoCoordinate2D(size.width / 2, size.height / 2), coords, true);
    return coords;
  }

  /// Get [Path] for star transformed based on start angle [startAngle], side indent factor [indentSideFactor],
  /// size of drawing area, stretched based on [boxFit] with corners rounded with specified [cornerRadius].
  Path getPath(
      {required GeoAngle startAngle,
      double indentSideFactor = 0.5,
      bool clockwise = false,
      required Size size,
      BoxFit boxFit = BoxFit.none,
      double cornerRadius = 0}) {
    List<GeoCoordinate2D> coords = getCoordinates(
        startAngle: startAngle,
        indentSideFactor: indentSideFactor,
        clockwise: clockwise,
        size: size,
        boxFit: boxFit);
    GeoPath geopath = GeoPath(coords);
    return geopath.roundedPath(cornerRadius);
  }
}
