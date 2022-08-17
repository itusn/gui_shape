import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'geo_utility.dart';
import 'geo_common.dart';

/// The [GeoPath] class is used to generate a smooth [Path] by rounding corners with [cornerRadius] units from the corner.
/// If [cornerRadius] is zero, the coordinates are converted into a [Path] without rounding corners.
/// Otherwise, the start and end of the curve on two adjacent sides is determined by [cornerRadius] using a bezeir curve.
class GeoPath {
  /// Raw coordinates
  final List<GeoCoordinate2D> coords;

  /// Constructor for [GeoPath]
  GeoPath(this.coords);

  /// Returns a closed [Path] with coordinates connected with straight line segments.
  Path straightPath() {
    Path path = Path();
    // create path starting from point 0, ...
    path.moveTo(coords[0].x, coords[0].y);
    for (int i = 1; i < coords.length; i++) {
      path.lineTo(coords[i].x, coords[i].y);
    }
    // close path at starting point
    path.lineTo(coords[0].x, coords[0].y);
    return path;
  }

  /// Returns a closed [Path] with coordinates connected with rounded corners.
  Path roundedPath(double cornerRadius) {
    if (cornerRadius <= 0) return straightPath();

    Path path = Path();
    const double k = 100000;
    // COMMENTED: Radius used for Approach 2 (below)
    // Radius radius = Radius.circular(cornerRadius*5);
    for (int i = 0; i <= coords.length; i++) {
      GeoCoordinate2D p1 =
          coords[(i + coords.length - 1) % coords.length]; // previous point
      GeoCoordinate2D p2 = coords[i % coords.length]; // current point
      GeoCoordinate2D p3 = coords[(i + 1) % coords.length]; // next point

      // calculate the angles between the lines formed by p1-p2 and p3-p2
      // Note: Handle vertical slope (ie. infinity) as a very large number
      // get slope between point 1 & 2, an 3 & 2
      double mp2p1 = p2.slopeTo(p1); // slope between point 1 and 2
      if (mp2p1.isInfinite)
        mp2p1 =
            0x80000000; // set to a large finite number, since we can't operate on infinity
      double mp2p3 = p2.slopeTo(p3); // slope between point 3 and 2
      if (mp2p3.isInfinite)
        mp2p3 =
            0x80000000; // set to a large finite number, since we can't operate on infinity
      double mp2p1xmp2p3 = (mp2p1 * mp2p3);

      // get angle between line P2P1 and Line P2P3 (ie. angle of P1-P2-P3)
      // if (mp2p1 * mp2p3)*k = -1*k then slopes are effectively perpendicular
      // we use k = 10000 so we can round the number and test for perpendicularity
      bool isPerpendicular = ((mp2p1xmp2p3 * k).roundToDouble() == -k);
      double angle123 = isPerpendicular
          ? (pi / 2)
          : atan((mp2p1 - mp2p3) / (1 + mp2p1xmp2p3));

      // calculate the length of the segment at which rounding the corner should start/end
      // tan (angle123 / 2) = cornerRadius / segment from p2 to p1
      // tan (angle123 / 2) = cornerRadius / segment from p2 to p3
      double seg21 = (cornerRadius / tan(angle123 / 2)).abs();
      double seg23 = seg21;

      // calculate distance between points
      double d21 = p2.distanceTo(p1);
      double d23 = p2.distanceTo(p3);
      // the length of the segment can not be longer than the distance between the points
      if (seg21 > d21) seg21 = d21;
      if (seg23 > d23) seg23 = d23;

      // get point for rounded arc on line p2 to p1 / p2 to p3
      GeoCoordinate2D vp2p1 = GeoUtility.pointFromTo2D(p2, p1, seg21);
      GeoCoordinate2D vp2p3 = GeoUtility.pointFromTo2D(p2, p3, seg23);

      if (i == 0) {
        // move to starting position
        path.moveTo(vp2p3.x, vp2p3.y);
      } else {
        // line to point, just before rounding the corner
        path.lineTo(vp2p1.x, vp2p1.y);
        // Approach 3: Use conic method to round the corner
        path.conicTo(p2.x, p2.y, vp2p3.x, vp2p3.y, 1);
        // COMMENTED: Approach 2: Arc method to round the corner (not very good)
        // bool clockwise = !GeoUtility.isClockwise(<GeoCoordinate2D>[p1, p2, p3]);
        // path.arcToPoint(Offset(vp2p3.x,vp2p3.y), radius: radius, clockwise: clockwise);
        // COMMENTED: Approach 1: Straight line method to (not-really) round the corner (but useful for testing purposes)
        // path.lineTo(vp2p3.x,vp2p3.y);
      }
    }
    return path;
  }
}
