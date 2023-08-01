import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:path_provider/path_provider.dart';
import 'wdlogger_trace.dart';


class WDLogger {

  WDLogger._internal() {}
  static WDLogger _singleton = WDLogger._internal();

  factory WDLogger() => _singleton;
  ///是否print
  bool printEnable = false;
  File? file;
  bool overrideExisting = false;
  Encoding encoding = utf8;
  ///是否展示日志打印的文件位置，行数
  bool showFileRow = false;
  ///日志保存时间，默认7天，会根据文件路径去删除当前文件夹下的文件
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
    await logger.checkDeleteLogs(saveTime);
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
      final date = DateTime.now();
      var file = File(directory!.path+"/wdlog/${date.year}_${date.month}_${date.day}.log");
      WDLogger.d('default file path --- ${file}');
      try {
        bool exist = await file.exists();
        if (!exist) {
          return await file.create(recursive: true);
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
        return await file.create(recursive: true);
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
    logger._d(message,StackTrace.current);
  }
  _d(Object message,StackTrace trace){
    final date = DateTime.now();
    String time = '${date.year}-${date.month}-${date.day} ${date.hour}:${date.month}:${date.second}:${date.millisecond}';
    if (printEnable){
      log("Time: ${time} ( Msg: $message ${getStackTraceInfo(trace)} )");
    }
    var output = StringBuffer('Time: ${time} ');
    if (message is String) {
      output.write("( Msg: $message ${getStackTraceInfo(trace)} )");
    } else{
      output.write("( Msg: ${message.toString()} ${getStackTraceInfo(trace)} )");
    }
    _sink?.writeAll([output.toString()], '\n');
    _sink?.writeln();
  }

  String getStackTraceInfo(StackTrace trace){
    if (!showFileRow) {
      return '';
    }
    WDLoggerTrace programInfo = WDLoggerTrace(trace);
    return '-- File: ${programInfo.fileName} -- Row: ${programInfo.lineNumber}';
  }
  ///校验删除过期的日志文件
  Future checkDeleteLogs(int day) async {
    if (this.file == null) {
      return;
    }
    String path = this.file!.path;
    final index = path.lastIndexOf('/');
    path = path.substring(0,index);
    var dir = Directory(path);
    bool exist = await dir.exists();
    if (!exist) {
      return;
    }
    Stream<FileSystemEntity> file = dir.list();
    await for (FileSystemEntity x in file) {
      final fileCreateTime = x.statSync().accessed;
      final currentDate = DateTime.now();
      final difference = currentDate.difference(fileCreateTime).inDays;
      if (difference >= 0) {
        x.delete();
      }
    }
  }
}