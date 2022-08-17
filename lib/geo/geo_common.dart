import 'dart:math';
import 'dart:ui';

/// The [GeoCoordinate] class defines (x,y,z) coordinates on a 3-dimensional space.
class GeoCoordinate {
  /// The x-coordinate in a 3-dimensional space
  double x;
  /// The y-coordinate in a 3-dimensional space
  double y;
  /// The x-coordinate in a 3-dimensional space
  double z;

  /// Constructor for [GeoCoordinate]
  GeoCoordinate(this.x, this.y, this.z);

  /// Calculate the distance between two points
  double distanceTo(GeoCoordinate point) => (sqrt(pow(point.y - y,2) + pow(point.x - x,2) + pow(point.z - z,2)));

  /// Compare two coordinates for equality.
  @override
  bool operator ==(Object other) {
    return (other is GeoCoordinate) && (other.x == x) && (other.y == y) && (other.z == z);
  }

  /// Translate a coordinate by another by adding it's respective coordinates.
  /// Simply, addition of two coordinates.
  GeoCoordinate operator +(Object other) {
    if (other is GeoCoordinate) {
      return GeoCoordinate(x + other.x, y + other.y, z + other.z);
    } else {
      return this;
    }
  }

  /// Multiple coordinates by [factor].
  GeoCoordinate operator *(Object factor) {
    if (factor is GeoCoordinate) {
      return GeoCoordinate(x * factor.x, y * factor.y, z + factor.z);
    } else if (factor is double) {
      return GeoCoordinate(x * factor, y * factor, z + factor);
    } else if (factor is int) {
      return GeoCoordinate(x * factor, y * factor, z + factor);
    } else {
      return this;
    }
  }

  /// Linearly interpolate from [other] coordinate to this coordinate by
  /// an extrapolation factor `t`.
  GeoCoordinate lerpFrom(GeoCoordinate other, double t) {
    return GeoCoordinate(
      lerpDouble(other.x, x, t)!,
      lerpDouble(other.y, y, t)!,
      lerpDouble(other.z, z, t)!
    );
  }

  /// Linearly interpolate from this coordinate to [other] coordinate by
  /// an extrapolation factor `t`.
  GeoCoordinate lerpTo(GeoCoordinate other, double t) {
    return GeoCoordinate(
        lerpDouble(x, other.x, t)!,
        lerpDouble(y, other.y, t)!,
        lerpDouble(z, other.z, t)!
    );
  }

  /// Represent coordinate as a printable string (x: #, y: #, z: #).
  @override
  String toString() {
    return "(x:$x, y:$y, z:$z)";
  }

  /// Calculate hashcode of 3-dimensional coordinate.
  @override
  int get hashCode {
    return x.hashCode ^ (y.hashCode*17) ^ (z.hashCode*29);
  }

}

/// The [GeoCoordinate2D] class defines (x,y) coordinates on a 2-dimensional plane (w/ z = 0 implied).
class GeoCoordinate2D extends GeoCoordinate {

  /// Constructor for [GeoCoordinate]
  GeoCoordinate2D(double x, double y) : super(x, y, 0);

  /// Convert 2-dimensional coordinate to [Offset] class (defined in dart:ui library).
  Offset asOffset() => Offset(x,y);

  /// Calculate slope between 2 points
  double slopeTo(GeoCoordinate2D point) => ((point.y - y) / (point.x - x));

  /// Compute distance between 2 points
  @override
  double distanceTo(GeoCoordinate point) => (sqrt(pow(point.y - y,2) + pow(point.x - x,2)));

