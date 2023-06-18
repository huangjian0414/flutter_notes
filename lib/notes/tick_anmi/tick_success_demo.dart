

import 'package:flutter/material.dart';
import 'package:flutter_notes/notes/tick_anmi/source/tick_success_control.dart';

import 'source/tick_success_view.dart';


class TickSuccessDemo extends StatefulWidget {
  const TickSuccessDemo({Key? key}) : super(key: key);

  @override
  State<TickSuccessDemo> createState() => _TickSuccessDemoState();
}

class _TickSuccessDemoState extends State<TickSuccessDemo> {

  bool isSuccess = false;
  TickSuccessControl control = TickSuccessControl(needColorTransition: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('进度完成打勾效果'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TickSuccessView(control: control,),
            TextButton(onPressed: (){
              setState(() {
                isSuccess = !isSuccess;
                control.updateStatus(isSuccess);
              });
            }, child: Text('${isSuccess?'重置':'完成'}')),
          ],
        )
      ),
    );
  }
}
