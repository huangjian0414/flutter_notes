import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';

Future<String?> createDirectory() async {
  final Directory? directory = await getExternalStorageDirectory();
  if (Directory == null) {
    return null;
  }
  var file = Directory(directory!.path+"/wdlog");
  try {
    bool exist = await file.exists();
    if (exist == false) {
      await file.create();
    }
  } catch(e) {
    print("createDirectory error");
  }

  return file.path;
}

class LoggerManager {
  //私有构造函数
  LoggerManager._internal() {
    deleteLogsOfBefore7Day();
    initLogger();
  }

  //保存单例
  static LoggerManager _singleton = LoggerManager._internal();

  //工厂构造函数
  factory LoggerManager() => _singleton;

  Logger? logger;

  // log初始化设置
  Future<void> initLogger({String? path}) async {

    ConsoleOutput consoleOutput = ConsoleOutput();
    List<LogOutput> multiOutput = [consoleOutput];
    if (path != null) {
      print('000 -${path}');
      FileOutput fileOutPut = FileOutput(file: File(path));
      multiOutput.insert(0, fileOutPut);
    }
    if (logger != null && !logger!.isClosed()) {
      logger!.close();
      logger = null;
    }
    logger = Logger(
      filter: DevelopmentFilter(),
      printer: HybridPrinter(
          SimplePrinter(printTime: true),
      ),
      output: MultiOutput(
        multiOutput,
      ), // Use the default LogOutput (-> send everything to console)
    );
  }

  // Debug
  void debug(String message) {
    logger!.d(message);
  }

  // trace
  void trace(String message) {
    logger!.t(message);
  }

  // info
  void info(String message) {
    logger!.i(message);
  }

  // warning
  void warning(String message) {
    logger!.w(message);
  }

  // error
  void error(String message) {
    logger!.e(message);
  }

  // 每次启动只保留7天内的日志，删除7天前的日志
  Future<void> deleteLogsOfBefore7Day() async {
    // final String fileDir = await createDirectory();
    //
    // // 获取目录的所有文件
    // var dir = Directory(fileDir);
    // Stream<FileSystemEntity> file = dir.list();
    // await for (FileSystemEntity x in file) {
    //   // 获取文件的的名称
    //   List<String> paths = x.path.split('/');
    //   if (paths.isNotEmpty) {
    //     String logName = paths.last.replaceAll('.log', '');
    //     final logDate = DateUtil.getDateTime(logName);
    //     final currentDate = DateTime.now();
    //     //比较相差的天数
    //     if (logDate != null) {
    //       final difference = currentDate.difference(logDate!).inDays;
    //       print("deleteLogsOfBefore7Day logDate:${logDate}, currentDate:${currentDate}, difference:${difference}");
    //       if (difference > 7) {
    //         var file = File(x.path);
    //         // 删除文件
    //         file.delete();
    //       }
    //     }
    //   }
    // }
  }
}
