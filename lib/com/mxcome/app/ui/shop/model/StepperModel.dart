
import 'dart:ui';

import '../../../IConstant.dart';

class StepperModel {
  String title;
  double size;
  bool isFinish;
  bool isSelect;


  StepperModel(
      this.title,
      this.size,
      this.isFinish,
      this.isSelect);

  Color getBorderColor() {
    return isSelect ? IConstant.grey_bg_color : IConstant.main_color;
  }

}
