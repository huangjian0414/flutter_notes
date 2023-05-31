
import 'dart:math';

import 'package:flutter/material.dart';

class RadarScanConfig {

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
  Duration duration;

  RadarScanConfig({
      this.sectorAngle = pi*2/3,
      this.circleCount = 4,
      this.circleWidth = 1,
      this.showMiddleline = false,
      this.scanLineWidth = 2,
      this.scnaLineColor = const Color(0x503585FE),
      this.bgLineColor = const Color(0x0F3585FE),
      this.bgLineWidth = 1,
      this.shaderColors,
    this.duration = const Duration(seconds: 5)
  });
}