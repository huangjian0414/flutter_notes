
import 'dart:math';
import 'package:flutter/material.dart';

class RoundRotatePainter extends CustomPainter {


  double progress;
  Paint _bgPaint = Paint()
    ..style = PaintingStyle.fill;

  Paint _paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  Paint _surroundPaint = Paint()
    ..color = Color(0xFF2FACFE).withOpacity(0.7)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  RoundRotatePainter({this.progress = 0});

  @override
  void paint(Canvas canvas, Size size) {

    double p1 = 6*pi/5/(2*pi);
    double p2 = 8*pi/7/(2*pi);
    double p3 = 9*pi/8/(2*pi);
    if (progress >= p1) {
      _surroundPaint.color = Color(0xFF2FACFE).withOpacity(0.2);
      canvas.drawArc(Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2 - 10),
          width: 126,
          height: 30), 0-((progress-p1)*2*pi), -pi/5, false, _surroundPaint);
      canvas.drawArc(Rect.fromCenter(center: Offset(size.width / 2, size.height / 2 +10),
          width: 132, height: 30),
          0-((progress-p1)*2*pi), -pi/5, false, _surroundPaint);
      canvas.drawArc(Rect.fromCenter(center: Offset(size.width / 2, size.height / 2 +30),
          width: 104, height: 26),
          0-((progress-p2)*2*pi), -pi/7, false, _surroundPaint);
      canvas.drawArc(Rect.fromCenter(center: Offset(size.width / 2, size.height / 2 +50),
          width: 48, height: 14),
          0-((progress-p3)*2*pi), -pi/8, false, _surroundPaint);
    }
    ///背景圆
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
    ///第一个绕的圆圈
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
    if (progress < p1) {
      canvas.drawArc(Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2 - 10),
          width: 126,
          height: 30), 6*pi/5-progress*2*pi, -pi/5, false, _surroundPaint);
    }

    ///第二个绕的圆圈
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

    if (progress < p1) {
      canvas.drawArc(Rect.fromCenter(center: Offset(size.width / 2, size.height / 2 +10), width: 132, height: 30),
          6*pi/5-progress*2*pi, -pi/5, false, _surroundPaint);
    }

    ///第三个绕的圆圈
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
    canvas.drawArc(Rect.fromCenter(center: Offset(size.width / 2, size.height / 2 +30),
        width: 104, height: 26),
        0-pi/7, pi+pi/7*2, false, _paint);
    if (progress < p2) {
      canvas.drawArc(Rect.fromCenter(center: Offset(size.width / 2, size.height / 2 +30),
          width: 104, height: 26),
          8*pi/7-progress*2*pi, -pi/7, false, _surroundPaint);
    }

    ///第四个绕的圆圈
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
    canvas.drawArc(Rect.fromCenter(center: Offset(size.width / 2, size.height / 2 +50),
        width: 48, height: 14),
        0-pi/8, pi+pi/8*2, false, _paint);
    if (progress < p3) {
      canvas.drawArc(Rect.fromCenter(center: Offset(size.width / 2, size.height / 2 +50),
          width: 48, height: 14),
          9*pi/8-progress*2*pi, -pi/8, false, _surroundPaint);
    }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
