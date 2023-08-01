import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:path_provider/path_provider.dart';



class WDLogger {

  WDLogger._internal() {}
  static WDLogger _singleton = WDLogger._internal();

  factory WDLogger() => _singleton;
  ///是否print
  bool printEnable = false;
  File? file;
  bool overrideExisting = false;
  Encoding encoding = utf8;
  bool showFileRow = false;
  int saveTime = 7;
  IOSink? _sink;

  ///初始化，返回文件是否开启成功,print正常使用
  static Future<bool> initLogger(
      {String? path,
        bool printEnable = false,
        bool overrideExisting = false,
        Encoding encoding = utf8,
        bool showFileRow = false,
        int saveTime = 7}) async {
    final logger = WDLogger();
    logger.printEnable = printEnable;
    logger.overrideExisting = overrideExisting;
    logger.encoding = encoding;
    logger.showFileRow = showFileRow;
    logger.saveTime = saveTime;
    await logger.checkDeleteLogs(saveTime);
    File? file;
    if (path == null) {
      file = await logger.getDefaultFile();
    }else{
      file = await logger.checkPath(path);
      if (file == null) {
        file = await logger.getDefaultFile();
      }
    }
    if (file == null) {
      return false;
    }
    WDLogger.d('file check success -- ${file}');
    logger.destroy();
    logger.file = file;
    logger._sink = logger.file!.openWrite(
      mode: overrideExisting ? FileMode.writeOnly : FileMode.writeOnlyAppend,
      encoding: encoding
    );
    return true;
  }
  ///获取默认存储文件
  Future<File?> getDefaultFile() async{
    if (Platform.isAndroid) {
      final Directory? directory = await getExternalStorageDirectory();
      if (Directory == null) {
        return null;
      }
      var dir = Directory(directory!.path+"/wdlog");
      try {
        bool exist = await dir.exists();
        if (!exist) {
          await dir.create();
        }
      } catch(e) {
        return null;
      }
      final date = DateTime.now();
      var file = File(directory!.path+"/wdlog/${date.year}_${date.month}_${date.day}.log");
      WDLogger.d('default file path --- ${file}');
      try {
        bool exist = await file.exists();
        if (!exist) {
          return await file.create();
        }else{
          return file;
        }
      } catch(e) {
        return null;
      }
    }
    return null;
  }
  ///传入的path校验
  Future<File?> checkPath(String path) async{
    var file = File(path);
    try {
      bool exists = await file.exists();
      if (!exists) {
        return await file.create();
      }
      return Future.value(file);
    } catch (e) {
      return Future.error(e);
    }
  }
  ///释放
  Future<void> destroy() async {
    if (_sink != null) {
      await _sink?.flush();
      await _sink?.close();
    }
    this.file = null;
  }
  ///打印日志
  static d(Object message) {
    final logger = WDLogger();
    logger._d(message);
  }
  _d(Object message){
    final date = DateTime.now();
    String time = '${date.year}-${date.month}-${date.day} ${date.hour}:${date.month}:${date.second}:${date.millisecond}';
    if (printEnable){
      log("Time: ${time} ( Msg: $message ${getStackTraceInfo()} )");
    }
    var output = StringBuffer('Time: ${time} ');
    if (message is String) {
      output.write("( Msg: $message ${getStackTraceInfo()} )");
    } else{
      output.write("( Msg: ${message.toString()} ${getStackTraceInfo()} )");
    }
    _sink?.writeAll([output.toString()], '\n');
    _sink?.writeln();
  }

  String getStackTraceInfo(){
    if (!showFileRow) {
      return '';
    }
    WDCustomTrace programInfo = WDCustomTrace(StackTrace.current);
    return '-- File: ${programInfo.fileName} -- Row: ${programInfo.lineNumber}';
  }

  Future checkDeleteLogs(int day) async {
    // 获取目录的所有文件
    final Directory? directory = await getExternalStorageDirectory();
    if (Directory == null) {
      return;
    }
    var dir = Directory(directory!.path+"/wdlog");
    bool exist = await dir.exists();
    if (!exist) {
      return;
    }
    Stream<FileSystemEntity> file = dir.list();
    await for (FileSystemEntity x in file) {
      final fileCreateTime = x.statSync().accessed;
      final currentDate = DateTime.now();
      final difference = currentDate.difference(fileCreateTime).inDays;
      if (difference > day) {
        var file = File(x.path);
        file.delete();
      }
    }
  }
}

class WDCustomTrace {
  final StackTrace _trace;
  String fileName = '';
  int lineNumber = 0;
  int columnNumber = 0;


  WDCustomTrace(this._trace) {
    _parseTrace();
  }

  void _parseTrace() {
    var traceString = this._trace.toString().split("\n")[0];
    var indexOfPackage = traceString.indexOf('(');
    var indexOfFileName = traceString.indexOf('.dart');
    // var indexOfFileName = traceString.indexOf(RegExp(r'[A-Za-z_]+.dart'));
    if(indexOfFileName+5>traceString.length){
      return;
    }
    if(indexOfPackage+1>indexOfFileName+5){
      return;
    }
    var filePath = traceString.substring(indexOfPackage+1,indexOfFileName+5);
    var fileInfo = traceString.substring(indexOfFileName);
    var listOfInfos = fileInfo.split(":");
    // this.fileName = listOfInfos[0];
    this.fileName = filePath;
    this.lineNumber = int.parse(listOfInfos[1]);
    var columnStr = listOfInfos[2];
    columnStr = columnStr.replaceFirst(")", "");
    this.columnNumber = int.parse(columnStr);
  }
}