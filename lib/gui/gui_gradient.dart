
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'gui_bitmap_data.dart';

/// Defines a gradient color with stopping point (generally but not necessarily between 0 and 1.0)
class GuiGradientColor {
  Color color;
  double stop;
  GuiGradientColor(this.color, this.stop);

  // String representation of a gradient color with it's stopping point (format: color @ stop)
  @override
  String toString() {
    return "$color @ $stop";
  }
}

/// The [GuiNormalizeGradient] class takes a user-defined 2-dimensional color maps and normalizes it
/// to contain equal number of stops in each row of the color map, and inserts the colors for stops
/// at 0.0 and 1.0 if missing.
/// Each row may be defined by an arbitrary number of gradient colors [GuiGradientColor].
/// GuiNormalizeGradient will automatically reconstruct the colormap so that each row has equal number of
/// columns or gradient colors.  If stops for 0.0 and 1.0 are missing from either row or column, it is
/// automatically computed based on colors defined outside the range.  If none were provided, then
/// a transparent color is assumed.
class GuiNormalizeGradient {

  /// A normalized color map, with each row containing equal number of GuiGradientColor
  final Map<double, List<GuiGradientColor>> colormap = <double, List<GuiGradientColor>>{};

  /// List of color map stops.  If original map did not contain stops for 0.0 and 1.0, then it is
  /// automatically added and its color values are automatically computed based on colors around it.
  /// The list is always ordered from smallest value to largest value.
  List<double> mapStops = <double>[];

  /// Index of stop 0.0 in [mapsStops]
  int mapStop0Idx = 0;
  /// Index of stop 1.0 in [mapsStops]
  int mapStop1Idx = 0;
  /// Minimum value of stop in [mapStops]
  double mapMinStop = 0;
  /// Maximum value of stops in [mapStops]
  double mapMaxStop = 0;

  /// List of gradient stops in a row.  If original map did not contain stops for 0.0 and 1.0, then it is
  /// automatically added and its color values are automatically computed based on colors around it.
  /// The list is always ordered from smallest value to largest value.
  List<double> gradientStops = <double>[];
  /// Index of stop 0.0 in [gradientStops]
  int gradientStop0Idx = 0;
  /// Index of stop 1.0 in [gradientStops]
  int gradientStop1Idx = 0;
  /// Minimum value of stop in [gradientStops]
  double gradientMinStop = 0;
  /// Maximum value of stop in [gradientStops]
  double gradientMaxStop = 0;

  // Local transparent gradient array (for edge calculations)
  List<GuiGradientColor>? _transGradient;

  GuiNormalizeGradient(Map<double, List<GuiGradientColor>> colormap) {
    _normalizeColorMap(colormap);
  }

  // Normalize input colormap
  void _normalizeColorMap(Map<double, List<GuiGradientColor>> inColorMap) {
    // create map w/ non-null gradients
    Map<double, List<GuiGradientColor>> tmpColorMap = <double, List<GuiGradientColor>>{};
    inColorMap.forEach((double key, List<GuiGradientColor>? value) {
      // include only non-empty gradients
      if (value != null && value.isNotEmpty) tmpColorMap[key] = value;
    });
    if (tmpColorMap.isEmpty) return;

    // order color map stops
    Set<double> mapStopsSet = <double>{};
    mapStopsSet.addAll(tmpColorMap.keys);
    // make sure we have 0.0 & 1.0 for map stops
    mapStopsSet.add(0.0);
    mapStopsSet.add(1.0);
    // sort map stops
    mapStops = mapStopsSet.toList();
    mapStops.sort();
    mapMinStop = mapStops.first;
    mapMaxStop = mapStops.last;
    // locate color map stop index for 0 and 1.0
    for (mapStop0Idx = 0; (mapStop0Idx < mapStops.length) && (mapStops[mapStop0Idx] != 0); mapStop0Idx++) {
    }
    for (mapStop1Idx = mapStops.length-1; (mapStop1Idx >= 0) && (mapStops[mapStop1Idx] != 1.0); mapStop1Idx--) {
    }

    // condense gradient stops
    Set<double> gradStopsSet = <double>{};
    for (List<GuiGradientColor> gradient in tmpColorMap.values) {
      for (GuiGradientColor gclr in gradient) {
        gradStopsSet.add(gclr.stop);
      }
    }
    // make sure we have 0.0 & 1.0
    gradStopsSet.add(0.0);
    gradStopsSet.add(1.0);

    // sort gradient stops
    gradientStops = gradStopsSet.toList();
    gradientStops.sort();
    gradientMinStop = gradientStops.first;
    gradientMaxStop = gradientStops.last;
    // locate gradient stop index for 0 and 1.0
    for (gradientStop0Idx = 0; (gradientStop0Idx < gradientStops.length) && (gradientStops[gradientStop0Idx] != 0); gradientStop0Idx++) {
    }
    for (gradientStop1Idx = gradientStops.length-1; (gradientStop1Idx >= 0) && (gradientStops[gradientStop1Idx] != 1.0); gradientStop1Idx--) {
    }

    // reset color map
    colormap.clear();

    // normalize all gradients to have values for each stop in gradstops
    bool bMissing = false;
    for (double mapstop in mapStops) {
      List<GuiGradientColor>? gradient = tmpColorMap[mapstop];
      if (gradient == null) {
        bMissing = true;
        continue;
      }
      List<GuiGradientColor> effgradient = <GuiGradientColor>[];
      for (int i = 0; i < gradientStops.length; i++) {
        effgradient.add(_getGradientColor(gradient, gradientStops[i], gradientMinStop, gradientMaxStop));
      }
      colormap[mapstop] = effgradient;
    }

    // check if we have gradient for stop 0 & stop 1.0
    if (bMissing) {
      // create transparent gradient (in case it is needed)
      _prepareTransparentGradient();
      // fill in missing gradients
      double prevstop = mapStops.first;
      List<GuiGradientColor> prev = _transGradient!;
      for (int i = 0; i < mapStops.length; i++) {
        double curstop = mapStops[i];
        if (colormap.containsKey(curstop)) {
          prevstop = curstop;
          prev = colormap[curstop]!;
          continue;
        }
        double nextstop = (i+1 != mapStops.length) ? mapStops[i+1] : mapStops.last;
        List<GuiGradientColor>? next = colormap[nextstop];
        if (next == null) {
          nextstop = (i+2 != mapStops.length) ? mapStops[i+2] : mapStops.last;
          next = colormap[nextstop];
          // in case we still don't have a next
          next ??= _transGradient!;
        }
        List<GuiGradientColor> cur = getGradientInBetween( curstop, prev, prevstop, next, nextstop);
        colormap[curstop] = cur;
        prevstop = curstop;
        prev = cur;
      }
    }
  }

