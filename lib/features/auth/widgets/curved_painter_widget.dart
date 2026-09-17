import 'package:flutter/material.dart';

class CurvedPainterWidget extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Color color1 = const Color(0xFF00ACB3);
    Color color2 = const Color(0xFF044042);
    var paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color1,
          color2,
        ],
      ).createShader(Rect.fromCircle(
        center: const Offset(0,0),
        radius: 10,
      ));

    var path = Path();

    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.7,
        size.width * 0.5, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.9,
        size.width * 1.0, size.height * 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}