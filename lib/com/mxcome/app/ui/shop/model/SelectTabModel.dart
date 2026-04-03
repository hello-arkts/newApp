
import 'package:flutter/material.dart';

import '../../../IConstant.dart';

class SelectTabModel {

  int type;
  bool isSelect;

  SelectTabModel(
      this.type,
      this.isSelect);

  Color getTextColor() {
    if (isSelect) {
      return IConstant.main_color;
    } else {
      return IConstant.text_color;
    }
  }

  Color getBgColor() {
    if (isSelect) {
      return IConstant.main_color;
    } else {
      return Colors.transparent;
    }
  }

}
