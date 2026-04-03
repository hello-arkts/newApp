
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/PodiumEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/LevelGiftModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/BigTextButton.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/TransformCard.dart';
import 'package:sprintf/sprintf.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../IURLConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseModel.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../model/LotteryLevelModel.dart';

class LotteryPage extends StatefulWidget {

  dynamic activityDetail;
  dynamic activityMember;

  LotteryPage(this.activityDetail, this.activityMember);

  @override
  State<LotteryPage> createState() => LotteryPageState();

}

class LotteryPageState extends BaseKeepAliveState<LotteryPage> {

  dynamic _activityDetail;
  dynamic _activityMember;

  int _levelNum = 0;
  int _tabSelectIndex = 0;
  final List<LotteryLevelModel> _activityTabList = [];
  List<LevelGiftModel> _levelGiftList = [];
  Map<int, int> lotteryList = HashMap();
  Map<int, double> lotteryPriceList = HashMap();

  bool _isLevelFinish = false;
  bool _autoLevel = false;

  String btnText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_draw_now);

  @override
  void initState() {
    super.initState();
    _activityDetail = widget.activityDetail;
    _activityMember = widget.activityMember;
    _levelNum = BaseModel.getInt(_activityDetail, "levelNum");
    for (int i = 0; i < _levelNum; i++) {
      String title = sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_activity_for_the_level), [ 1 + i]);
      _activityTabList.add(LotteryLevelModel(title, 1 + i, false));
    }
    setDefaultLevel(_tabSelectIndex);
    setSelectLevel();
    loadContentDatas();
  }

  setDefaultLevel(int tabSelectIndex) {
    List<dynamic> levelGiftList = BaseModel.getDynamic(_activityDetail, "levelGiftList");
    for (int i=0; i<levelGiftList.length; i++) {
      int level = BaseModel.getInt(levelGiftList[i], "level");
      _tabSelectIndex = level - 1;
      return;
    }
  }

  @override
  Future<void> loadContentDatas() async {
    String activityId = BaseModel.getString(widget.activityMember, "activityId");
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_GET_ACTIVITY_RANDOM_LEVEL_GIFT, {
      "activityId": activityId
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<dynamic> dataList = rsp.data;
      for (var item in dataList) {
        int level = BaseModel.getInt(item, "level");
        int productGiftId = BaseModel.getInt(item, "productGiftId");
        lotteryList.putIfAbsent(level, () => productGiftId);
        lotteryPriceList.putIfAbsent(productGiftId, () => BaseModel.getDouble(item, "price"));
      }
    }
    setSelectLevel();
    levelFinish();
    checkAutoLevel();
  }

  void setSelectLevel() {
    List<LevelGiftModel> tempList = getLevelGift(_tabSelectIndex);
    setState(() {
      _levelGiftList = tempList;
      for (var item in _activityTabList) {
        item.isSelect = false;
      }
      _activityTabList[_tabSelectIndex].isSelect = true;
    });
  }

  void levelFinish() {
    bool isFinish = true;
    for (var item in _activityTabList) {
      int level = item.level;
      if (!lotteryList.containsKey(level) && getLevelGift(level - 1).isNotEmpty) {
        isFinish = false;
      }
    }
    setState(() {
      _isLevelFinish = isFinish;
    });
  }

  Future<void> checkAutoLevel() async {
    if (_autoLevel) {
      _autoLevel = false;
      await Future.delayed(const Duration(milliseconds: 1500), () {
        int tabIndex = _tabSelectIndex + 1;
        if (getLevelGift(tabIndex).isEmpty) {
          //ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_activity_no_prizes_level));
          return;
        }
        setState(() {
          for (var item in _activityTabList) {
            item.isSelect = false;
          }
          _activityTabList[tabIndex].isSelect = true;
          _tabSelectIndex = _activityTabList[tabIndex].level - 1;
          setSelectLevel();
          btnText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_continue_draw);
        });
      });

    }
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
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_draw_now), style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        SizedBox(height: 16.w),
        buildLevelList(),
        SizedBox(height: 30.w),
        buildLotteryList(),
        Container(
          height: 110.w,
          margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 25.w),
          child: Row(
            children: [
              Container(width: 3.w, color: IConstant.red_bg_color),
              SizedBox(width: 12.w),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_lottery_tip1),
                      maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color)),
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_lottery_tip2),
                      maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color)),
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_lottery_tip3),
                      maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color)),
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_lottery_tip4),
                      maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color)),
                ],
              ))
            ],
          ),
        )
      ],
    );
  }

  Widget buildLevelList() {
    if(_activityDetail == null) return Container();
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _activityTabList.map((item) => InkWell(
          onTap: () {
            if (getLevelGift(item.level - 1).isEmpty) {
              ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_activity_no_prizes_level));
              return;
            }
            setState(() {
              for (var item in _activityTabList) {
                item.isSelect = false;
              }
              item.isSelect = true;
              _tabSelectIndex = item.level - 1;
              setSelectLevel();
            });
          },
          child: buildTabLevel(item),
        )).toList());
  }

  List<LevelGiftModel> getLevelGift(int tabSelectIndex) {
    List<dynamic> levelGiftList = BaseModel.getDynamic(_activityDetail, "levelGiftList");
    List<LevelGiftModel> tempList = [];
    for (dynamic item in levelGiftList) {
      int level = BaseModel.getInt(item, "level");
      int productGiftId = BaseModel.getInt(item, "productGiftId");
      if (tabSelectIndex + 1 == level) {
        tempList.add(LevelGiftModel.fromJson(item, lotteryPriceList[productGiftId], lotteryList.containsValue(productGiftId)));
      }
    }
    return tempList;
  }

  Widget buildTabLevel(LotteryLevelModel levelModel) {
    return Container(
      height: 35.w,
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(5.w, 0.w, 5.w, 0.w),
      padding: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 0.w),
      decoration: BoxDecoration(
          color: levelModel.getBgColor(),
          borderRadius: BorderRadius.circular(35.w)
      ),
      child: Text(levelModel.title, style: TextStyle(fontSize: 13.sp, color: levelModel.getTextColor())),
    );
  }

  Widget buildLotteryList() {
    return _levelGiftList.isEmpty ? Container() : Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _levelGiftList.map((e) => TransformCard(e)).toList(),
    );
  }

  Widget buildBottomBar(){
    return BottomAppBar(
      height: 110.w,
      elevation: 0.w,
      child: Container(
        margin: EdgeInsets.fromLTRB(80.w, 10.w, 80.w, 10.w),
        child: _isLevelFinish ? BigTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_activity_lottery_complete), onTap: () {
          EventBusUtil.getInstance().emit(PodiumEvent());
          finishContext(context);
        }): BigTextButton(text: btnText, enable: !lotteryList.containsKey(_tabSelectIndex + 1), onTap: () {
          getRandomLevelGift();
        }),
      ),
    );
  }

  List<LevelGiftModel> getLevelList(List<dynamic> levelGiftList, int level) {
    List<LevelGiftModel> tempList = [];
    for (dynamic item in levelGiftList) {
      int tempLevel = BaseModel.getInt(item, "level");
      if (level == tempLevel) {
        int productGiftId = BaseModel.getInt(item, "productGiftId");
        tempList.add(LevelGiftModel.fromJson(item, lotteryPriceList[productGiftId], lotteryList.containsValue(productGiftId)));
      }
    }
    return tempList;
  }

  Future<void> getRandomLevelGift() async {
    ViewUtils.show();
    String activityId = BaseModel.getString(widget.activityMember, "activityId");
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_GET_RANDOM_LEVEL_GIFT, {
      "activityId": activityId,
      "level": "${_activityTabList[_tabSelectIndex].getLevel()}"
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      _autoLevel = true;
      loadContentDatas();
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

}
