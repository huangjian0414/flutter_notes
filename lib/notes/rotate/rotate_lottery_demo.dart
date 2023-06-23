import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';


class WheelDemo extends StatefulWidget {
  @override
  _WheelPageState createState() => _WheelPageState();
}

class _WheelPageState extends State<WheelDemo> {
  final List<WheelItem> wheelItems = [];

  double startAngle = 0.0;
  double endAngle = 0.0;
  bool isSpinning = false;
  int selectedItemIndex = -1;
  Timer? _timer;

  List<Color> _colors = [];

  // 初始旋转速度
  double _rotationSpeed = pi/18;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var i=0; i<8; i++) {
      final color = getOtherColor();
      final text = '奖品${i+1}';
      final item = WheelItem(text: text, normalColor: color);
      wheelItems.add(item);
    }
  }
  getOtherColor(){
    Random random = Random();
    final tempColor = Color.fromARGB(255, random.nextInt(255), random.nextInt(255), random.nextInt(255));
    if (_colors.contains(tempColor)) {
      return getOtherColor();
    }
    _colors.add(tempColor);
    return tempColor;
  }


  void spinWheel() {
    if (isSpinning) return;
    isSpinning = true;

    // 随机选择一个奖项
    Random random = Random();
    int index = random.nextInt(wheelItems.length);
    selectedItemIndex = index;
    print('抽中了 奖品 ${selectedItemIndex+1}');

    final itemAngle = 2*pi/wheelItems.length;
    final startAng = itemAngle * index;
    double startSpace = 2*pi/4*3 - startAng;

    if (2*pi/4*3 - startAng < 0) {
      startSpace = startSpace + 2*pi;
    }

    // 计算旋转角度
    int randomAngle = random.nextInt((itemAngle/2*100).toInt());
    endAngle = startSpace + 2*pi * 4 - randomAngle/100;

    // 开始旋转
    startAngle = 0.0;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        startAngle += _rotationSpeed;
        if (startAngle >= endAngle) {
          startAngle = endAngle;
          timer.cancel();
          isSpinning = false;
        }
      });
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('抽奖大转盘'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: isSpinning ? null : spinWheel,
          child: CustomPaint(
            size: Size(300, 300),
            painter: WheelPainter(
              wheelItems: wheelItems,
              startAngle: startAngle,
              textSize: 16,
            ),
          ),
        ),
      ),
    );
  }

}



class WheelPainter extends CustomPainter {
  final List<WheelItem> wheelItems;
  final double startAngle;
  Paint wheelPaint = Paint()..color = Colors.orange;
  Paint highlightPaint = Paint()..color = Colors.red;
  Paint textPaint = Paint()..color = Colors.white;
  final double textSize;

  Paint selectedPaint = Paint()
    ..color = Colors.greenAccent
    ..strokeWidth = 2;

  WheelPainter({
    required this.wheelItems,
    this.startAngle = 0.0,
    this.textSize = 16.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    canvas.save();

    // 绘制转盘
    canvas.drawCircle(
      Offset(radius, radius),
      radius,
      wheelPaint,
    );

    // 绘制每个扇形区域
    double sweepAngle = 2*pi / wheelItems.length;
    double start = startAngle;
    for (int i = 0; i < wheelItems.length; i++) {
      wheelPaint.color = wheelItems[i].normalColor;
      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(radius, radius),
          radius: radius,
        ),
        start,
        sweepAngle,
        true,
        i == -1 ? highlightPaint : wheelPaint,
      );
      start += sweepAngle;
    }

    // 绘制文本
    for (int i = 0; i < wheelItems.length; i++) {
      TextSpan span = TextSpan(
        text: wheelItems[i].text,
        style: TextStyle(
          color: Colors.white,
          fontSize: textSize,
        ),
      );
      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      double angle = startAngle + sweepAngle * i + sweepAngle / 2;
      double x = radius + radius / 2 * cos(angle) - tp.width / 2;
      double y = radius + radius / 2 * sin(angle) - tp.height / 2;
      canvas.save();
      canvas.translate(x, y);
      tp.paint(canvas, Offset.zero);
      canvas.restore();
    }

    canvas.restore();

    canvas.drawLine(Offset(radius, radius), Offset(radius, 0-20), selectedPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class WheelItem {
  final String text;
  final Color normalColor;

  WheelItem({required this.text,required this.normalColor});
}
