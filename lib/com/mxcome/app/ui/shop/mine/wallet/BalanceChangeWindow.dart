
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/IURLConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseRsp.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/SmallTextButton.dart';
import 'package:mxcome/com/mxcome/app/utils/Adapt.dart';
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import 'package:sprintf/sprintf.dart';


class BalanceChangeWindow extends StatefulWidget {

  String balanceInfoId;

  double changeBalance;

  BalanceChangeWindow(this.changeBalance, this.balanceInfoId);

  @override
  State<StatefulWidget> createState() {
    return BalanceChangeWindowState();
  }

}

class BalanceChangeWindowState extends BaseKeepAliveState<BalanceChangeWindow> {

  double _changeBalance = 0;

  @override
  void initState() {
    super.initState();
    _changeBalance = widget.changeBalance;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    String balanceWindowTip1 = LanguageConfig.get(LanguageConfigKeys.shop_home_balance_window_tip_1);
    String balanceWindowTip2 = LanguageConfig.get(LanguageConfigKeys.shop_home_balance_window_tip_2);
    var tip1 = balanceWindowTip1.split("|");
    var tip2 = balanceWindowTip2.split("|");
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.w),
      child: Column(
        children: [
          Image.asset("assets/icons/bg_home_balance_window.png", height: 162.w, fit: BoxFit.cover),
          SizedBox(height: 25.w,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(tip1[0], style: TextStyle(fontSize: 15.sp, color: IConstant.text_color,),),
              PriceText(_changeBalance, fontSize: 15.sp, fontWeight: FontWeight.bold,),
              Text(tip1[1], style: TextStyle(fontSize: 15.sp, color: IConstant.text_color,),),
            ],
          ),
          SizedBox(height: 5.w,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(tip2[0], style: TextStyle(fontSize: 15.sp, color: IConstant.text_color,),),
              Text(tip2[1], style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: IConstant.text_color,),),
            ],
          ),
          SizedBox(height: 40.w,),
          InkWell(
            onTap: () {
              endBalanceWindow();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 66.w, vertical: 10.w),
              decoration: ShapeDecoration(
                color: const Color(0xFFFEF5F5),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.w, color: IConstant.main_color),
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              child: Text(
                LanguageConfig.get(LanguageConfigKeys.ViewUtils_confirm),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: IConstant.main_color,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> endBalanceWindow() async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_SSO_END_BALANCE_WINDOW, {'balanceInfoId' : widget.balanceInfoId});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      finish();
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

}
