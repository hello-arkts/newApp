import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/login/RedLevelPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/UserInfoEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/promotion/MinePrizePage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/promotion/SelectPrizePage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:mxcome/com/mxcome/app/utils/Adapt.dart';
import 'package:mxcome/com/mxcome/app/utils/AppUtils.dart';
import 'package:sprintf/sprintf.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IURLConstant.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/HttpUtils.dart';
import '../../model/PromotionLevelModel.dart';
import '../../utils/FormatUtil.dart';
import '../../widget/LoadImageView.dart';
import 'PromotionDetailPage.dart';

class PromotionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PromotionPageState();
  }
}

class PromotionPageState extends BaseKeepAliveState<PromotionPage> {

  double _redAmount = 0;
  double _lastAmount = 0;
  int _currentLevel = 1;
  List<PromotionLevelModel> _amountLevelList = [];
  final List<dynamic> _extendMemberList = [];
  int _oneLevelExtendNum = 0; //推广一级人数
  int _twoLevelExtendNum = 0; //推广二级人数
  int _threeLevelExtendNum = 0; //推广三级人数
  int _todayOneLevelExtendNum = 0; //今日新增一级
  int _todayThreeLevelExtendNum = 0; //今日新增三级
  int _todayTwoLevelExtendNum = 0; //今日新增二级
  String redActivityId = '';

  @override
  void initState() {
    super.initState();
    loadContentDatas();
    //handleRedInfo();
  }

