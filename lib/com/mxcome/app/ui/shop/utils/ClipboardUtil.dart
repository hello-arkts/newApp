import 'package:flutter/services.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';

//复制粘贴
class ClipboardUtil {

  //复制内容
  static setData(String data) {
    if (data != '') {
      Clipboard.setData(ClipboardData(text: data));
    }
  }

  //复制内容
  static setDataToast(String data) {
    if (data != '') {
      Clipboard.setData(ClipboardData(text: data));
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_copy_success));
    }
  }

  //获取内容
  static Future<ClipboardData?> getData() {
    return Clipboard.getData(Clipboard.kTextPlain);
  }

}
