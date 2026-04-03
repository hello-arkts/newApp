
class Logger {

  static const int _maxLen = 512;

  static void log(Object? object) {
    _printLog('log', object?.toString());
  }

  static void info(Object? object) {
    _printLog('info', object?.toString());
  }

  static void warn(Object? object) {
    _printLog('warn', object);
  }

  static void error(Object? object) {
    _printLog('error', object);
  }

  static void _printLog(String? tag, Object? object) {
    String dest = object?.toString() ?? 'null';
    if (dest.length <= _maxLen) {
      print('$tag $dest');
      return;
    }
    print('------ $tag 开始 ------');
    while (dest.isNotEmpty) {
      if (dest.length > _maxLen) {
        print(dest.substring(0, _maxLen));
        dest = dest.substring(_maxLen, dest.length);
      } else {
        print(dest);
        dest = '';
      }
    }
    print('------- $tag 结束 ------');
  }

}
