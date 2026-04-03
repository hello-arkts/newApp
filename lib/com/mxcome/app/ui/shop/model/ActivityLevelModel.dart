import 'dart:ui';

import 'package:mxcome/com/mxcome/app/IConstant.dart';

class ActivityLevelModel {
  int index;
  String title;
  int level;
  bool isSelect;

  ActivityLevelModel(this.index, this.title, this.level, this.isSelect);

  Color getBgColor() {
    if (isSelect) {
      return IConstant.black_color;
    } else {
      return IConstant.line_color;
    }
  }

  Color getTextColor() {
    if (isSelect) {
      return IConstant.white_color;
    } else {
      return IConstant.text_color;
    }
  }

  int getLevel() {
    return level;
  }

}
