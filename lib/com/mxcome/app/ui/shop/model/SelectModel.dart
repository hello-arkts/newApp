
import 'dart:ui';

import '../../../IConstant.dart';

class SelectModel {
  String icon =  "";
  String name;
  String value;
  bool isSelect;

  SelectModel(
      this.name,
      this.value,
      this.isSelect, {this.icon = ""});

  Color getBorderColor() {
    return isSelect ? IConstant.main_color : IConstant.line_color;
  }

  Color getBgColor() {
    return isSelect ? IConstant.red_bg_color : const Color(0xFFF9F9F9);
  }


  Color getIconColor() {
    return isSelect ? IConstant.main_color : IConstant.text_color;
  }

}
