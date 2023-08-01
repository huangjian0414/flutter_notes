
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notes/notes/log_util/log_manager.dart';
import 'package:flutter_notes/notes/log_util/wd_logtool.dart';
import 'package:flutter_notes/notes/rotate/rotate_lottery_demo.dart';
import 'notes/log_util/log_util.dart';
import 'notes/raddar_scan/raddar_scan_demo.dart';
import 'notes/round_rotate/round_rotate_demo.dart';
import 'notes/tick_anmi/tick_success_demo.dart';
import 'notes/wd_area_selection/area_selection_demo.dart';
import 'dart:isolate';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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

    WDLogger.initLogger(printEnable: true).then((value) {
      Timer.periodic(Duration(milliseconds: 500), (timer) {
        WDLogger.d('message --- ${timer.tick}');
        WDLogger.d({'11':'232','22':'65'});
        WDLogger.d(Colors.cyan);
      });
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Notes'),
        actions: [
          CircularProgressIndicator(color: Colors.red,),
          SizedBox(width: 120,)
        ],
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