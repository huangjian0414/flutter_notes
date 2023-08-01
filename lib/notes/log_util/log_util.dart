
import 'dart:async';
import 'dart:isolate';

class WDLogUtil {
  static final WDLogUtil _instance = WDLogUtil._internal();

  List<String> logs = [];
  SendPort? _sendPort;
  factory WDLogUtil() {
    return _instance;
  }

  WDLogUtil._internal() {
    _init();
  }

  _init() async{
    // 创建管道
    ReceivePort receivePort= ReceivePort();
    Future iso = Isolate.spawn(doWork, receivePort.sendPort,debugName: 'WDLog');
    iso.then((value) {
      receivePort.listen((data) {
        print('receiveData：$data');
        if (data is SendPort) {
          _sendPort = data;
        }
      });
    });
    print('WDLogUtil -- init');
    Timer.periodic(Duration(milliseconds: 1000), (timer) async{
      await sendLogs();
    });
  }
  sendLogs() async{
    if (_sendPort != null && logs.isNotEmpty) {
      print('发送消息');
      _sendPort!.send(logs);
      logs.clear();
    }
  }

}


doWork(SendPort port){
  final receivePort2 = new ReceivePort();
  port.send(receivePort2.sendPort);
  receivePort2.listen((message) {
    print("receivePort2接收到消息--$message");

  });
}