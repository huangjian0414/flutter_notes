import 'package:flutter/material.dart';
import '../wd_area_selection_defines.dart';
import '../wd_areamodel_protocol.dart';
import '../wd_area_point_model.dart';
import '../wd_area_tool.dart';

///点击节点，给出点击的区域和点击的节点下标
typedef AreaNodeTapCallback = Function (int areaIndex,int nodeIndex);
///拖拽节点结束
typedef AreaNodePanEndCallback = Function (int areaIndex,int nodeIndex);
///拖拽区域结束
typedef AreaPanEndCallback = Function (int areaIndex);
///拖拽节点
typedef AreaNodePanCallback = Function (int areaIndex,int nodeIndex);
///点击区域
typedef TapAreaAction = Function (WDAreaModelProtocol areaModel,int index);

abstract class WDAreaSelectionProtocol {
  ///手指按下逻辑
  void pointerDownAction(PointerDownEvent detail, {VoidCallback? refreshCallback});
  ///手指抬起逻辑处理
  void pointerUpAction({VoidCallback? refreshCallback});
  /// 拖拽逻辑处理
  void pointerMoveAction(PointerMoveEvent detail, {VoidCallback? refreshCallback});

  ///区域数组
  List<WDAreaModelProtocol> areas = [];
  ///坐标是否有偏移，（用于背景容器大，内容容器放至其中的情况）
  Offset offset = Offset.zero;
  ///父容器是否可以拖动,看业务是否需要(操作区域的时候为false)
  bool parentContainerPanEnabled = false;

  ///监听区域点击
  void listenTapAreaAction(TapAreaAction? action){}
  ///监听区域节点点击
  void listenTapAreaNodeAction(AreaNodeTapCallback action){}
  ///选中/取消选中某个区域
  void selectedArea(int areaIndex){}

  ///区域重心
  List<List> areaCenters = [];
}


class WDAreaManager extends WDAreaSelectionProtocol {

  WDAreaManager({
    this.areaNodeTapCallback,
    this.areaNodePanEndCallback,
    this.areaPanEndCallback,
    this.areaNodePanCallback,
  });
  ///是否在区域内
  bool isInPath = false;
  ///当前手指接触的某个区域的某个节点
  WDAreaPointModel? touchNode;
  /// 点击的节点所属的区域
  WDAreaModelProtocol? touchNodeArea;
  /// 当前手指接触的区域
  WDAreaModelProtocol? touchArea;
  ///操作是移动
  bool isMoveArea = false;
  ///手指按下的时间，用来区分是点击还是拖拽
  DateTime? touchTime;

  AreaNodeTapCallback? areaNodeTapCallback;
  AreaNodePanEndCallback? areaNodePanEndCallback;
  AreaPanEndCallback? areaPanEndCallback;
  AreaNodePanCallback? areaNodePanCallback;
  TapAreaAction? _tapAreaAction;
  AreaNodeTapCallback? _tapAreaNodeAction;
  ///手指按下逻辑
  @override
  void pointerDownAction(PointerDownEvent detail,{VoidCallback? refreshCallback}) {
    resetSomething();
    touchTime = DateTime.now();
    checkTapOnNode(detail, offset);
    if (touchNode == null) {
      WDAreaLog('没有按在节点上 ----- ${offset}');
      checkTapOnArea(detail, offset);
      if (touchArea != null) {
        WDAreaLog('按在区域上 -----');
        isInPath = true;
      }
    }
    if (refreshCallback != null) {
      refreshCallback();
    }
  }
  ///检测是否接触在节点上
  checkTapOnNode(PointerDownEvent detail,Offset imageOffset){
    WDAreaLog('判断是否按在节点上 ----- ${detail} - ${imageOffset} - ${areas}');
    for (var i=areas.length-1; i>=0; i--) {
      WDAreaLog('checkNodeContainsPoint ----- ${areas[i].points}  - ${detail.localPosition}');
      if (areas[i].isCanEdit||areas[i].isCanTap) {
        final pointModel = WDAreaTool.checkNodeContainsPoint(areas[i].points, detail.localPosition,
            imgOffset: imageOffset);
        if (pointModel != null && pointModel.type != WDAreaPointType.kNone) {
          touchNode = pointModel;
          touchNodeArea = areas[i];
          WDAreaLog('按在节点上了 ----- ');
          break;
        }
      }
    }
  }
  ///检测是否接触在区域上
  checkTapOnArea(PointerDownEvent detail,Offset imageOffset){
    WDAreaLog('判断是否按在区域内 ----- ${detail} - ${imageOffset} - ${areas}');
    for (var i=areas.length-1; i>=0; i--) {
      if (areas[i].isCanEdit||areas[i].isCanTap) {
        if (WDAreaTool.checkPathContainsPoint(areas[i].points, detail.localPosition,
            imgOffset: imageOffset)||
            WDAreaTool.checkLineContainsPoint(areas[i].points, detail.localPosition,
                imgOffset: imageOffset)) {
          touchArea = areas[i];
          WDAreaLog('按在区域内了 ----- ');
          break;
        }
      }
    }
  }

