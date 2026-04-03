import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/ActivityTaskChangeEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/DelayedEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/promotion/RedStagePage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CountDownView.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/LoadImageView.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:sprintf/sprintf.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../cart/CartPage.dart';
import '../event/OpenMenuEvent.dart';
import '../event/PocketEvent.dart';
import '../event/UserInfoEvent.dart';
import '../mine/promotion/PromotionPage.dart';
import '../model/TaskModel.dart';
import '../utils/EventBusUtil.dart';
import '../widget/ClockComponent.dart';
import '../widget/GenAvatar.dart';
import '../widget/PriceText.dart';
import 'HistoryPage.dart';
import 'PrizeTabPage.dart';
import 'RuleDetailPage.dart';

class PocketHeaderBar extends AppBar {

  bool innerBoxIsScrolled;

  String startTime;

  PocketHeaderBar(this.innerBoxIsScrolled, {this.startTime = ''});

  @override
  State<PocketHeaderBar> createState() => _PocketHeaderBarState();

}

class _PocketHeaderBarState extends BaseKeepAliveState<PocketHeaderBar> {

  bool isLogin = false;

  int activityMemberCount = 0;

  int pocketMemberCount = 0;

  dynamic umsPocketConfig;

  dynamic userInfo;

  dynamic userInfoEvent;

  dynamic pocketEvent;

  dynamic delayedEvent;

  double sumBalance = 0;

  double monthBalance = 0;

  double dayBalance = 0;

  List<TaskModel> dataList = [];

  double redAmount = 0;
  int redLevel = 0;	//红包关卡：1->一级闯关, 2->二级闯关, 2->三级闯关
  int redPower = 0;	//是否有红包闯关资格：0->否, 1->是，-1->永久失效
  String redTimeEnd = "";
  String redTimeStart = "";

