

import 'dart:math';
import 'package:flutter/material.dart';
import 'radar_scan_config.dart';
import 'radar_scan_painter.dart';

class RadarScanView extends StatefulWidget {

  RadarScanConfig? config;
  Widget? midWidget;
  ///设置midWidget后无效
  VoidCallback? onPressed;
  RadarScanView({Key? key,this.config,this.midWidget,this.onPressed}) : super(key: key);

  @override
  State<RadarScanView> createState() => _RadarScanViewState();
}

class _RadarScanViewState extends State<RadarScanView> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation _animation;
  late RadarScanConfig _radarScanConfig;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.config == null) {
      _radarScanConfig = RadarScanConfig();
    }else{
      _radarScanConfig = widget.config!;
    }
    _controller = AnimationController(vsync: this,duration: _radarScanConfig.duration??Duration(seconds: 5));
    _animation = Tween(begin: .0, end: pi * 2).animate(_controller);
    _controller.repeat();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(animation: _animation, builder: (ctx,child){
          return CustomPaint(
            painter: RadarScanPainter(
                _animation.value,
              sectorAngle: _radarScanConfig.sectorAngle,
              showMiddleline: _radarScanConfig.showMiddleline,
              circleCount: _radarScanConfig.circleCount,
              circleWidth: _radarScanConfig.circleWidth,
              scanLineWidth: _radarScanConfig.scanLineWidth,
              scnaLineColor: _radarScanConfig.scnaLineColor,
              bgLineWidth: _radarScanConfig.bgLineWidth,
              bgLineColor: _radarScanConfig.bgLineColor,
              shaderColors: _radarScanConfig.shaderColors
            ),
          );
        }),
        buildMidWidget()
      ],
    );
  }
  buildMidWidget(){
    if (widget.midWidget != null) {
      return widget.midWidget;
    }
    return Center(
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Color(0xFF3585FE),
            borderRadius: BorderRadius.circular(15)
          ),
          child: Icon(Icons.add,color: Colors.white,),
        ),
      ),
    );
  }
}

