import 'dart:ui';

import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/LevelGiftModel.dart';

class LotteryLevelModel {
  String title;
  bool isSelect;
  int level;

  LotteryLevelModel(this.title, this.level, this.isSelect);

  Color getBgColor() {
    if (isSelect) {
      return IConstant.main_color;
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
