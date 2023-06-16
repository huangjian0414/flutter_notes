

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class PathPainter extends CustomPainter {
  //进度 0-1
  double progress = 0.0;
  bool isSuccess;
  PathPainter(this.progress,{this.isSuccess = false});

  Paint _paint = new Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0
    ..isAntiAlias = true;
  Paint _circlePaint = new Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0
    ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Size size) {

    double radius = min(size.width/2, size.height/2);
    Offset center = Offset(size.width/2, size.height/2);
    if (isSuccess) {
      Path startPath = Path();
      startPath.moveTo(center.dx-radius/2, center.dy);
      startPath.lineTo(center.dx-radius/6, center.dy+radius/2-radius/6);
      startPath.lineTo(center.dx+radius/2, center.dy-radius/3);

      PathMetrics pathMetrics = startPath.computeMetrics();
      PathMetric pathMetric = pathMetrics.first;
      Path extrPath = pathMetric.extractPath(0, pathMetric.length * progress);
      canvas.drawPath(extrPath, _paint);
    }else{
      Path arcPath = Path();
      arcPath.addArc(Rect.fromCircle(center: center, radius: radius-5), 0, pi*3/2);
      canvas.translate(center.dx, center.dy);
      canvas.rotate(pi*2*progress);
      canvas.translate(-center.dx, -center.dy);
      canvas.drawPath(arcPath, _circlePaint);

    }
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    //返回ture 实时更新
    return true;
  }
}