import 'package:flutter/material.dart';

class DropIcon extends StatelessWidget {
  final double size;
  final Color color;
  const DropIcon({super.key, this.size = 72, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(size, size), painter: _DropPainter(color));
  }
}

class _DropPainter extends CustomPainter {
  final Color color;
  _DropPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    path.moveTo(size.width * 0.5, 0);
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.35,
      size.width * 0.5,
      size.height,
    );
    path.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.35,
      size.width * 0.5,
      0,
    );
    canvas.drawShadow(path, Colors.black, 6, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DropPainter old) => false;
}
