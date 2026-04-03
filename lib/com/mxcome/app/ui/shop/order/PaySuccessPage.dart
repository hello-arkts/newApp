
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/lottery/RandomLotteryPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/UserInfoEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../config/LanguageConfig.dart';
import '../detail/ProductDetailPage.dart';
import '../widget/OutlineTextButton.dart';

class PaySuccessPage extends StatefulWidget {

  String productId;
  bool isLottery;

  PaySuccessPage({ this.productId = "", this.isLottery = false });

  @override
  State<StatefulWidget> createState() {
    return PaySuccessPageState();
  }
}

class PaySuccessPageState extends BaseKeepAliveState<PaySuccessPage> {

  @override
  void initState() {
    super.initState();
    EventBusUtil.getInstance().emit(UserInfoEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.5.w,
        leading: InkWell(
          onTap: () {
            backHome();
            if (!TextUtil.isEmpty(widget.productId)) {
              nextPageState(ProductDetailPage(widget.productId), false);
            }
          },
          child: const Icon(Icons.arrow_back_ios_new),
        ),
        centerTitle: true,
        title: Text(
            LanguageConfig.get(LanguageConfigKeys.Shop_order_pay_success),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
        children: [
          SizedBox(height: 60.w),
          Image.asset("assets/icons/success.png", width: 50.w, height: 50.w),
          SizedBox(height: 10.w),
          Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_pay_success),
              style: TextStyle(fontSize: 20.w, color: IConstant.title_color)),
          SizedBox(height: 20.w),
          Text(widget.isLottery ?
          LanguageConfig.get(LanguageConfigKeys.Shop_order_pay_success_winning) :
          LanguageConfig.get(LanguageConfigKeys.Shop_order_pay_success_tip1),
              style: TextStyle(fontSize: 14.w, color: IConstant.main_color)),
          SizedBox(height: 20.w),
          widget.isLottery ? InkWell(
            onTap: () {
              backHome();
              nextPage(RandomLotteryPage(), false);
            },
            child: Container(
              width: 140.w,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.w),
              decoration: BoxDecoration(
                color: IConstant.red_bg_color3,
                border: Border.all(width: 1.w, color: IConstant.main_color),
                borderRadius: BorderRadius.circular(40.w),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/icons/prize.png", width: 28.w, height: 28.w),
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_draw_now),
                    style: TextStyle(color: IConstant.main_color, fontSize: 15.sp),),
                ],
              ),
            ),
          ) :
          OutlineTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_share_goods), fontSize: 15.sp, onTap: () {
            backHome();
          }),
          SizedBox(height: 40.w),
          Container(
            height: 50.w,
            margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.w),
            child: Row(
              children: [
                Image.asset("assets/icons/warn.png", width: 20.w, height: 20.w),
                SizedBox(width: 12.w),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_pay_success_tip2),
                        maxLines: 3, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color)),
                  ],
                ))
              ],
            ),
          )
        ]
    );
  }

}
