
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/PayModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CountDownView.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IURLConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseModel.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/HttpUtils.dart';
import '../utils/FormatUtil.dart';
import '../widget/PriceText.dart';
import '../widget/SmallTextButton.dart';
import 'PaySuccessPage.dart';

class PromptQRPage extends StatefulWidget {

  dynamic order;

  String imageData = "";

  String orderSn = "";

  String tradeNo = "";

  String productId;
  bool isLottery;

  PromptQRPage(this.order, this.imageData, this.orderSn, this.tradeNo, { this.productId = "", this.isLottery = false });

  @override
  State<StatefulWidget> createState() {
    return PromptQRPageState();
  }
}

class PromptQRPageState extends BaseKeepAliveState<PromptQRPage> {

  dynamic order;
  PayModel? payModel;

  int orderOverTime = 15;

  @override
  void initState() {
    super.initState();
    order = widget.order;
  }

  @override
  void didChangeDependencies() {
    getServiceTime();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        leading: InkWell(
          onTap: () {
            finishContext(context);
            ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_order_cancel_payment));
          },
          child: const Icon(Icons.arrow_back_ios_new),
        ),
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_prompt_pay),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildBody() {
    return ListView(
          children: [
            Container(
              height: 80.w,
              margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
              padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
              decoration: BoxDecoration(
                  color: IConstant.red_bg_color3,
                  borderRadius: BorderRadius.circular(15.w)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_pay_amount), style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: IConstant.text_color)),
                      Expanded(child: PriceText(BaseModel.getDouble(order, "payAmount"), fontSize: 24.sp, fontWeight: FontWeight.bold, textAlign: TextAlign.right)),
                    ],
                  ),
                  Expanded(child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_pay_remaining_time), style: TextStyle(fontSize: 14.sp, color: IConstant.title_color)),
                      buildClock()
                    ],
                  ))
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0.w),
              child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_pay_qr_code), style: TextStyle(fontSize: 15.sp, color: IConstant.title_color)),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16.w, 20.w, 16.w, 0.w),
              child: Image.asset("assets/icons/prompt_qr.png", height: 60.w),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 0.w),
              child: Image.memory(
                base64Decode(widget.imageData),
                gaplessPlayback: true,
                width: 200,
                height: 200,
              ),
            ),
            Container(
              height: 120.w,
              margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 30.w),
              child: Row(
                children: [
                  Container(width: 3.w, color: IConstant.red_bg_color),
                  SizedBox(width: 12.w),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_prompt_pay_tip1), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color))),
                      Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_prompt_pay_tip2), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color))),
                      Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_prompt_pay_tip3), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color))),
                      Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_prompt_pay_tip4), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color))),
                    ],
                  ))
                ],
              ),
            )
          ],
    );
  }

  Widget buildClock() {
    String createTime = BaseModel.getString(order, "createTime");
    if (BaseModel.isNotEmpty(order, "orderOverTime")) {
      orderOverTime = BaseModel.getInt(order, "orderOverTime");
    }
    DateTime endTime = DateTime.parse(createTime);
    endTime = endTime.add(Duration(minutes: orderOverTime));
    return CountDownView(startTime: serviceTime, endTime: handleDate(endTime), fontSize: 15.sp,
        textColor: IConstant.main_color,
        textAlign: TextAlign.right,
        prefix: "",
        stop: LanguageConfig.get(LanguageConfigKeys.Shop_activity_closed));
  }

  String handleDate(DateTime dateTime) {
    return FormatUtil.formatLineYMDHMS(dateTime); //格式化日期
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 4.w, 16.w, 4.w),
        height: 100.w,
        alignment: Alignment.center,
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(10.w)),
              clipBehavior: Clip.antiAlias,
              elevation: 4.w,
              child: Container(
                width: 200.w,
                padding: EdgeInsets.fromLTRB(10.w, 8.w, 10.w, 8.w),
                child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_prompt_pay_tip5), maxLines: 2,
                    overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color)),
              ),
            ),
            SizedBox(
              width: 200.w,
              child: SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_after_pay_query), onTap: () {
                payResult();
              }),
            )
          ],
        ),
      ),
    );
  }

  Future<void> payResult() async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_GET_PAY_RESULT, {
      "orderSn": widget.orderSn,
      "tradeNo": widget.tradeNo
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      int tradeStatus = BaseModel.getInt(rsp.data, "tradeStatus");
      if (tradeStatus == 0) { //交易未支付
        ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_order_not_pay));
      } else if(tradeStatus == 2) { //支付中
        ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_order_paying));
      } else if(tradeStatus == 3) { //支付成功
        nextPage(PaySuccessPage(productId: widget.productId, isLottery: widget.isLottery), false);
      } else if(tradeStatus == 4) { //支付失败
        ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_order_pay_failed));
      }
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

}
