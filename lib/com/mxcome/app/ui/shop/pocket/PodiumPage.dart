
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/pocket/LotteryPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CountDownView.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/OutlineTextButton.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/SmallTextButton.dart';
import 'package:mxcome/com/mxcome/app/utils/Adapt.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../IURLConstant.dart';
import '../../../Logger.dart';
import '../../../model/BaseModel.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/TextUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../event/PodiumEvent.dart';
import '../utils/EventBusUtil.dart';
import '../utils/FormatUtil.dart';
import '../utils/Util.dart';
import '../widget/ClockComponent.dart';
import 'GetPrizeActivityPage.dart';
import 'ProfitRecordPage.dart';

class PodiumPage extends StatefulWidget {

  dynamic activityDetail;
  dynamic activityMember;

  PodiumPage(this.activityDetail, this.activityMember);

  @override
  State<PodiumPage> createState() => PodiumPageState();
}

class PodiumPageState extends BaseKeepAliveState<PodiumPage> {

  dynamic _activityDetail;

  dynamic _activityMember;

  List<dynamic> _buyList = [];
  double _totalProfit = 0;

  bool _levelLottery = false; //关卡抽奖是否可用

  bool _rankLottery = false; //排名抽奖是否可用

  bool _isLevelFinish = false; //是否进行关卡抽奖

  dynamic podiumEvent;

  String levelTip = LanguageConfig.get(LanguageConfigKeys.Shop_activity_no_level_reward_tip);
  String rankTip = LanguageConfig.get(LanguageConfigKeys.Shop_activity_no_rank_reward_tip);

  String _statusText = "";
  String _endTime = "";

  int _status = 0; //状态（0:进行中 1:待统计 2:通关 -1:未通关）

  int _countedTimeout = 7 * 24 * 60;
  int _prizeGetTimeout = 8 * 24 * 60;

  late DateTime _countedTime;
  late DateTime _prizeGetTime;

  List<dynamic> _levelGiftList = [];

  @override
  void initState() {
    super.initState();
    _activityDetail = widget.activityDetail;
    _activityMember = widget.activityMember;
    initData();
    podiumEvent = EventBusUtil.getInstance().on<PodiumEvent>((event) {
      loadRandomLevelGift();
    });
    loadContentDatas();
  }

  @override
  void didChangeDependencies() {
    getServiceTime();
  }

