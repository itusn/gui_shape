import 'package:flutter/material.dart';
import '../shape/i_gui_shape.dart';
import 'gui_shadow.dart';

/// A stateless widget for clipping a shape (implementing [IGuiShape] interface) around a [child] widget.
/// An array of shadows may be defined to create impression of elevation (aka floating effect).
class GuiClipShape extends StatelessWidget {
  final Widget? child;
  final IGuiShape shape;
  final List<GuiShadow>? shadows;

  /// Create a clip with a specified shape (ie. [GuiCustomShape], [GuiShapePolygon], [GuiShapeStar], ...)
  /// Shadows with color and elevation may be defined to create floating effect.
  /// The child widget is clipped to the specified shape
  const GuiClipShape({Key? key,
        required this.shape,
        this.shadows = const [],
        this.child}) : super(key: key);

  /// Render a clipped child widget
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1.0,
        child: CustomPaint(
            painter: GuiShapeShadowPainter(shape,shadows!),
            child: ClipPath(
              clipper: GuiShapeClipper(shape),
              child: child,
            )
        )
    );
  }
}

/// Provides a polygon shaped clip path.
class GuiShapeClipper extends CustomClipper<Path> {
  final IGuiShape shape;

  /// Create a polygon clipper with the provided specs.
  GuiShapeClipper(this.shape);

  @override
  Path getClip(Size size) {
    return shape.getPath(size: size);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

/// A polygon shaped shadow
class GuiShapeShadowPainter extends CustomPainter {
  final IGuiShape shape;
  final List<GuiShadow>? boxShadows;

  /// Creates a polygon shaped shadow
  GuiShapeShadowPainter(this.shape, this.boxShadows);

  @override
  void paint(Canvas canvas, Size size) {
    if (boxShadows != null) {
      Path path = shape.getPath(size: size);
      boxShadows!.forEach((GuiShadow shadow) {
        canvas.drawShadow(path, shadow.color, shadow.elevation, false);
      });
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}