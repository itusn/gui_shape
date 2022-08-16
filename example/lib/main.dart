import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gui_shape/gui_shape.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // globals for control properties of shapes in demo
  int sides = 3;
  double cornerRadius = 8;
  double indentSideFactor = 0.3;
  double startAngle = 0;
  BoxFit boxFit = BoxFit.fill;
  bool clockwise = true;

  // local random number generator
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
  }

  // controls which demo is visible in scrollable view
  bool _showPolygons = true;
  bool _showStars = true;
  bool _showCustomShapes = true;
  bool _showCustomGradient = true;

  @override
  Widget build(BuildContext context) {
    int rows = 3, columns = 3;
    double xlen = (MediaQuery.of(context).size.width / columns - 4).roundToDouble();
    double ylen = ((MediaQuery.of(context).size.height - 148) / rows - 4).roundToDouble();
    // double mlen = ((xlen < ylen) ? xlen : ylen).roundToDouble();

    List<Widget> content = <Widget>[];
    // add polygons
    if (_showPolygons) {
      // content.add(_caption("Polygons in ($mlen,$mlen)"));
      // content.addAll(_drawPolygons(Size( mlen, mlen )));
      content.add(_caption("Polygons in ($xlen,$ylen)"));
      content.addAll(_drawPolygons(Size( xlen, ylen )));
    }

    // add stars
    if (_showStars) {
      // content.add(_caption("Stars in ($mlen,$mlen)"));
      // content.addAll(_drawStars(Size( mlen, mlen )));
      content.add(_caption("Stars in ($xlen,$ylen)"));
      content.addAll(_drawStars(Size( xlen, ylen )));
    }

    // add custom shape
    if (_showCustomShapes) {
      // content.add(_caption("Custom Shape in ($mlen,$mlen)"));
      // content.addAll(_drawCustom(Size( mlen, mlen )));
      content.add(_caption("Custom Shape in ($xlen,$ylen)"));
      content.addAll(_drawCustom(Size( xlen, ylen )));
    }

    // add custom gradient
    if (_showCustomGradient) {
      // content.add(_caption("Custom Gradient in ($mlen,$mlen)"));
      // content.addAll(_drawCustomGradient(Size( mlen, mlen )));
      content.add(_caption("Custom Gradient in ($xlen,$ylen)"));
      content.addAll(_drawCustomGradient(Size( xlen, ylen )));
    }

    // add padding
    content.add(const SizedBox(height: 48, width: 48));

    // layout screen
    return Scaffold(
        appBar: AppBar(
          title: const Text("Demo"),
          actions: [
            IconButton(
              icon: Icon(Icons.check_box_outline_blank, color: _showPolygons? Colors.white : Colors.grey),
              onPressed: () {
                setState(() {
                  _showPolygons = !_showPolygons;
                });
              }
            ),
            IconButton(
                icon: Icon(Icons.star_border, color: _showStars? Colors.white : Colors.grey),
                onPressed: () {
                  setState(() {
                    _showStars = !_showStars;
                  });
                }
            ),
            IconButton(
                icon: Icon(Icons.camera_outdoor, color: _showCustomShapes? Colors.white : Colors.grey),
                onPressed: () {
                  setState(() {
                    _showCustomShapes = !_showCustomShapes;
                  });
                }
            ),
            IconButton(
                icon: Icon(Icons.gradient, color: _showCustomGradient? Colors.white : Colors.grey),
                onPressed: () {
                  setState(() {
                    _showCustomGradient = !_showCustomGradient;
                  });
                }
            ),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: content,
          ),
        ),
        bottomSheet: _buildOptions(),
      );
  }

  List<Widget> _drawPolygons(Size shapeSize) {
    return <Widget>[
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // R1-C1. Regular Polygon Clip
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: GuiClipShape(
                shape: GuiShapePolygon(
                  sides: sides,
                  cornerRadius: 0,
                  startAngle: GeoAngle(degree: startAngle),
                  clockwise: clockwise,
                  boxFit: BoxFit.none,
                ),
                shadows: const [
                  GuiShadow(color: Colors.red, elevation: 1.0),
                  GuiShadow(color: Colors.grey, elevation: 4.0)
                ],
                child: Container(
                    color: Colors.blue,
                    child: const Center(
                      child: Icon(Icons.person, color: Colors.white),
                    )
                ),
              ),
            ),
            // R1-C2. Regular Polygon Border
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: GuiShapeBorder(
                    shape: GuiShapePolygon(
                      sides: sides,
                      cornerRadius: 0,
                      startAngle: GeoAngle(degree: startAngle),
                      clockwise: clockwise,
                      boxFit: BoxFit.none,
                    ),
                    side: const BorderSide(
                        color: Colors.purple,
                        width: 2.0), 
                  ),
                ),
                onPressed: () {},
                child: const Icon(Icons.person, color: Colors.yellow),
              ),
            ),
            // R1-C3. Fitted Polygon Border
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: GuiShapeBorder(
                    shape: GuiShapePolygon(
                      sides: sides,
                      cornerRadius: 0,
                      startAngle: GeoAngle(degree: startAngle),
                      clockwise: clockwise,
                      boxFit: boxFit,
                    ),
                    side: const BorderSide(
                        color: Colors.red,
                        width: 2.0), 
                  ),
                ),
                onPressed: () {},
                child: const Icon(Icons.person, color: Colors.greenAccent),
              ),
            ),
          ]
      ),

      Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // R2-C1. Rounded Polygon Clip
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: GuiClipShape(
                shape: GuiShapePolygon(
                  sides: sides,
                  cornerRadius: cornerRadius,
                  startAngle: GeoAngle(degree: startAngle),
                  clockwise: clockwise,
                  boxFit: BoxFit.none,
                ),
                shadows: const [
                  GuiShadow(color: Colors.red, elevation: 1.0),
                  GuiShadow(color: Colors.grey, elevation: 4.0)
                ],
                child: Container(
                    color: Colors.blue,
                    child: const Center(
                      child: Icon(Icons.person, color: Colors.white),
                    )
                ),
              ),
            ),
            // R2-C2. Rounded Polygon Border
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: GuiShapeBorder(
                    shape: GuiShapePolygon(
                      sides: sides,
                      cornerRadius: cornerRadius,
                      startAngle: GeoAngle(degree: startAngle),
                      clockwise: clockwise,
                      boxFit: BoxFit.none,
                    ),
                    side: const BorderSide(
                        color: Colors.purple,
                        width: 2.0), 
                  ),
                ),
                onPressed: () {},
                child: const Icon(Icons.person, color: Colors.yellow),
              ),
            ),
            // R2-C3. Fitted Rounded Polygon Border
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: GuiShapeBorder(
                    shape: GuiShapePolygon(
                      sides: sides,
                      cornerRadius: cornerRadius,
                      startAngle: GeoAngle(degree: startAngle),
                      clockwise: clockwise,
                      boxFit: boxFit,
                    ),
                    side: const BorderSide(
                        color: Colors.red,
                        width: 2.0), 
                  ),
                ),
                onPressed: () {},
                child: const Icon(Icons.person, color: Colors.greenAccent),
              ),
            ),
          ]
      ),

      Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // R3-C1. Rotated Rounded Polygon Clip
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: GuiClipShape(
                shape: GuiShapePolygon(
                  sides: sides,
                  cornerRadius: cornerRadius,
                  startAngle: GeoAngle(degree: startAngle + 45),
                  clockwise: clockwise,
                  boxFit: BoxFit.none,
                ),
                shadows: const [
                  GuiShadow(color: Colors.red, elevation: 1.0),
                  GuiShadow(color: Colors.grey, elevation: 4.0)
                ],
                child: Container(
                    color: Colors.blue,
                    child: const Center(
                      child: Icon(Icons.person, color: Colors.white),
                    )
                ),
              ),
            ),
            // R3-C2. Rotated Rounded Polygon Border
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: GuiShapeBorder(
                    shape: GuiShapePolygon(
                      sides: sides,
                      cornerRadius: cornerRadius,
                      startAngle: GeoAngle(degree: startAngle + 45),
                      clockwise: clockwise,
                      boxFit: BoxFit.none,
                    ),
                    side: const BorderSide(
                        color: Colors.purple,
                        width: 2.0), 
                  ),
                ),
                onPressed: () {},
                child: const Icon(Icons.person, color: Colors.yellow),
              ),
            ),
            // R3-C3. Rotated Fitted Rounded Polygon Border
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: GuiShapeBorder(
                    shape: GuiShapePolygon(
                      sides: sides,
                      cornerRadius: cornerRadius,
                      startAngle: GeoAngle(degree: startAngle + 45),
                      clockwise: clockwise,
                      boxFit: boxFit,
                    ),
                    side: const BorderSide(
                        color: Colors.red,
                        width: 2.0), 
                  ),
                ),
                onPressed: () {},
                child: const Icon(Icons.person, color: Colors.greenAccent),
              ),
            ),
          ]
      ),
    ];
  }

  List<Widget> _drawStars(Size shapeSize) {
    return <Widget>[
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // R1-C1. Regular Star Clip
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: GuiClipShape(
                shape: GuiShapeStar(
                  sides: sides,
                  cornerRadius: 0,
                  startAngle: GeoAngle(degree: startAngle),
                  clockwise: clockwise,
                  boxFit: BoxFit.none,
                  indentSideFactor: indentSideFactor,
                ),
                shadows: const [
                  GuiShadow(color: Colors.red, elevation: 1.0),
                  GuiShadow(color: Colors.grey, elevation: 4.0)
                ],
                child: Container(
                    color: Colors.blue,
                    child: const Center(
                      child: Icon(Icons.person, color: Colors.white),
                    )
                ),
              ),
            ),
            // R1-C2. Regular Star Border
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: GuiShapeBorder(
                    shape: GuiShapeStar(
                      sides: sides,
                      cornerRadius: 0,
                      startAngle: GeoAngle(degree: startAngle),
                      clockwise: clockwise,
                      boxFit: BoxFit.none,
                      indentSideFactor: indentSideFactor,
                    ),
                    side: const BorderSide(
                        color: Colors.purple,
                        width: 2.0), 
                  ),
                ),
                onPressed: () {},
                child: const Icon(Icons.person, color: Colors.yellow),
              ),
            ),
            // R1-C3. Fitted Star Border
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: GuiShapeBorder(
                    shape: GuiShapeStar(
                      sides: sides,
                      cornerRadius: 0,
                      startAngle: GeoAngle(degree: startAngle),
                      clockwise: clockwise,
                      boxFit: boxFit,
                      indentSideFactor: indentSideFactor,
                    ),
                    side: const BorderSide(
                        color: Colors.red,
                        width: 2.0), 
                  ),
                ),
                onPressed: () {},
                child: const Icon(Icons.person, color: Colors.greenAccent),
              ),
            ),
          ]
      ),

      Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // R2-C1. Rounded Star Clip
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: GuiClipShape(
                shape: GuiShapeStar(
                  sides: sides,
                  cornerRadius: cornerRadius,
                  startAngle: GeoAngle(degree: startAngle),
                  clockwise: clockwise,
                  boxFit: BoxFit.none,
                  indentSideFactor: indentSideFactor,
                ),
                shadows: const [
                  GuiShadow(color: Colors.red, elevation: 1.0),
                  GuiShadow(color: Colors.grey, elevation: 4.0)
                ],
                child: Container(
                    color: Colors.blue,
                    child: const Center(
                      child: Icon(Icons.person, color: Colors.white),
                    )
                ),
              ),
            ),
            // R2-C2. Rounded Star Border
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: GuiShapeBorder(
                    shape: GuiShapeStar(
                      sides: sides,
                      cornerRadius: cornerRadius,
                      startAngle: GeoAngle(degree: startAngle),
                      clockwise: clockwise,
                      boxFit: BoxFit.none,
                      indentSideFactor: indentSideFactor,
                    ),
                    side: const BorderSide(
                        color: Colors.purple,
                        width: 2.0), 
                  ),
                ),
                onPressed: () {},
                child: const Icon(Icons.person, color: Colors.yellow),
              ),
            ),
            // R2-C3. Fitted Rounded Star Border
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: GuiShapeBorder(
                    shape: GuiShapeStar(
                      sides: sides,
                      cornerRadius: cornerRadius,
                      startAngle: GeoAngle(degree: startAngle),
                      clockwise: clockwise,
                      boxFit: boxFit,
                      indentSideFactor: indentSideFactor,
                    ),
                    side: const BorderSide(
                        color: Colors.red,
                        width: 2.0), 
                  ),
                ),
                onPressed: () {},
                child: const Icon(Icons.person, color: Colors.greenAccent),
              ),
            ),
          ]
      ),

      Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // R3-C1. Rotated Rounded Star Clip
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: GuiClipShape(
                shape: GuiShapeStar(
                  sides: sides,
                  cornerRadius: cornerRadius,
                  startAngle: GeoAngle(degree: startAngle + 45),
                  clockwise: clockwise,
                  boxFit: BoxFit.none,
                  indentSideFactor: indentSideFactor,
                ),
                shadows: const [
                  GuiShadow(color: Colors.red, elevation: 1.0),
                  GuiShadow(color: Colors.grey, elevation: 4.0)
                ],
                child: Container(
                    color: Colors.blue,
                    child: const Center(
                      child: Icon(Icons.person, color: Colors.white),
                    )
                ),
              ),
            ),
            // R3-C2. Rotated Rounded Star Border
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: GuiShapeBorder(
                    shape: GuiShapeStar(
                      sides: sides,
                      cornerRadius: cornerRadius,
                      startAngle: GeoAngle(degree: startAngle + 45),
                      clockwise: clockwise,
                      boxFit: BoxFit.none,
                      indentSideFactor: indentSideFactor,
                    ),
                    side: const BorderSide(
                        color: Colors.purple,
                        width: 2.0), 
                  ),
                ),
                onPressed: () {},
                child: const Icon(Icons.person, color: Colors.yellow),
              ),
            ),
            // R3-C3. Rotated Fitted Rounded Star Border
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: GuiShapeBorder(
                    shape: GuiShapeStar(
                      sides: sides,
                      cornerRadius: cornerRadius,
                      startAngle: GeoAngle(degree: startAngle + 45),
                      clockwise: clockwise,
                      boxFit: boxFit,
                      indentSideFactor: indentSideFactor,
                    ),
                    side: const BorderSide(
                        color: Colors.red,
                        width: 2.0), 
                  ),
                ),
                onPressed: () {},
                child: const Icon(Icons.person, color: Colors.greenAccent),
              ),
            ),
          ]
      ),

    ];
  }

  List<GeoCoordinate2D> customCoords = [];
  List<Widget> _drawCustom(Size shapeSize) {
    if (sides != customCoords.length) {
      double maxlen = shapeSize.width < shapeSize.height? shapeSize.width : shapeSize.height;
      customCoords = [];
      // create a random custom shape w/ N sides
      for (int i = 0; i < sides; i++) {
        GeoAngle angle = GeoAngle(degree: i * 360/sides);
        double radius = maxlen/2 * (0.4 + 0.6*_random.nextDouble());
        customCoords.add(
          GeoCoordinate2D(
              maxlen/2 + radius * cos(angle.radian),
              maxlen/2 - radius * sin(angle.radian)
          )
        );
      }
    }

    return <Widget>[
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // R1-C1. Regular Custom Clip
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: GuiClipShape(
                shape: GuiShapeCustom(
                  points: customCoords,
                  cornerRadius: 0,
                  rotate: GeoAngle(degree: startAngle),
                  clockwise: clockwise,
                  boxFit: BoxFit.none,
                ),
                shadows: const [
                  GuiShadow(color: Colors.red, elevation: 1.0),
                  GuiShadow(color: Colors.grey, elevation: 4.0)
                ],
                child: Container(
                    color: Colors.blue,
                    child: const Center(
                      child: Icon(Icons.person, color: Colors.white),
                    )
                ),
              ),
            ),
            // R1-C2. Regular Custom Border
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: GuiShapeBorder(
                    shape: GuiShapeCustom(
                      points: customCoords,
                      cornerRadius: 0,
                      rotate: GeoAngle(degree: startAngle),
                      clockwise: clockwise,
                      boxFit: BoxFit.none,
                    ),
                    side: const BorderSide(
                        color: Colors.purple,
                        width: 2.0), 
                  ),
                ),
                onPressed: () {},
                child: const Icon(Icons.person, color: Colors.yellow),
              ),
            ),
            // R1-C3. Fitted Custom Border
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: GuiShapeBorder(
                    shape: GuiShapeCustom(
                      points: customCoords,
                      cornerRadius: 0,
                      rotate: GeoAngle(degree: startAngle),
                      clockwise: clockwise,
                      boxFit: boxFit,
                    ),
                    side: const BorderSide(
                        color: Colors.red,
                        width: 2.0), 
                  ),
                ),
                onPressed: () {},
                child: const Icon(Icons.person, color: Colors.greenAccent),
              ),
            ),
          ]
      ),

      Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // R2-C1. Rounded Custom Clip
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: GuiClipShape(
                shape: GuiShapeCustom(
                  points: customCoords,
                  cornerRadius: cornerRadius,
                  rotate: GeoAngle(degree: startAngle),
                  clockwise: clockwise,
                  boxFit: BoxFit.none,
                ),
                shadows: const [
                  GuiShadow(color: Colors.red, elevation: 1.0),
                  GuiShadow(color: Colors.grey, elevation: 4.0)
                ],
                child: Container(
                    color: Colors.blue,
                    child: const Center(
                      child: Icon(Icons.person, color: Colors.white),
                    )
                ),
              ),
            ),
            // R2-C2. Rounded Custom Border
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: GuiShapeBorder(
                    shape: GuiShapeCustom(
                      points: customCoords,
                      cornerRadius: cornerRadius,
                      rotate: GeoAngle(degree: startAngle),
                      clockwise: clockwise,
                      boxFit: BoxFit.none,
                    ),
                    side: const BorderSide(
                        color: Colors.purple,
                        width: 2.0), 
                  ),
                ),
                onPressed: () {},
                child: const Icon(Icons.person, color: Colors.yellow),
              ),
            ),
            // R2-C3. Fitted Rounded Custom Border
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: GuiShapeBorder(
                    shape: GuiShapeCustom(
                      points: customCoords,
                      cornerRadius: cornerRadius,
                      rotate: GeoAngle(degree: startAngle),
                      clockwise: clockwise,
                      boxFit: boxFit,
                    ),
                    side: const BorderSide(
                        color: Colors.red,
                        width: 2.0), 
                  ),
                ),
                onPressed: () {},
                child: const Icon(Icons.person, color: Colors.greenAccent),
              ),
            ),
          ]
      ),

      Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // R3-C1. Rotated Rounded Custom Clip
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: GuiClipShape(
                shape: GuiShapeCustom(
                  points: customCoords,
                  cornerRadius: cornerRadius,
                  rotate: GeoAngle(degree: startAngle + 45),
                  clockwise: clockwise,
                  boxFit: BoxFit.none,
                ),
                shadows: const [
                  GuiShadow(color: Colors.red, elevation: 1.0),
                  GuiShadow(color: Colors.grey, elevation: 4.0)
                ],
                child: Container(
                    color: Colors.blue,
                    child: const Center(
                      child: Icon(Icons.person, color: Colors.white),
                    )
                ),
              ),
            ),
            // R3-C2. Rotated Rounded Custom Border
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: GuiShapeBorder(
                    shape: GuiShapeCustom(
                      points: customCoords,
                      cornerRadius: cornerRadius,
                      rotate: GeoAngle(degree: startAngle + 45),
                      clockwise: clockwise,
                      boxFit: BoxFit.none,
                    ),
                    side: const BorderSide(
                        color: Colors.purple,
                        width: 2.0), 
                  ),
                ),
                onPressed: () {},
                child: const Icon(Icons.person, color: Colors.yellow),
              ),
            ),
            // R3-C3. Rotated Fitted Rounded Custom Border
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: GuiShapeBorder(
                    shape: GuiShapeCustom(
                      points: customCoords,
                      cornerRadius: cornerRadius,
                      rotate: GeoAngle(degree: startAngle + 45),
                      clockwise: clockwise,
                      boxFit: boxFit,
                    ),
                    side: const BorderSide(
                        color: Colors.red,
                        width: 2.0), 
                  ),
                ),
                onPressed: () {},
                child: const Icon(Icons.person, color: Colors.greenAccent),
              ),
            ),
          ]
      ),

    ];
  }

  List<Widget> _drawCustomGradient(Size shapeSize) {
    return <Widget>[
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GuiNormalizeGradient({
              0.0: <GuiGradientColor>[GuiGradientColor(Colors.white,0.0), GuiGradientColor(Colors.red, 1.0) ],
              1.0: <GuiGradientColor>[GuiGradientColor(Colors.blue,0.0), GuiGradientColor(Colors.green, 1.0) ],
            }).createImage(shapeSize.width.toInt(), shapeSize.height.toInt()),
            GuiNormalizeGradient({
              -0.1: <GuiGradientColor>[GuiGradientColor(const Color.fromARGB(255, 255, 0, 0),-0.1), GuiGradientColor(const Color.fromARGB(255, 255, 255, 0), 1.1)],
              1.1: <GuiGradientColor>[GuiGradientColor(const Color.fromARGB(255, 0, 255, 0),-0.1), GuiGradientColor(const Color.fromARGB(255, 0, 0, 255), 1.1)],
            }).createImage(shapeSize.width.toInt(), shapeSize.height.toInt()),
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: GuiClipShape(
                shape: GuiShapePolygon(
                  sides: sides,
                  cornerRadius: 0,
                  startAngle: GeoAngle(degree: startAngle),
                  clockwise: clockwise,
                  boxFit: BoxFit.fill,
                ),
                shadows: const [
                  GuiShadow(color: Colors.red, elevation: 1.0),
                  GuiShadow(color: Colors.grey, elevation: 4.0)
                ],
                child: GuiGradientImage.fromNormalizeGradient(
                    GuiNormalizeGradient({
                      0.0: <GuiGradientColor>[GuiGradientColor(Colors.red,0.0), GuiGradientColor(Colors.purple, 0.5), GuiGradientColor(Colors.yellow, 1.0) ],
                      0.5: <GuiGradientColor>[GuiGradientColor(Colors.blue,0.0), GuiGradientColor(Colors.yellow, 0.5), GuiGradientColor(Colors.green, 1.0) ],
                      1.0: <GuiGradientColor>[GuiGradientColor(Colors.yellow,0.0), GuiGradientColor(Colors.indigo, 0.5), GuiGradientColor(Colors.amber, 1.0) ],
                    }),
                    shapeSize
                ),
              ),
            ),
          ]
      ),
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GuiNormalizeGradient({
              0.0: <GuiGradientColor>[GuiGradientColor(Colors.white,0.0), GuiGradientColor(Colors.red, 0.25), GuiGradientColor(Colors.white, 0.5), GuiGradientColor(Colors.red, 0.75), GuiGradientColor(Colors.white, 1.0) ],
              0.25: <GuiGradientColor>[GuiGradientColor(Colors.red,0.0), GuiGradientColor(Colors.white, 0.25), GuiGradientColor(Colors.red, 0.5), GuiGradientColor(Colors.white, 0.75), GuiGradientColor(Colors.red, 1.0) ],
              0.5: <GuiGradientColor>[GuiGradientColor(Colors.white,0.0), GuiGradientColor(Colors.red, 0.25), GuiGradientColor(Colors.white, 0.5), GuiGradientColor(Colors.red, 0.75), GuiGradientColor(Colors.white, 1.0) ],
              0.75: <GuiGradientColor>[GuiGradientColor(Colors.red,0.0), GuiGradientColor(Colors.white, 0.25), GuiGradientColor(Colors.red, 0.5), GuiGradientColor(Colors.white, 0.75), GuiGradientColor(Colors.red, 1.0) ],
              1.0: <GuiGradientColor>[GuiGradientColor(Colors.white,0.0), GuiGradientColor(Colors.red, 0.25), GuiGradientColor(Colors.white, 0.5), GuiGradientColor(Colors.red, 0.75), GuiGradientColor(Colors.white, 1.0) ],
            }).createImage(shapeSize.width.toInt(), shapeSize.height.toInt()),
            GuiNormalizeGradient({
              0.0: <GuiGradientColor>[GuiGradientColor(Colors.yellow,0.0), GuiGradientColor(Colors.red, 0.25), GuiGradientColor(Colors.white, 0.5), GuiGradientColor(Colors.red, 0.75), GuiGradientColor(Colors.white, 1.0) ],
              0.25: <GuiGradientColor>[GuiGradientColor(Colors.red,0.0), GuiGradientColor(Colors.yellow, 0.25), GuiGradientColor(Colors.red, 0.5), GuiGradientColor(Colors.yellow, 0.75), GuiGradientColor(Colors.red, 1.0) ],
              0.5: <GuiGradientColor>[GuiGradientColor(Colors.white,0.0), GuiGradientColor(Colors.red, 0.25), GuiGradientColor(Colors.yellow, 0.5), GuiGradientColor(Colors.red, 0.75), GuiGradientColor(Colors.white, 1.0) ],
              0.75: <GuiGradientColor>[GuiGradientColor(Colors.red,0.0), GuiGradientColor(Colors.yellow, 0.25), GuiGradientColor(Colors.red, 0.5), GuiGradientColor(Colors.yellow, 0.75), GuiGradientColor(Colors.red, 1.0) ],
              1.0: <GuiGradientColor>[GuiGradientColor(Colors.white,0.0), GuiGradientColor(Colors.red, 0.25), GuiGradientColor(Colors.white, 0.5), GuiGradientColor(Colors.red, 0.75), GuiGradientColor(Colors.yellow, 1.0) ],
            }).createImage(shapeSize.width.toInt(), shapeSize.height.toInt()),
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: GuiClipShape(
                shape: GuiShapePolygon(
                  sides: sides,
                  cornerRadius: 0,
                  startAngle: GeoAngle(degree: startAngle),
                  clockwise: clockwise,
                  boxFit: BoxFit.fill,
                ),
                shadows: const [
                  GuiShadow(color: Colors.red, elevation: 1.0),
                  GuiShadow(color: Colors.grey, elevation: 4.0)
                ],
                child: GuiGradientImage.fromNormalizeGradient(
                    GuiNormalizeGradient({
                      0.0: <GuiGradientColor>[GuiGradientColor(Colors.yellow,0.0), GuiGradientColor(Colors.red, 0.25), GuiGradientColor(Colors.white, 0.5), GuiGradientColor(Colors.red, 0.75), GuiGradientColor(Colors.white, 1.0) ],
                      0.25: <GuiGradientColor>[GuiGradientColor(Colors.red,0.0), GuiGradientColor(Colors.yellow, 0.25), GuiGradientColor(Colors.red, 0.5), GuiGradientColor(Colors.yellow, 0.75), GuiGradientColor(Colors.red, 1.0) ],
                      0.5: <GuiGradientColor>[GuiGradientColor(Colors.white,0.0), GuiGradientColor(Colors.red, 0.25), GuiGradientColor(Colors.yellow, 0.5), GuiGradientColor(Colors.red, 0.75), GuiGradientColor(Colors.white, 1.0) ],
                      0.75: <GuiGradientColor>[GuiGradientColor(Colors.red,0.0), GuiGradientColor(Colors.yellow, 0.25), GuiGradientColor(Colors.red, 0.5), GuiGradientColor(Colors.yellow, 0.75), GuiGradientColor(Colors.red, 1.0) ],
                      1.0: <GuiGradientColor>[GuiGradientColor(Colors.white,0.0), GuiGradientColor(Colors.red, 0.25), GuiGradientColor(Colors.white, 0.5), GuiGradientColor(Colors.red, 0.75), GuiGradientColor(Colors.yellow, 1.0) ],
                    }),
                    shapeSize
                ),
              ),
            ),
          ]
      ),
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GuiNormalizeGradient({
              0.0: <GuiGradientColor>[GuiGradientColor(Colors.yellow,0.0), GuiGradientColor(Colors.yellow, 0.25), GuiGradientColor(Colors.green, 0.5), GuiGradientColor(Colors.yellow, 0.75), GuiGradientColor(Colors.red, 1.0) ],
              0.25: <GuiGradientColor>[GuiGradientColor(Colors.green,0.0), GuiGradientColor(Colors.green, 0.25), GuiGradientColor(Colors.green, 0.5), GuiGradientColor(Colors.green, 0.75), GuiGradientColor(Colors.yellow, 1.0) ],
              0.5: <GuiGradientColor>[GuiGradientColor(Colors.green,0.0), GuiGradientColor(Colors.blue, 0.25), GuiGradientColor(Colors.blue, 0.5), GuiGradientColor(Colors.red, 0.75), GuiGradientColor(Colors.green, 1.0) ],
              0.75: <GuiGradientColor>[GuiGradientColor(Colors.yellow,0.0), GuiGradientColor(Colors.blue, 0.25), GuiGradientColor(Colors.white, 0.5), GuiGradientColor(Colors.white, 0.75), GuiGradientColor(Colors.green, 1.0) ],
              1.0: <GuiGradientColor>[GuiGradientColor(Colors.yellow,0.0), GuiGradientColor(Colors.green, 0.25), GuiGradientColor(Colors.blue, 0.5), GuiGradientColor(Colors.green, 0.75), GuiGradientColor(Colors.white, 1.0) ],
            }).createImage(shapeSize.width.toInt(), shapeSize.height.toInt()),
            GuiNormalizeGradient({
              0.0: <GuiGradientColor>[GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)),0.0), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.25), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.5), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.75), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 1.0) ],
              0.25: <GuiGradientColor>[GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)),0.0), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.25), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.5), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.75), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 1.0) ],
              0.5: <GuiGradientColor>[GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)),0.0), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.25), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.5), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.75), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 1.0) ],
              0.75: <GuiGradientColor>[GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)),0.0), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.25), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.5), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.75), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 1.0) ],
              1.0: <GuiGradientColor>[GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)),0.0), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.25), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.5), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.75), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 1.0) ],
            }).createImage(shapeSize.width.toInt(), shapeSize.height.toInt()),
            SizedBox(
              height: shapeSize.height,
              width: shapeSize.width,
              child: GuiClipShape(
                shape: GuiShapePolygon(
                  sides: sides,
                  cornerRadius: 0,
                  startAngle: GeoAngle(degree: startAngle),
                  clockwise: clockwise,
                  boxFit: BoxFit.fill,
                ),
                shadows: const [
                  GuiShadow(color: Colors.red, elevation: 1.0),
                  GuiShadow(color: Colors.grey, elevation: 4.0)
                ],
                child: GuiGradientImage.fromNormalizeGradient(
                    GuiNormalizeGradient({
                      0.0: <GuiGradientColor>[GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)),0.0), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.01 + _random.nextInt(24)/100), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.25 + _random.nextInt(50)/100), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.75 + _random.nextInt(24)/100), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 1.0) ],
                      (0.25 - 0.125 + _random.nextInt(25)/100): <GuiGradientColor>[GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)),0.0), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.01 + _random.nextInt(24)/100), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.25 + _random.nextInt(50)/100), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.75 + _random.nextInt(24)/100), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 1.0) ],
                      (0.5 - 0.125 + _random.nextInt(25)/100): <GuiGradientColor>[GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)),0.0), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.01 + _random.nextInt(24)/100), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.25 + _random.nextInt(50)/100), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.75 + _random.nextInt(24)/100), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 1.0) ],
                      (0.75 - 0.125 + _random.nextInt(25)/100): <GuiGradientColor>[GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)),0.0), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.01 + _random.nextInt(24)/100), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.25 + _random.nextInt(50)/100), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.75 + _random.nextInt(24)/100), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 1.0) ],
                      1.0: <GuiGradientColor>[GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)),0.0), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.01 + _random.nextInt(24)/100), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.25 + _random.nextInt(50)/100), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 0.75 + _random.nextInt(24)/100), GuiGradientColor(Color.fromARGB(_random.nextInt(255), _random.nextInt(255), _random.nextInt(255), _random.nextInt(255)), 1.0) ],
                    }),
                    shapeSize
                ),
              ),
            ),
          ]
      )
    ];
  }


  Widget _caption(String caption) {
    return Container(
        color: Colors.black12,
        width: double.infinity,
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(caption, textAlign: TextAlign.center)
        )
    );
  }

  Widget _buildOptions() {
    return Container(
        height: 48,
        width: double.infinity,
        color: Colors.black,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                child: Text("S: $sides"),
                onPressed: () {
                  setState(() {
                    sides++;
                  });
                },
              ),
              ElevatedButton(
                child: Text(clockwise? "CW": "CC"),
                onPressed: () {
                  setState(() {
                    clockwise = !clockwise;
                  });
                },
              ),
              ElevatedButton(
                child: Text("IS: $indentSideFactor"),
                onPressed: () {
                  setState(() {
                    // increment by 0.1 (and wrap around to 0.0 after 1.0)
                    indentSideFactor = (((indentSideFactor + 0.1) * 100).toInt() % 100) / 100;
                  });
                },
              ),
              ElevatedButton(
                child: Text("A: $startAngle"),
                onPressed: () {
                  setState(() {
                    // increment by 0.1 (and wrap around to 0.0 after 1.0)
                    startAngle = (startAngle + 5)  % 360;
                  });
                },
              ),
              ElevatedButton(
                child: const Icon(Icons.restore),
                onPressed: () {
                  setState(() {
                    sides = 3;
                    cornerRadius = 8;
                    indentSideFactor = 0.3;
                    startAngle = 0;
                    boxFit = BoxFit.fill;
                    clockwise = false;
                  });
                },
              ),
            ]
        )
    );
  }

}
