

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class TickSuccessPainter extends CustomPainter {
  //进度 0-1
  double progress = 0.0;
  bool isSuccess;
  ///进度圆圈颜色
  Color arcColor;
  ///进度圆圈宽度
  double arcWidth;
  ///进度圆弧开始角度
  double arcStartAngle;
  ///进度圆弧角度
  double arcSweepAngle;
  ///打勾颜色
  Color tickColor;
  ///打勾线条宽度
  double tickWidth;
  TickSuccessPainter(
      this.progress, {
        this.isSuccess = false,
        this.arcColor = Colors.white,
        this.tickColor = Colors.white,
        this.arcWidth = 1,
        this.tickWidth = 2,
        this.arcStartAngle = 0,
        this.arcSweepAngle = pi*3/2
      });

  Paint _paint = new Paint()
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true;
  Paint _circlePaint = new Paint()
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Size size) {

    double radius = min(size.width/2, size.height/2);
    Offset center = Offset(size.width/2, size.height/2);
    if (isSuccess) {
      _paint.color = tickColor;
      _paint.strokeWidth = tickWidth;
      Path startPath = Path();
      startPath.moveTo(center.dx-radius/2, center.dy);
      startPath.lineTo(center.dx-radius/6, center.dy+radius/2-radius/6);
      startPath.lineTo(center.dx+radius/2, center.dy-radius/3);

      PathMetrics pathMetrics = startPath.computeMetrics();
      PathMetric pathMetric = pathMetrics.first;
      Path extrPath = pathMetric.extractPath(0, pathMetric.length * progress);
      canvas.drawPath(extrPath, _paint);
    }else{
      _circlePaint.color = arcColor;
      _circlePaint.strokeWidth = arcWidth;
      Path arcPath = Path();
      arcPath.addArc(Rect.fromCircle(center: center, radius: radius-5), arcStartAngle, arcSweepAngle);
      canvas.translate(center.dx, center.dy);
      canvas.rotate(pi*2*progress);
      canvas.translate(-center.dx, -center.dy);
      canvas.drawPath(arcPath, _circlePaint);
    }
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}