  @override
  Future<void> loadContentDatas() async {
    BaseRsp res = await HttpUtils.post(IURLConstant.MALL_SSO_INFO, {});
    dynamic data = res.data;
    int isRedWindow = BaseModel.getInt(data, "isRedWindow");
    setState(() {
      _currentLevel = BaseModel.getInt(res.data, "redStage");
      redActivityId = BaseModel.getString(data, "redActivityId");
    });

    isLoading = true;
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_RED_HOME, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<PromotionLevelModel> tempList = [];
      List<dynamic> dataList = BaseModel.getDynamic(rsp.data, "amountLevelList");
      for (var item in dataList) {
        tempList.add(PromotionLevelModel.fromJson(item, _currentLevel));
      }
      setState(() {
        _amountLevelList = tempList;
        _redAmount = BaseModel.getDouble(rsp.data, "redAmount");
        _lastAmount = (isRedWindow == 1 || _redAmount == 0) ? 0 : BaseModel.getDouble(rsp.data, "lastAmount");
        _oneLevelExtendNum = BaseModel.getInt(rsp.data, "oneLevelExtendNum");
        _twoLevelExtendNum = BaseModel.getInt(rsp.data, "twoLevelExtendNum");
        _threeLevelExtendNum = BaseModel.getInt(rsp.data, "threeLevelExtendNum");
        _todayOneLevelExtendNum = BaseModel.getInt(rsp.data, "todayOneLevelExtendNum");
        _todayTwoLevelExtendNum = BaseModel.getInt(rsp.data, "todayTwoLevelExtendNum");
        _todayThreeLevelExtendNum = BaseModel.getInt(rsp.data, "todayThreeLevelExtendNum");
      });
    }
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_promotion_rewards),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
        actions: [
          InkWell(
            onTap: () {
              nextPage(MinePrizePage(), false);
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
              child: Image.asset("assets/icons/promotion_prize.png"),
            ),
          ),
        ],
      ),
      body: buildBody(),
    );
  }

  // Future<void> handleRedInfo() async {
  //   BaseRsp res = await HttpUtils.post(IURLConstant.MALL_SSO_INFO, {});
  //   int networkRedPower = BaseModel.getInt(res.data, "redPower");
  //   int isRedWindow = BaseModel.getInt(res.data, "isRedWindow");
  //   if ((networkRedPower ==1 || networkRedPower == 3) && isRedWindow == 1) { //有资格 isRedWindow (0：不需要弹窗；1：需要弹窗)
  //     await AppUtils.setUserInfo(res.data);
  //     EventBusUtil.getInstance().emit(UserInfoEvent(userInfoStatus: UserInfoStatus.complete));
  //     BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_RED_HOME, {});
  //     if (rsp.retCode == RspRetCode.SUCCESS) {
  //       int currentLevel = BaseModel.getInt(res.data, "redLevel");
  //       List<dynamic> dataList = BaseModel.getDynamic(rsp.data, "amountLevelList");
  //       for (var item in dataList) {
  //         int redLevel = BaseModel.getInt(item, "redLevel");
  //         double amount = BaseModel.getDouble(item, "amount");
  //         if (redLevel == currentLevel - 1) {
  //           showPop(0.55 * Adapt.getWindowHeight(), RedLevelPage(amount, callBack: (BuildContext ctx) {
  //             loadContentDatas();
  //           }), enableDrag: false);
  //           break;
  //         }
  //       }
  //     }
  //   }
  // }

  void loadUserInfo() async {
    bool isLogin = await AppUtils.isLogined();
    if (isLogin) {
      BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_SSO_INFO, {});
    }
  }

  Widget buildBody() {
    return ListView(
      children: [
        Row(
          children: [
            SizedBox(width: 16.w),
            Image.asset("assets/icons/promotion_wallet.png", width: 30.w),
            SizedBox(width: 10.w),
            PriceText(
              _redAmount,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: IConstant.main_color,
            ),
            SizedBox(width: 10.w),
            Container(
              decoration: BoxDecoration(
                color: IConstant.green_bg_color,
                borderRadius: BorderRadius.all(Radius.circular(4.w)),
              ),
              padding: EdgeInsets.fromLTRB(4.w, 2.w, 4.w, 2.w),
              child: Text("+${FormatUtil.price2String(_lastAmount)}",
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.green_color)),
            )
          ],
        ),
        buildLevel(),
        buildContent(),
        buildDailyPrize(),
        buildRules()
      ],
    );
  }

  Widget buildLevel() {
    return Container(
      height: 30.w,
      margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
      decoration: BoxDecoration(
        border: Border.all(width: 1.w, color: IConstant.red_translucent_color),
        borderRadius: BorderRadius.all(Radius.circular(20.w)),
      ),
      child: Row(
        children: _amountLevelList.map((e) => buildLevelItem(e)).toList(),
      ),
    );
  }

  Widget buildLevelItem(PromotionLevelModel model) {
    return Expanded(
        child: Container(
        height: 30.w,
        decoration: BoxDecoration(
          border: Border.all(
              width: 1.w,
              color: model.isSelect()
                  ? IConstant.main_color
                  : IConstant.white_color),
          borderRadius: BorderRadius.all(Radius.circular(20.w)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_activity_for_the_level), [ model.redLevel ]),
                style: TextStyle(fontSize: 12.w, color: IConstant.text_color)),
            SizedBox(width: 4.w),
            Padding(
              padding: EdgeInsets.only(top: 2.w),
              child: Text(FormatUtil.price2String(model.amount),
                  style: TextStyle(fontSize: 12.w, color: IConstant.text_color)),
            )
          ],
        ),
      ),
    );
  }

  Widget buildContent() {
    return Card(
      margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 16.w),
      elevation: 4.w,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(12.w),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(10.w, 14.w, 10.w, 14.w),
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: Image.asset(
                      "assets/icons/promotion_bg.png",
                    ).image)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_red_title),
                    style: TextStyle(
                        fontSize: 17.sp, color: IConstant.white_color)),
                SizedBox(height: 8.w),
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_red_sub_title),
                    style: TextStyle(
                        fontSize: 15.w, color: IConstant.white_color)),
              ],
            ),
          ),
          LinearProgressIndicator(
            value: getCompletionProgress(),
            backgroundColor: IConstant.grey_bg_color,
            valueColor: const AlwaysStoppedAnimation<Color>(IConstant.main_color),
          ),
          SizedBox(height: 12.w),
          Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  SizedBox(width: 16.w),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 70.w
                    ),
                    child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_number_promoters),
                        style: TextStyle(
                            fontSize: 12.w, color: IConstant.text_color)),
                  ),
                  SizedBox(width: 10.w),
                  Text("$_oneLevelExtendNum / $_twoLevelExtendNum / $_threeLevelExtendNum",
                      style: TextStyle(
                          fontSize: 12.w, color: IConstant.text_color))
                ],
              )),
              Expanded(
                  child: Row(
                children: [
                  SizedBox(width: 16.w),
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: 70.w
                    ),
                    child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_new_today),
                        style: TextStyle(
                            fontSize: 12.w, color: IConstant.text_color)),
                  ),
                  SizedBox(width: 10.w),
                  Text("$_todayOneLevelExtendNum / $_todayTwoLevelExtendNum / $_todayThreeLevelExtendNum",
                      style: TextStyle(
                          fontSize: 12.w, color: IConstant.text_color))
                ],
              ))
            ],
          ),
          SizedBox(height: 12.w),
          Divider(height: 1.w),
          Container(
            padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
            child: Row(
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_participated),
                    style:
                        TextStyle(fontSize: 12.w, color: IConstant.text_color)),
                Expanded(child: buildImages()),
                InkWell(
                  onTap: () {
                    nextPage(PromotionDetailPage(redActivityId, _oneLevelExtendNum, _twoLevelExtendNum, _threeLevelExtendNum), false);
                  },
                  child: Row(
                    children: [
                      Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_promotion_details),
                          style:
                          TextStyle(fontSize: 12.w, color: IConstant.text_color)),
                      Icon(Icons.chevron_right,
                          size: 22.w, color: IConstant.text_color)
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildImages() {
    List<dynamic> showItemList = _extendMemberList.length > 5 ? _extendMemberList.sublist(0, 5) : _extendMemberList;
    return Row(
      children: showItemList.map((item) => buildImageItem(item)).toList(),
    );
  }

  Widget buildImageItem(dynamic item) {
    return InkWell(
        onTap: () {
          nextPage(PromotionDetailPage(redActivityId, _oneLevelExtendNum, _twoLevelExtendNum, _threeLevelExtendNum), false);
        },
        child: Row(
          children: [
            ClipOval(
              child: LoadImageView(58.w, 58.w, BaseModel.getString(item, "icon")),
            ),
            SizedBox(width: 10.w)
          ],
        ));
  }

  double getCompletionProgress() {
    if (_amountLevelList.isEmpty) {
      return 0;
    } else {
      for (PromotionLevelModel item in _amountLevelList) {
        if (item.redStage == _currentLevel) {
          if (item.amount == 0) {
            return 0;
          } else {
            return _redAmount / item.amount;
          }
        }
      }
      return 0;
    }
  }

  Widget buildDailyPrize() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 0.w),
      padding: EdgeInsets.fromLTRB(14.w, 8.w, 10.w, 8.w),
      decoration: BoxDecoration(
          border: Border.all(width: 1.w, color: IConstant.line_color),
          borderRadius: BorderRadius.all(Radius.circular(10.w))),
      child: InkWell(
        onTap: () {
          nextPage(SelectPrizePage(_oneLevelExtendNum), false);
        },
        child: Row(
          children: [
            Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_Daily_direct_promotion_prizes),
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: IConstant.text_color)),
            expandeSpace,
            Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_choose_prize),
                style: TextStyle(fontSize: 12.w, color: IConstant.text_color)),
            Icon(Icons.chevron_right, size: 22.w, color: IConstant.text_color),
          ],
        ),
      ),
    );
  }

  Widget buildRules() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 40.w, 16.w, 0.w),
      padding: EdgeInsets.fromLTRB(14.w, 14.w, 14.w, 14.w),
      decoration: BoxDecoration(
          border: Border.all(width: 1.w, color: IConstant.line_color),
          borderRadius: BorderRadius.all(Radius.circular(10.w))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_promotion_rules),
              style: TextStyle(fontSize: 14.w, fontWeight: FontWeight.bold, color: IConstant.text_color)),
          SizedBox(height: 8.w),
          Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_promotion_rules_tip1),
              style: TextStyle(fontSize: 12.w, color: IConstant.text_color)),
          SizedBox(height: 8.w),
          Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_promotion_rules_tip2),
              style: TextStyle(fontSize: 12.w, color: IConstant.text_color)),
          SizedBox(height: 8.w),
          Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_promotion_rules_tip3),
              style: TextStyle(fontSize: 12.w, color: IConstant.text_color)),
          SizedBox(height: 8.w),
          Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_promotion_rules_tip4),
              style: TextStyle(fontSize: 12.w, color: IConstant.text_color)),
          SizedBox(height: 8.w),
          Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_promotion_rules_tip5),
              style: TextStyle(fontSize: 12.w, color: IConstant.text_color)),
          SizedBox(height: 8.w),
          Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_promotion_rules_tip6),
              style: TextStyle(fontSize: 12.w, color: IConstant.text_color)),
        ],
      ),
    );
  }
}
