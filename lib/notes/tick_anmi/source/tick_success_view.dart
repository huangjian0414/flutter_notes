
import 'dart:math';

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

  late Animation _colorAnimation;
  @override
  void initState() {

    super.initState();

    widget.control.animationController = new AnimationController(
        vsync: this, duration: widget.control.activeDuration);
    _colorAnimation = ColorTween(begin: widget.control.bgColor, end: widget.control.doneBgColor)
        .animate(widget.control.animationController!);
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
        animation: widget.control.animationController!.view,
        builder: (context,child) {
          return Container(
            width: widget.control.size.width,
            height: widget.control.size.height,
            decoration: BoxDecoration(
                color: widget.control.isSuccess?
                (widget.control.needColorTransition?
                _colorAnimation.value:widget.control.doneBgColor):widget.control.bgColor,
                borderRadius: BorderRadius.circular(min(widget.control.size.width/2, widget.control.size.height/2))
            ),
            child: CustomPaint(
              painter: TickSuccessPainter(
                  widget.control.animationController!.value,
                  isSuccess: widget.control.isSuccess,
                arcColor: widget.control.activeColor,
                arcWidth: widget.control.activeWidth,
                arcStartAngle: widget.control.activeStartAngle,
                arcSweepAngle: widget.control.activeEndAngle,
                tickColor: widget.control.doneColor,
                tickWidth: widget.control.doneWidth
              ),
            ),
          );
        }
    );
  }

}

