import 'dart:math' as math;
import 'package:flutter/material.dart';

class ArcPainter extends CustomPainter {
  ArcPainter(
      {this.startAngle = 0, this.sweepAngle = 0, this.color = Colors.white});
  final double startAngle;
  final double sweepAngle;
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(size.width * 0.05, size.width * 0.05,
        size.width * 0.95, size.height * 0.95);
    final startAngle = math.pi * this.startAngle;
    final sweepAngle = math.pi * this.sweepAngle;
    const useCenter = false;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.1;
    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(size.width * 0.5, 0.0)
      ..lineTo(size.width, size.height)
      ..lineTo(0.0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}

class SquareClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0.0, 0.0)
      ..lineTo(size.width, 0.0)
      ..lineTo(size.width, size.height)
      ..lineTo(0.0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(SquareClipper oldClipper) => false;
}

class KimClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, size.height * 0.9)
      ..lineTo(0, size.height)
      ..lineTo(size.width * 0.1, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(KimClipper oldClipper) => false;
}
