

import 'package:flutter/material.dart';
import 'package:flutter_notes/notes/round_rotate/round_rotate_paint.dart';

class RoundRotateDemo extends StatefulWidget {
  const RoundRotateDemo({Key? key}) : super(key: key);

  @override
  State<RoundRotateDemo> createState() => _RoundRotateDemoState();
}

class _RoundRotateDemoState extends State<RoundRotateDemo>  with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this,duration: Duration(seconds: 3));
    _controller.repeat();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('圆球进度效果'),
      ),
      body: Center(
        child: Container(
          child: CustomPaint(
            foregroundPainter: RoundRotatePainter(),
          ),
        ),
      ),
    );
  }
}
