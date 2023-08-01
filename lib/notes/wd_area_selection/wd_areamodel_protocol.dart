
import 'wd_area_selection_config.dart';

import 'wd_area_point_model.dart';
import 'wd_area_selection_defines.dart';

abstract class WDAreaModelProtocol {
  ///区域类型
  WDAreaType areaType = WDAreaType.kNone;
  ///像素坐标点数组
  List<WDAreaPointModel> points = [];
  ///是否展示节点
  bool isShowNode = false;
  ///是否可编辑
  bool isCanEdit = true;
  ///是否可点击
  bool isCanTap = false;
  ///是否隐藏（整个）
  bool isHidden = false;
  ///是否隐藏区域信息
  bool isAreaInfoHidden = true;
  ///区域配置项
  WDAreaSelectionConfigProtocol areaSelectionConfig = WDAreaSelectionDefaultConfig();
  ///区域size信息
  String areaSizeInfo = '';
  ///是否展示区域size信息
  bool isShowAreaSizeInfo = false;
}