import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/PayModel.dart';
import 'package:mxcome/com/mxcome/app/widget/PasswordField.dart';
import 'package:mxcome/com/mxcome/app/widget/PasswordKeyboard.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IURLConstant.dart';
import '../../../../config/LanguageConfig.dart';
import '../../../../model/BaseModel.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/HttpUtils.dart';
import '../../../../utils/ViewUtils.dart';
import '../../widget/PriceText.dart';

class CheckPayPwdPage extends StatefulWidget {

  dynamic order;

  PayModel? payModel;

  Function(BuildContext context) callBack;

  CheckPayPwdPage(this.order, this.payModel, this.callBack);

  @override
  State<StatefulWidget> createState() {
    return CheckPayPwdPageState();
  }
}

class CheckPayPwdPageState extends BaseKeepAliveState<CheckPayPwdPage> {

  String pwdText = '';

  @override
  void initState() {
    super.initState();
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
          child: PriceText(BaseModel.getDouble(widget.order, "payAmount"), fontSize: 24.sp, fontWeight: FontWeight.bold, textAlign: TextAlign.right),
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
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_payment_type), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
              expandeSpace,
              Text(getPayType(), style: TextStyle(fontSize: 14.sp, color: IConstant.main_color)),
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

  String getPayType() {
    if (widget.payModel?.payType == 2) {
      if (widget.payModel?.bankCode == "004") {
        return LanguageConfig.get(LanguageConfigKeys.Shop_order_kbank_pay);
      } else {
        return LanguageConfig.get(LanguageConfigKeys.Shop_order_scb_pay);
      }
    } else if (widget.payModel?.payType == 3) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_order_prompt_pay);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_order_balance_pay);
    }
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
 