
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IURLConstant.dart';
import 'package:mxcome/com/mxcome/app/Logger.dart';
import 'package:mxcome/com/mxcome/app/model/BaseRsp.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/ActivityMemberModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/ClockComponent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CountDownView.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/LoadImageView.dart';
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseModel.dart';
import '../../../utils/AppUtils.dart';
import '../brand/BrandShopPage.dart';
import '../utils/Util.dart';
import 'ActivityDetailPage.dart';

class ActivityItemStart extends StatefulWidget {

  String serviceTime;

  ActivityItemStart({this.serviceTime = '', super.key});

  @override
  State<ActivityItemStart> createState() => ActivityItemStartState();

}

class ActivityItemStartState extends BaseKeepAliveState<ActivityItemStart> {

  List<ActivityMemberModel> _activityMemberList = [];

  @override
  void initState() {
    super.initState();
    loadContentDatas();
  }

  @override
  void didChangeDependencies() async{
    getServiceTime();
  }

  @override
  Future<void> loadContentDatas() async {
    await getServiceTime();
    dynamic data = await AppUtils.getPocketData();
    List<dynamic> activityMemberList = BaseModel.isNotEmpty(data, "activityMemberList") ? BaseModel.getDynamic(data, "activityMemberList") : [];
    List<ActivityMemberModel> dataList = [];
    for (var item in activityMemberList) {
      int status = BaseModel.getInt(item, "status");
      String endTime = BaseModel.getString(item, "endTime");
      if (status == 0) {
        if (!Util.isTimeout2(startTime: serviceTime, endTime: endTime)) {
          String createTime = BaseModel.getString(item, "createTime");
          dataList.add(ActivityMemberModel(createTime, endTime, item));
        }
      }
    }
    setState(() {
      _activityMemberList = dataList;
    });
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
    ActivityMemberModel model = _activityMemberList[index];
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
                dynamic activity = await AppUtils.getActivity(BaseModel.getString(model.activityMember, "activityId"));
                activityStart(activity, false);
              },
              child: LoadImageView(double.infinity, 92.w, BaseModel.getString(model.activityMember, "activityPic"), alignment: Alignment.topCenter),
            ),
          ),
          // LinearProgressIndicator(
          //   value: getTimeDouble(model),
          //   backgroundColor: IConstant.white_color,
          //   valueColor: const AlwaysStoppedAnimation<Color>(IConstant.main_color),
          // ),
          SizedBox(height: 4.w,),
          Row(
            children: [
              Expanded(flex: 1, child: InkWell(
                onTap: () {
                  nextPage(BrandShopPage(BaseModel.getString(model.activityMember, "shopId")), false);
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipOval(child: LoadImageView(30.w, 30.w, BaseModel.getString(model.activityMember, "shopIcon"))),
                      SizedBox(width: 6.w),
                      Expanded(child: Text(BaseModel.getString(model.activityMember, "shopName"),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.title_color)))
                    ],
                  ),
                ),
              )),
              Expanded(flex: 1, child: buildStopTime(model.activityMember)),
              Expanded(flex: 1, child: Container(
                margin: EdgeInsets.fromLTRB(16.w, 6.w, 8.w, 8.w),
                child: buildRightItem(model.activityMember),
              ))
            ],
          )
        ],
      ),
    );
  }

  double getTimeDouble(ActivityMemberModel model) {
    DateTime createTime = DateTime.parse(model.createTime);
    DateTime endTime = DateTime.parse(model.endTime);
    int spaceTime = endTime.millisecondsSinceEpoch - createTime.millisecondsSinceEpoch;
    int currentSpaceTime = endTime.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
    return (currentSpaceTime / spaceTime);
  }

  Widget buildRightItem(dynamic activityMember) {
    String activityId = BaseModel.getString(activityMember, "activityId");
    return InkWell(onTap: () async {
      dynamic activity = await AppUtils.getActivity(activityId);
      activityStart(activity, true);
    },
        child: Container(
          padding: EdgeInsets.fromLTRB(10.w, 6.w, 10.w, 6.w),
          decoration: BoxDecoration(
              color: IConstant.main_color,
              borderRadius: BorderRadius.circular(20.w)
          ),
          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_continue_to_challenge), maxLines: 2, overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center, style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
        ));
  }

  Widget buildStopTime(dynamic item) {
    String endTime = BaseModel.getString(item, "endTime");
    return CountDownView(startTime: serviceTime, endTime: endTime,
        fontSize: 11.w,
        textColor: IConstant.main_color,
        prefix: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_remain),
        stop: LanguageConfig.get(LanguageConfigKeys.Shop_activity_closed));
  }

}
