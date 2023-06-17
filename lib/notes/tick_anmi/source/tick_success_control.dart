
import 'dart:math';
import 'package:flutter/material.dart';

class TickSuccessControl {

  AnimationController? animationController;
  ///是否已完成
  bool isSuccess;
  ///大小
  Size size;
  ///背景色
  Color bgColor;
  ///进度圆圈颜色
  Color activeColor;
  ///进度圆圈画笔宽度
  double activeWidth;
  ///进度圆圈开始角度
  double activeStartAngle;
  ///进度圆圈结束角度
  double activeEndAngle;
  ///完成打勾颜色
  Color doneColor;
  ///完成打勾画笔宽度
  double doneWidth;
  ///进度圆圈动画时间
  Duration activeDuration;
  ///完成打勾动画时间
  Duration doneDuration;

  TickSuccessControl({
    this.isSuccess = false,
    this.animationController,
    this.size = const Size(20, 20),
    this.bgColor = Colors.blueAccent,
    this.activeColor = Colors.white,
    this.doneColor = Colors.white,
    this.activeDuration = const Duration(seconds: 1),
    this.doneDuration = const Duration(seconds: 1),
    this.activeWidth = 1,
    this.doneWidth = 2,
    this.activeStartAngle = 0,
    this.activeEndAngle = pi*3/2
  });

  updateStatus(bool status){
    if (status != isSuccess) {
      isSuccess = status;
      animationController?.reset();
      if (isSuccess) {
        animationController?.duration = activeDuration;
        animationController?.forward();
      }else{
        animationController?.duration = doneDuration;
        animationController?.repeat();
      }
    }
  }
}