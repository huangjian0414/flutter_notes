class WDLoggerTrace {
  final StackTrace _trace;
  String fileName = '';
  int lineNumber = 0;
  int columnNumber = 0;


  WDLoggerTrace(this._trace) {
    _parseTrace();
  }

  void _parseTrace() {
    List<String> traceStringList = this._trace.toString().split("\n");
    if (traceStringList.length < 2) {
      return;
    }
    var traceString = traceStringList[1];
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