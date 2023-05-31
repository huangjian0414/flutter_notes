

import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class RadarScanPainter extends CustomPainter {
  ///旋转角度
  double angle;
  ///扫描扇形角度
  double sectorAngle;
  ///背景圆圈个数
  int circleCount;
  ///背景线宽
  double circleWidth;
  ///是否显示中间线
  bool showMiddleline;
  ///扫描线宽
  double scanLineWidth;
  ///扫描线颜色
  Color scnaLineColor;
  ///背景线颜色
  Color bgLineColor;
  ///背景线宽度
  double bgLineWidth;
  ///扫描扇形渐变色
  List<Color>? shaderColors;

  Paint _bgPaint = Paint()
    ..style = PaintingStyle.stroke;

  Paint _paint = Paint()
    ..style = PaintingStyle.fill
    ..strokeWidth = 1;
  Paint _scnaLinePaint = Paint()
    ..style = PaintingStyle.stroke;

  RadarScanPainter(this.angle,
      {this.circleCount = 4,
        this.showMiddleline = false,
        this.sectorAngle = pi*2/3,
        this.scanLineWidth = 2,
        this.bgLineColor = const Color(0x0F3585FE),
        this.bgLineWidth = 1,
        this.shaderColors,
        this.scnaLineColor = const Color(0x503585FE),
        this.circleWidth = 1,
      });

  @override
  void paint(Canvas canvas, Size size) {

    _paint.strokeWidth = circleWidth;
    _scnaLinePaint.color = scnaLineColor;
    _scnaLinePaint.strokeWidth = scanLineWidth;
    _bgPaint.color = bgLineColor;
    _bgPaint.strokeWidth = bgLineWidth;

    var radius = min(size.width / 2, size.height / 2);
    if (showMiddleline) {///中间线绘制
      canvas.drawLine(Offset(size.width / 2, size.height / 2 - radius),
          Offset(size.width / 2, size.height / 2 + radius), _bgPaint);
      canvas.drawLine(Offset(size.width / 2 - radius, size.height / 2),
          Offset(size.width / 2 + radius, size.height / 2), _bgPaint);
    }
    ///背景圆绘制
    for (var i = 1; i <= circleCount; ++i) {
      canvas.drawCircle(Offset(size.width / 2, size.height / 2),
          radius * i / circleCount, _bgPaint);
    }

    List<Color> colors = [Color(0xFF32AEFF).withOpacity(.01), Color(0xFF32AEFF).withOpacity(.2)];
    if (shaderColors != null) {
      colors = shaderColors!;
    }
    _paint.shader = ui.Gradient.sweep(
        Offset(size.width / 2, size.height / 2),
        colors,
        [.0, 1.0],
        TileMode.clamp,
        .0,
        sectorAngle);
    canvas.save();
    ///角度
    double r = sqrt(pow(size.width, 2) + pow(size.height, 2));
    double startAngle = atan(size.height / size.width);
    Point p0 = Point(r * cos(startAngle), r * sin(startAngle));
    Point px = Point(r * cos(angle + startAngle), r * sin(angle + startAngle));
    canvas.translate((p0.x - px.x) / 2, (p0.y - px.y) / 2);
    canvas.rotate(angle);
    ///扇形
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2), radius: radius),
        0,
        sectorAngle,
        true,
        _paint);
    final lx = size.width/2 - cos(pi-sectorAngle)*radius;
    final ly = size.height/2 + sin(pi-sectorAngle)*radius;
    ///扫描线
    canvas.drawLine(Offset(size.width / 2, size.height / 2),
        Offset(lx, ly), _scnaLinePaint);
    canvas.restore();

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
