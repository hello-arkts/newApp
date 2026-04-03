
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/pocket/PodiumPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/ClockComponent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CountDownView.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../IURLConstant.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../brand/BrandShopPage.dart';
import '../model/SelectTabModel.dart';
import '../utils/FormatUtil.dart';
import '../utils/Util.dart';
import '../widget/LoadImageView.dart';
import '../widget/PriceText.dart';
import 'GetPrizeActivityPage.dart';
import 'HistoryDetailPage.dart';

class PrizeActivityPage extends StatefulWidget {

  @override
  State<PrizeActivityPage> createState() => PrizeActivityPageState();

}

class PrizeActivityPageState extends BaseKeepAliveState<PrizeActivityPage> {

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
        datas = BaseModel.getDynamic(rsp.data, "activityMemberList");
      });
    }
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: IConstant.white_color,
        body: Container(
          margin: EdgeInsets.only(top: 10.w),
          child: buildBody(),
        )
    );
  }

  @override
  void didChangeDependencies() {
    getServiceTime();
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
                activityHistory(datas[index]);
              },
              child: buildActivityItem(index),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 10.w);
          }),
    );
  }

  void activityHistory(dynamic activityMember) async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_ACTIVITY_MEMBER_INFO, {
      "activityId": BaseModel.getString(activityMember, "activityId")
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      nextPage(HistoryDetailPage(activityMember), false);
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  Widget buildActivityItem(int index) {
    dynamic activityMember = datas[index];
    return Card(
      margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 0.w),
      elevation: 4.w,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(12.w),
      ),
      child: Column(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.w)),
              child: LoadImageView(double.infinity, 92.w, BaseModel.getString(activityMember, "activityPic"),
                  alignment: Alignment.topCenter)
          ),
          SizedBox(width: 6.w),
          Row(
            children: [
              Expanded(flex: 1, child: InkWell(
                onTap: () {
                  nextPage(BrandShopPage(BaseModel.getString(activityMember, "shopId")), false);
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipOval(child: LoadImageView(30.w, 30.w, BaseModel.getString(activityMember, "shopIcon"))),
                      SizedBox(width: 6.w),
                      Expanded(child: Text(BaseModel.getString(activityMember, "shopName"),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.title_color)))
                    ],
                  ),
                ),
              )),
              Expanded(flex: 1, child: buildStopTime(activityMember)),
              Expanded(flex: 1, child: Container(
                margin: EdgeInsets.fromLTRB(16.w, 6.w, 8.w, 8.w),
                child: buildStatus(activityMember),
              ))
            ],
          )
        ],
      ),
    );
  }

  Widget buildStopTime(dynamic item) {
    return Row(
      children: [
        Container(
          color: IConstant.line_color,
          width: 1.w,
          height: 20.w,
        ),
        SizedBox(width: 10.w),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_get_gold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11.sp, color: IConstant.main_color)),
                SizedBox(width: 4.w),
                PriceText(BaseModel.getDouble(item, "withdrawalBalance"), fontSize: 12.sp),
              ],
            ),
            buildLockTime(item)
          ],
        ))
      ],
    );
  }

  Widget buildLockTime(dynamic item) {
    String statusText = '';
    String _endTime = '';
    String endTime = BaseModel.getString(item, "endTime");
    DateTime dateTime = DateTime.parse(endTime);
    DateTime countedTime = dateTime.add(Duration(minutes: _countedTimeout));
    DateTime prizeGetTime = countedTime.add(Duration(minutes: _prizeGetTimeout));
    if (!Util.isTimeout2(startTime: serviceTime, endTime: FormatUtil.formatLineYMDHMS(countedTime))) { //统计时间
      _endTime = FormatUtil.formatLineYMDHMS(countedTime);
      statusText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_waiting_statistics);
    } else if (Util.isTimeout2(startTime: serviceTime, endTime: FormatUtil.formatLineYMDHMS(countedTime)) && !Util.isTimeout2(startTime: serviceTime, endTime: FormatUtil.formatLineYMDHMS(prizeGetTime))) { //领取时间
      _endTime = FormatUtil.formatLineYMDHMS(prizeGetTime);
      statusText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_get_prize_stop);
    } else if (Util.isTimeout2(startTime: serviceTime, endTime: FormatUtil.formatLineYMDHMS(prizeGetTime))) { //领取结束时间
      _endTime = FormatUtil.formatLineYMDHMS(prizeGetTime);
      statusText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_get_prize_finish);
    }
    return CountDownView(startTime: serviceTime, endTime: _endTime,
        fontSize: 11.w,
        textColor: IConstant.main_color,
        prefix: statusText,
        stop: LanguageConfig.get(LanguageConfigKeys.Shop_activity_closed));
  }

  Widget buildStatus(dynamic item) {
    return InkWell(
      onTap: () {
        goPrizeActivity(item);
      },
      child: Container(
          padding: EdgeInsets.fromLTRB(8.w, 6.w, 8.w, 6.w),
          decoration: BoxDecoration(
              color: IConstant.main_color,
              borderRadius: BorderRadius.circular(30.w)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/icons/podium_icon.png", width: 15.w,),
              SizedBox(width: 8.w,),
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_podium), textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10.sp, color: IConstant.white_color))
            ],
          )
    ));
  }

  Future<void> goPrizeActivity(dynamic item) async {
    ViewUtils.show();
    String activityId = BaseModel.getString(item, "activityId");
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_ACTIVITY_GET_INFO, {
      "activityId": activityId
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      nextPage(PodiumPage(rsp.data, item), false);
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

}
