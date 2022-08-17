import 'package:flutter/material.dart';
import '../shape/i_gui_shape.dart';

/// Creates an outlined border defined by provided shape.
class GuiShapeBorder extends OutlinedBorder {
  final IGuiShape shape;

  /// Constructs an outlined border with [shape] and border [side] properties.
  /// The [shape] defines the outline of the border
  /// The [side] controls the width and look for the border.
  const GuiShapeBorder({
    required this.shape,
    BorderSide side = BorderSide.none,
  }) : super(side: side);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  // Retrieve the path for the shape
  Path _getPath(Rect rect) {
    return shape.getPath(size: rect.size).shift(Offset(
        rect.center.dx - rect.width / 2, rect.center.dy - rect.height / 2));
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is GuiShapeBorder) {
      return GuiShapeBorder(
        shape: shape.lerpFrom(a.shape, t),
        side: BorderSide.lerp(a.side, side, t),
      );
    } else {
      return super.lerpFrom(a, t);
    }
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is GuiShapeBorder) {
      return GuiShapeBorder(
        shape: shape.lerpTo(b.shape, t),
        side: BorderSide.lerp(side, b.side, t),
      );
    } else {
      return super.lerpTo(b, t);
    }
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        var path = _getPath(rect);
        canvas.drawPath(path, side.toPaint());
        break;
    }
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(rect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(rect);
  }

  @override
  ShapeBorder scale(double t) {
    return GuiShapeBorder(shape: shape, side: side.scale(t));
  }

  @override
  OutlinedBorder copyWith({BorderSide? side}) {
    return GuiShapeBorder(shape: shape, side: side ?? this.side);
  }
}
