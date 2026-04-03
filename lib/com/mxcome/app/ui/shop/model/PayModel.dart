
import 'dart:ui';

import '../../../IConstant.dart';

class PayModel {
  String bankCode;	//银行code
  String title;	//银行名称
  int payType; //1：分期付，2：银行卡支付，3：第三方支付，4：余额付
  bool isSelect;

  PayModel(
      this.bankCode,
      this.title,
      this.payType,
      this.isSelect,
  );

  Color getBgColor() {
    return isSelect ? IConstant.red_bg_color3 : IConstant.white_color;
  }

  Color getBorderColor() {
    return isSelect ? IConstant.main_color : IConstant.line_color;
  }

}
