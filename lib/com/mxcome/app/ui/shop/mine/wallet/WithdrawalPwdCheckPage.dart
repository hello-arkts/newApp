import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/Logger.dart';
import 'package:mxcome/com/mxcome/app/widget/PasswordField.dart';
import 'package:mxcome/com/mxcome/app/widget/PasswordKeyboard.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IURLConstant.dart';
import '../../../../config/LanguageConfig.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/HttpUtils.dart';
import '../../../../utils/ViewUtils.dart';
import '../../widget/PriceText.dart';

class WithdrawalPwdCheckPage extends StatefulWidget {

  double amount = 0;

  double feeWithdraw = 0;

  Function(BuildContext context) callBack;

  WithdrawalPwdCheckPage(this.amount, this.feeWithdraw, this.callBack);

  @override
  State<StatefulWidget> createState() {
    return WithdrawalPwdCheckPageState();
  }
}

class WithdrawalPwdCheckPageState extends BaseKeepAliveState<WithdrawalPwdCheckPage> {

  String pwdText = '';

  @override
  void initState() {
    super.initState();
    Logger.log("---feeWithdraw: ${widget.feeWithdraw}");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 25.w),
          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_please_enter_pwd),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 16.w),
          child: PriceText(widget.amount, fontSize: 24.sp, fontWeight: FontWeight.bold, textAlign: TextAlign.right),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20.w, 16.w, 20.w, 0.w),
          color: IConstant.line_color,
          height: 1.w,
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 00.w),
          child: Row(
            children: [
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_wallet_service_fee), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
              expandeSpace,
              PriceText(getFee(), fontSize: 14.sp, color: IConstant.text_color),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 00.w),
          child: Row(
            children: [
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_wallet_fee_rate), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
              expandeSpace,
              Text("${widget.feeWithdraw}%", style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.all(30.w),
          width: double.infinity,
          height: 50.w,
          child: PasswordField(pwdText),
        ),
        expandeSpace,
        PasswordKeyboard((ctx, item) => {
          setState(() {
            if (item == "del") {
              pwdText = pwdText.substring(0, pwdText.length - 1);
            } else {
              if (pwdText.length < 6) {
                pwdText += item;
                autoSubmit();
              }
            }
          })
        }),
      ],
    );
  }

  double getFee() {
    return widget.amount * widget.feeWithdraw / 100;
  }


  Future<void> autoSubmit() async {
    if (pwdText.length == 6) {
      await Future.delayed(const Duration(milliseconds: 300), () {
        checkPayPwd();
      });
    }
  }

  Future<void> checkPayPwd() async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_CHECK_PAY_PASSWORD, {
      "password": pwdText
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      widget.callBack(context);
    } else {
      pwdText = "";
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_order_pay_pwd_error));
    }
    ViewUtils.dismiss();
  }

}
 