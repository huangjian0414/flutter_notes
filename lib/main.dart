
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notes/notes/rotate/rotate_lottery_demo.dart';
import 'notes/raddar_scan/raddar_scan_demo.dart';
import 'notes/round_rotate/round_rotate_demo.dart';
import 'notes/tick_anmi/tick_success_demo.dart';
import 'notes/wd_area_selection/area_selection_demo.dart';
import 'package:wd_screen_button/wd_screen_button.dart';
import 'package:wdlogger/wdlogger.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WDLogger.registerNavigatorKey(navigatorKey);
    WDLogger.initLogger(printEnable: true,needLogEntry: true).then((value) {
      Timer.periodic(Duration(milliseconds: 500), (timer) {
        WDLogger.d('message --- ${timer.tick}');
      });
    });

    // WDScreenButton.initConfig(
    //   navigatorKey,
    //   left: 30,
    //   top: 100,
    //   isShowBtn: true,
    //   callBack: () {
    //     // 点击按钮触发的操作
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Notes'),
      ),
      body: Center(
        child: SafeArea(
          child: ListView.builder(itemBuilder: (ctx,index){
            return Container(
              height: 40,
              child: Center(child: TextButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return getTitles()[index]['page'];
                }));
              },child: Text(getTitles()[index]['title']),)),
            );
          },itemCount: getTitles().length,padding: EdgeInsets.symmetric(vertical: 20),),
        ),
      ),
    );
  }

  List getTitles(){
    return [
      {
        'title':'雷达扫描',
        'page':  RaddarScanDemo()
      },
      {
        'title':'圆球进度效果',
        'page':  RoundRotateDemo()
      },
      {
        'title':'进度完成打勾效果',
        'page':  TickSuccessDemo()
      },
      {
        'title':'抽奖大转盘',
        'page':  WheelDemo()
      },
      {
        'title':'区域选择',
        'page':  AreaSelectionDemo()
      },
    ];
  }

}