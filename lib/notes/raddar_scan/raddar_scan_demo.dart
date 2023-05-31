

import 'package:flutter/material.dart';
import 'package:flutter_notes/notes/raddar_scan/source/radar_scan_config.dart';

import 'source/radar_scan_view.dart';

class RaddarScanDemo extends StatelessWidget {
  const RaddarScanDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('雷达扫描'),
      ),
      body: Center(
        child: Container(child: RadarScanView(
          config: RadarScanConfig(showMiddleline: true),
        ),color: Colors.white,width: double.infinity,height: double.infinity,),
      ),
    );
  }
}
