import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class WaveGlassy extends StatefulWidget {
  final double size;
  final Color borderColor, fillColor;
  final double progress;

  WaveGlassy({this.size, this.borderColor, this.fillColor, this.progress});

  @override
  WaveGlassyState createState() => new WaveGlassyState();
}

class WaveGlassyState extends State<WaveGlassy> with TickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2500),
    );
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new ClipPath(
        clipper: CircleClipper(),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: Colors.grey.shade200.withOpacity(0.3),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget child) {
                return new CustomPaint(
                  painter: WaveGlassyPainter(controller, widget.borderColor,
                      widget.fillColor, widget.progress),
                );
              },
            ),
          ),
        ));
  }
}

class WaveGlassyPainter extends CustomPainter {
  Animation<double> _animation;
  Color borderColor, fillColor;
  double _progress;

  WaveGlassyPainter(
      this._animation, this.borderColor, this.fillColor, this._progress)
      : super(repaint: _animation);

  @override
  void paint(Canvas canvas, Size size) {
    // draw small wave
    Paint wave2Paint = new Paint()..color = fillColor.withOpacity(0.5);
    double p = _progress / 100.0;
    double n = 4.2;
    double amp = 4.0;
    double baseHeight = (1 - p) * size.height;

    Path path = Path();
    path.moveTo(0.0, baseHeight);
    for (double i = 0.0; i < size.width; i++) {
      path.lineTo(
          i,
          baseHeight +
              sin((i / size.width * 2 * pi * n) +
                      (_animation.value * 2 * pi) +
                      pi * 1) *
                  amp);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    canvas.drawPath(path, wave2Paint);

    // draw big wave
    Paint wave1Paint = new Paint()..color = fillColor;
    n = 2.2;
    amp = 10.0;

    path = Path();
    path.moveTo(0.0, baseHeight);
    for (double i = 0.0; i < size.width; i++) {
      path.lineTo(
          i,
          baseHeight +
              sin((i / size.width * 2 * pi * n) + (_animation.value * 2 * pi)) *
                  amp);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    canvas.drawPath(path, wave1Paint);

    // draw border
    Paint borderPaint = new Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(new Rect.fromCircle(
          center: new Offset(size.width / 2, size.height / 2),
          radius: size.width / 2));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