  List<GuiGradientColor> _prepareTransparentGradient() {
    if (_transGradient == null) {
      final List<GuiGradientColor> emptyGradient = <GuiGradientColor>[];
      _transGradient = <GuiGradientColor>[];
      for (int i = 0; i < gradientStops.length; i++) {
        _transGradient!.add(_getGradientColor(emptyGradient, gradientStops[i], gradientMinStop, gradientMaxStop));
      }
    }
    return _transGradient!;
  }

  /// Obtain Color at [xStop],[yStop] from the normalized color map
  /// If the color can not be determined (in case xStop and yStop are out of range), the [outOfRangeColor] is returned.
  /// The default value of [outOfRangeColor] is Colors.transparent.
  Color colorAt(double xStop, double yStop, [Color outOfRangeColor = Colors.transparent]) {
    if (yStop < mapMinStop || yStop > mapMaxStop || xStop < gradientMinStop || xStop > gradientMaxStop) return outOfRangeColor;
    // get begin gradient
    int curYStopIdx = 0;
    double begYStop = mapStops[curYStopIdx];
    List<GuiGradientColor> begGrad = colormap[begYStop]!;
    for (curYStopIdx = 1; curYStopIdx < mapStops.length; curYStopIdx++) {
      double endYStop =  mapStops[curYStopIdx];
      List<GuiGradientColor> endGrad = colormap[endYStop]!;
      if (yStop > endYStop) {
        begYStop = endYStop;
        begGrad = endGrad;
        continue;
      }
      // get color range at yStop
      List<GuiGradientColor> curGrad = GuiNormalizeGradient.getGradientInBetween(yStop, begGrad, begYStop, endGrad, endYStop);

      int curXGgcIdx = 0;
      GuiGradientColor begGgc = curGrad[curXGgcIdx];
      for (curXGgcIdx = 1; curXGgcIdx < curGrad.length; curXGgcIdx++) {
        GuiGradientColor endGgc = curGrad[curXGgcIdx];
        if (xStop > endGgc.stop) {
          begGgc = endGgc;
          continue;
        }
        // get color between beg and end Ggc at xStop
        Color clr = GuiNormalizeGradient.getColorInBetween(xStop, begGgc, endGgc);
        return clr;
      }
    }
    // It should not reach here, but compiliers aren't that smart to figure that out own their own.
    return outOfRangeColor;
  }

  /// Generate a gradient in between two other gradients, where [stop] is a value in between [fromStop] to [toStop].
  /// The gradient colors are interpolated from [fromGradient] and [toGradient].
  static List<GuiGradientColor> getGradientInBetween(double stop, List<GuiGradientColor> fromGradient, double fromStop, List<GuiGradientColor> toGradient, double toStop) {
    // fromgrad and tograd must have the same number of elements (as achieved after normalizing each gradient to have all stops)
    List<GuiGradientColor> gradient = <GuiGradientColor>[];
    if (stop == fromStop) return fromGradient;
    if (stop == toStop || fromStop == toStop) return toGradient;

    // else compute gradient based on location of stop between fromStop and toStop.
    double t = (stop - fromStop) / (toStop - fromStop);
    for (int i = 0; i < fromGradient.length; i++) {
      gradient.add(
        GuiGradientColor(
          Color.lerp(fromGradient[i].color, toGradient[i].color, t)!,
          fromGradient[i].stop
        )
      );
    }
    return gradient;
  }