  resetSomething(){
    touchNode = null;
    touchArea = null;
    isInPath = false;
    touchTime = null;
    touchNodeArea = null;
    isMoveArea = false;
  }

  ///手指抬起逻辑处理
  @override
  void pointerUpAction({VoidCallback? refreshCallback}){

    if (isInPath) { ///点击在区域路径内
      final nowTime = DateTime.now().millisecondsSinceEpoch;
      WDAreaLog('点击区域时差 --- ${nowTime - touchTime!.millisecondsSinceEpoch}');
      if (touchArea!.isCanEdit && isMoveArea) {///拖拽区域后，更新一下区域的坐标数据
        if (areaPanEndCallback != null) {
          areaPanEndCallback!(areas.indexOf(touchArea!));
        }
      }
      ///如果点击到抬起时间少于100毫秒，当作点击事件处理
      if (nowTime - touchTime!.millisecondsSinceEpoch <= 120 && touchArea!.isCanTap) {
          WDAreaLog('点击区域');
          if (isMoveArea) {///如果触发了拖拽，则不处理，因为拖拽已经处理过了
            isMoveArea = false;
          }else{
            refreshShowNode();
            checkAreaLast(touchArea!);
            if (refreshCallback != null) {
              refreshCallback();
            }
          }
          if (_tapAreaAction != null) {
            final areaIndex = areas.indexOf(touchArea!);
            _tapAreaAction?.call(touchArea!,areaIndex);
          }
      }
    }else if (touchTime != null && touchNode != null && touchNodeArea!.points.length>0 && touchNodeArea!.isShowNode) {
      ///点击在节点上
      WDAreaLog('点击节点 -- ${touchNodeArea?.isCanTap}');
      if (!touchNodeArea!.isCanTap) {
        return;
      }
      final nowTime = DateTime.now().millisecondsSinceEpoch;
      final index = touchNodeArea!.points.indexOf(touchNode!);
      final areaIndex = areas.indexOf(touchNodeArea!);
      if (_tapAreaNodeAction != null) {
        _tapAreaNodeAction!(areaIndex,index);
      }
      ///如果点击到抬起时间少于100毫秒，当作点击事件处理
      if (nowTime - touchTime!.millisecondsSinceEpoch <= 100) {
        WDAreaLog('点击了第${areaIndex}个区域的第${index}个节点');
        if (touchNode!.type == WDAreaPointType.kAdd) {
          if (touchNodeArea!.points.length < touchNodeArea!.areaSelectionConfig.maxPolygonPointCount) {
            if (touchNodeArea!.points[index-1].type == WDAreaPointType.kClose) {
              touchNodeArea!.points[index].type = WDAreaPointType.kRemove;
              touchNodeArea!.points[index].icon = touchNodeArea!.areaSelectionConfig.pointConfigs[WDAreaPointType.kRemove];
              touchNodeArea!.points.add(WDAreaPointModel(touchNodeArea!.points[index].x-50, touchNodeArea!.points[index].y,
                  type: WDAreaPointType.kAdd,icon: touchNodeArea!.areaSelectionConfig.pointConfigs[WDAreaPointType.kAdd]));
            }else{
              touchNodeArea!.points[index].type = WDAreaPointType.kCircle;
              touchNodeArea!.points[index].radius = 6;
              touchNodeArea!.points[index].icon = null;
              touchNodeArea!.points.add(WDAreaPointModel(touchNodeArea!.points[index].x-50, touchNodeArea!.points[index].y,
                  type: WDAreaPointType.kAdd,icon: touchNodeArea!.areaSelectionConfig.pointConfigs[WDAreaPointType.kAdd]));
            }
            if (refreshCallback != null) {
              refreshCallback();
            }
          }
        }else if (touchNode!.type == WDAreaPointType.kRemove){
          WDAreaLog('删除');
          if (index < touchNodeArea!.points.length - 2) {
            touchNodeArea!.points[index+1].type = WDAreaPointType.kRemove;
            touchNodeArea!.points[index+1].icon = touchNodeArea!.areaSelectionConfig.pointConfigs[WDAreaPointType.kRemove];
            touchNodeArea!.points[index+1].radius = 10;
            touchNodeArea!.points.removeAt(index);
          }else if(index == touchNodeArea!.points.length - 2){
            touchNodeArea!.points.removeAt(index);
          }
          if (refreshCallback != null) {
            refreshCallback();
          }
        }else if (touchNode!.type == WDAreaPointType.kClose){
          WDAreaLog('关闭第${areaIndex}个区域');
          areas.removeAt(areaIndex);
          if (refreshCallback != null) {
            refreshCallback();
          }
        }
        if (areaNodeTapCallback != null) {
          areaNodeTapCallback!(areaIndex,index);
        }
      }else{ ///拖拽节点，像素坐标已改变，业务上需要更新外界世界坐标应该给出去操作
        if (areaNodePanEndCallback != null) {
          areaNodePanEndCallback!(areaIndex,index);
        }
      }
    }
  }
  ///刷新节点显/隐
  void refreshShowNode({bool isMove = false}) {
    if (touchArea!.areaSelectionConfig.areaSelectedType == WDAreaSelectedType.kSelectedSingle) {
      if (isMove||!touchArea!.isShowNode) {
        for (var i=0; i<areas.length; i++) {
          areas[i].isShowNode = false;
        }
        touchArea!.isShowNode = true;
      }else{
        touchArea!.isShowNode = false;
      }
    }else if(touchArea!.areaSelectionConfig.areaSelectedType == WDAreaSelectedType.kSelectedMulti){
      if (isMove) {
        touchArea!.isShowNode = true;
      }else{
        touchArea!.isShowNode = !touchArea!.isShowNode;
      }
    }
  }
  /// 拖拽逻辑处理
  @override
  void pointerMoveAction(PointerMoveEvent detail,
      {VoidCallback? refreshCallback}) {
    WDAreaLog('pointerMoveAction  ${touchNode} -${touchArea} - ${touchNodeArea} - ${isInPath} - ${touchArea?.isCanEdit}');
    if (touchNode != null && (touchNodeArea?.isShowNode??false)) {
      ///拖拽某个区域的某个节点
      if (!touchNodeArea!.isCanEdit) {
        return;
      }
      checkAreaLast(touchNodeArea!);
      if (touchNodeArea!.areaType == WDAreaType.kRect) {
        if (touchNode!.type == WDAreaPointType.kExpand) {
          ///x坐标限制
          if (touchNodeArea!.points[1].x + detail.localDelta.dx <=
              touchNodeArea!.points[0].x + touchNodeArea!.areaSelectionConfig.rectAreaMinSize.width) {
            touchNodeArea!.points[1].x = touchNodeArea!.points[0].x + touchNodeArea!.areaSelectionConfig.rectAreaMinSize.width;
          } else {
            touchNodeArea!.points[1].x =
                touchNodeArea!.points[1].x + detail.localDelta.dx;
          }

          ///y坐标限制
          if (touchNodeArea!.points[3].y + detail.localDelta.dy <=
              touchNodeArea!.points[0].y + touchNodeArea!.areaSelectionConfig.rectAreaMinSize.height) {
            touchNodeArea!.points[3].y = touchNodeArea!.points[0].y + touchNodeArea!.areaSelectionConfig.rectAreaMinSize.height;
          } else {
            touchNodeArea!.points[3].y =
                touchNodeArea!.points[3].y + detail.localDelta.dy;
          }
          touchNode!.x = touchNodeArea!.points[1].x;
          touchNode!.y = touchNodeArea!.points[3].y;
        }
      } else {
        touchNode!.x = touchNode!.x + detail.localDelta.dx;
        touchNode!.y = touchNode!.y + detail.localDelta.dy;
      }
      if (areaNodePanCallback != null) {
        final index = touchNodeArea!.points.indexOf(touchNode!);
        final areaIndex = areas.indexOf(touchNodeArea!);
        areaNodePanCallback!(areaIndex,index);
      }
      if (refreshCallback != null) {
        refreshCallback();
      }
    } else if (isInPath) {
      ///拖拽某个区域
      if (!touchArea!.isCanEdit) {
        return;
      }
      isMoveArea = true;
      checkAreaLast(touchArea!);
      refreshShowNode(isMove: true);
      touchArea!.points.forEach((element) {
        element.x = element.x + detail.localDelta.dx;
        element.y = element.y + detail.localDelta.dy;
      });
      if (refreshCallback != null) {
        refreshCallback();
      }
    }
  }

