




import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class RoundRotatePainter extends CustomPainter {

  Paint _bgPaint = Paint()
    ..style = PaintingStyle.fill;

  Paint _paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  RoundRotatePainter();

  @override
  void paint(Canvas canvas, Size size) {

    _bgPaint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF2FACFE).withOpacity(0),
        Color(0xFF2FACFE).withOpacity(0.46)
      ],
    ).createShader(
      Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2), radius: 105/2),
    );
    canvas.drawCircle(Offset(size.width / 2, size.height / 2),
        105/2, _bgPaint);

    _paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF2FACFE).withOpacity(0),
        Color(0xFF2FACFE).withOpacity(0.46),
      ],
    ).createShader(
      Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2 - 10),
          width: 126,
          height: 30),
    );
    canvas.drawArc(Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2 - 10),
        width: 126,
        height: 30), 0 - pi / 5, pi + pi / 5 * 2, false, _paint);
    _paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF2FACFE).withOpacity(0),
        Color(0xFF2FACFE).withOpacity(0.46),
      ],
    ).createShader(
      Rect.fromCenter(center: Offset(size.width / 2, size.height / 2 +10), width: 132, height: 30),
    );
    canvas.drawArc(Rect.fromCenter(center: Offset(size.width / 2, size.height / 2 +10), width: 132, height: 30), 0-pi/5, pi+pi/5*2, false, _paint);
    _paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF2FACFE).withOpacity(0),
        Color(0xFF2FACFE).withOpacity(0.46),
      ],
    ).createShader(
      Rect.fromCenter(center: Offset(size.width / 2, size.height / 2 +30), width: 104, height: 26),
    );
    canvas.drawArc(Rect.fromCenter(center: Offset(size.width / 2, size.height / 2 +30), width: 104, height: 26), 0-pi/7, pi+pi/7*2, false, _paint);
    _paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF2FACFE).withOpacity(0),
        Color(0xFF2FACFE).withOpacity(0.46),
      ],
    ).createShader(
        Rect.fromCenter(center: Offset(size.width / 2, size.height / 2 +50), width: 48, height: 14)
    );
    canvas.drawArc(Rect.fromCenter(center: Offset(size.width / 2, size.height / 2 +50), width: 48, height: 14), 0-pi/8, pi+pi/8*2, false, _paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
