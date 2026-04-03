import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';

class PrizeTabModel {

  int index;
  String title;
  bool isSelect;

  PrizeTabModel(this.index, this.title, this.isSelect);

  Color getBgColor() {
    if (isSelect) {
      return IConstant.main_color;
    } else {
      return Colors.transparent;
    }
  }
  
}
