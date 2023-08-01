
import 'package:flutter/foundation.dart';


enum WDAreaType{
  kNone,
  kLine,//直线区域
  kRect,//矩形区域
  kPolygon,//多边形区域
}
enum WDAreaSelectedType{
  kSelectedSingle,///单选
  kSelectedMulti,///多选
}

void WDAreaLog(Object message) {
  if (!kReleaseMode){
    debugPrint('${message}',wrapWidth: 10000);
  }
}