  @override
  void initState() {
    dataList.add(TaskModel("1", true)); //任务
    dataList.add(TaskModel("2", false)); //活动
    super.initState();
    userInfoEvent = EventBusUtil.getInstance().on<UserInfoEvent>((event) {
      if (event.userInfoStatus == UserInfoStatus.complete) {
        loadContentDatas();
      }
    });
    pocketEvent = EventBusUtil.getInstance().on<PocketEvent>((event) {
      if (event.pocketType == PocketType.complete) {
        loadContentDatas();
      }
    });
    delayedEvent = EventBusUtil.getInstance().on<DelayedEvent>((event) {
      TaskModel model = dataList[1];
      setState(() {
        for (var item in dataList) {
          item.isSelect = false;
        }
        model.isSelect = !model.isSelect;
      });
      EventBusUtil.getInstance().emit(ActivityTaskChangeEvent(changeType: ChangeType.activity));
    });
    loadContentDatas();
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(userInfoEvent);
    EventBusUtil.getInstance().off(pocketEvent);
    EventBusUtil.getInstance().off(delayedEvent);
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    bool loginState = await AppUtils.isLogined();
    setState(() {
      isLogin = loginState;
    });
    if (loginState) {
      dynamic data = await AppUtils.getPocketData();
      List activityMemberList = BaseModel.isNotEmpty(data, "activityMemberList") ? BaseModel.getDynamic(data, "activityMemberList") : [];
      List pocketMemberList = BaseModel.isNotEmpty(data, "pocketMemberList") ? BaseModel.getDynamic(data, "pocketMemberList") : [];
      dynamic userData = await AppUtils.getUserInfo();
      setState(() {
        sumBalance = BaseModel.getDouble(data, "sumBalance");
        monthBalance = BaseModel.getDouble(data, "monthBalance");
        dayBalance = BaseModel.getDouble(data, "dayBalance");
        umsPocketConfig = BaseModel.getDynamic(data, "umsPocketConfig");
        activityMemberCount = activityMemberList.length;
        pocketMemberCount = pocketMemberList.length;
        userInfo = userData;
        redAmount = BaseModel.getDouble(userData, "redAmountSum");
        redLevel = BaseModel.getInt(data, "redLevel");
        redPower = BaseModel.getInt(data, "redPower");
        redTimeEnd = BaseModel.getString(data, "redTimeEnd");
        redTimeStart = BaseModel.getString(data, "redTimeStart");
        isLogin = loginState;
      });
    } else {
      setState(() {
        sumBalance = 0;
        monthBalance = 0;
        dayBalance = 0;
        umsPocketConfig = null;
        activityMemberCount = 0;
        pocketMemberCount = 0;
        userInfo = null;
        redAmount = 0;
        redLevel = 0;
        redPower = 0;
        redTimeEnd = "";
        redTimeStart = "";
        isLogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SliverAppBar(
      backgroundColor: IConstant.white_color,
      elevation: 0.w,
      pinned: true,
      leading: Container(),
      leadingWidth: 0.w,
      title: buildLevel(),
      actions: <Widget>[
        InkWell(
          onTap: () {
            goHistory();
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
            child: Image.asset("assets/icons/pocket_history.png"),
          ),
        ),
      ],
      //固定标题栏
      expandedHeight: getExpandedHeight(),
      //显示的高度
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: Image.asset(
                        "assets/icons/pocket_bg.png",
                      ).image)),
              child: Column(
                children: [
                  isLogin ? buildPocketInfo() : Container(
                    margin: EdgeInsets.only(top: (statusBarHeight + appBarHeight - 2.w)),
                  ),
                  buildIncome(),
                  isLogin && showAdvCenter() ? InkWell(
                    onTap: () {
                      if (redPower == 1 || redPower == 2) {
                        nextPage(RedStagePage(), false);
                      } else {
                        //ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_not_red_level));
                      }
                    },
                    child: buildAdvCenter(),
                  ) : Container(),
                  buildButtons(),
                  Container(
                    color: IConstant.white_color, height: 4.w)
                ],
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLeading() {
    return InkWell(
        onTap: () {
          EventBusUtil.getInstance().emit(OpenMenuEvent());
        },
        child: Container(margin: EdgeInsets.all(2.w), child: buildAvatar()));
  }

  void openCart(){
    showPop(0.9 * Adapt.getWindowHeight(), CartPage(fromDetail: true));
  }

  String getDisplayName() {
    String nickname = BaseModel.getString(userInfo, "nickname");
    String username = BaseModel.getString(userInfo, "username");
    String phoneCode = BaseModel.getString(userInfo, "phoneCode");
    String phone = BaseModel.getString(userInfo, "phone");
    return TextUtils.isNotEmpty(nickname) ? nickname: "$phoneCode $phone";
  }

  Widget buildAvatar() {
    if (isLogin && userInfo != null) {
      String avatar = BaseModel.getString(userInfo, "icon");
      if (TextUtils.isNotEmpty(avatar)) {
        return ClipOval(
            child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: GenAvatar(avatar)));
      } else {
        String displayName = getDisplayName();
        return ClipOval(
            child: Container(
                width: double.infinity,
                height: double.infinity,
                color: IConstant.white_bg_color,
                child: Center(
                    child: Text(TextUtils.isNotEmpty(displayName) ? displayName.substring(0, 1) : "",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20.sp, color: IConstant.text_color)))));
      }
    } else {
      return ClipOval(
          child: Container(
              width: double.infinity,
              height: double.infinity,
              color: IConstant.white_bg_color,
              child: Center(
                  child: Icon(Icons.menu,
                      size: 25.w,
                      color: IConstant.text_color))));
    }
  }

  Widget buildLevel() {
    if (isLogin) {
      return Container(
        margin: EdgeInsets.fromLTRB(0.w, 0.w, 10.w, 10.w),
        child: Row(
          children: [
            Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_level), style: TextStyle(fontSize: 18.sp, color: IConstant.text_color)),
            Text(" Lv.${ BaseModel.getInt(umsPocketConfig, "pocketLevel") }", style: TextStyle(fontSize: 19.sp, color: IConstant.main_color)),
          ],
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          goLogin();
        },
        child: Row(
          children: [
            Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_not_login), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
          ],
        ),
      );
    }
  }

  Widget buildPocketInfo() {
    return Container(
      height: 35.w,
      margin: EdgeInsets.fromLTRB(16.w, (statusBarHeight + appBarHeight - 14.w), 16.w, 8.w),
      child: Row(
        children: [
          Container(
              constraints: BoxConstraints(
                maxWidth: 0.45 * Adapt.getWindowWidth()
              ),
              child: Text(getOrdersToLevel(), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))),
          InkWell(
              onTap: () {
                showPop(0.7 * Adapt.getWindowHeight(), RuleDetailPage(umsPocketConfig));
              },
              child: Container(
                margin: EdgeInsets.only(left: 10.w),
                padding: EdgeInsets.fromLTRB(8.w, 2.w, 8.w, 2.w),
                decoration: BoxDecoration(
                    color: IConstant.white_color,
                    borderRadius: BorderRadius.all(Radius.circular(10.w))
                ),
                child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_detail), style: TextStyle(fontSize: 11.sp, color: IConstant.text_color)),
              )
          ),
        ],
      ),
    );
  }

  Widget buildIncome() {
    return Container(
          height: 78.w,
          margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 8.w),
          decoration: BoxDecoration(
              color: IConstant.white_color,
              borderRadius: BorderRadius.all(Radius.circular(12.w))
          ),
          child: Column(
            children: [
              SizedBox(height: 12.w),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_history_income),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 13.sp, color: IConstant.sub_text_color)),
                        SizedBox(height: 8.w),
                        PriceText(sumBalance, color: IConstant.text_color, fontSize: 15.sp, fontWeight: FontWeight.bold),

                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_this_month_income),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 13.sp, color: IConstant.sub_text_color)),
                        SizedBox(height: 8.w),
                        PriceText(monthBalance, color: IConstant.text_color, fontSize: 15.sp, fontWeight: FontWeight.bold),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_today_income),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 13.sp, color: IConstant.sub_text_color)),
                        SizedBox(height: 8.w),
                        PriceText(dayBalance, fontSize: 15.sp, fontWeight: FontWeight.bold),

                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 12.w),
            ],
          )
      );
  }

  Widget buildAdvCenter() {
    return Container(
      height: 105.w,
      margin: EdgeInsets.fromLTRB(10.w, 2.w, 10.w, 0.w),
      padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 22.w),
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: Image.asset(
                "assets/icons/pocket_adv_bg.png",
              ).image)),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: 140.w
                ),
                child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_promotion_center),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14.sp, color: IConstant.white_color)),
              ),
              expandeSpace,
              Container(
                  constraints: BoxConstraints(
                      maxWidth: 100.w
                  ),
                  child: redPower != 1 && redPower != 2? Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_red_level), style: TextStyle(fontSize: 12.sp, color: IConstant.white_color))
                    : Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_red_level), style: TextStyle(fontSize: 12.sp, color: IConstant.white_color)),
              ),
              Container(
                width: 1.w,
                height: 12.w,
                color: IConstant.line_color,
                margin: EdgeInsets.fromLTRB(6.w, 0, 6.w, 0),
              ),
              redPower != 1 && redPower != 2? Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_closed), style: TextStyle(fontSize: 12.sp, color: IConstant.white_color))
                  : Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_activated), style: TextStyle(fontSize: 12.sp, color: IConstant.white_color)),
              SizedBox(width: 8.w),
              redPower != 1 && redPower != 2? Icon(Icons.circle, size: 8.w, color: const Color(0xFFB2B2B2))
                  : Icon(Icons.circle, size: 8.w, color: IConstant.green_color),
            ],
          ),
          expandeSpace,
          buildRedAmount(),
        ],
      ),
    );
  }

  Widget buildRedAmount() {
    if (redPower != 1 && redPower != 2) {
      return Row(
        children: [
          Image.asset("assets/icons/red_close_warn.png", width: 16.w),
          SizedBox(width: 4.w),
          Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_waiting_exciting_activities), style: TextStyle(fontSize: 12.sp, color: IConstant.white_color)),
          expandeSpace
        ],
      );
    } else {
      if (redAmount > 0) {
        return Row(
          children: [
            Image.asset("assets/icons/red_wallet.png", width: 16.w),
            SizedBox(width: 4.w),
            Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_earned), style: TextStyle(fontSize: 12.sp, color: IConstant.white_color)),
            PriceText(redAmount, fontSize: 12.sp, color: IConstant.white_color),
            expandeSpace,
            CountDownView(startTime: widget.startTime, endTime: redTimeEnd,
                fontSize: 12.w,
                textColor: IConstant.white_color,
                prefixColor: IConstant.white_color,
                prefix: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_period_validity),
                stop: LanguageConfig.get(LanguageConfigKeys.Shop_activity_closed))
          ],
        );
      } else {
        return Row(
          children: [
            Image.asset("assets/icons/red_wallet.png", width: 18.w),
            SizedBox(width: 4.w),
            Container(
              constraints: BoxConstraints(
                  maxWidth: 150.w
              ),
              child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_complete_task_tip),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp, color: IConstant.white_color)),
            ),
            expandeSpace,
            Container(
              constraints: BoxConstraints(
                  maxWidth: 120.w
              ),
              child: CountDownView(startTime: widget.startTime, endTime: redTimeEnd,
                  fontSize: 12.w,
                  textColor: IConstant.white_color,
                  prefixColor: IConstant.white_color,
                  prefix: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_period_validity),
                  stop: LanguageConfig.get(LanguageConfigKeys.Shop_activity_closed)),
            )
          ],
        );
      }
    }
  }

  Widget buildButtons() {
    return Container(
      height: 50.w,
      margin: EdgeInsets.only(top: 8.w),
      padding: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 0.w),
      decoration: BoxDecoration(
          color: IConstant.white_color,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.w))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              Row(children: dataList.map((item) => buildButton(item)).toList()),
              expandeSpace,
              InkWell(
                onTap: () {
                  goPrize();
                },
                child: Image.asset("assets/icons/prize_button.png", width: 40.w),
              )
            ],
          ),
        ],
      ),
    );
  }

  void goPrize() {
    if (!isLogin) {
      toLogin((ctx) {
        finishContext(ctx);
        nextPage(PrizeTabPage(), false);
      });
    } else {
      nextPage(PrizeTabPage(), false);
    }
  }

  void goHistory() {
    if (!isLogin) {
      toLogin((ctx) {
        finishContext(ctx);
        loadContentDatas();
      });
    } else {
      nextPage(HistoryPage(), false);
    }
  }

  Widget buildButton(TaskModel model) {
    return Container(
        height: 36.w,
        margin: EdgeInsets.only(right: 10.w),
        child: OutlinedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
                EdgeInsets.fromLTRB(16.w, 4.w, 16.w, 4.w)),
            backgroundColor: createTextButtonStyle(model.isSelect),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.w))),
            side: createTextButtonBorderSide(model.isSelect),
          ),
          onPressed: () {
            setState(() {
              for (var item in dataList) {
                item.isSelect = false;
              }
              model.isSelect = !model.isSelect;
            });
            if (model.type == "1") {
              EventBusUtil.getInstance().emit(ActivityTaskChangeEvent(changeType: ChangeType.task));
            } else {
              EventBusUtil.getInstance().emit(ActivityTaskChangeEvent(changeType: ChangeType.activity));
            }
          },
          child: Text(getTitle(model),
              maxLines: 1,
              style: TextStyle(fontSize: 13.sp, color: model.isSelect ? IConstant.main_color : IConstant.sub_text_color)),
        ));
  }

  WidgetStateProperty<BorderSide> createTextButtonBorderSide(bool isSelect) {
    return WidgetStateProperty.all(BorderSide(width: 1.w, color: isSelect ? IConstant.main_color: IConstant.line_color));
  }

  WidgetStateProperty<Color> createTextButtonStyle(bool isSelect) {
    return WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return isSelect ? IConstant.red_bg_color: IConstant.white_color;
      } else if (states.contains(WidgetState.disabled)) {
        return isSelect ? IConstant.red_bg_color: IConstant.white_color;
      }
      return isSelect ? IConstant.red_bg_color: IConstant.white_color;
    });
  }

  WidgetStateProperty<Color> createTextButtonColor(Color color) {
    return WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return color;
      } else if (states.contains(MaterialState.disabled)) {
        return color;
      }
      return color;
    });
  }

  String getTitle(TaskModel model){
    if (model.type == "1") {
      return LanguageConfig.get(LanguageConfigKeys.Shop_pocket_task);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_activity);
    }
  }

  goLogin() {
    if (!isLogin) {
      toLogin((ctx) {
        finishContext(ctx);
        loadContentDatas();
      });
    }
  }

  String getOrdersToLevel() {
    String level = LanguageConfig.get(LanguageConfigKeys.Shop_pocket_more_orders_to_level);
    return sprintf(level, [getNextPocketLevel(), getLevelOrderCount()]);
  }

  String getNextPocketLevel() {
    return "Lv.${BaseModel.getInt(umsPocketConfig, "pocketLevel") + 1}";
  }

  String getLevelOrderCount() {
    return "${BaseModel.getInt(umsPocketConfig, "levelOrderCount")}";
  }

  bool showAdvCenter() {
    //return TextUtils.isNotEmpty(redTimeEnd) && !Util.isTimeout(redTimeEnd);
    return redPower == 1 || redPower == 2;
  }

  double getExpandedHeight() {
    if (isLogin) {
      if (showAdvCenter()) { //显示红包闯关
        return 286.w + appBarHeight;
      } else { //不显示红包闯关
        return 188.w + appBarHeight;
      }
    } else { //未登录
      return 156.w + appBarHeight;
    }
  }

}