  ///校验一下，如果当前操作的区域不是最后一个就移动到最后一个，最后一个层级最上层
  checkAreaLast(WDAreaModelProtocol areaModel){

    final index = areas.indexOf(areaModel);
    if (index != areas.length - 1) {
      final area = areas.removeAt(index);
      areas.add(area);
      if (index < areaCenters.length) {
        final areaCenter = areaCenters.removeAt(index);
        areaCenters.add(areaCenter);
      }
    }
  }

  @override
  bool get parentContainerPanEnabled{
    return (!isInPath&&(touchNode==null)&&(touchArea==null))|| !(touchArea?.isCanEdit??true) || !(touchNodeArea?.isCanEdit??true);
  }
  @override
  void listenTapAreaAction(TapAreaAction? action) {
    super.listenTapAreaAction(action);
    _tapAreaAction = action;
  }
  @override
  void listenTapAreaNodeAction(AreaNodeTapCallback action) {
    // TODO: implement listenTapAreaNodeAction
    super.listenTapAreaNodeAction(action);
    _tapAreaNodeAction = action;
  }

  @override
  void selectedArea(int areaIndex) {
    // TODO: implement selectedArea
    super.selectedArea(areaIndex);
    if (areaIndex < areas.length) {
      areas[areaIndex].isShowNode = !areas[areaIndex].isShowNode;
    }
  }
}