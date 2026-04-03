
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/ClockComponent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CountDownView.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../IURLConstant.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/HttpUtils.dart';
import '../utils/FormatUtil.dart';
import '../utils/Util.dart';
import '../widget/LoadImageView.dart';
import 'GetPrizeTaskPage.dart';
import 'TaskDetailPage.dart';

class PrizeTaskPage extends StatefulWidget {

  @override
  State<PrizeTaskPage> createState() => PrizeTaskPageState();

}

class PrizeTaskPageState extends BaseKeepAliveState<PrizeTaskPage> {

  int _countedTimeout = 7 * 24 * 60;
  int _prizeGetTimeout = 8 * 24 * 60;

  @override
  void initState() {
    super.initState();
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    isLoading = true;
    getServiceTime();
    dynamic data = await AppUtils.getPocketData();
    setState(() {
      _countedTimeout = BaseModel.isNotEmpty(data, "countedTimeout") ? BaseModel.getInt(data, "countedTimeout") : _countedTimeout;
      _prizeGetTimeout = BaseModel.isNotEmpty(data, "prizeGetTimeout") ? BaseModel.getInt(data, "prizeGetTimeout") : _prizeGetTimeout;
    });
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_GET_RECEIVE_GIFT, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        datas = BaseModel.getDynamic(rsp.data, "pocketMemberList");
      });
    }
    isLoading = false;
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
      body: buildBody()
    );
  }

  Widget buildBody() {
    return datas.isEmpty ? buildHeader() : EasyRefresh(
      header: const MaterialHeader(color: IConstant.main_color),
      footer: CupertinoFooter(emptyWidget: Container(
            padding: EdgeInsets.all(10.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_more), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
          )),
      onRefresh: ()=> onRefresh(),
      onLoad: ()=> onLoadMore(),
      child: ListView.separated(
          scrollDirection: Axis.vertical,
          itemCount: datas.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                nextPage(TaskDetailPage(datas[index]), false);
              },
              child: buildTaskItem(index),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 10.w);
          }),
    );

  }

  Widget buildTaskItem(int index) {
    dynamic pocketMemberItem = datas[index];
    dynamic product = pocketMemberItem["product"];
    return Card(
      margin: EdgeInsets.fromLTRB(16.w, 20.w, 16.w, 0.w),
      elevation: 4.w,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(12.w),
      ),
      child: Column(
        children: [
          buildTaskInfo(product, pocketMemberItem),
          Divider(thickness: 4.w,color: IConstant.grey_line_color,),
          buildBottomItem(product, pocketMemberItem),
        ],
      ),
    );
  }

  Widget buildTaskInfo(dynamic product, dynamic pocketMemberItem){
    return SizedBox(
      height: 90.w,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12.w)),
              child: LoadImageView(0.2 * Adapt.getWindowWidth(), 0.2 * Adapt.getWindowWidth(), BaseModel.getString(product, "pic"))),
          SizedBox(width: 10.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 15.w, bottom: 15.w, right: 15.w,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 0.65 * Adapt.getWindowWidth(), child: Text("${BaseModel.getString(product, "name")}", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13.sp, color: IConstant.text_color))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_get_gold),
                              style: TextStyle(fontSize: 11.sp, color: IConstant.main_color)),
                          SizedBox(width: 4.w),
                          PriceText(BaseModel.getDouble(pocketMemberItem, "withdrawalBalance"), fontSize: 12.sp),
                        ],
                      ),
                      Row(
                        children: [
                          Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_task_completed), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                          SizedBox(width: 4.w),
                          Text("${ BaseModel.getInt(pocketMemberItem, "buyQuantity") }", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.main_color)),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottomItem(dynamic product, dynamic pocketMemberItem){
    return Row(
      children: [
        Expanded(flex: 1, child: Container(
          margin: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(child: LoadImageView(30.w, 30.w, BaseModel.getString(product, "shopIcon"))),
              SizedBox(width: 6.w),
              Expanded(child: Text(BaseModel.getString(product, "shopName"),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.title_color)))
            ],
          ),
        )),
        Expanded(flex: 1, child: buildStopTime(pocketMemberItem)),
        Expanded(flex: 1, child: Container(
          margin: EdgeInsets.fromLTRB(10.w, 6.w, 8.w, 8.w),
          child: buildStatus(pocketMemberItem),
        )),
      ],
    );
  }

  String getProfitText(dynamic item) {
    double minProfit = BaseModel.getDouble(item, "minProfit");
    double maxProfit = BaseModel.getDouble(item, "maxProfit");
    return FormatUtil.profitAmount(maxProfit, maxPrice: maxProfit);
  }

  String getCompletionDegree(dynamic item) {
    String completionDegree = LanguageConfig.get(LanguageConfigKeys.Shop_pocket_task_completed);
    int buyQuantity = BaseModel.getInt(item, "buyQuantity");
    return "$completionDegree $buyQuantity/10";
  }

  double getRateDouble(dynamic item) {
    int buyQuantity = BaseModel.getInt(item, "buyQuantity");
    return buyQuantity / 10;
  }

  String getAmount(dynamic item) {
    double profitAmount = BaseModel.getDouble(item, "profitAmount");
    return FormatUtil.price2String(profitAmount);
  }

  Widget buildStopTime(dynamic item) {
    String endTime = BaseModel.getString(item, "endTime");
    DateTime dateTime = DateTime.parse(endTime);
    DateTime countedTime = dateTime.add(Duration(minutes: _countedTimeout));
    DateTime prizeGetTime = countedTime.add(Duration(minutes: _prizeGetTimeout));
    return CountDownView(startTime: serviceTime, endTime: FormatUtil.formatLineYMDHMS(prizeGetTime),
        fontSize: 11.w,
        textColor: IConstant.main_color,
        prefix: LanguageConfig.get(LanguageConfigKeys.Shop_activity_get_prize_stop),
        stop: LanguageConfig.get(LanguageConfigKeys.Shop_activity_closed));
  }

  Widget buildLockTime(dynamic item) {
    String endTime = BaseModel.getString(item, "endTime");
    DateTime dateTime = DateTime.parse(endTime);
    dateTime = dateTime.add(Duration(minutes: _countedTimeout));
    dateTime = dateTime.add(Duration(minutes: _prizeGetTimeout));
    if (Util.isTimeout2(startTime: serviceTime, endTime: FormatUtil.formatLineYMDHMS(dateTime))) {
      return Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_expired),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 10.sp, color: IConstant.green_color));
    } else {
      return SizedBox(
        width: 0.3 * Adapt.getWindowWidth(),
        child: RichText(
            text: TextSpan(
                children: [
                  TextSpan(
                    text: LanguageConfig.get(LanguageConfigKeys.Shop_activity_get_prize_stop),
                    style: TextStyle(fontSize: 10.sp, color: IConstant.main_inactive_color,),
                  ),
                  const TextSpan(
                    text: ' ',
                  ),
                  TextSpan(
                    text: FormatUtil.formatMDHM(dateTime),
                    style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color: IConstant.main_color),
                  ),
                ])),
      );
    }
  }

  Widget buildStatus(dynamic item) {
    return InkWell(
      onTap: () {
        nextPage(GetPrizeTaskPage(item), false);
      },
      child: Container(
          padding: EdgeInsets.fromLTRB(8.w, 6.w, 8.w, 6.w),
          decoration: BoxDecoration(
              color: IConstant.main_color,
              borderRadius: BorderRadius.circular(30.w)
          ),
          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_get_prize), textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10.sp, color: IConstant.white_color))),
    );
  }

}
