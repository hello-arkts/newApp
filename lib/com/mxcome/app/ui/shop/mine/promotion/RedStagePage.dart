import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/login/RedLevelPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/GetPrizeEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/UserInfoEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/promotion/MinePrizePage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/promotion/SelectPrizePage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CountDownView.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:mxcome/com/mxcome/app/utils/Adapt.dart';
import 'package:mxcome/com/mxcome/app/utils/AppUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import 'package:sprintf/sprintf.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IURLConstant.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/HttpUtils.dart';
import '../../model/PromotionLevelModel.dart';
import '../../utils/FormatUtil.dart';
import '../../widget/LoadImageView.dart';
import 'PromotionDetailPage.dart';
import 'RedHistoryPage.dart';

class RedStagePage extends StatefulWidget {

  RedStagePage();

  @override
  State<StatefulWidget> createState() {
    return RedStagePageState();
  }
}

class RedStagePageState extends BaseKeepAliveState<RedStagePage> {

  int _currentLevel = 1;

  List<PromotionLevelModel> _amountLevelList = [];

  int _oneLevelExtendNum = 0; //推广一级人数

  int _twoLevelExtendNum = 0; //推广二级人数

  int _threeLevelExtendNum = 0; //推广三级人数

  int _todayOneLevelExtendNum = 0; //今日新增一级

  int _todayThreeLevelExtendNum = 0; //今日新增三级

  int _todayTwoLevelExtendNum = 0; //今日新增二级

  final ScrollController _scrollController = ScrollController();

  String redEndTime = "";

  int currentChildLevel = 1;

  int totalChildLevel = 1;

  double currentChildLevelAmount = 0;

  int pullNewComers = 0;

  double _redAmount = 0;

  double _redAmountSum = 0;

  int redPower = 1;

  dynamic getPrizeEvent;

  String _redActivityId = '';

  String _redTitle = '';

  int isRedWindow = 0;

  @override
  void initState() {
    super.initState();
    getPrizeEvent = EventBusUtil.getInstance().on<GetPrizeEvent>((event) {
      refreshPullValue();
    });
    loadContentDatas();
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(getPrizeEvent);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getServiceTime();
  }