  /// Generate a color in between two other colors, where [stop] is a value in between [from.stop] to [to.stop].
  /// The color is interpolated from [from] and [to].
  static Color getColorInBetween(double stop, GuiGradientColor from, GuiGradientColor to) {
    if (stop == from.stop) return from.color;
    if (stop == to.stop) return to.color;
    return Color.lerp(from.color, to.color, (stop - from.stop) / (to.stop - from.stop))!;
  }

  // get gradient color from gradient color list based on stop value
  GuiGradientColor _getGradientColor(List<GuiGradientColor> gradient, double stop, double minstop, double maxstop) {
    // start with transparent color
    GuiGradientColor prev = GuiGradientColor(Colors.transparent, minstop);
    // iterate through gradient colors for desired stop
    for (int i = 0; i < gradient.length; i++) {
      GuiGradientColor curr = gradient[i];
      // if stop matches, return gradient color
      if (curr.stop == stop) return curr;
      // if gradient's color stop exceeds desired stop, return a calculated gradient color based
      // on distance from previous to desired over distance between next and previous
      if (curr.stop > stop) {
        return GuiGradientColor(
            Color.lerp(prev.color, curr.color, (stop - prev.stop)/(curr.stop - prev.stop))!,
            stop
        );
      }
      prev = curr;
    }
    // if not found, then return gradient color with last as transparent color
    return GuiGradientColor(
        Color.lerp(prev.color, Colors.transparent, (stop - prev.stop)/(maxstop - prev.stop))!,
        stop
    );
  }

  /// Generate a ARGB image based on normalized gradient.  The width and height of the image are specified
  /// as input parameters.  The output is a Flutter Image widget.
  Image createImage(int width, int height) {
    // prepare bitmap structure
    GuiBitmapBuffer gbmp = GuiBitmapBuffer(width: width, height: height, bitsPerPixel: GuiBitmapBuffer.bitsPerPixelArgb);
    Uint8List data = gbmp.imageData;
    int offset = 0;

    // check if width and height are valid
    if (width < 1) width = 1;
    if (height < 1) height = 1;

    // set start of stop idx to stop 0.0
    int curStopIdx = mapStop0Idx;
    // get begin gradient
    double begYStop = mapStops[curStopIdx];
    List<GuiGradientColor> begGrad = colormap[begYStop]!;
    // get end gradient
    curStopIdx++;
    double endYStop =  mapStops[curStopIdx];
    List<GuiGradientColor> endGrad = colormap[endYStop]!;

    double yStopIncrement = (height > 1)? (1.0/(height - 1)) : 1.0;
    double xStopIncrement = (width > 1) ? (1.0/(width - 1)) : 1.0;

    // For each row
    double yStop = 0;
    for (int y = 0; y < height; y++, yStop += yStopIncrement) {
      // get offset for row
      offset = gbmp.imageRowOffset(y);
      // get gradient stop
      while (yStop > endYStop) {
        begYStop = endYStop;
        begGrad = endGrad;
        curStopIdx++;
        if (curStopIdx >= mapStops.length) break;
        endYStop = mapStops[curStopIdx];
        endGrad = colormap[endYStop]!;
      }
      List<GuiGradientColor> curGrad = GuiNormalizeGradient.getGradientInBetween(yStop, begGrad, begYStop, endGrad, endYStop);

      // get color range
      int curGgcIdx = gradientStop0Idx;
      GuiGradientColor begGgc = curGrad[curGgcIdx];
      curGgcIdx++;
      GuiGradientColor endGgc = curGrad[curGgcIdx];
      double xStop = 0.0;
      for (int x = 0; x < width; x++, xStop += xStopIncrement) {
        while (xStop > endGgc.stop) {
          begGgc = endGgc;
          curGgcIdx++;
          if (curGgcIdx >= curGrad.length) break;
          endGgc = curGrad[curGgcIdx];
        }
        // get color for offset at (x,y)
        Color clr = GuiNormalizeGradient.getColorInBetween(xStop, begGgc, endGgc);
        // PixelFormat.rgba8888
        data[offset] = clr.blue;
        data[offset+1] = clr.green;
        data[offset+2] = clr.red;
        data[offset+3] = clr.alpha;
        // increment offset
        offset += gbmp.bytesPerPixel;
      }
    }
    // convert data into image
    return gbmp.toImage();
  }

}

/// A helper class for generating image based on 2-dimensional gradient and [size] dimensions.
class GuiGradientImage {

  static Image fromNormalizeGradient(GuiNormalizeGradient gradient, Size size) {
    return gradient.createImage(size.width.ceil().toInt(), size.height.ceil().toInt());
  }

  static Image fromRawGradientMap(Map<double, List<GuiGradientColor>> colormap, Size size) {
    return GuiNormalizeGradient(colormap).createImage(size.width.ceil().toInt(), size.height.ceil().toInt());
  }

}