  /// Rotate coordinate by specified [angle] using [pivot] as center of rotation.
  GeoCoordinate2D rotate(GeoAngle angle, [GeoCoordinate2D? pivot]) {
    if (angle.degree == 0) return GeoCoordinate2D(x,y);
    // rotation matrix
    double mr1c1, mr1c2, mr2c1, mr2c2;
    mr1c1 = cos(angle.radian);
    mr1c2 = -sin(angle.radian);
    mr2c1 = sin(angle.radian);
    mr2c2 = cos(angle.radian);

    // adjust coordinate if we have a pivot point
    double cx, cy;
    cx = pivot != null? x - pivot.x : x;
    cy = pivot != null? y - pivot.y : y;

    // calculate new coordinates by multiplying matrix with adjusted coordinates
    double newx = cx*mr1c1 + cy*mr1c2;
    double newy = cx*mr2c1 + cy*mr2c2;

    if (pivot != null) {
      newx = newx + pivot.x;
      newy = newy + pivot.y;
    }
    // return new coordinate
    return GeoCoordinate2D(newx, newy);
  }

  /// Linearly interpolate from [other] coordinate to this coordinate by
  /// an extrapolation factor `t`.
  GeoCoordinate2D lerpFrom2D(GeoCoordinate2D other, double t) {
    return GeoCoordinate2D(
        lerpDouble(other.x, x, t)!,
        lerpDouble(other.y, y, t)!
    );
  }

  /// Linearly interpolate from this coordinate to [other] coordinate by
  /// an extrapolation factor `t`.
  GeoCoordinate2D lerpTo2D(GeoCoordinate2D other, double t) {
    return GeoCoordinate2D(
        lerpDouble(x, other.x, t)!,
        lerpDouble(y, other.y, t)!
    );
  }


  /// Compare two coordinates for equality.
  @override
  bool operator ==(Object other) {
    return (other is GeoCoordinate2D) && (other.x == x) && (other.y == y);
  }

  /// Represent coordinate as a printable string (x: #, y: #).
  @override
  String toString() {
    return "(x:$x, y:$y)";
  }

  /// Calculate hashcode of 2-dimensional coordinate
  @override
  int get hashCode {
    return x.hashCode ^ (y.hashCode*17);
  }

}


/// The [GeoAngle] class defines an angle that may be given in degrees or radians (but not both).
/// It automatically converts angles to degrees and radians for easier access
class GeoAngle {

  /// A static [GeoAngle] representing 0 degrees (0 radians).
  static final GeoAngle zero = GeoAngle(degree: 0);
  /// A static [GeoAngle] representing 180 degrees
  static final GeoAngle angle180 = GeoAngle(degree: 180);
  /// a static [GeoAngle] representing 360 degrees
  static final GeoAngle angle360 = GeoAngle(degree: 360);

  /// The angle in degrees.
  late final double degree;

  /// The angle in radians.
  late final double radian;

  /// Constructor for [GeoAngle].  Either degree or radians must be defined, but NOT both.
  GeoAngle({double? degree, double? radian}) : assert((degree != null) ^ (radian != null)) {
    if (degree != null) {
      this.degree = degree;
      this.radian = degree * pi / 180;
    } else if (radian != null) {
      this.radian = radian;
      this.degree = radian * 180 / pi;
    } else {
      degree = 0;
      radian = 0;
    }
  }

  /// Static function for converting degress to radians (Note: pi = 180 degrees)
  static double toRadian(double degree) {
    return (degree * pi) / 180;
  }

  /// Static function for converting radians to degrees (Note: pi = 180 degrees)
  static double toDegree(double radian) {
    return (radian * 180) / pi;
  }

  /// Compare two angles for equality.
  @override
  bool operator ==(Object other) {
    return (other is GeoAngle) && (other.radian == radian);
  }

  /// Add two angles
  GeoAngle operator +(Object other) {
    if (other is GeoAngle) {
      return GeoAngle(radian: radian + other.radian);
    } else if (other is double) {
      return GeoAngle(radian: radian + other);
    } else {
      return this;
    }
  }

  /// Subtract two angles
  GeoAngle operator -(Object other) {
    if (other is GeoAngle) {
      return GeoAngle(radian: radian - other.radian);
    } else if (other is double) {
      return GeoAngle(radian: radian - other);
    } else {
      return this;
    }
  }

