import 'package:flutter/material.dart';
import 'geo_common.dart';
import 'geo_path.dart';
import 'geo_utility.dart';

/// The [GeoCustomPoints] class defines a custom user-defined shape.
class GeoCustomPoints {
  final List<GeoCoordinate2D> points;                    // points in a custom shape

  /// Creates a new instance of [GeoPolygon] with n-sides
  GeoCustomPoints(this.points);

  /// Get list of coordinates rotated by angle [rotate] inside a rectangle defined by [size].
  /// The coordinate are scaled to fit if [boxFit] is defined.
  /// Note: Depending on resolution, a rectangle may be defined to create the visual appearance of a regular polygon.
  /// Angle [startAngle] is defined as start from east direction, and moving counter-clockwise (towards north, west, then south)
  List<GeoCoordinate2D> getCoordinates({required GeoAngle rotate, bool clockwise = false, required Size size, BoxFit boxFit = BoxFit.none}) {
    GeoCoordinate2D center = GeoCoordinate2D(size.width/2, size.height/2);
    List<GeoCoordinate2D> coords = <GeoCoordinate2D>[];
    for (int i = 0; i < points.length; i++) {
      coords.add(points[i].rotate(clockwise? rotate : -rotate,center));
    }

    bool hasBoxFit = (boxFit != BoxFit.none);
    if (hasBoxFit) {
      GeoUtility.scaleToFit(size, boxFit, coords, true, true);
      GeoUtility.recenter(GeoCoordinate2D(size.width/2, size.height/2), coords, true);
    }
    return coords;
  }

  /// Get Path based on coordinates defined and transformed based on rotation angle [rotate], size of drawing area,
  /// stretched based on [boxFit] with corners rounded with specified [cornerRadius].
  Path getPath({required GeoAngle rotate, bool clockwise = false, required Size size, BoxFit boxFit = BoxFit.none, double cornerRadius = 0}) {
    List<GeoCoordinate2D> coords = getCoordinates(rotate: rotate, clockwise: clockwise, size: size, boxFit: boxFit);
    GeoPath geopath = GeoPath(coords);
    return geopath.roundedPath(cornerRadius);
  }

}