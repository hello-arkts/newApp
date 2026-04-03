
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../utils/TextUtils.dart';
import '../utils/FormatUtil.dart';
import '../widget/LoadImageView.dart';

class ProfitRecordPage extends StatefulWidget {

  List<dynamic> buyList = [];

  ProfitRecordPage(this.buyList);

  @override
  State<ProfitRecordPage> createState() => ProfitRecordPageState();
}

class ProfitRecordPageState extends BaseKeepAliveState<ProfitRecordPage> {

  List<dynamic> buyList = [];

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
      appBar: AppBar(
        elevation: 0.5.w,
        leading: Container(),
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_mxget_detail),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildBody() {
    return Container(
      padding: EdgeInsets.all(10.w),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(flex: 4, child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_purchase_users),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 12.sp, fontWeight: FontWeight.normal, color: IConstant.sub_text_color))),
              Expanded(flex: 5, child:  Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_purchase_time),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12.sp, fontWeight: FontWeight.normal, color: IConstant.sub_text_color))),
              Expanded(flex: 2, child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_purchase_quantity),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 12.sp, fontWeight: FontWeight.normal, color: IConstant.sub_text_color))),
              Expanded(flex: 3, child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_wallet_mxget_income),
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
                    return buildBuyItem(index);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: 10.w);
                  })),
        ],
      ),
    );
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      elevation: 2.w,
      child: Container(
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        height: 60.w,
        child: Row(
          children: [
            Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_get_gold),
                style: TextStyle(
                    fontSize: 14.sp, color: IConstant.text_color)),
            expandeSpace,
            Text(FormatUtil.price2String(getTotalAmount()), style: TextStyle(fontSize: 14.sp, color: IConstant.main_color))
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
        SizedBox(width: 4.w),
        Expanded(flex: 5, child: Text(getBuyTime(BaseModel.getString(item, "buyTime")),
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color))),
        SizedBox(width: 4.w),
        Expanded(flex: 2, child: Text("×${BaseModel.getString(item, "productQuantity")}",
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color))),
        SizedBox(width: 4.w),
        Expanded(flex: 3, child: Text("+${FormatUtil.price2String(BaseModel.getDouble(item, "profitAmount"))}", textAlign: TextAlign.right,
            style: TextStyle(fontSize: 12.sp, color: IConstant.green_color)))
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
          Expanded(child: Container(constraints: BoxConstraints(maxWidth: 65.w), child: Text(FormatUtil.showName(displayName), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))))
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
          SizedBox(width: 4.w),
          Expanded(child: Container(constraints: BoxConstraints(maxWidth: 65.w), child: Text(FormatUtil.showName(displayName), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))))
        ],
      );
    }
  }

  String getDisplayName(dynamic item) {
    String nickname = BaseModel.getString(item, "nickName");
    String generatorId = BaseModel.getString(item, "generatorId");
    return TextUtils.isNotEmpty(nickname) ? nickname: generatorId;
  }

  double getTotalAmount() {
    double total = 0;
    for (var item in buyList) {
      total += BaseModel.getDouble(item, "profitAmount");
    }
    return total;
  }

}
