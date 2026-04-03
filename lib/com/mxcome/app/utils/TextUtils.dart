
import 'package:mxcome/com/mxcome/app/Logger.dart';

class TextUtils {
  static bool isEmpty(dynamic str) {
    return str == null || str.toString().isEmpty;
  }

  static bool isNotEmpty(dynamic str) {
    return !isEmpty(str);
  }

  static void println(Object? obj) {
    Logger.info(obj);
  }

}
