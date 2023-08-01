import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';

import 'wd_area_point_model.dart';

class WDAreaTool {

  ///检测点是否在Path内部
  static bool checkPathContainsPoint(List<WDAreaPointModel> points, Offset touchPoint,{Offset imgOffset = Offset.zero}){
    Path areaPath = Path();
    List<Offset> pos = points.map((e) => Offset(e.x+imgOffset.dx, e.y+imgOffset.dy)).toList();
    areaPath.addPolygon(pos, true);
    return areaPath.contains(touchPoint);
  }
  ///检测点是否在某个节点内，在则返回这个节点
  static WDAreaPointModel? checkNodeContainsPoint(List<WDAreaPointModel> points, Offset touchPoint,{Offset imgOffset = Offset.zero}){
    var path = Path();
    for (var i=0; i<points.length; i++) {
      WDAreaPointModel pointModel = points[i];
      path.reset();
      path.addOval(Rect.fromCircle(
        center: Offset(pointModel.x+imgOffset.dx, pointModel.y+imgOffset.dy),
        radius: pointModel.radius,
      ));
      if (path.contains(touchPoint)) {
        return pointModel;
      }
    }
    return null;
  }
  ///检测点是否在直线区域内, 将直线扩大成矩形
  static bool checkLineContainsPoint(List<WDAreaPointModel> points, Offset touchPoint,{Offset imgOffset = Offset.zero}){
    if (points.length !=2) {
      return false;
    }
    var pos = points;
    if (points[0].x > points[1].x) {
      pos = pos.reversed.toList();
    }
    var point1,point2,point3,point4;
    if (pos[0].x - pos[1].x == 0) {
      point1 = Offset(pos[0].x-10, pos[0].y);
      point2 = Offset(pos[0].x+10, pos[0].y);
      point3 = Offset(pos[1].x-10, pos[1].y);
      point4 = Offset(pos[1].x+10, pos[1].y);
    }else if(pos[0].y - pos[1].y == 0){
      point1 = Offset(pos[0].x, pos[0].y-10);
      point2 = Offset(pos[0].x, pos[0].y+10);
      point3 = Offset(pos[1].x, pos[1].y+10);
      point4 = Offset(pos[1].x, pos[1].y-10);
    }else{
      double length=math.sqrt((math.pow((pos[0].x-pos[1].x).abs(), 2)+(math.pow((pos[0].y-pos[1].y).abs(), 2))));
      double w = (pos[0].x-pos[1].x).abs();
      double h = (pos[0].y-pos[1].y).abs();
      final h1 = 10 * (w/length);
      final w1 = 10 * (h/length);
      if (pos[0].y < pos[1].y) {
        point1 = Offset(pos[0].x-w1, pos[0].y+h1);
        point2 = Offset(pos[0].x+w1, pos[0].y-h1);
        point3 = Offset(pos[1].x+w1, pos[1].y-h1);
        point4 = Offset(pos[1].x-w1, pos[1].y+h1);
      }else{
        point1 = Offset(pos[0].x-w1, pos[0].y-h1);
        point2 = Offset(pos[0].x+w1, pos[0].y+h1);
        point3 = Offset(pos[1].x+w1, pos[1].y+h1);
        point4 = Offset(pos[1].x-w1, pos[1].y-h1);
      }
    }
    List<Offset> ps = [point1,point2,point3,point4];
    for (var i=0; i<ps.length; i++) {
      ps[i] = Offset(ps[i].dx+imgOffset.dx, ps[i].dy+imgOffset.dy);
    }
    var path = Path();
    path.addPolygon(ps, true);
    return path.contains(touchPoint);
  }
  ///校验2个路径是否有交集
  static bool checkTwoPathIntersect(Path path1, Path path2){
    try{
      Path p = Path.combine(PathOperation.intersect, path1, path2);
      debugPrint("checkTwoPathIntersect - ${p.getBounds()}");
      if (p.getBounds().isEmpty) {
        return false;
      }
      return true;
    }catch(error){
      return false;
    }
  }
  static Path lineToRect(List<WDAreaPointModel> points,{double width = 1}){
    var pos = points;
    if (points[0].x > points[1].x) {
      pos = pos.reversed.toList();
    }
    var point1,point2,point3,point4;
    if (pos[0].x - pos[1].x == 0) {
      point1 = Offset(pos[0].x-width, pos[0].y);
      point2 = Offset(pos[0].x+width, pos[0].y);
      point3 = Offset(pos[1].x-width, pos[1].y);
      point4 = Offset(pos[1].x+width, pos[1].y);
    }else if(pos[0].y - pos[1].y == 0){
      point1 = Offset(pos[0].x, pos[0].y-width);
      point2 = Offset(pos[0].x, pos[0].y+width);
      point3 = Offset(pos[1].x, pos[1].y+width);
      point4 = Offset(pos[1].x, pos[1].y-width);
    }else{
      double length=math.sqrt((math.pow((pos[0].x-pos[1].x).abs(), 2)+(math.pow((pos[0].y-pos[1].y).abs(), 2))));
      double w = (pos[0].x-pos[1].x).abs();
      double h = (pos[0].y-pos[1].y).abs();
      final h1 = width * (w/length);
      final w1 = width * (h/length);
      if (pos[0].y < pos[1].y) {
        point1 = Offset(pos[0].x-w1, pos[0].y+h1);
        point2 = Offset(pos[0].x+w1, pos[0].y-h1);
        point3 = Offset(pos[1].x+w1, pos[1].y-h1);
        point4 = Offset(pos[1].x-w1, pos[1].y+h1);
      }else{
        point1 = Offset(pos[0].x-w1, pos[0].y-h1);
        point2 = Offset(pos[0].x+w1, pos[0].y+h1);
        point3 = Offset(pos[1].x+w1, pos[1].y+h1);
        point4 = Offset(pos[1].x-w1, pos[1].y-h1);
      }
    }
    List<Offset> ps = [point1,point2,point3,point4];
    var path = Path();
    path.addPolygon(ps, true);
    return path;
  }
}