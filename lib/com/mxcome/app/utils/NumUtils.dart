
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';

class NumUtils {

  static bool isCNPhoneNumber(String input) {
    String regexMobile = "^1[3456789]\\d{9}\$";
    return input.isNotEmpty && matches(regexMobile, input);
  }

  static bool isTHPhoneNumber(String input) {
    String regexMobile = r"^.{9,10}$";
    return input.isNotEmpty && matches(regexMobile, input);
  }

  static bool matches(String regex, String input) {
    if (input.isEmpty) return false;
    return RegExp(regex).hasMatch(input);
  }

  static bool isEmail(String email) {
    if (TextUtils.isEmpty(email)) return false;
    const pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

}