
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/pocket/PodiumPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/Util.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CountDownView.dart';
import 'package:sprintf/sprintf.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../IURLConstant.dart';
import '../../../Logger.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseModel.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../brand/BrandShopPage.dart';
import '../utils/FormatUtil.dart';
import '../widget/ClockComponent.dart';
import '../widget/LoadImageView.dart';
import '../widget/PriceText.dart';
import 'ActivityDetailPage.dart';
import 'GetPrizeActivityPage.dart';

class ActivityItemEnd extends StatefulWidget {

  String serviceTime;

  ActivityItemEnd({this.serviceTime = '', super.key});

  @override
  State<ActivityItemEnd> createState() => ActivityItemEndState();

}

class ActivityItemEndState extends BaseKeepAliveState<ActivityItemEnd> {

  List<dynamic> _activityMemberList = [];
  int _countedTimeout = 7 * 24 * 60;

  @override
  void initState() {
    super.initState();
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    await getServiceTime();
    dynamic data = await AppUtils.getPocketData();
    _countedTimeout = BaseModel.isNotEmpty(data, "countedTimeout") ? BaseModel.getInt(data, "countedTimeout") : _countedTimeout;
    List<dynamic> dataList = [];
    List<dynamic> activityMemberList = BaseModel.isNotEmpty(data, "activityMemberList") ? BaseModel.getDynamic(data, "activityMemberList") : [];
    for (var item in activityMemberList) {
      int status = BaseModel.getInt(item, "status");
      String endTime = BaseModel.getString(item, "endTime");
      DateTime dateTime = DateTime.parse(endTime);
      DateTime countedTime = dateTime.add(Duration(minutes: _countedTimeout));
      if (status == 1) {
        if (!Util.isTimeout2(startTime: serviceTime, endTime: FormatUtil.formatLineYMDHMS(countedTime))) {
          dataList.add(item);
        }
      }
    }
    setState(() {
      _activityMemberList = dataList;
    });
  }

  @override
  void didChangeDependencies() async{
    getServiceTime();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _activityMemberList.isEmpty ? buildHeader() : CustomScrollView(
      slivers: <Widget>[
        SliverPadding(padding: EdgeInsets.only(top: 16.w), sliver: SliverList(
          delegate:
          SliverChildBuilderDelegate((BuildContext context, int index) {
            return buildTaskItem(index);
          }, childCount: _activityMemberList.length),
        ))
      ],
    );
  }

  Widget buildTaskItem(int index) {
    dynamic activityMember = _activityMemberList[index];
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10, //阴影范围
            spreadRadius: 0.1, //阴影浓度
            color: Colors.grey.withOpacity(0.3), //阴影颜色
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.w)),
            child: InkWell(
              onTap: () async {
                nextPage(ActivityDetailPage(activityMember), false);
              },
              child: LoadImageView(double.infinity, 92.w, BaseModel.getString(activityMember, "activityPic"), alignment: Alignment.topCenter),
            )
          ),
          SizedBox(height: 4.w,),
          // LinearProgressIndicator(
          //   value: getTimeDouble(activityMember),
          //   backgroundColor: IConstant.white_color,
          //   valueColor: const AlwaysStoppedAnimation<Color>(IConstant.main_color),
          // ),
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
                child: buildRightItem(activityMember),
              ))
            ],
          )
        ],
      ),
    );
  }

  Future<void> goPodiumPage(dynamic activityMember) async {
    String activityId = BaseModel.getString(activityMember, "activityId");
    int level = BaseModel.getInt(activityMember, "level");
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_ACTIVITY_GET_INFO, {
      "activityId": activityId
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      nextPage(PodiumPage(rsp.data, activityMember), false);
    }
  }

  double getTimeDouble(dynamic activityMember) {
    DateTime createTime = DateTime.parse(BaseModel.getString(activityMember, "createTime"));
    DateTime endTime = DateTime.parse(BaseModel.getString(activityMember, "endTime"));
    int spaceTime = endTime.millisecondsSinceEpoch - createTime.millisecondsSinceEpoch;
    int currentSpaceTime = endTime.millisecondsSinceEpoch - FormatUtil.getTHNowTime().millisecondsSinceEpoch;
    return (currentSpaceTime / spaceTime);
  }

  Widget buildRightItem(dynamic activityMember) {
    String endTime = BaseModel.getString(activityMember, "endTime");
    DateTime dateTime = DateTime.parse(endTime);
    dateTime = dateTime.add(Duration(minutes: _countedTimeout));
    String formatDate = FormatUtil.formatLineYMDHMS(dateTime);
    if (Util.isTimeout2(startTime: serviceTime, endTime: formatDate)) {
      return InkWell(onTap: () {
        goPodiumPage(activityMember);
      },
        child: Container(
          padding: EdgeInsets.fromLTRB(10.w, 6.w, 10.w, 6.w),
          decoration: BoxDecoration(
              color: IConstant.main_color,
              borderRadius: BorderRadius.circular(20.w)
          ),
          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_get_now), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
        ),
      );
    } else {
      return Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_upcoming_profits), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11.sp, color: IConstant.main_color));
    }
  }

  String getCurrentLevel(dynamic item) {
    String completionDegree = LanguageConfig.get(
        LanguageConfigKeys.Shop_pocket_task_completion_degree);
    return sprintf(completionDegree, [
      "${BaseModel.getString(item, "level")}/${BaseModel.getString(item, "levelNum")}"
    ]);
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
    String endTime = BaseModel.getString(item, "endTime");
    DateTime dateTime = DateTime.parse(endTime);
    dateTime = dateTime.add(Duration(minutes: _countedTimeout));
    String formatDate = FormatUtil.formatLineYMDHMS(dateTime);
    if (Util.isTimeout2(startTime: serviceTime, endTime: formatDate)) {
      return Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_completed_counted),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 10.sp, color: IConstant.green_color));
    } else {
      return CountDownView(startTime: serviceTime, endTime: formatDate,
          fontSize: 10.sp,
          textColor: IConstant.main_color,
          prefix: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_counted_shop),
          stop: LanguageConfig.get(LanguageConfigKeys.Shop_activity_closed));
    }
  }

}
