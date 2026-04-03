
import 'dart:ui';

import '../../../IConstant.dart';

class RefundModel {
  int type;
  String name;
  bool isEnable;
  bool isSelect;
  int reasonId;

  RefundModel(
      this.type,
      this.name,
      this.isEnable,
      this.isSelect,
      this.reasonId);

  Color getBorderColor() {
    if(!isEnable) {
      return IConstant.grey_bg_color;
    }
    return isSelect ? IConstant.main_color : IConstant.line_color;
  }

  Color getBgColor() {
    if(!isEnable) {
      return IConstant.grey_bg_color;
    }
    return isSelect ? IConstant.red_bg_color : const Color(0xFFF9F9F9);
  }

  Color getTextColor() {
    if(!isEnable) {
      return IConstant.sub_text_color;
    }
    return IConstant.text_color ;
  }

}
