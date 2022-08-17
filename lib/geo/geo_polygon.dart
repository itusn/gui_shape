import 'package:flutter/material.dart';
import 'geo_common.dart';
import 'geo_path.dart';
import 'geo_utility.dart';

/// The [GeoPolygon] class defines a n-sided polygon.
/// The class may be used to calculate coordinates and paths of a polygon.
class GeoPolygon {
  /// Number of sides in a polygon
  final int sides; // number of sides of a polygon

  /// Interior and internal angles of an n-sided regular polygon
  late final GeoAngle
      interiorAngle; // angle between adjacent vertices w/ origin at the center
  late final GeoAngle
      internalAngle; // angle between adjacent sides of a polygon

  /// Creates a new instance of [GeoPolygon] with n-sides
  GeoPolygon(this.sides) : assert(sides >= 3) {
    interiorAngle = GeoAngle(degree: 360 / sides);
    internalAngle = GeoAngle(degree: 180 - 360 / sides);
  }

  /// Get list of coordinates starting at angle [startAngle] inside a rectangle defined by [size].
  /// For regular polygon, make sure [size] defines a square with equal dimensions.
  /// Note: Depending on resolution, a rectangle may be defined to create the visual appearance of a regular polygon.
  /// Angle [startAngle] is defined as start from east direction, and moving counter-clockwise (towards north, west, then south)
  List<GeoCoordinate2D> getCoordinates(
      {required GeoAngle startAngle,
      bool clockwise = false,
      required Size size,
      BoxFit boxFit = BoxFit.none}) {
    GeoEllipse ellipse = GeoEllipse(size.width / 2, size.height / 2);
    List<GeoCoordinate2D> coords = <GeoCoordinate2D>[];
    double currentAngle = clockwise ? startAngle.radian : -startAngle.radian;

    bool hasBoxFit = (boxFit != BoxFit.none);
    GeoCoordinate2D? center = GeoCoordinate2D(size.width / 2, size.height / 2);
    for (int i = 0; i < sides; i++) {
      coords.add(ellipse.coordinateByRadian(currentAngle, center));
      currentAngle += clockwise ? interiorAngle.radian : -interiorAngle.radian;
    }
    if (hasBoxFit) {
      GeoUtility.scaleToFit(size, boxFit, coords, true, true);
      GeoUtility.recenter(
          GeoCoordinate2D(size.width / 2, size.height / 2), coords, true);
    }
    return coords;
  }

  /// Get [Path] for polygon transformed based on start angle [startAngle], size of drawing area,
  /// stretched based on [boxFit] with corners rounded with specified [cornerRadius].
  Path getPath(
      {required GeoAngle startAngle,
      bool clockwise = false,
      required Size size,
      BoxFit boxFit = BoxFit.none,
      double cornerRadius = 0}) {
    List<GeoCoordinate2D> coords = getCoordinates(
        startAngle: startAngle,
        clockwise: clockwise,
        size: size,
        boxFit: boxFit);
    GeoPath geopath = GeoPath(coords);
    return geopath.roundedPath(cornerRadius);
  }
}
