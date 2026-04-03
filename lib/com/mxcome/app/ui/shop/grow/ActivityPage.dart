import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/grow/ActivityProductPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/LoadImageView.dart';
import 'package:sprintf/sprintf.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IURLConstant.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../brand/BrandShopPage.dart';
import '../detail/ProductDetailPage.dart';
import '../widget/BigTextButton.dart';

class ActivityPage extends StatefulWidget {

  dynamic activity;

  ActivityPage(this.activity);

  @override
  State<StatefulWidget> createState() {
    return ActivityPageState();
  }
}

class ActivityPageState extends BaseKeepAliveState<ActivityPage> {

  dynamic activity;

  List<dynamic> giftConfigList = [];

  @override
  void initState() {
    super.initState();
    activity = widget.activity;
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_ACTIVITY_GET_INFO, {
      "activityId": BaseModel.getString(activity, "id")
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        giftConfigList = BaseModel.getDynamic(rsp.data, "giftConfigList");
      });
    }
  }

  @override
  void didUpdateWidget(covariant ActivityPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    loadContentDatas();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        leading: Container(),
        centerTitle: true,
        title: Text(BaseModel.getString(activity, "name"),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: Card(
        margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 10.w),
        elevation: 0.w,
        child: ListView(
          children: [
            InkWell(
              onTap: () {
                nextPage(BrandShopPage(BaseModel.getString(activity, "shopId")), false);
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(16.w, 14.w, 16.w, 0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_sponsor),
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.sub_title_color)),
                    SizedBox(height: 4.w),
                    Row(
                      children: [
                        ClipOval(child: LoadImageView(40.w, 40.w, BaseModel.getString(activity, "shopIcon"))),
                        SizedBox(width: 6.w),
                        Text(BaseModel.getString(activity, "shopName"),
                            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: IConstant.title_color)),
                        Icon(Icons.chevron_right, size: 20.w, color: IConstant.text_color),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16.w, 14.w, 16.w, 0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_time),
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.sub_title_color)),
                  SizedBox(height: 8.w),
                  Row(
                    children: [
                      Text(calculateDiffTime(),
                          style: TextStyle(
                              fontSize: 12.sp, color: IConstant.main_color)),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 8.w), child: Container(width: 1.w, height: 10.w, color: IConstant.sub_title_color,),),
                      Text(getActivityTime(),
                          style: TextStyle(
                              fontSize: 12.sp, color: IConstant.text_color)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16.w, 14.w, 16.w, 0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_complete_task),
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.sub_title_color)),
                  SizedBox(height: 8.w),
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/prize_1.png',
                        width: 24.w,
                        height: 24.w,
                      ),
                      SizedBox(width: 6.w),
                      Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_obtain_goods_profit),
                          style: TextStyle(
                              fontSize: 14.sp, color: IConstant.text_color)),
                      SizedBox(width: 6.w),
                      Icon(
                        Icons.check,
                        size: 20.w,
                        color: IConstant.main_color,
                      ),
                    ],
                  ),
                  SizedBox(height: 6.w),
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/prize_2.png',
                        width: 24.w,
                        height: 24.w,
                      ),
                      SizedBox(width: 6.w),
                      Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_obtain_level_prize),
                          style: TextStyle(
                              fontSize: 14.sp, color: IConstant.text_color)),
                      SizedBox(width: 6.w),
                      Icon(
                        Icons.check,
                        size: 20.w,
                        color: IConstant.main_color,
                      ),
                    ],
                  ),
                  SizedBox(height: 6.w),
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/prize_3.png',
                        width: 24.w,
                        height: 24.w,
                      ),
                      SizedBox(width: 6.w),
                      Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_obtain_top_prize),
                          style: TextStyle(
                              fontSize: 14.sp, color: IConstant.text_color)),
                      SizedBox(width: 6.w),
                      Icon(
                        Icons.check,
                        size: 20.w,
                        color: IConstant.main_color,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16.w, 14.w, 16.w, 0.w),
              child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_obtain_top_prize_tips),
                  style: TextStyle(
                      fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.sub_title_color)),
            ),
            Container(
                margin: EdgeInsets.fromLTRB(16.w, 14.w, 16.w, 0.w),
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: IConstant.line_color,
                  borderRadius: BorderRadius.circular(10.w),
                ),
                child: buildPrize()
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildPrize() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 125.w,
        mainAxisSpacing: 10.w, //item上下间隔
        crossAxisSpacing: 10.w, //item左右间隔
      ),
      itemCount: giftConfigList.length,
      itemBuilder: (BuildContext context, int index) {
        return buildGiftItem(giftConfigList[index], index);
      },
    );
  }

  Widget buildGiftItem(dynamic item, int index){
     return Column(
         children: [
           SizedBox(height: 2.w),
           Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_activity_st_place), ["${ 1 + index }"]), style: TextStyle(
               fontSize: 14.sp, color: IConstant.text_color)),
           SizedBox(height: 8.w),
           InkWell(onTap: () {
             nextPageState(ProductDetailPage(BaseModel.getString(item, "productGiftId")), false);
           }, child: Card(
               shape: RoundedRectangleBorder(
                   borderRadius: BorderRadiusDirectional.circular(8.w)),
               clipBehavior: Clip.antiAlias,
               elevation: 1,
               child: LoadImageView(50.w, 50.w, BaseModel.getString(item, "productGiftPic")))),
           SizedBox(height: 8.w),
           Text(getRanking(item), style: TextStyle(
               fontSize: 14.sp, color: IConstant.sub_text_color)),
           SizedBox(height: 8.w),
     ]);
  }

  String getRanking(dynamic item){
    return sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_activity_top), ["${BaseModel.getString(item, "startNum")} - ${BaseModel.getString(item, "endNum")}"]);
  }

  /// 计算天数、小时
  String calculateDiffTime() {
    var nowTime = DateTime.parse(BaseModel.getString(activity, "startTime"));
    var endTime = DateTime.parse(BaseModel.getString(activity, "endTime"));
    var surplus = endTime.difference(nowTime);
    int day = (surplus.inSeconds ~/ 3600) ~/ 24;
    int hour = (surplus.inSeconds ~/ 3600) % 24;
    int minute = surplus.inSeconds % 3600 ~/ 60;
    int second = surplus.inSeconds % 60;

    var str = '';
    if (day > 0) {
      str = '$day${LanguageConfig.get(LanguageConfigKeys.Shop_pocket_days)}';
    }
    if (hour > 0 || (day > 0 && hour == 0)) {
      if (hour < 10) {
        str = "${str}0";
      }
      str = "$str$hour${LanguageConfig.get(LanguageConfigKeys.Shop_pocket_hours)}";
    }
    return str;
  }

  String getActivityTime() {
    String startTime = BaseModel.getString(activity, "startTime");
    String endTime = BaseModel.getString(activity, "endTime");
    String formatStart = FormatUtil.formatMDHM(DateTime.parse(startTime));
    String formatEnd = FormatUtil.formatMDHM(DateTime.parse(endTime));
    return "$formatStart - $formatEnd";
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      elevation: 0.w,
      child: Container(
        margin: EdgeInsets.fromLTRB(80.w, 20.w , 80.w, 20.w),
        child: BigTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_activity_quick_understand), onTap: () {
          activityStartLock(activity);
        }),
      ),
    );
  }

  void activityStartLock(dynamic activity) async {
    String activityId = BaseModel.getString(activity, "id");
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_ACTIVITY_MEMBER_INFO, {
      "activityId": activityId
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      dynamic activityMember = rsp.data;
      rsp = await HttpUtils.post(IURLConstant.MALL_ACTIVITY_GET_INFO, {
        "activityId": activityId
      });
      if (rsp.retCode == RspRetCode.SUCCESS) {
        showPop(0.95 * Adapt.getWindowHeight(), ActivityProductPage(rsp.data, activityMember: activityMember));
      } else {
        ViewUtils.displayToast(rsp.msg);
      }
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

}