  void initData() async {
    await getServiceTime();
    dynamic data = await AppUtils.getPocketData();
    _countedTimeout = BaseModel.isNotEmpty(data, "countedTimeout") ? BaseModel.getInt(data, "countedTimeout") : _countedTimeout;
    _prizeGetTimeout = BaseModel.isNotEmpty(data, "prizeGetTimeout") ? BaseModel.getInt(data, "prizeGetTimeout") : _prizeGetTimeout;
    _levelGiftList = BaseModel.isNotEmpty(widget.activityDetail, "levelGiftList") ? BaseModel.getDynamic(widget.activityDetail, "levelGiftList") : [];
    _status = BaseModel.getInt(widget.activityMember, "status");
    String endTime = BaseModel.getString(widget.activityDetail, "endTime");
    DateTime dateTime = DateTime.parse(endTime);
    _countedTime = dateTime.add(Duration(minutes: _countedTimeout));
    _prizeGetTime = _countedTime.add(Duration(minutes: _prizeGetTimeout));
    if (widget.activityMember != null && !Util.isTimeout2(startTime: serviceTime, endTime: FormatUtil.formatLineYMDHMS(_countedTime))) { //统计时间
      _endTime = FormatUtil.formatLineYMDHMS(_countedTime);
      _statusText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_waiting_statistics);
    } else if (widget.activityMember != null && Util.isTimeout2(startTime: serviceTime, endTime: FormatUtil.formatLineYMDHMS(_countedTime)) && !Util.isTimeout2(startTime: serviceTime, endTime: FormatUtil.formatLineYMDHMS(_prizeGetTime))) { //领取时间
      _endTime = FormatUtil.formatLineYMDHMS(_prizeGetTime);
      _statusText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_remaining_collection_time);
    } else if (widget.activityMember != null && Util.isTimeout2(startTime: serviceTime, endTime: FormatUtil.formatLineYMDHMS(_prizeGetTime))) { //领取结束时间
      _endTime = FormatUtil.formatLineYMDHMS(_prizeGetTime);
      _statusText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_get_prize_finish);
    }
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(podiumEvent);
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    String activityId = BaseModel.getString(widget.activityMember, "activityId");
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_GET_ACTIVITY_PROFIT_AMOUNT, {
      "activityId": activityId
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      _buyList = rsp.data;
      double totalProfit = 0;
      for(var item in _buyList){
        totalProfit += BaseModel.getDouble(item, "profitAmount");
      }
      setState(() {
        _totalProfit = totalProfit;
      });
    }
    loadActivityMember();
    loadLevelLottery();
    loadRandomLevelGift();
    loadRankGift();
  }

  void loadActivityMember() async {
    String activityId = BaseModel.getString(widget.activityMember, "activityId");
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_ACTIVITY_MEMBER_INFO, {
      "activityId": activityId
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        _activityMember = rsp.data;
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  void loadLevelLottery() {
    setState(() {
      _status = BaseModel.getInt(widget.activityMember, "status");
      _levelGiftList = BaseModel.isNotEmpty(widget.activityDetail, "levelGiftList") ? BaseModel.getDynamic(widget.activityDetail, "levelGiftList") : [];
      if (_status == 2 && _levelGiftList.isNotEmpty) {
        _levelLottery = true;
        levelTip = "";
      } else {
        _levelLottery = false;
        levelTip = LanguageConfig.get(LanguageConfigKeys.Shop_activity_no_level_reward_tip);
      }
    });
  }

  void loadRankGift() {
    _status = BaseModel.getInt(widget.activityMember, "status");
    setState(() {
      if (_status == 2) {
        _rankLottery = true;
        rankTip = LanguageConfig.get(LanguageConfigKeys.Shop_activity_success_get_rank_reward_tip);
      } else {
        _rankLottery = false;
        rankTip = LanguageConfig.get(LanguageConfigKeys.Shop_activity_no_rank_reward_tip);
      }
    });
  }

  Future<void> loadRandomLevelGift() async {
    String activityId = BaseModel.getString(widget.activityDetail, "id");
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_GET_ACTIVITY_RANDOM_LEVEL_GIFT, {
      "activityId": activityId,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<dynamic> dataList = rsp.data;
      setState(() {
        int alreadyLotteryGiftNum = dataList.length;
        _isLevelFinish = (alreadyLotteryGiftNum > 0 && alreadyLotteryGiftNum == getLevelConfigGiftNum());
        if (_isLevelFinish) {
          levelTip = LanguageConfig.get(LanguageConfigKeys.Shop_activity_success_get_level_reward_tip);
        }
      });
    }
  }

  int getLevelConfigGiftNum() {
    List<int> levelNumList = [];
    if(_levelGiftList.isNotEmpty) {
      for(int i = 0; i< _levelGiftList.length; i++) {
        int levelNum = BaseModel.getInt(_levelGiftList[i], 'level');
        if(!levelNumList.contains(levelNum)) {
          levelNumList.add(levelNum);
        }
      }
      return levelNumList.length;
    }else{
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDEAEA),
        elevation: 0.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_podium), style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
        actions: [
          InkWell(
            onTap: () {
              nextPage(GetPrizeActivityPage(_activityDetail, _activityMember), false);
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
              child: Image.asset("assets/icons/prize.png"),
            ),
          ),
        ],
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildBody() {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFDEAEA),
              Color(0xFFD0FCF2),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: Container(
                  padding: EdgeInsets.fromLTRB(16.w, 4.w, 16.w, 4.w),
                  decoration: BoxDecoration(
                      color: IConstant.white_color,
                      borderRadius: BorderRadius.circular(20.w)
                  ),
                  child: Row(
                    children: [
                      Text(
                          LanguageConfig.get(
                              LanguageConfigKeys.Shop_activity_activity_top),
                          style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(getRank(),
                          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: IConstant.main_color)),
                    ],
                  ),
                )
              )
            ],
          ),
          Expanded(child: Container(
              padding: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 0.w),
              child: Image.asset("assets/icons/activity_winner.png")
          )),
          Card(
            margin: EdgeInsets.fromLTRB(16.w, 20.w, 16.w, 30.w),
            elevation: 5.w,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadiusDirectional.circular(12.w)),
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.w, 6.w, 10.w, 6.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(flex: 2, child: Row(
                    children: [
                      Image.asset("assets/icons/prize_1.png", width: 24.w, height: 24.w),
                      SizedBox(width: 2.w,),
                      Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_total_mxget), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),)
                    ],
                  )),
                  SizedBox(width: 10.w),
                  Expanded(child: PriceText(_totalProfit, fontSize: 14.sp)),
                  OutlineTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_activity_view_details), borderColor: IConstant.line_color,
                      bgColor: IConstant.white_color, textColor: IConstant.main_color, onTap: () {
                        showPop(0.7 * Adapt.getWindowHeight(), ProfitRecordPage(_buyList));
                  })
                ],
              ),
            ),
          ),
          Container(
            color: IConstant.white_color,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 0.w),
                  child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_activity_achievements), style: TextStyle(fontSize: 14.w, color: IConstant.text_color))
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(16.w, 26.w, 16.w, 0.w),
                  padding: EdgeInsets.fromLTRB(14.w, 10.w, 14.w, 10.w),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.w, color: IConstant.line_color),
                      borderRadius: BorderRadius.circular(10.w)
                  ),
                  child: Row(
                    children: [
                      Image.asset("assets/icons/prize_2.png", width: 24.w, height: 24.w),
                      SizedBox(width: 10.w),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_level_prize), style: TextStyle(fontSize: 14.w, color: IConstant.text_color)),
                          Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_level_draw_now_tip), style: TextStyle(fontSize: 12.w, color: IConstant.sub_text_color)),
                        ],
                      )),
                      SizedBox(width: 6.w),
                      _isLevelFinish ? SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_activity_get_prize), enable: true, onTap: () {
                        nextPage(GetPrizeActivityPage(_activityDetail, _activityMember), false);
                      }) : SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_activity_lottery_draw), enable: _levelLottery, onTap: () {
                        showPop(0.7 * Adapt.getWindowHeight(), LotteryPage(_activityDetail, _activityMember));
                      })
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(16.w, 26.w, 16.w, 10.w),
                  padding: EdgeInsets.fromLTRB(14.w, 10.w, 14.w, 10.w),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.w, color: IConstant.line_color),
                      borderRadius: BorderRadius.circular(10.w)
                  ),
                  child: Row(
                    children: [
                      Image.asset("assets/icons/prize_3.png", width: 24.w, height: 24.w),
                      SizedBox(width: 10.w),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_top_prize), style: TextStyle(fontSize: 14.w, color: IConstant.text_color)),
                          Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_top_rewards_tip), style: TextStyle(fontSize: 12.w, color: IConstant.sub_text_color)),
                        ],
                      )),
                      SizedBox(width: 6.w),
                      SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_activity_get_prize), enable: _rankLottery, onTap: () {
                        nextPage(GetPrizeActivityPage(_activityDetail, _activityMember, selectIndex: 1), false);
                      })
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

  Widget buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      elevation: 2.w,
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
        height: 50.w,
        child: TextUtils.isNotEmpty(_statusText) ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_statusText, style: TextStyle(fontSize: 13.sp, color: IConstant.main_inactive_color)),
            CountDownView(startTime: serviceTime, endTime: _endTime,
                fontSize: 13.sp,
                textColor: IConstant.main_color,
                textAlign: TextAlign.right,
                stop: LanguageConfig.get(LanguageConfigKeys.Shop_activity_closed))],
        ): Container()),
    );
  }

  String getRank() {
    String rank = BaseModel.getString(_activityMember, "rank");
    if (TextUtils.isEmpty(rank)) {
      rank = LanguageConfig.get(LanguageConfigKeys.Shop_activity_not_listed);
    }
    return rank;
  }

}
