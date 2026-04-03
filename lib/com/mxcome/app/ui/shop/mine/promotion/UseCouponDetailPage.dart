
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/Logger.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/GetPrizeEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/promotion/UseConfirmPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/UseCouponModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sprintf/sprintf.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IConstant.dart';
import '../../../../IURLConstant.dart';
import '../../../../config/LanguageConfig.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/Adapt.dart';
import '../../../../utils/HttpUtils.dart';
import '../../../../utils/ViewUtils.dart';
import '../../widget/LoadImageView.dart';
import '../../widget/SmallTextButton.dart';

class UseCouponDetailPage extends StatefulWidget {

  dynamic prize;
  UseCouponDetailPage(this.prize);

  @override
  State<UseCouponDetailPage> createState() => UseCouponDetailPageState();
}

class UseCouponDetailPageState extends BaseKeepAliveState<UseCouponDetailPage> {

  dynamic _prize;
  int _status = 0;
  List<UseCouponModel> couponItemList = [];

  @override
  void initState() {
    super.initState();
    _prize = widget.prize;
    _status = BaseModel.getInt(_prize, "status");
    List<UseCouponModel> tempList = [];
    List<dynamic> mItemList = BaseModel.getDynamic(_prize, "couponItemList");
    for (var item in mItemList) {
      tempList.add(UseCouponModel.fromJson(item));
    }
    couponItemList = tempList;
    loadContentDatas();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
          leading: Container(),
          leadingWidth: 0.w,
          elevation: 0.w,
          centerTitle: false,
          title: Text(getTitle(),
              style: TextStyle(fontSize: 17.sp, color: IConstant.text_color))),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    dynamic gift = BaseModel.getDynamic(_prize, "gift");
    String pic = BaseModel.getString(gift, "pic");
    return ListView(
      children: [
        Container(
            margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 10.w),
            padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
            decoration: BoxDecoration(
                border: Border.all(width: 1.w, color: IConstant.line_color),
                borderRadius: BorderRadius.all(Radius.circular(12.w))),
            child: Row(
              children: [
                ClipOval(
                    child: LoadImageView(60.w, 60.w, pic.split(',')[0])),
                SizedBox(width: 10.w),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(BaseModel.getString(gift, "name"),
                                style: TextStyle(
                                    fontSize: 14.sp, color: IConstant.text_color)),
                            SizedBox(width: 10.w),
                            Container(
                              padding: EdgeInsets.fromLTRB(8.w, 2.w, 8.w, 2.w),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1.w, color: IConstant.main_color),
                                  borderRadius: BorderRadius.circular(10.w)),
                              child: Text(getType(BaseModel.getInt(_prize, "type")), style: TextStyle(fontSize: 12.sp, color: IConstant.main_color)),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.w),
                        Row(
                          children: [
                            Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_value),
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 14.sp, color: IConstant.title_color)),
                            SizedBox(width: 4.w),
                            PriceText(BaseModel.getDouble(gift, "sellPrice"),
                                fontSize: 14.sp, color: IConstant.title_color),
                            expandeSpace,
                            Text("×${BaseModel.getInt(_prize, "quantity")}",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 12.sp, color: IConstant.sub_text_color))
                          ],
                        )
                      ],
                    )),
              ],
            )
        ),
        Container(
          margin: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 0.w),
          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_voucher_code_info), style: TextStyle(
              fontSize: 15.sp, color: IConstant.text_color)),
        ),
        SizedBox(
          height: 330.w,
          child: Swiper(
            key: UniqueKey(),
            itemBuilder: (BuildContext context, int index) {
              return buildQrcode(index);
            },
            itemCount: couponItemList.length,
            loop: couponItemList.length == 1 ? false : true,
            pagination: couponItemList.length > 1 ? const SwiperPagination(
                alignment: Alignment.topCenter,
                builder: DotSwiperPaginationBuilder(
                  color: IConstant.translucent_color,
                  activeColor: IConstant.main_color,
                )) : null,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_prize_info), style: TextStyle(
              fontSize: 15.sp, color: IConstant.text_color)),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
          padding: EdgeInsets.fromLTRB(0.w, 10.w, 0.w, 10.w),
          decoration: BoxDecoration(
              border: Border.all(width: 1.w, color: IConstant.line_color),
              borderRadius: BorderRadius.all(Radius.circular(12.w))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                child: Text("${BaseModel.getString(gift, "name") } ${FormatUtil.price2String(BaseModel.getDouble(gift, "sellPrice"))}",
                    style: TextStyle(
                        fontSize: 14.sp, color: IConstant.text_color)),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0.w, 10.w, 0.w, 10.w),
                height: 1.w, color: IConstant.line_color),
              Row(
                children: [
                  SizedBox(width: 10.w),
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_exchange_number), style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
                  SizedBox(width: 10.w),
                  Text(BaseModel.getString(_prize, "orderSn"),
                      style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                  SizedBox(width: 10.w),
                ],
              ),
              SizedBox(height: 4.w),
              Row(
                children: [
                  SizedBox(width: 10.w),
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_exchange_time), style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
                  SizedBox(width: 10.w),
                  Text(BaseModel.getString(_prize, "createTime"),
                      style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                  SizedBox(width: 12.w),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
          padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
          decoration: BoxDecoration(
              color: IConstant.line_color,
              borderRadius: BorderRadius.all(Radius.circular(12.w))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_usage_rules), style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.text_color)),
              SizedBox(height: 10.w),
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_usage_rules_tip1), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
              SizedBox(height: 10.w),
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_usage_rules_tip2), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
              SizedBox(height: 10.w),
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_usage_rules_tip3), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
            ],
          ),
        )
      ],
    );
  }

  String getType(int type) {
    if (type == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_exchange_voucher);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_entity_prizes);
    }
  }

  String getTitle() {
    List<UseCouponModel> tempList = [];
    for (UseCouponModel item in couponItemList) {
      if (item.status == 1) {
        tempList.add(item);
      }
    }
    if (tempList.length == couponItemList.length) {
      _status = 1;
    }
    String statusText = "";
    if (_status == 0) {
      statusText = LanguageConfig.get(LanguageConfigKeys.Shop_mine_to_be_use);
    } else if (_status == -1) {
      statusText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_expired);
    } else {
      statusText = LanguageConfig.get(LanguageConfigKeys.Shop_mine_used);
    }
    return statusText;
  }

  Future<void> nowUse(int index) async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_USE_COUPON_ID, {
      "couponId": "${couponItemList[index].id}",
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      EventBusUtil.getInstance().emit(GetPrizeEvent());
      setState(() {
        couponItemList[index].status = 1;
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  Widget buildQrcode(int index) {
    dynamic gift = BaseModel.getDynamic(_prize, "gift");
    dynamic coupon = BaseModel.getDynamic(_prize, "coupon");
    UseCouponModel useCoupon = couponItemList[index];
    Logger.log("---useCoupon: ${useCoupon.status}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        expandeSpace,
        useCoupon.status == 0 ? Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset("assets/icons/scan_icon.png", width: 200.w, height: 200.w),
              _status == -1 ? Positioned(left: 40.w, top: 40.w, right: 40.w, bottom: 40.w, child:  ClipOval(
                  child: Container(
                      color: IConstant.white_color,
                      alignment: Alignment.center,
                      child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_expired),
                          style: TextStyle(fontSize: 15.sp, color: IConstant.text_color))))) : Container()
            ],
          ),
        ) : Container(
            alignment: Alignment.center,
            child: QrImageView(
              data: useCoupon.code,
              version: QrVersions.auto,
              size: 200.w)
        ),
        Container(
          margin: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 10.w),
          alignment: Alignment.center,
          child: Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_usage_expiration_time), [FormatUtil.formatYMDHMS(DateTime.parse(BaseModel.getString(coupon, "endTime")))]),
            style: TextStyle(fontSize: 13.sp, color: IConstant.main_color),),
        ),
        _status == -1 ? Container() : Container(
          alignment: Alignment.center,
          child: SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_mine_now_use), enable: useCoupon.status == 0, fontSize: 12.sp, left: 60.w, right: 60.w, onTap: () {
            showPop(0.3 * Adapt.getWindowHeight(), UseConfirmPage(
                callBack: (BuildContext ctx) {
                  finishContext(ctx);
                  nowUse(index);
                }));
          }),
        ),
        expandeSpace,
      ],
    );
  }

}
