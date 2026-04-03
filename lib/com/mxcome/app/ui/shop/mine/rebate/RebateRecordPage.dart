import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/LoadImageView.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/ToggleSwitch.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';

class RebateRecordPage extends StatefulWidget {

  List<dynamic> buyList = [];

  RebateRecordPage(this.buyList);

  @override
  State<RebateRecordPage> createState() => RebateRecordPageState();
}

class RebateRecordPageState extends BaseKeepAliveState<RebateRecordPage> {

  List<dynamic> buyList = [];

  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      buyList = widget.buyList;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildBody() {
    return Container(
      padding: EdgeInsets.all(10.w),
      child: Column(
        children: [
          Container(
            width: 170.w,
            height: 32.w,
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            margin: EdgeInsets.only(top: 30.w, bottom: 20.w),
            child: ToggleSwitch(
                minWidth: 82.w,
                initialLabelIndex: 0,
                labels: const ['购买记录', '退单记录'],
                boxBorder: Border.all(color: IConstant.white_bg_color, width: 1.w),
                activeBgColor: IConstant.white_color,
                activeTextColor: IConstant.main_color,
                onToggle: (index) {
                }),
          ),
          Row(
            children: [
              Expanded(flex: 3, child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_purchase_users),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 12.sp, fontWeight: FontWeight.normal, color: IConstant.sub_text_color))),
              Expanded(flex: 4, child:  Text("时间",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12.sp, fontWeight: FontWeight.normal, color: IConstant.sub_text_color))),
              Expanded(flex: 2, child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_purchase_quantity),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12.sp, fontWeight: FontWeight.normal, color: IConstant.sub_text_color))),
              Expanded(flex: 2, child: Text(getAmount(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 12.sp, fontWeight: FontWeight.normal, color: IConstant.sub_text_color))),
            ],
          ),
          SizedBox(height: 10.w),
          Expanded(
              child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemCount: buyList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {},
                      child: buildBuyItem(index),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: 10.w);
                  })),
        ],
      ),
    );
  }

  Widget buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      elevation: 8.w,
      child: Container(
        padding: EdgeInsets.only(left: 28.w, right: 28.w),
        height: 60.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("总返利", style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
            PriceText(2356.59, fontSize: 14.sp),
          ],
        ),
      ),
    );
  }

  Widget buildBuyItem(int index) {
    dynamic item = buyList[index];
    return Row(
      children: [
        Expanded(flex: 4, child: buildImageItem(item)),
        Expanded(flex: 4, child: Text(getBuyTime(BaseModel.getString(item, "buyTime")),
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color))),
        Expanded(flex: 2, child: Text("×${BaseModel.getString(item, "productQuantity")}",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color))),
        tabIndex == 1 ?
        Expanded(flex: 2, child: Text("+${FormatUtil.price2String(BaseModel.getDouble(item, "profitAmount"))}", textAlign: TextAlign.right,
            style: TextStyle(fontSize: 12.sp, color: IConstant.green_color))) :
        Expanded(flex: 2, child: Text("-${FormatUtil.price2String(BaseModel.getDouble(item, "profitAmount"))}", textAlign: TextAlign.right,
            style: TextStyle(fontSize: 12.sp, color: IConstant.main_color))),
      ],
    );
  }

  String getBuyTime(String buyTime) {
    DateTime calcTime = DateTime.parse(buyTime);
    return FormatUtil.formatYMDHMS(calcTime);
  }

  Widget buildImageItem(dynamic item) {
    String icon = BaseModel.getString(item, "icon");
    if (TextUtil.isEmpty(icon)) {
      String displayName = getDisplayName(item);
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
              child: Container(
                  width: 35.w,
                  height: 35.w,
                  color: IConstant.red_translucent_color,
                  child: Center(
                      child: Text(FormatUtil.showIcon(displayName),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20.sp, color: IConstant.text_color))))),
          SizedBox(width: 4.w),
          Container(constraints: BoxConstraints(maxWidth: 65.w), child: Text(FormatUtil.showName(displayName), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)))
        ],
      );
    } else {
      String displayName = getDisplayName(item);
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: LoadImageView(35.w, 35.w, BaseModel.getString(item, "icon")),
          ),
          SizedBox(width: 8.w),
          Container(constraints: BoxConstraints(maxWidth: 65.w), child: Text(FormatUtil.showName(displayName), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)))
        ],
      );
    }
  }

  String getTitle() {
    if (tabIndex == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_pocket_purchase_record);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_pocket_chargeback_record);
    }
  }

  String getTime() {
    if (tabIndex == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_pocket_purchase_time);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_pocket_chargeback_time);
    }
  }

  String getAmount() {
    if (tabIndex == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_mxget_income);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_mxget_income);
    }
  }

  String getTotal() {
    if (tabIndex == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_pocket_total_purchase);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_pocket_total_chargeback);
    }
  }

  double getTotalAmount() {
    double total = 0;
    for (var item in buyList) {
      total += BaseModel.getDouble(item, "profitAmount");
    }
    return total;
  }

  String getDisplayName(dynamic item) {
    String nickName = BaseModel.getString(item, "nickName");
    String generatorId = BaseModel.getString(item, "generatorId");
    return TextUtils.isNotEmpty(nickName) ? nickName: generatorId;
  }

}
