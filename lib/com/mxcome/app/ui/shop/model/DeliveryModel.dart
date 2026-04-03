
import 'dart:ui';

import '../../../IConstant.dart';

class DeliveryModel {

  int type; //1：平邮，2：快递，3：泰国邮政
  String title;	//银行名称
  bool isSelect;
  List<dynamic> dataList;

  DeliveryModel(
      this.type,
      this.title,
      this.isSelect,
      this.dataList,
  );

  Color getBgColor() {
    return isSelect ? IConstant.red_bg_color3 : IConstant.white_color;
  }

  Color getBorderColor() {
    return isSelect ? IConstant.main_color : IConstant.line_color;
  }

}
