
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


class RedLevelPage extends StatefulWidget {

  String redActivityId;

  double amount;

  Function(BuildContext context)? callBack;

  RedLevelPage(this.amount, this.redActivityId, {this.callBack});

  @override
  State<StatefulWidget> createState() {
    return RedLevelPageState();
  }

}

class RedLevelPageState extends BaseKeepAliveState<RedLevelPage> {

  double _amount = 0;

  @override
  void initState() {
    super.initState();
   _amount = widget.amount;
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        leading: Container(),
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_successfully_crossed),
            style: TextStyle(fontSize: 17.w, color: IConstant.text_color)),
      ),
      body: Column(
        children: [
          Container(
            width: 120.w,
            padding: EdgeInsets.fromLTRB(10.w, 2.w, 10.w, 2.w),
            decoration: BoxDecoration(
              color: IConstant.red_bg_color3,
              borderRadius: BorderRadius.all(Radius.circular(10.w)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PriceText(_amount, fontSize: 14.sp),
                expandeSpace,
                Image.asset("assets/icons/confirm.png",
                    width: 10.w, height: 10.w),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 170.w,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: Image.asset("assets/icons/ic_activity_pass.png").image)),
              ),
              Positioned(left: 0.w, right: 0.w, bottom: 0.w, child: Container(
                height: 35.w,
                color: IConstant.black_translucent_color,
                alignment: Alignment.center,
                child: Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_product_crossed_level_success_tip), [ "${IConstant.currency}$_amount" ]), textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp, color: IConstant.white_color),),
              ))
            ],
          )
        ],
      ),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      elevation: 0.w,
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
        height: 50.w,
        alignment: Alignment.center,
        child: SizedBox(
          width: 180.w,
          child: SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.ViewUtils_confirm), onTap: () {
            endRedWindow();
          }),
        ),
      ),
    );
  }

  Future<void> endRedWindow() async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_FINISH_RED_WINDOW, {'redActivityId' : widget.redActivityId});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      if(widget.callBack != null) {
        widget.callBack!(context);
      }
      finish();
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

}
