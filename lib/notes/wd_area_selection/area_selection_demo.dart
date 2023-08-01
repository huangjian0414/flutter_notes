
import 'package:flutter/material.dart';
import 'package:flutter_notes/notes/wd_area_selection/wd_areamodel_protocol.dart';

import 'manager/wd_area_manager.dart';
import 'wd_area_point_model.dart';
import 'wd_area_selection_defines.dart';
import 'wd_area_view.dart';


class AreaSelectionDemo extends StatefulWidget {
  @override
  _AreaSelectionState createState() => _AreaSelectionState();
}

class _AreaSelectionState extends State<AreaSelectionDemo>{

  final _manager = WDAreaManager();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final areaModel = AreaModel();
    areaModel.points = [
      WDAreaPointModel(0, 0, type: WDAreaPointType.kNone),
      WDAreaPointModel(50, 0,
          type: WDAreaPointType.kClose,
          icon: Icon(Icons.close)),
      WDAreaPointModel(50, 50,
          type: WDAreaPointType.kExpand,
          icon: Icon(Icons.arrow_right_alt)),
      WDAreaPointModel(0, 50, type: WDAreaPointType.kNone),
    ];
    _manager.areas = [areaModel];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('区域选择'),
      ),
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          color: Colors.blue,
          child: WDAreaView(
            areaManager: _manager,
            refreshCallback: () {
              setState(() {});
            },
            onDoubleTap: () {

            },
            child: Container(color: Colors.white,),
          ),
        ),
      ),
    );
  }

}

class AreaModel extends WDAreaModelProtocol {

  @override
  // TODO: implement areaType
  WDAreaType get areaType => WDAreaType.kRect;
}

