import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'wd_area_selection_defines.dart';
import 'wd_area_selection_config.dart';
import 'wd_area_point_model.dart';

class WDAreaSelectionPainter extends CustomPainter {

  WDAreaSelectionPainter(this.points,
      {
        this.offset = Offset.zero,
        this.isShowNode = false,
        this.isShowSize = false,
        this.config,
        this.sizeInfo = ''
      });

  List<WDAreaPointModel> points;
  ///对于扩充地图的偏移
  Offset offset;
  ///节点是否展示
  bool isShowNode;
  String sizeInfo ;
  bool isShowSize;

  WDAreaSelectionConfigProtocol? config;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    if (config == null) {
      config = WDAreaSelectionDefaultConfig();
    }

    if (points.length == 2) { /// 直线区域
      List<Offset> pos = points.map((e) => Offset(e.x+offset.dx, e.y+offset.dy)).toList();
      Paint linePaint = Paint();
      linePaint.color = config!.lineColor;
      linePaint.style = PaintingStyle.stroke;
      linePaint.strokeWidth = config!.lineWidth;
      canvas.drawLine(pos[0], pos[1], linePaint);
      if (isShowNode) {
        ///画实心圆
        Paint paint_circle = Paint();
        paint_circle.color = config!.nodeBgColor;
        pos.forEach((element) {
          canvas.drawCircle(element, points[1].radius, paint_circle);
        });
      }
      return;
    }
    ///画区域
    Path areaPath = Path();
    List<Offset> pos = points.map((e) => Offset(e.x+offset.dx, e.y+offset.dy)).toList();
    areaPath.addPolygon(pos, true);
    Paint paint_bg = Paint();
    paint_bg.color = config!.fillColor;
    paint_bg.strokeWidth = config!.lineWidth;
    canvas.drawPath(areaPath, paint_bg);
    Paint paint_Area = Paint();
    paint_Area.color = config!.lineColor;
    paint_Area.style = PaintingStyle.stroke;
    paint_Area.strokeWidth = config!.lineWidth;
    canvas.drawPath(areaPath, paint_Area);

    if (isShowSize) {
      Rect rect = areaPath.getBounds();
      ParagraphBuilder pb = ParagraphBuilder(
          ParagraphStyle(
              fontSize: 10
          )
      );
      pb.pushStyle(ui.TextStyle(color: config!.lineColor));
      pb.addText(sizeInfo);
      double w = rect.right-rect.left;
      if (w < 100) {
        w = 100;
      }
      ParagraphConstraints pc = ParagraphConstraints(width: w);
      Paragraph paragraph = pb.build()..layout(pc);
      canvas.drawParagraph(paragraph, Offset(rect.left, rect.bottom+5));
    }

    if (isShowNode) {
      ///画实心圆
      Paint paint_circle = Paint();
      paint_circle.color = config!.nodeBgColor;
      points.forEach((element) {
        if(element.type != WDAreaPointType.kNone){
          canvas.drawCircle(Offset(element.x+offset.dx, element.y+offset.dy), element.radius, paint_circle);
        }
      });
    }
  }

  @override
  bool shouldRepaint(covariant WDAreaSelectionPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}