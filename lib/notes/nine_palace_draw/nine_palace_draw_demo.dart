
import 'package:flutter/material.dart';

class NinePalaceDrawDemo extends StatefulWidget {
  @override
  _LotteryScreenState createState() => _LotteryScreenState();
}

class _LotteryScreenState extends State<NinePalaceDrawDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  int _selectedIndex = -1;
  bool _isAnimating = false;

  List<String> _items = [
    '奖品1',
    '奖品2',
    '奖品3',
    '奖品4',
    '奖品5',
    '奖品6',
    '奖品7',
    '奖品8',
    '奖品9',
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _animation = StepTween(begin: 0, end: 8).animate(CurvedAnimation(parent: _animationController, curve: Curves.ease),);

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isAnimating = false;
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _selectedIndex = -1;
    _isAnimating = true;

    _animationController.reset();
    _animationController.repeat();
  }

  void _onItemTap(int index) {
    if (!_isAnimating) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('九宫格抽奖动画'),
      ),
      body: Center(
        child: AnimatedBuilder(
            animation: _animation,
          builder: (context,child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _onItemTap(index),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _animation.value == index
                                ? Colors.red
                                : Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _items[index],
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _startAnimation,
                  child: Text('开始抽奖'),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
