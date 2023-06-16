
import 'package:flutter/material.dart';

import 'tick_success_control.dart';
import 'tick_success_painter.dart';

class TickSuccessView extends StatefulWidget {
  TickSuccessControl control;
  TickSuccessView({Key? key,
    required this.control
  }) : super(key: key);

  @override
  State<TickSuccessView> createState() => _TickSuccessViewState();
}

class _TickSuccessViewState extends State<TickSuccessView> with TickerProviderStateMixin {

  @override
  void initState() {

    super.initState();

    widget.control.animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    widget.control.animationController!.repeat();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.control.animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.control.animationController!,
        builder: (context,child) {
          return Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10)
            ),
            child: CustomPaint(
              painter: PathPainter(widget.control.animationController!.value,isSuccess: widget.control.isSuccess),
            ),
          );
        }
    );
  }

}

