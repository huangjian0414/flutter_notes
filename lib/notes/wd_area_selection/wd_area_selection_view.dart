import 'dart:math';

import 'package:flutter/material.dart';
import 'wd_area_point_model.dart';
import 'wd_area_selection_config.dart';
import 'wd_area_selection_painter.dart';

typedef AreaNodeAction = Function(WDAreaPointModel areaPoint);

class WDMapAreaSelectionView extends StatefulWidget {
  WDMapAreaSelectionView(
      {Key? key,
      this.points,
      this.offset = Offset.zero,
      this.centerOffset = Offset.zero,
      this.isShowNode = false,
      this.isHidden = false,
      this.config,
      this.areaInfo,
      this.areaInfoHidden = true,
      this.areaInfoRotateCount = 0,
      this.sizeInfo = '',
      this.isShowSize = false})
      : super(key: key);

  List<WDAreaPointModel>? points;

  ///对于扩充地图的偏移
  Offset offset;

  ///节点是否展示
  bool isShowNode;

  ///隐藏区域
  bool isHidden;
  WDAreaSelectionConfigProtocol? config;

  ///区域重心
  Offset centerOffset;
  Widget? areaInfo;
  bool areaInfoHidden;

  ///旋转角度倍数
  int areaInfoRotateCount;

  String sizeInfo;
  bool isShowSize;

  @override
  State<WDMapAreaSelectionView> createState() => _WDMapAreaSelectionViewState();
}

class _WDMapAreaSelectionViewState extends State<WDMapAreaSelectionView> {
  List<Widget> get icons {
    if (widget.points == null) {
      return [];
    }
    var originalAngle = widget.areaInfoRotateCount * (-pi / 2);
    var angle = originalAngle;
    List<Widget> items = [];
    widget.points!.forEach((element) {
      if (element.icon != null) {
        items.add(
          Positioned(
            left: element.x - element.radius + widget.offset.dx,
            top: element.y - element.radius + widget.offset.dy,
            child: Offstage(
              offstage: !widget.isShowNode,
              child: Transform.rotate(
                angle: angle,
                child: element.icon!,
              ),
            ),
          ),
        );
      }
    });
    return items;
  }

  List<Widget> get allWidgets {
    List<Widget> temp = [...icons];
    temp.add(getAreaInfo());
    return temp;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.config == null) {
      widget.config = WDAreaSelectionDefaultConfig();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: widget.isHidden,
      child: CustomPaint(
        painter: WDAreaSelectionPainter(widget.points ?? [],
            offset: widget.offset,
            isShowNode: widget.isShowNode,
            config: widget.config!,
            isShowSize: widget.isShowSize,
            sizeInfo: widget.sizeInfo),
        child: Stack(
          children: allWidgets,
        ),
      ),
    );
  }

  Widget getAreaInfo() {
    Widget w = SizedBox.shrink();
    if (!widget.areaInfoHidden && widget.areaInfo != null) {
      w = widget.areaInfo!;
    }
    double width = 0, height = 0;
    if (widget.areaInfoRotateCount % 2 == 0) {
      width = widget.config!.areaInfoSize.width;
      height = widget.config!.areaInfoSize.height;
    } else {
      width = widget.config!.areaInfoSize.height;
      height = widget.config!.areaInfoSize.width;
    }
    return Positioned(
      child: Container(
        child: Transform.rotate(
          child: w,
          angle: widget.areaInfoRotateCount * (-pi / 2),
        ),
        width: width,
        height: height,
        alignment: Alignment.center,
      ),
      left: widget.offset.dx + widget.centerOffset.dx - width / 2,
      top: widget.offset.dy + widget.centerOffset.dy - height / 2,
    );
  }
}
