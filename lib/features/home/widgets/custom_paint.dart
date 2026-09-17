import 'package:flutter/material.dart';

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    Path path_0 = Path();
    path_0.moveTo(-26.117,2.23131);
    path_0.cubicTo(-1.74607,-6.70412,13.2536,26.8204,24.5655,57.673);
    path_0.cubicTo(35.8773,88.5256,107.396,105.056,83.025,113.991);
    path_0.cubicTo(58.654,122.927,-23.1012,158.611,-34.4131,127.759);
    path_0.cubicTo(-45.725,96.9062,-50.488,11.1667,-26.117,2.23131);
    path_0.close();

    Paint paint0Fill = Paint()..style=PaintingStyle.fill;
    paint0Fill.color = const Color(0xffFF6B00).withValues(alpha: 0.08);
    canvas.drawPath(path_0,paint0Fill);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}