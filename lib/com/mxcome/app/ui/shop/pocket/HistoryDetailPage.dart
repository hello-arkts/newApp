
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/PocketEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/ActivityLevelModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/Util.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CountDownView.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/IconTextButton.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sprintf/sprintf.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../IURLConstant.dart';
import '../../../PageConstant.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../brand/BrandShopPage.dart';
import '../utils/ClipboardUtil.dart';
import '../utils/FormatUtil.dart';
import '../widget/ClockComponent.dart';
import '../widget/LoadImageView.dart';
import 'PodiumPage.dart';

class HistoryDetailPage extends StatefulWidget {

  dynamic activityMember;

  HistoryDetailPage(this.activityMember);

  @override
  State<HistoryDetailPage> createState() => HistoryDetailPageState();

}

class HistoryDetailPageState extends BaseKeepAliveState<HistoryDetailPage> {

  int _levelNum = 0;
  int _currentLevel = 0;
  int _status = 0; //状态（0:进行中 1:待统计 2:通关 -1:未通关）

  final List<ActivityLevelModel> _activityLevelList = [];

  List<dynamic> _pocketMemberList = [];
  List<dynamic> _filterPocketMemberList = [];

  dynamic _activityDetail;
  dynamic _activityMember;

  int _levelStatus = 0; //0: 不可用，1：下一关，2：领奖台
  String btnIcon = "assets/icons/lock.png";
  String statusText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_arbitrary_deal);
  String btnText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_continue_break_barrier);

  int _totalBuyCount = 0;

  int _tabSelectIndex = 0;

  dynamic pocketEvent;

  @override
  void initState() {
    super.initState();
    _activityMember = widget.activityMember;
    _currentLevel = BaseModel.getInt(_activityMember, "level");
    _levelNum = BaseModel.getInt(_activityMember, "levelNum");
    _status = BaseModel.getInt(_activityMember, "status");
    pocketEvent = EventBusUtil.getInstance().on<PocketEvent>((event) {

    });
    loadContentDatas();
  }

  @override
  void didChangeDependencies() {
    getServiceTime();
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(pocketEvent);
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    await getServiceTime();
    String activityId = BaseModel.getString(_activityMember, "activityId");
    int level = BaseModel.getInt(_activityMember, "level");
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_ACTIVITY_GET_INFO, {
      "activityId": activityId
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        _activityDetail = rsp.data;
        _tabSelectIndex = _currentLevel -1;
        for (int i = 0; i < _levelNum; i++) {
          String title = sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_activity_for_the_level), [ 1 + i]);
          _activityLevelList.add(ActivityLevelModel(i, title, level, 1 + 1 == level));
        }
      });
    }
    loadPocketActivityLevel();
  }

  Future<void> loadPocketActivityLevel() async {
    String activityId = BaseModel.getString(_activityMember, "activityId");
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_GET_POCKET_ACTIVITY_LEVEL, {
      "activityId": activityId
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        _pocketMemberList = rsp.data;
      });
      for (var item in _activityLevelList) {
        item.isSelect = false;
      }
      _activityLevelList[_tabSelectIndex].isSelect = true;
      refreshLevel();
      setBtnStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_details),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
        actions: [
          InkWell(
            onTap: () {
              nextPage(PodiumPage(_activityDetail, _activityMember), false);
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
              child: Image.asset("assets/icons/flag_prize.png"),
            ),
          ),
        ],
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildBody() {
    return EasyRefresh(
        header: const MaterialHeader(color: IConstant.main_color),
        onRefresh: ()=> _onRefresh(), child: ListView(
      children: [
        Card(
          margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 16.w),
          elevation: 4.w,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(12.w),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.w)),
                child: LoadImageView(double.infinity, 220.w, getActivityImg(_activityMember)),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 0.w),
                child: Row(
                  children: [
                    Expanded(child: Text(BaseModel.getString(_activityMember, "activityName"), maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14.sp, color: IConstant.title_color))),
                    SizedBox(width: 10.w),
                    Offstage(
                      offstage: _status != 0,
                      child: Row(
                        children: [
                          Image.asset("assets/icons/task_icon1.png", width: 11.w, height: 11.w),
                          SizedBox(
                            width: 4.w,
                          ),
                          Text(
                              LanguageConfig.get(LanguageConfigKeys.Shop_activity_count_down),
                              style: TextStyle(fontSize: 13.sp, color: IConstant.sub_text_color)),
                          SizedBox(
                            width: 4.w,
                          ),
                        ],
                      ),
                    ),
                    CountDownView(startTime: serviceTime, endTime: "${BaseModel.getString(_activityMember, "endTime")}",
                        textColor: IConstant.main_color,
                        textAlign: TextAlign.right,
                        stop: LanguageConfig.get(LanguageConfigKeys.Shop_activity_not_exist))
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(16.w, 4.w, 16.w, 0.w),
                child: Text(BaseModel.getString(_activityMember, "activityTitle"),
                    maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13.sp, color: IConstant.sub_text_color)),
              ),
              SizedBox(height: 10.w)
            ],
          ),
        ),
        buildLevelList(),
        Row(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 10.w),
              child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_this_task), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
            ),
            expandeSpace,
            Container(
              margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 0.w),
              padding: EdgeInsets.fromLTRB(10.w, 4.w, 10.w, 4.w),
              decoration: BoxDecoration(
                  color: IConstant.red_bg_color,
                  borderRadius: BorderRadius.circular(16.w)
              ),
              child: Row(
                children: [
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_deal), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
                  SizedBox(width: 10.w),
                  Text("$_totalBuyCount", style: TextStyle(fontSize: 15.sp, color: IConstant.main_color))
                ],
              ),
            )
          ],
        ),
        buildTaskList(),
      ],
    ));
  }

  Future<void> _onRefresh() async {
    EventBusUtil.getInstance().emit(PocketEvent());
    loadPocketActivityLevel();
    getServiceTime();
  }

  void refreshLevel() {
    List<dynamic> tempList = [];
    for (dynamic item in _pocketMemberList) {
      int activityLevel = BaseModel.getInt(item, "activityLevel");
      if (_tabSelectIndex + 1 == activityLevel) {
        tempList.add(item);
      }
    }
    tempList.sort((a, b) => BaseModel.getDouble(BaseModel.getDynamic(a, "product"), "price")
        .compareTo(BaseModel.getDouble(BaseModel.getDynamic(b, "product"), "price")));
    setState(() {
      _filterPocketMemberList = tempList;
    });
    setTotal();
  }

  void setTotal() {
    int total = 0;
    for (dynamic item in _pocketMemberList) {
      int activityLevel = BaseModel.getInt(item, "activityLevel");
      if (_tabSelectIndex + 1 == activityLevel) {
        int buyQuantity = BaseModel.getInt(item, "buyQuantity");
        total += buyQuantity;
      }
    }
    setState(() {
      _totalBuyCount = total;
    });
  }

  void setBtnStatus() {
    int total = 0;
    for (dynamic item in _pocketMemberList) {
      int activityLevel = BaseModel.getInt(item, "activityLevel");
      if (_currentLevel == activityLevel) {
        int buyQuantity = BaseModel.getInt(item, "buyQuantity");
        total += buyQuantity;
      }
    }
    if (total >= 10 && _status == 2) { //完成
      if (_currentLevel == _levelNum) { //领奖台
        _levelStatus = 2;
        btnIcon = "assets/icons/flag_diagonal.png";
        statusText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_wait_statistics_completed);
        btnText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_completed_game);
      } else { //继续闯关
        _levelStatus = 1;
        btnIcon = "assets/icons/lock_open.png";
        statusText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_arbitrary_deal);
        btnText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_continue_break_barrier);
      }
    } else { //未完成
      if (_currentLevel == _levelNum) { //领奖台
        _levelStatus = 0;
        btnIcon = "assets/icons/flag_diagonal.png";
        statusText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_one_step_success);
        btnText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_podium);
      } else { //继续闯关
        _levelStatus = 0;
        btnIcon = "assets/icons/lock.png";
        statusText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_arbitrary_deal);
        btnText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_continue_break_barrier);
      }
    }
  }

  String getActivityImg(dynamic activity){
    if(BaseModel.isNotEmpty(activity, "activityCoverImg")) {
      return BaseModel.getString(activity, "activityCoverImg");
    } else {
      return BaseModel.getString(activity, "activityPic");
    }
  }

  String getCurrentLevel(int level) {
    if(_activityDetail == null) return "";
    return "$level/$_levelNum";
  }

  Widget buildLevelList() {
    if(_activityDetail == null) return Container();
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _activityLevelList.map((item) => InkWell(
          onTap: () {
            if (_currentLevel < item.index + 1) {
              return;
            }
            setState(() {
              for (var item in _activityLevelList) {
                item.isSelect = false;
              }
              item.isSelect = true;
              _tabSelectIndex = item.index;
            });
            refreshLevel();
          },
          child: buildTabLevel(item),
        )).toList());
  }

  Widget buildTabLevel(ActivityLevelModel levelModel) {
    return Stack(
      children: [
        Container(
          height: 28.w,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(5.w, 0.w, 5.w, 0.w),
          padding: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 0.w),
          decoration: BoxDecoration(
              color: levelModel.getBgColor(),
              borderRadius: BorderRadius.circular(8.w)
          ),
          child: Text(levelModel.title, style: TextStyle(fontSize: 13.sp, color: levelModel.getTextColor())),
        ),
        _currentLevel < levelModel.index + 1 ? Positioned(
            top: 4.w,
            right: 4.w,
            child: Image.asset("assets/icons/lock.png", width: 12.w, height: 12.w)
        ) : Container()
      ],
    );
  }

  Widget buildLevelStatus(int status) {
    if (status == 1) {
      return Container(
          padding: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
          decoration: BoxDecoration(
              color: const Color(0x1072C472),
              borderRadius: BorderRadius.circular(8.w)
          ),
          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_doing), style: TextStyle(fontSize: 10.sp, color: const Color(0xff72C472))));
    } else if (status == -1) {
      return Container(
          padding: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
          decoration: BoxDecoration(
              color: IConstant.red_bg_color,
              borderRadius: BorderRadius.circular(8.w)
          ),
          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_closed), style: TextStyle(fontSize: 10.sp, color: IConstant.main_color)));
    } else {
      return Container(
          padding: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
          decoration: BoxDecoration(
              color: IConstant.red_bg_color,
              borderRadius: BorderRadius.circular(8.w)
          ),
          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_not_start), style: TextStyle(fontSize: 10.sp, color: IConstant.main_color)));
    }
  }

  Widget buildBottomBar(){
    return BottomAppBar(
      height: 110.w,
      elevation: 0.w,
      child: SizedBox(
        height: 90.w,
        child: Stack(
          children: [
            Positioned(left: 0.w, right: 0.w, bottom: 50.w, child: Container(
              color: IConstant.line_color,
              height: 2.w,
            )),
            Positioned(left: 0.w, right: 0.w, bottom: 0.w, child: Container(
              height: 40.w,
              margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 6.w),
              child: Row(
                children: [
                  Expanded(child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_get_gold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
                      SizedBox(width: 8.w),
                      PriceText(BaseModel.getDynamic(_activityMember, "withdrawalBalance"), fontSize: 14.sp),
                    ],
                  )),
                  SizedBox(width: 16.w),
                  buildNextBtn()
                ],
              ),
            )),
            statusText != LanguageConfig.get(LanguageConfigKeys.Shop_activity_wait_statistics_completed) ?
            Positioned(top: 0.w, right: 16.w, child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(10.w),
                    topEnd: Radius.circular(10.w),
                    bottomStart: Radius.circular(10.w),
                  )),
              clipBehavior: Clip.antiAlias,
              elevation: 4.w,
              child: Container(
                height: 30.w,
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(10.w, 0.w, 10.w, 0.w),
                child: Text(statusText, style: TextStyle(fontSize: 11.sp, color: IConstant.main_color)),
              ),
            )): Container()
          ],
        ),
      ),
    );
  }

  Widget buildNextBtn() {
    if (_levelStatus == 0) {
      return IconTextButton(
          icon: Image.asset(btnIcon, color: IConstant.sub_text_color, width: 22.w, height: 22.w),
          bgColor: IConstant.grey_bg_color,
          textColor: IConstant.sub_text_color,
          fontSize: 13.w,
          text: btnText, onTap: () {});
    } else if(_levelStatus == 1) {
      return IconTextButton(
          icon: Image.asset(btnIcon, color: IConstant.main_color, width: 22.w, height: 22.w),
          bgColor: IConstant.red_bg_color4,
          textColor: IConstant.red_bg_color5,
          fontSize: 13.w,
          text: btnText, onTap: () {
        showNextDialog();
      });
    } else {
      if(_status != 2) {
        return IconTextButton(
            icon: Image.asset(btnIcon, color: IConstant.white_color, width: 22.w, height: 22.w),
            bgColor: IConstant.red_bg_color4,
            textColor: IConstant.red_bg_color5,
            fontSize: 13.w,
            text: btnText, onTap: () {
          nextPage(PodiumPage(_activityDetail, _activityMember), false);
        });
      }else {
        return IconTextButton(
            icon: Image.asset(btnIcon, color: IConstant.grey_bg_color, width: 22.w, height: 22.w),
            bgColor: IConstant.grey_bg_color,
            textColor: IConstant.text_color,
            fontSize: 13.w,
            text: btnText, onTap: () {
        });
      }
    }
  }

  Widget buildTaskList() {
    List<Widget> taskList = [];
    for (int i = 0; i < _filterPocketMemberList.length; i++) {
      Color color = IConstant.main_color;
      if(i == 0) {
        color = IConstant.green_color;
      } else if(i == 1) {
        color = IConstant.blue_color;
      } else {
        color = IConstant.main_color;
      }
      taskList.add(buildTaskItem(_filterPocketMemberList[i], color));
    }
    return Column(
      children: taskList,
    );
  }

  Widget buildTaskItem(dynamic item, Color color) {
    int stock = BaseModel.getInt(item, "stock");
    dynamic product = BaseModel.getDynamic(item, "product");
    return Card(
      margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 16.w),
      elevation: 4.w,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(12.w),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              buildTaskInfo(product, item, color),
              buildBottomItem(product, item),
            ],
          ),
          stock == 0 ? Positioned(left: 0.w, top: 0.w, right: 0.w, bottom: 0.w,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: IConstant.black_translucent_color,
                    borderRadius: BorderRadius.circular(12.w)
                ),
                child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_sold_out), style: TextStyle(fontSize: 14.sp, color: IConstant.white_color)),
          )) : Container()],
      ),
    );
  }

  Widget buildTaskInfo(dynamic product, dynamic pocketMember, Color color){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12.w)),
            child: LoadImageView(0.2 * Adapt.getWindowWidth(), 0.2 * Adapt.getWindowWidth(), BaseModel.getString(product, "pic"))),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.w),
            SizedBox(width: 0.65 * Adapt.getWindowWidth(), child: Text("${BaseModel.getString(product, "name")}", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13.sp, color: IConstant.text_color))),
            SizedBox(height: 4.w),
            Row(
              children: [
                PriceText(BaseModel.getDouble(product, "price"), fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.title_color),
                SizedBox(width: 16.w),
                Container(
                  padding: EdgeInsets.fromLTRB(6.w, 0.w, 6.w, 0.w),
                  decoration: BoxDecoration(
                      color: IConstant.red_bg_color3,
                      borderRadius: BorderRadius.circular(20.w)
                  ),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/icons/profit.png", width: 10.w, height: 10.w),
                        SizedBox(width: 2.w),
                        Text(getProfitText(pocketMember),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 11.sp, color: IConstant.main_color)),
                      ]
                  ),
                )
              ],
            ),
            SizedBox(height: 4.w),
            Container(
              padding: EdgeInsets.fromLTRB(8.w, 2.w, 8.w, 2.w),
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6.w)
              ),
              child: Text(getCompletionDegree(pocketMember), style: TextStyle(fontSize: 12.sp, color: IConstant.white_color)),
            ),
            SizedBox(height: 6.w),
            SizedBox(
              width: 0.65 * Adapt.getWindowWidth(),
              child: LinearProgressIndicator(
                value: getRateDouble(pocketMember),
                backgroundColor: IConstant.white_color,
                valueColor: const AlwaysStoppedAnimation<Color>(IConstant.main_color),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget buildBottomItem(dynamic product, dynamic pocketMemberItem){
    return Row(
      children: [
        Expanded(flex: 1, child: InkWell(
          onTap: () {
            nextPage(BrandShopPage(BaseModel.getString(product, "shopId")), false);
          },
          child: Container(
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
          ),
        )),
        expandeSpace,
        Expanded(flex: 1, child: Container(
          margin: EdgeInsets.fromLTRB(10.w, 6.w, 8.w, 8.w),
          child: buildRightItem(pocketMemberItem),
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
    int buyQuantity = BaseModel.getInt(item, "buyQuantity");
    return "$buyQuantity/10";
  }

  double getRateDouble(dynamic item) {
    int buyQuantity = BaseModel.getInt(item, "buyQuantity");
    return buyQuantity / 10;
  }

  // String? getRateString(dynamic item) {
  //   String conversionRate = LanguageConfig.get(LanguageConfigKeys.Shop_pocket_conversion_rate);
  //   int dealNum = BaseModel.getInt(item, "dealNum");
  //   int loseNum = BaseModel.getInt(item, "loseNum");
  //   String rate = "0";
  //   if (dealNum > 0 ) {
  //     rate = "${1 - (loseNum / dealNum)}";
  //   }
  //   String? formatRate = NumUtil.getDoubleByValueStr(rate)?.toStringAsFixed(1);
  //   return "$conversionRate $formatRate%";
  // }

  Future<void> copy(dynamic item) async {
    String shareUrl = await Util.getShareData(item);
    ClipboardUtil.setDataToast(shareUrl);
  }

  Future<void> shareWeb(dynamic item) async {
    String shareUrl = await Util.getShareData(item);
    Share.share(shareUrl);
  }

  Widget buildRightItem(dynamic item) {
    int status = 0;
    if (status == 0) {
      return InkWell(
          onTap: () {
            // shareWeb(item);
          },
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(6.w, 4.w, 6.w, 4.w),
            decoration: BoxDecoration(
                color: IConstant.line_color,
                borderRadius: BorderRadius.circular(20.w)
            ),
            child: Row(
              children: [
                SizedBox(width: 4.w),
                Image.asset("assets/icons/share.png", width: 14.w, height: 14.w, color: IConstant.sub_text_color),
                Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_recommend_now), maxLines: 2, overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color)))
              ],
            ),
          ));
    } else {
      return Container(
          width: 0.3 * Adapt.getWindowWidth(),
          padding: EdgeInsets.fromLTRB(6.w, 4.w, 6.w, 4.w),
          decoration: BoxDecoration(
              color: IConstant.red_bg_color,
              borderRadius: BorderRadius.circular(20.w)
          ),
          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_completed), maxLines: 2, overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center, style: TextStyle(fontSize: 11.sp, color: IConstant.main_color),
          ));
    }
  }

  Widget buildStopTime(dynamic item) {
    int status = 0;
    if (status == 0) {
      String endTime = BaseModel.getString(item, "endTime");
      return CountDownView(startTime: serviceTime, endTime: endTime,
          fontSize: 11.w,
          textColor: IConstant.main_color,
          prefix: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_remain),
          stop: LanguageConfig.get(LanguageConfigKeys.Shop_activity_closed));
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_get_gold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12.sp, color: IConstant.main_color)),
          SizedBox(width: 8.w),
          PriceText(BaseModel.getDouble(item, "withdrawalBalance"), fontSize: 12.sp),
        ],
      );
    }
  }

  void showNextDialog() {
    ViewUtils.showCustomDialog(context, LanguageConfig.get(LanguageConfigKeys.Shop_activity_successfully_crossed),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icons/activity_pass.png", width: double.infinity, height: 200.w),
            SizedBox(height: 20.w),
            Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_successfully_crossed_tip), textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
          ],
        ),
        LanguageConfig.get(LanguageConfigKeys.Shop_activity_enter_next_level), (ctx, event) {
          if (event == DialogEvent.confirm) {
            finishContext(ctx);
            changeNextLevel();
          } else {
            finishContext(ctx);
          }
        }
    );
  }

  Future<void> changeNextLevel() async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_PASS_LEVEL, {
      "activityId": BaseModel.getString(_activityDetail, "id")
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        _currentLevel = _currentLevel + 1;
        _tabSelectIndex = _tabSelectIndex + 1;
      });
      loadPocketActivityLevel();
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

}