  /// Multiply an angle
  GeoAngle operator *(Object other) {
    if (other is GeoAngle) {
      return GeoAngle(radian: radian * other.radian);
    } else if (other is double) {
      return GeoAngle(radian: radian * other);
    } else if (other is int) {
      return GeoAngle(radian: radian * other);
    } else {
      return this;
    }
  }

  /// Divide an angle
  GeoAngle operator /(Object other) {
    if (other is GeoAngle) {
      return GeoAngle(radian: radian / other.radian);
    } else if (other is double) {
      return GeoAngle(radian: radian / other);
    } else if (other is int) {
      return GeoAngle(radian: radian / other);
    } else {
      return this;
    }
  }

  /// negative of angle
  GeoAngle operator -() {
    return GeoAngle(radian: -radian);
  }

  /// A string representation of angle, showing angle in both radians and degrees.
  @override
  String toString() {
    return "(r:$radian, d:$degree)";
  }

  @override
  int get hashCode => radian.hashCode;


}

/// The [GeoEllipse] class defines an geometric ellipse with horizontal radius [xRadius], and vertical radius [yRadius].
/// The class may be used to calculate coordinates on the ellipse given an angle in radians or degrees.
class GeoEllipse {
  final double xRadius;
  final double yRadius;

  /// Creates a new instance of [GeoEllipse] with horizontal radius [xRadius], and vertical radius [yRadius]
  GeoEllipse(this.xRadius, this.yRadius) {
    _xy =  xRadius * yRadius;
  }

  /// An internal multiplier of x-radius and y-radius to expedite coordinate calculations at angles.
  late final double _xy;

  /// Get coordinate on an ellipse centered at [center] at an [angle] given in radians.
  /// If center is not specified, origin (0,0) is assumed.
  /// Factor [factor] is multiplied with the amplitude at the angle to support polar charting
  GeoCoordinate2D coordinateByRadian(double angle,[GeoCoordinate2D? center, double factor = 1.0]) {
    // calculate sin and cos of angle
    double sinr = sin(angle);
    double cosr = cos(angle);
    // calculate x and y positions in ellipse
    // x = +/- ( xradius * yradius * cos(angle) / sqrt( (yradius * cos(angle))^2 + (xradius * sin(angle))^2 )
    // y = +/- ( xradius * yradius * sin(angle) / sqrt( (yradius * cos(angle))^2 + (xradius * sin(angle))^2 )
    double cx = factor * (_xy * cosr) / sqrt(pow(yRadius * cosr,2) + pow(xRadius*sinr,2));
    double cy = factor * (_xy * sinr) / sqrt(pow(yRadius * cosr,2) + pow(xRadius*sinr,2));
    return center == null? GeoCoordinate2D(cx,cy) : GeoCoordinate2D(center.x + cx, center.y + cy);
  }

  /// Get coordinate on an ellipse centered at [center] at an [angle] given in degrees.
  /// If center is not specified, origin (0,0) is assumed.
  GeoCoordinate2D coordinateByDegree(double angle,[GeoCoordinate2D? center]) {
    return coordinateByRadian(GeoAngle.toRadian(angle), center);
  }

  /// Get coordinate on an ellipse centered at [center] at an [angle] given in [GeoAngle] (either radian or degree).
  /// If center is not specified, origin (0,0) is assumed.
  GeoCoordinate2D coordinate(GeoAngle angle,[GeoCoordinate2D? center]) {
    return coordinateByRadian(angle.radian,center);
  }

  /// String representation of [GeoEllipse] showing horizontal (x) radius, and vertical (y) radius.
  @override
  String toString() {
    return "Ellipse(xr:$xRadius, yr:$yRadius)";
  }

}

/// The [GeoCircle] class defines an geometric circle with [radius].
/// The class may be used to calculate coordinates on the circle given an angle in radians or degrees.
class GeoCircle extends GeoEllipse {
  /// The radious of a circle
  final double radius;

  /// Constructor of [GeoCircle]
  GeoCircle(this.radius) : super(radius, radius);

  /// String representation of [GeoCircle] showing radius.
  @override
  String toString() {
    return "Circle(r:$radius)";
  }

}
