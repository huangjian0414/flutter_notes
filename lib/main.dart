
import 'package:flutter/material.dart';
import 'notes/raddar_scan/raddar_scan_demo.dart';
import 'notes/round_rotate/round_rotate_demo.dart';


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
    ];
  }
}
