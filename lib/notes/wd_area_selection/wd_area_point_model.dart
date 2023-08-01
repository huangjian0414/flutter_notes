
import 'package:flutter/material.dart';

enum WDAreaPointType{
  kNone,
  kCircle,
  kAdd,
  kRemove,
  kExpand,
  kClose,
  kSelected
}

class WDAreaPointModel {

  WDAreaPointModel(this.x,this.y,{this.type = WDAreaPointType.kCircle,this.icon,this.radius = 10});

  double x;
  double y;
  WDAreaPointType type;
  Widget? icon;
  double radius;
}