  @override
  Future<void> loadContentDatas() async {
    setState(() {
      isLoading = true;
    });
    BaseRsp res = await HttpUtils.post(IURLConstant.MALL_SSO_INFO, {});
    dynamic userInfo = res.data;
    setState(() {
      pullNewComers = BaseModel.getInt(userInfo, "pullNewComers");
    });

    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_RED_HOME, {'redActivityId' : _redActivityId});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      _currentLevel = BaseModel.getInt(rsp.data, "redStage");
      redEndTime = BaseModel.getString(rsp.data, "redEndTime");
      redPower = BaseModel.getInt(rsp.data, "redPower");
      isRedWindow = BaseModel.getInt(rsp.data, "isRedWindow");
      _redActivityId = BaseModel.getString(rsp.data, 'redActivityId');
      List<PromotionLevelModel> tempList = [];
      List<dynamic> dataList = BaseModel.getDynamic(rsp.data, "amountLevelList");
      if(dataList.isNotEmpty) {
        for (var item in dataList) {
          tempList.add(PromotionLevelModel.fromJson(item, _currentLevel));
        }
        _scrollToSelectedIndex();
      }
      handleRedInfo(dataList);
      isLoading = false;
      setState(() {
        _redTitle = BaseModel.getString(rsp.data, "redActivityName");
        _amountLevelList = tempList;
        _redAmount = BaseModel.getDouble(rsp.data, "redAmount");
        _redAmountSum = BaseModel.getDouble(rsp.data, "redAmountSum");
        _oneLevelExtendNum = BaseModel.getInt(rsp.data, "oneLevelExtendNum");
        _twoLevelExtendNum = BaseModel.getInt(rsp.data, "twoLevelExtendNum");
        _threeLevelExtendNum = BaseModel.getInt(rsp.data, "threeLevelExtendNum");
        _todayOneLevelExtendNum = BaseModel.getInt(rsp.data, "todayOneLevelExtendNum");
        _todayTwoLevelExtendNum = BaseModel.getInt(rsp.data, "todayTwoLevelExtendNum");
        _todayThreeLevelExtendNum = BaseModel.getInt(rsp.data, "todayThreeLevelExtendNum");
        currentChildLevel = BaseModel.getInt(rsp.data, "levelStageNow");
        totalChildLevel = BaseModel.getInt(rsp.data, "levelStageAll");
        currentChildLevelAmount = BaseModel.getDouble(rsp.data, "levelAmount");
      });
    }else {
      ViewUtils.displayToast(rsp.msg);
      setState(() {
        isLoading = false;
      });
    }
  }

  refreshPullValue() async {
    BaseRsp res = await HttpUtils.post(IURLConstant.MALL_SSO_INFO, {});
    dynamic data = res.data;
    setState(() {
      pullNewComers = BaseModel.getInt(data, "pullNewComers");
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        title: Text(_redTitle,
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color, fontWeight: FontWeight.bold)),
        actions: [
          InkWell(
            onTap: () {
              nextPage(RedHistoryPage(pullNewComers, callBack: (redActivityId, redTitle) {
                _redTitle = redTitle;
                _redActivityId = redActivityId;
                loadContentDatas();
              },), false);
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
              child: Image.asset("assets/icons/ic_red_history.png"),
            ),
          ),
        ],
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Future<void> handleRedInfo(dynamic amountLevelList) async {
    if ((redPower ==1 || redPower == 2 || redPower == 3) && isRedWindow == 1) { //有资格 isRedWindow (0：不需要弹窗；1：需要弹窗)
      if(redPower == 3) {
        var item = amountLevelList[_currentLevel - 1];
        double amount = BaseModel.getDouble(item, "amount");
        showPop(0.55 * Adapt.getWindowHeight(), RedLevelPage(amount, _redActivityId, callBack: (BuildContext ctx) {
          loadContentDatas();
        }), enableDrag: false);
      }else {
        for (var item in amountLevelList) {
          int redLevel = BaseModel.getInt(item, "redLevel");
          double amount = BaseModel.getDouble(item, "amount");
          if (redLevel == _currentLevel - 1) {
            showPop(0.55 * Adapt.getWindowHeight(), RedLevelPage(amount, _redActivityId, callBack: (BuildContext ctx) {
              loadContentDatas();
            }), enableDrag: false);
            break;
          }
        }
      }
    }
  }

  Widget buildBody() {
    return isLoading ? ViewUtils.buildLoading() : ListView(
      children: [
        buildLevel(),
        buildContent(),
        buildDailyPrize(),
        buildRules()
      ],
    );
  }

  Widget buildLevel() {
    return _amountLevelList.isNotEmpty ? Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 12.w),
          height: 88.w,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            scrollDirection: Axis.horizontal,
            //physics: const NeverScrollableScrollPhysics(),
            controller: _scrollController,
            itemCount: _amountLevelList.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    width: 114.w,
                    height: 65.w,
                    decoration: BoxDecoration(
                      color: getRedStageColor(index),
                      borderRadius: BorderRadius.all(Radius.circular(16.w)),
                      border: Border.all(color: index == _currentLevel - 1? IConstant.main_color : Colors.transparent)
                    ),
                    child: buildLevelItem(index)
                  ),
                  index == _currentLevel - 1  ? Padding(
                    padding: EdgeInsets.only(top: 11.w),
                    child: Image.asset("assets/icons/promotion_polygon.png", width: 17.w, height: 12.w,),
                  ): Container(),
                ],
              );
            }, separatorBuilder: (BuildContext context, int index) {
              return SizedBox(width: 10.w,);
          },
          ),
        ),
        Container(
          transform: Matrix4.translationValues(0, -2.w, 0),
          height: 66.w,
          width: double.infinity,
          color: IConstant.main_color,
          padding: EdgeInsets.fromLTRB(18.w, 9.w, 0.w, 0.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.only(left: currentChildLevelAmount > 10000.00 ? getCompletionProgress() + 10.w : getCompletionProgress() + 20.w ,), child: Column(
                    children: [
                      PriceText(getRedLevelAmount(), fontSize: 14.sp, color: Colors.white, isFormat: false),
                      Image.asset("assets/icons/promotion_polygon_down.png", width: 12.w, height: 9.w,),
                    ],
                  ),),
                  expandeSpace,
                  Padding(
                    padding: EdgeInsets.only(right: 18.w),
                    child: Row(
                      children: [
                        Text('$currentChildLevel',
                            style: TextStyle(fontSize: 14.sp, color: IConstant.white_color)),
                        Text('/$totalChildLevel',
                            style: TextStyle(fontSize: 14.sp, color: IConstant.white_color.withOpacity(0.65))),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 5.w),
                    child: Image.asset("assets/icons/promotion_coin.png", width: 22.w, height: 22.w,),
                  ),
                  SizedBox(width: 15.w,),
                  Row(
                    children: [
                      Stack(
                        children: [
                          // 下面的背景盒子
                          Container(
                            height: 10.w,
                            width: 246.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(14.r)),
                              color: Colors.white.withOpacity(0.35),
                            ),
                          ),
                          // 上面的进度条盒子
                          Container(
                            height: 10.w,
                            width: getCompletionProgress(), // 动态更改进度条盒子的宽度即可
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(14.r)),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 30.w,),
                      Text('${currentChildLevelAmount.toInt()}', style: TextStyle(fontSize: 14.sp, color: IConstant.white_color)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ):Container();
  }

  double getRedLevelAmount() {
    if(redPower == 3) {
      return currentChildLevelAmount;
    }else {
      return _redAmount > currentChildLevelAmount ? 0 : _redAmount;
    }
  }

  getRedStageColor(int index) {
    if(redPower == -1 && index == _currentLevel - 1) {
      return IConstant.white_bg_color;
    }else {
      return index <= _currentLevel - 1 ? IConstant.red_bg_color4 : IConstant.white_bg_color;
    }
  }

  void _scrollToSelectedIndex() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      final double itemWidth = 123.w; // 列表项的宽度
      final double screenWidth = MediaQuery.of(context).size.width - 40.w;
      final double scrollOffset = (_currentLevel - 1)  * itemWidth - (screenWidth - itemWidth) / 2;
      _scrollController.animateTo(
        scrollOffset,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    });
  }

  Widget buildLevelItem(int index) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 8.w, 11.w, 0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLevelTop(_amountLevelList[index], index),
          SizedBox(height: 4.w,),
          buildLevelBottom(_amountLevelList[index], index),
        ],
      ),
    );
  }

  Widget buildLevelTop(PromotionLevelModel model, int index) {
    if(index < _currentLevel - 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_activity_for_the_level), [ model.redLevel ]), style: TextStyle(fontSize: 14.sp, color: IConstant.main_color)),
          Image.asset("assets/icons/confirm.png", width: 14.w, height: 14.w,),
        ],
      );
    }else if(index == _currentLevel - 1){
      return redPower != 3 ? Row(
        children: [
          Icon(Icons.circle, color: IConstant.main_color, size: 8.w,),
          SizedBox(width: 6.w,),
          redPower == -1 ? Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_activity_for_the_level), [ model.redLevel ]), style: TextStyle(fontSize: 14.sp, color: IConstant.main_color) ) : Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_passing_levels), style: TextStyle(fontSize: 14.sp, color: IConstant.main_color)),
        ],
      ) : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_over_all_level), style: TextStyle(fontSize: 14.sp, color: IConstant.main_color)),
          Image.asset("assets/icons/confirm.png", width: 14.w, height: 14.w,),
        ],
      );
    }else{
      return Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_activity_for_the_level), [ model.redLevel ]),
          style: TextStyle(fontSize: 14.w, color: IConstant.text_color.withOpacity(0.55)));
    }
  }

  Widget buildLevelBottom(PromotionLevelModel model, int index) {
    return PriceText(fixed: 0,model.amount, fontSize: 16.sp, color: index <= _currentLevel - 1 ? IConstant.main_color : IConstant.text_color.withOpacity(0.35),);
  }

  Widget buildContent() {
    return Container(
      margin: EdgeInsets.fromLTRB(18.w, 20.w, 18.w, 16.w),
      padding: EdgeInsets.fromLTRB(15.w, 10.w, 15.w, 20.w),
      decoration: BoxDecoration(
          border: Border.all(width: 1.w, color: IConstant.line_color),
          borderRadius: BorderRadius.all(Radius.circular(10.w))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              redEndTime.isEmpty? Container() : Row(
                children: [
                  Image.asset("assets/icons/task_icon1.png", width: 14.w, height: 14.w,),
                  SizedBox(width: 3.w,),
                  redPower == -1 ? Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_expired), style: TextStyle(fontSize: 14.sp, color: IConstant.main_color)) :
                  CountDownView(startTime: serviceTime, endTime: redEndTime,
                      fontSize: 12.w,
                      textColor: IConstant.main_color,
                      stop: LanguageConfig.get(LanguageConfigKeys.Shop_activity_closed))
                ],
              ),
              InkWell(
                onTap: () {
                  nextPage(PromotionDetailPage(_redActivityId, _oneLevelExtendNum, _twoLevelExtendNum, _threeLevelExtendNum), false);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.w, color: IConstant.line_color),
                      borderRadius: BorderRadius.all(Radius.circular(16.r))
                  ),
                  child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_promotion_details), style: TextStyle(fontSize: 13.w, color: IConstant.main_color, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
          SizedBox(height: 20.w,),
          Row(
            children: [
              Expanded(flex: 1, child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_number_promoters),
                      style: TextStyle(fontSize: 14.w, color: IConstant.text_color.withOpacity(0.55))),
                  SizedBox(height: 14.w,),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: Text('$_oneLevelExtendNum',
                            style: TextStyle(fontSize: 16.w, color: IConstant.text_color, fontWeight: FontWeight.bold)),
                      ),
                      Container(height: 19.w, color: IConstant.line_color, width: 1.w,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text('$_twoLevelExtendNum',
                            style: TextStyle(fontSize: 16.w, color: IConstant.text_color, fontWeight: FontWeight.bold)),
                      ),
                      Container(height: 19.w, color: IConstant.line_color, width: 1.w,),
                      Padding(
                        padding: EdgeInsets.only(left: 12.w),
                        child: Text('$_threeLevelExtendNum',
                            style: TextStyle(fontSize: 16.w, color: IConstant.text_color, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  )
                ],
              )),
              Container(
                height: 56.w,
                width: 1.w,
                color: IConstant.white_bg_color,
              ),
              Expanded(flex: 1, child: Container(
                padding: EdgeInsets.only(left: 18.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_new_today),
                        style: TextStyle(fontSize: 14.w, color: IConstant.text_color.withOpacity(0.55))),
                    SizedBox(height: 14.w,),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 12.w),
                          child: Text('$_todayOneLevelExtendNum',
                              style: TextStyle(fontSize: 16.w, color: IConstant.text_color, fontWeight: FontWeight.bold)),
                        ),
                        Container(height: 19.w, color: IConstant.line_color, width: 1.w,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text('$_todayTwoLevelExtendNum',
                              style: TextStyle(fontSize: 16.w, color: IConstant.text_color, fontWeight: FontWeight.bold)),
                        ),
                        Container(height: 19.w, color: IConstant.line_color, width: 1.w,),
                        Padding(
                          padding: EdgeInsets.only(left: 12.w),
                          child: Text('$_todayThreeLevelExtendNum',
                              style: TextStyle(fontSize: 16.w, color: IConstant.text_color, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    )
                  ],
                ),
              )),
            ],
          )
        ],
      ),
    );
  }

  double getCompletionProgress() {
    if(redPower == 3) {
      return 246.w;
    }else {
      if(currentChildLevelAmount == 0 || _redAmount > currentChildLevelAmount) {
        return 0;
      }else {
        return _redAmount * 246.w / currentChildLevelAmount;
      }
    }
  }

  Widget buildDailyPrize() {
    return Container(
      margin: EdgeInsets.fromLTRB(18.w, 0.w, 18.w, 0.w),
      padding: EdgeInsets.fromLTRB(15.w, 13.w, 12.w, 20.w),
      decoration: BoxDecoration(
          border: Border.all(width: 1.w, color: IConstant.line_color),
          borderRadius: BorderRadius.all(Radius.circular(10.w))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(constraints: BoxConstraints(minWidth: 160.w), child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_my_push_value), style: TextStyle(fontSize: 14.w, color: IConstant.text_color))),
              Expanded(
                child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_direct_push_tips), style: TextStyle(fontSize: 14.w, color: IConstant.text_color.withOpacity(0.55))),
              )
            ],
          ),
          SizedBox(height: 19.w,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$pullNewComers', style: TextStyle(fontSize: 14.w, color: IConstant.main_color)),
              InkWell(
                onTap: () {
                  nextPage(SelectPrizePage(_oneLevelExtendNum), false);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.w, color: IConstant.line_color),
                      borderRadius: BorderRadius.all(Radius.circular(16.r))
                  ),
                  child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_exchange_prizes), style: TextStyle(fontSize: 13.w, color: IConstant.main_color, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildRules() {
    return Container(
      margin: EdgeInsets.fromLTRB(18.w, 20.w, 18.w, 20.w),
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

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      elevation: 4.w,
      child: Container(
        padding: EdgeInsets.fromLTRB(18.w, 20.w, 18.w, 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_total_gains), style: TextStyle(fontSize: 14.w, color: IConstant.text_color)),
                SizedBox(width: 11.w,),
                Image.asset("assets/icons/promotion_wallet_2.png", width: 14.w),
                SizedBox(width: 7.w,),
                PriceText(_redAmountSum, fontSize: 14.sp),
              ],
            ),
            InkWell(
              onTap: () {
                nextPage(MinePrizePage(), false);
              },
              child: Container(
                height: 30.w,
                padding: EdgeInsets.only(left: 7.w, right: 7.w),
                decoration: BoxDecoration(
                    color: IConstant.main_color,
                    borderRadius: BorderRadius.all(Radius.circular(16.r))
                ),
                child: Row(
                  children: [
                    Image.asset("assets/icons/promotion_center_2.png", width: 22.w, height: 22.w,),
                    SizedBox(width: 4.w,),
                    Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_view_prize), style: TextStyle(fontSize: 13.w, color: IConstant.white_color)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
