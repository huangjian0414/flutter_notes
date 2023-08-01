import 'package:flutter/material.dart';
import 'wd_area_point_model.dart';
import 'wd_area_selection_defines.dart';

abstract class WDAreaSelectionConfigProtocol {
  ///线的颜色
  Color lineColor = Color(0xFFFB648C);

  ///线包围区域的填充色
  Color fillColor = Color(0xFFFC8DA7).withOpacity(0.8);

  ///线宽
  double lineWidth = 3.0;

  ///节点背景色
  Color nodeBgColor = Color(0xFFFB648C);

  ///直线区域
  List<WDAreaPointModel> lineAreaPoints = [];

  ///矩形区域
  List<WDAreaPointModel> rectAreaPoints = [];

  ///多边形区域
  List<WDAreaPointModel> polygonAreaPoints = [];

  ///几种点类型的icon
  Map<WDAreaPointType, Widget> pointConfigs = {};

  ///矩形区域最小size，加载地图后通过m换算过来像素赋值
  Size rectAreaMinSize = Size(30, 30);

  ///区域最大个数
  int areaMaxCount = 30;

  ///区域的一边长度, 加载地图后通过m换算过来像素赋值
  double areaWidth = 50;

  ///区域信息组件默认size
  Size areaInfoSize = Size(100, 60);

  ///区域选中类型,默认单选
  WDAreaSelectedType areaSelectedType = WDAreaSelectedType.kSelectedSingle;

  ///多边形区域最多点个数
  int maxPolygonPointCount = 10;
  int minPolygonPointCount = 3;
}

class WDAreaSelectionDefaultConfig extends WDAreaSelectionConfigProtocol {

  @override
  // TODO: implement lineAreaPoints
  List<WDAreaPointModel> get lineAreaPoints => _defaultLinePoints();

  @override
  // TODO: implement rectAreaPoints
  List<WDAreaPointModel> get rectAreaPoints => _defaultRectPoints();

  @override
  // TODO: implement polygonAreaPoints
  List<WDAreaPointModel> get polygonAreaPoints => _defaultPolygonPoints();

  @override
  // TODO: implement pointConfigs
  Map<WDAreaPointType, Widget> get pointConfigs => {
        WDAreaPointType.kAdd: Icon(Icons.add, size: 20, color: Colors.white),
        WDAreaPointType.kRemove:
            Icon(Icons.remove, size: 20, color: Colors.white),
        WDAreaPointType.kClose:
            Icon(Icons.close, size: 20, color: Colors.white),
        WDAreaPointType.kExpand:
            Icon(Icons.open_in_full, size: 20, color: Colors.white),
        WDAreaPointType.kSelected:
            Icon(Icons.done, size: 20, color: Colors.white),
      };

  ///直线区域
  List<WDAreaPointModel> _defaultLinePoints() {
    return [
      WDAreaPointModel(0, 0,
          type: WDAreaPointType.kClose,
          icon: pointConfigs[WDAreaPointType.kClose]),
      WDAreaPointModel(areaWidth, 0,
          type: WDAreaPointType.kExpand,
          icon: pointConfigs[WDAreaPointType.kExpand]),
    ];
  }

  ///矩形区域
  List<WDAreaPointModel> _defaultRectPoints() {
    return [
      WDAreaPointModel(0, 0, type: WDAreaPointType.kNone),
      WDAreaPointModel(areaWidth, 0,
          type: WDAreaPointType.kClose,
          icon: pointConfigs[WDAreaPointType.kClose]),
      WDAreaPointModel(areaWidth, areaWidth,
          type: WDAreaPointType.kExpand,
          icon: pointConfigs[WDAreaPointType.kExpand]),
      WDAreaPointModel(0, areaWidth, type: WDAreaPointType.kNone),
    ];
  }

  ///多边形区域
  List<WDAreaPointModel> _defaultPolygonPoints() {
    return [
      WDAreaPointModel(0, 0, type: WDAreaPointType.kCircle, radius: 6),
      WDAreaPointModel(areaWidth, 0,
          type: WDAreaPointType.kClose,
          icon: pointConfigs[WDAreaPointType.kClose]),
      WDAreaPointModel(areaWidth + areaWidth / 2, areaWidth / 2,
          type: WDAreaPointType.kRemove,
          icon: pointConfigs[WDAreaPointType.kRemove]),
      WDAreaPointModel(areaWidth, areaWidth,
          type: WDAreaPointType.kCircle, radius: 6),
      WDAreaPointModel(0, areaWidth,
          type: WDAreaPointType.kAdd, icon: pointConfigs[WDAreaPointType.kAdd]),
    ];
  }
}
