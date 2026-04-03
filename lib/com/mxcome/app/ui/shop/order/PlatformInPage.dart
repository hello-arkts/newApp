import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:sprintf/sprintf.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../config/LanguageConfig.dart';
import '../model/PlatformModel.dart';
import '../widget/SmallTextButton.dart';

class PlatformInPage extends StatefulWidget {

  PlatformInPage();

  @override
  State<StatefulWidget> createState() {
    return PlatformInPageState();
  }

}

class PlatformInPageState extends BaseKeepAliveState<PlatformInPage> {

  List<dynamic> dataList = [
    PlatformModel("ip_icon",
        LanguageConfig.get(LanguageConfigKeys.Shop_order_brand),
        LanguageConfig.get(LanguageConfigKeys.Shop_order_sender_max_time),
        LanguageConfig.get(LanguageConfigKeys.Shop_order_consume), isViolate: true),
    PlatformModel("delivery_icon",
        LanguageConfig.get(LanguageConfigKeys.Shop_order_delivery),
        LanguageConfig.get(LanguageConfigKeys.Shop_order_delivery_max_time),
        LanguageConfig.get(LanguageConfigKeys.Shop_order_consume)),
    PlatformModel("user_icon",
        LanguageConfig.get(LanguageConfigKeys.Shop_order_user),
        LanguageConfig.get(LanguageConfigKeys.Shop_order_receipt_max_time),
        LanguageConfig.get(LanguageConfigKeys.Shop_order_consume)),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: IConstant.white_color,
        appBar: AppBar(
          elevation: 0.5.w,
          centerTitle: true,
          title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_platform_in),
              style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
        ),
        body: buildBody(),
        bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        buildOrderState(),
        buildInterveneInfo(),
        buildResult(),
      ],
    );
  }

  Widget buildOrderState() {
    return Container(
      margin: EdgeInsets.fromLTRB(14.w, 10.w, 14.w, 0),
      padding: EdgeInsets.fromLTRB(14.w, 10.w.w, 14.w, 10.w),
      decoration: BoxDecoration(
          color: IConstant.grey_bg_color,
          borderRadius: BorderRadius.circular(12.w)),
      child: Row(children: [
        Expanded(child: Text(getAfterState(), style: TextStyle(fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: IConstant.title_color))),
        SizedBox(width: 10.w),
        Container(
          padding: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
          decoration: BoxDecoration(
              border: Border.all(width: 1.w, color: IConstant.blue_color),
              borderRadius: BorderRadius.circular(15.w)),
          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_policy), style: TextStyle(fontSize: 11.sp, color: IConstant.blue_color)),
        )
      ],),
    );
  }

  String getAfterState(){
    return sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_order_eligible), "退货退款");
  }

  Widget buildInterveneInfo() {
    return Container(
      margin: EdgeInsets.fromLTRB(14.w, 10.w, 14.w, 0),
      padding: EdgeInsets.fromLTRB(10.w, 10.w.w, 10.w, 10.w),
      decoration: BoxDecoration(
          color: IConstant.white_color,
          border: Border.all(color: IConstant.grey_bg_color),
          borderRadius: BorderRadius.circular(12.w)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_responsibility_division),
             style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
          Column(
            children: dataList.map((item) => buildItem(item)).toList(),
          )
       ],
      ),
    );
  }

  Widget buildResult() {
    return Container(
      margin: EdgeInsets.fromLTRB(14.w, 14.w, 14.w, 0.w),
      decoration: BoxDecoration(
          border: Border.all(color: IConstant.grey_bg_color, width: 1.w),
          borderRadius: BorderRadius.circular(12.w)),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(14.w, 6.w, 14.w, 6.w),
            decoration: BoxDecoration(
                color: IConstant.red_bg_color3,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.w))),
            child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_platform_tip1),
                style: TextStyle(fontSize: 12.sp, color: IConstant.main_color)),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(14.w, 12.w, 14.w, 12.w),
            decoration: BoxDecoration(
                color: IConstant.white_color,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.w))),
            child: Row(
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_result),
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: IConstant.text_color)),
                expandeSpace,
                Text(getBrandPostage(),
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: IConstant.text_color)),
              ],
            ),
          )
        ],
      ),
    );
  }

  String getBrandPostage(){
    return sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_order_bear_the_postage), "品牌");
  }

  Widget buildItem(PlatformModel item) {
    return Padding(padding: EdgeInsets.only(top: 10.w, bottom: 10.w),
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
          decoration: BoxDecoration(
              color: IConstant.red_bg_color3,
              borderRadius: BorderRadius.all(Radius.circular(12.w))),
          child: Row(
            children: [
              Image.asset("assets/icons/${item.icon}.png", width: 18.w, height: 18.w),
              SizedBox(width: 2.w),
              Text(item.name,
                  style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
            ],
          ),
        ),
        SizedBox(width: 10.w),
        Text(item.subTitle,
            style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
        SizedBox(width: 10.w),
        Text(item.totalConsume,
            style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
        SizedBox(width: 4.w),
        Text("24:56:10",
            style: TextStyle(fontSize: 12.sp, color: IConstant.main_color)),
        expandeSpace,
        buildViolate(item.isViolate),
      ],
    ),);
  }

  Widget buildViolate(bool violate){
    return violate ? Row(
      children: [
        Image.asset("assets/icons/error.png", width: 20.w, height: 20.w),
        Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_promise),
            style: TextStyle(fontSize: 13.sp, color: IConstant.text_color))
      ],
    ) : Container();
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
            finishContext(context);
          }),
        ),
      ),
    );
  }

}
