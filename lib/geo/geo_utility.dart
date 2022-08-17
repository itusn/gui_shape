import 'dart:math';
import 'package:flutter/material.dart';
import 'geo_common.dart';

/// The [GeoUtility] class is used for performing various transformations on coordinates (ie. re-centering, shifting, scaling, etc.).
class GeoUtility {

  /// Convert a 2-dimensional coordinate to Offset
  static toOffset(GeoCoordinate2D coord) => Offset(coord.x, coord.y);

  /// Convert a 2-dimensional coordinate array in Offset array
  static toOffsetList(List<GeoCoordinate2D> coords) => coords.map((coord) => Offset(coord.x, coord.y)).toList();

  /// Center the coordinates defined in [coords] based on new [center] (or origin).
  /// If [bInPlace] is true, the [coords] array values will be updated, otherwise a new coordinate array will be returned.
  static List<GeoCoordinate2D> recenter(GeoCoordinate2D center, List<GeoCoordinate2D> coords, [bool bInPlace = false]) {
    if (bInPlace) {
      for (GeoCoordinate2D coord in coords) {
        coord.x = center.x + coord.x;
        coord.y = center.y + coord.y;
      }
      return coords;
    } else {
      List<GeoCoordinate2D> newcoords = <GeoCoordinate2D>[];
      for (GeoCoordinate2D coord in coords) {
        newcoords.add(GeoCoordinate2D(center.x + coord.x, center.y + coord.y));
      }
      return newcoords;
    }
  }

  /// Shift coordinates to a new origin by subtracting each coordinates (x,y) with the new origin.
  /// If [bInPlace] is true, the [coords] array values will be updated, otherwise a new coordinate array will be returned.
  static List<GeoCoordinate2D> neworigin(GeoCoordinate2D origin, List<GeoCoordinate2D> coords, [bool bInPlace = false]) {
    if (bInPlace) {
      for (GeoCoordinate2D coord in coords) {
        coord.x = coord.x - origin.x;
        coord.y = coord.y - origin.y;
      }
      return coords;
    } else {
      List<GeoCoordinate2D> newcoords = <GeoCoordinate2D>[];
      for (GeoCoordinate2D coord in coords) {
        newcoords.add(GeoCoordinate2D(coord.x - origin.x, coord.y - origin.y));
      }
      return newcoords;
    }
  }

  /// Adjust coordinates [coords] within rectangle defined by dimensions [size] such that it meets [boxFit] criteria.
  /// If [bInPlace] is true, the [coords] array values will be updated, otherwise a new coordinate array will be returned.
  static List<GeoCoordinate2D> scaleToFit(Size size, BoxFit boxFit, List<GeoCoordinate2D> coords, [bool bRecenter = false, bool bInPlace = false]) {
    double sizeX = size.width / 2;
    double sizeY = size.height / 2;
    double minX = double.infinity, maxX = double.negativeInfinity, minY = double.infinity, maxY = double.negativeInfinity;
    for (int i = 0; i < coords.length; i++) {
      GeoCoordinate2D coord = coords[i];
      if (coord.x < minX) minX = coord.x;
      if (coord.x > maxX) maxX = coord.x;
      if (coord.y < minY) minY = coord.y;
      if (coord.y > maxY) maxY = coord.y;
    }
    if (bRecenter) {
      GeoCoordinate2D newOrigin = GeoCoordinate2D((maxX+minX)/2,(maxY+minY)/2);
      coords = neworigin(newOrigin, coords, bInPlace);
      // readjust minX/Y, an maxX/Y
      maxX = maxX - newOrigin.x;
      maxY = maxY - newOrigin.y;
      minX = minX - newOrigin.x;
      minY = minY - newOrigin.y;
    }

    double scaleX = 1.0, scaleY = 1.0;
    if (boxFit == BoxFit.fitWidth) {
      scaleX = sizeX / max(maxX.abs(), minX.abs());
    } else if (boxFit == BoxFit.fitHeight) {
      scaleY = sizeY / max(maxY.abs(), minY.abs());
    } else {
      scaleX = sizeX / max(maxX.abs(), minX.abs());
      scaleY = sizeY / max(maxY.abs(), minY.abs());
    }

    List<GeoCoordinate2D> retcoords = bInPlace? coords : <GeoCoordinate2D>[];
    if (bInPlace) {
      for (GeoCoordinate2D coord in coords) {
        coord.x *= scaleX;
        coord.y *= scaleY;
      }
    } else {
      for (GeoCoordinate2D coord in coords) {
        retcoords.add(GeoCoordinate2D(coord.x * scaleX, coord.y * scaleY));
      }
    }
    return retcoords;
  }


  /// Calculate the point [length] distance from point [from], moving towards point [to] in a 2-dimensional plane.
  static GeoCoordinate2D pointFromTo2D(GeoCoordinate2D from, GeoCoordinate2D to, double length) {
    if (from == to) return from; // from and to are the same point.
    double deltay = (to.y - from.y);
    double deltax = (to.x - from.x);
    if (deltax == 0) { // vertical
      return GeoCoordinate2D(from.x, from.y + deltay.sign * length);
    } else if (deltay == 0) { // horizontal
      return GeoCoordinate2D(from.x + deltax.sign * length, from.y);
    } else {
      double deltah = sqrt(pow(deltax,2) + pow(deltay,2));
      double factor = length / deltah;
      return GeoCoordinate2D(
          from.x + factor * deltax,
          from.y + factor * deltay);
    }
  }

  /// Calculate the point [length] distance from point [from], moving towards point [to] in a 3-dimensional plane.
  static GeoCoordinate pointFromTo3D(GeoCoordinate from, GeoCoordinate to, double length) {
    if (from == to) return from; // from and to are the same point.
    double deltay = (to.y - from.y);
    double deltax = (to.x - from.x);
    double deltaz = (to.z - from.z);
    double deltah = sqrt(pow(deltax,2) + pow(deltay,2) + pow(deltaz,2));
    double factor = length / deltah;
    return GeoCoordinate(
        from.x + factor * deltax,
        from.y + factor * deltay,
        from.z + factor * deltaz);
  }

  /// Check whether the sequence of paths defined by vertices is moving in clockwise or counter-clockwise direction.
  static bool isClockwise(List<GeoCoordinate2D> vertices) {
    double sum = 0.0;
    for (int i = 0; i < vertices.length; i++) {
      GeoCoordinate2D v1 = vertices[i];
      GeoCoordinate2D v2 = vertices[(i + 1) % vertices.length];
      sum += (v2.x - v1.x) * (v2.y + v1.y);
    }
    return sum > 0.0;
  }

}
