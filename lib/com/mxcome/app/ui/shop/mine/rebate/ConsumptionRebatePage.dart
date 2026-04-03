import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/IURLConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/model/BaseRsp.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CountDownView.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/LoadImageView.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/ToggleSwitch.dart';
import 'package:mxcome/com/mxcome/app/utils/Adapt.dart';
import 'package:mxcome/com/mxcome/app/utils/AppUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import '../../widget/GenAvatar.dart';
import 'MySubordinatePage.dart';
import 'RebateDetailPage.dart';
import 'RebateQrScanPage.dart';

class ConsumptionRebatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ConsumptionRebatePageState();
  }
}

class ConsumptionRebatePageState extends BaseKeepAliveState<ConsumptionRebatePage> {

  dynamic userInfo;

  dynamic rebateInfo;

  int currentIndex = 0;

  List<dynamic> orderItemList = [];

  dynamic memberRebateCycle;

  @override
  void initState() {
    super.initState();
    loadContentDatas();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    dynamic useData = await AppUtils.getUserInfo();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_SSO_REBATE_HOME, {});
    BaseRsp res = await HttpUtils.post(IURLConstant.MALL_SSO_REBATE_DETAIL, {"cycleId": ""});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        userInfo = useData;
        rebateInfo = rsp.data;
        memberRebateCycle = BaseModel.getDynamic(rsp.data, "memberRebateCycle");
        orderItemList = BaseModel.isNotEmpty(res.data, "orderItemList") ? BaseModel.getDynamic(res.data, "orderItemList") : [];
      });
    }else {
      setState(() {
        memberRebateCycle = null;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getServiceTime();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_wallet_rebate),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return memberRebateCycle == null ? ViewUtils.buildLoading() : Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 20.w),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              showPop(0.9 * Adapt.getWindowHeight(), RebateQrScanPage());
            },
            child: SizedBox(
              width: 85.w,
              height: 85.w,
              child: Stack(
                children: [
                  buildAvatar(),
                  Positioned(right: -5.w, bottom: -5.w, child: Image.asset(
                    "assets/icons/ic_rebate_scan.png",
                    width: 36.w,
                    height: 36.w,
                  ),)
                ],
              ),
            ),
          ),
          SizedBox(height: 30.w,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: Image.asset("assets/icons/bg_consumption_rebate.png").image),
            ),
            child: Column(
              children: [
                Container(
                  height: 40.w,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(-1, 0),
                      end: Alignment(1.00, 0.00),
                      colors: [Color(0xFFD8E4FF), Color(0xFFFFD2D3)],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14.r),
                      topRight: Radius.circular(14.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            "assets/icons/ic_rebate_data_1.png",
                            width: 24.w,
                            height: 24.w,
                          ),
                          SizedBox(width: 8.w,),
                          Text(
                            LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_my_subordinate),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: IConstant.text_color,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(width: 8.w,),
                          Container(
                            width: 35.w,
                            height: 28.w,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999.r),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${BaseModel.getInt(rebateInfo, "childNum")}",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: IConstant.main_color,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          showPop(0.9 * Adapt.getWindowHeight(), MySubordinatePage());
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                          ),
                          child: Text(
                            LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_view_subordinate),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: IConstant.text_color,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15.w),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1.w, color: IConstant.line_color),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "assets/icons/ic_rebate_data_2.png",
                                width: 24.w,
                                height: 24.w,
                              ),
                              SizedBox(width: 6.w,),
                              Text(
                                LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_current_order),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: IConstant.text_color,
                                    fontSize: 12.sp,
                                ),
                              ),
                              SizedBox(width: 6.w,),
                              Container(
                                constraints: BoxConstraints(
                                    maxWidth: 110.w
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.w),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    color: IConstant.red_bg_color3,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
                                  ),
                                  child: Text(
                                    LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_condition),
                                    style: TextStyle(
                                      color: IConstant.main_color,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Text(
                            '${BaseModel.getInt(rebateInfo, "itemNum")}${LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_order)}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: IConstant.text_color,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(height: 15.w,),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Row(
                      //       children: [
                      //         Image.asset(
                      //           "assets/icons/ic_calculate_time.png",
                      //           width: 24.w,
                      //           height: 24.w,
                      //         ),
                      //         SizedBox(width: 8.w,),
                      //         Text(
                      //           '统计时间',
                      //           textAlign: TextAlign.center,
                      //           style: TextStyle(
                      //             color: IConstant.text_color,
                      //             fontSize: 12.sp,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //     CountDownView(startTime: serviceTime, endTime: BaseModel.getString(rebateInfo, "endTime"), fontSize: 12.w,
                      //       textColor: IConstant.main_color,
                      //       stop: LanguageConfig.get(LanguageConfigKeys.Shop_activity_closed))
                      //   ],
                      // ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 14.w, right: 14.w, top: 14.w, bottom: 14.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_rules_1),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          height: 1.14,
                        ),
                      ),
                      SizedBox(height: 3.w,),
                      Text(
                        LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_rules_2),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          height: 1.14,
                        ),
                      ),
                      SizedBox(height: 3.w,),
                      Text(
                        LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_rules_3),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          height: 1.14,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              showPop(0.90 * Adapt.getWindowHeight(), RebateDetailPage(cycleId: BaseModel.getString(memberRebateCycle, "cycleId"),));
            },
            child: Container(
              margin: EdgeInsets.only(top: 20.w, left: 18.w, right: 18.w),
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.w),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.w, color: IConstant.line_color),
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_my_profits),
                    style: TextStyle(
                      color: IConstant.text_color,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  Row(
                    children: [
                      buildMyRebateList(),
                      Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18.sp,)
                    ],
                  )
                ],
              ),
            ),
          ),
          //buildConsumptionRecord()
        ],
      ),
    );
  }

  Widget buildMyRebateList() {
    List<dynamic> showItemList = orderItemList.length > 3 ? orderItemList.sublist(0, 3) : orderItemList;
    return Row(
      children: showItemList.map((item) => buildMyRebateItem(item)).toList(),
    );
  }

  Widget buildMyRebateItem(dynamic item) {
    return Row(
      children: [
        ClipOval(
          child: LoadImageView(24.w, 24.w, BaseModel.getString(item, "icon")),
        ),
        SizedBox(width: 8.w)
      ],
    );
  }

  Widget buildAvatar() {
    String avatar = BaseModel.getString(userInfo, "icon");
    return ClipOval(
      child: GenAvatar(avatar),
    );
  }
}
