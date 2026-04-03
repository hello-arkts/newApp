import 'dart:collection';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/ActivityEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';

import '../../../IURLConstant.dart';
import '../../../model/BaseModel.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/TextUtils.dart';
import '../event/UserInfoEvent.dart';
import '../model/SignModel.dart';
import '../utils/EventBusUtil.dart';
import '../widget/GenAvatar.dart';
import '../widget/LoadImageView.dart';

class SignPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return SignPageState();
  }

}

class SignPageState extends BaseKeepAliveState<SignPage> {

  dynamic userInfo;

  bool isLogin = false;

  dynamic userInfoEvent;

  List<SignModel> weekList = [];

  LinkedHashMap<String, dynamic> signedDateMap = LinkedHashMap();

  int signContinueDay = 0;

  String historyIntegration = "0";

  int integralInitValue = 100;

  int integralStepValue = 100;

  @override
  void initState() {
    super.initState();
    userInfoEvent = EventBusUtil.getInstance().on<UserInfoEvent>((event) {
      if (event.userInfoStatus == UserInfoStatus.complete) {
        loadContentDatas();
      }
    });
    loadContentDatas();
    DateTime now = DateTime.now();
    int weekDay = now.weekday;
    DateTime firstDay = now.subtract(Duration(days: weekDay));
    List<SignModel> tempList = [];
    for (int i = 0; i < 7; i++) {
      DateTime day = DateTime(firstDay.year, firstDay.month, firstDay.day + i);
      String ymd = FormatUtil.formatLineYMD(day);
      bool isSameDay = DateUtils.isSameDay(day, now);
      if (isSameDay || day.isAfter(now)) {
        SignModel model = SignModel(day, ymd, 0, isSameDay ? DateStatus.same : DateStatus.after);
        tempList.add(model);
      } else {
        SignModel model = SignModel(day, ymd, 0, DateStatus.before);
        tempList.add(model);
      }
    }
    setState(() {
      weekList  = tempList;
    });
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(userInfoEvent);
    super.dispose();
  }

  Future<void> _onRefresh() async {
    EventBusUtil.getInstance().emit(ActivityEvent());
    EventBusUtil.getInstance().emit(UserInfoEvent());
    await Future.delayed(const Duration(milliseconds: 800),() {
    });
  }

  @override
  Future<void> loadContentDatas() async {
    bool loginState = await AppUtils.isLogined();
    if (loginState) {
      dynamic data = await AppUtils.getUserInfo();
      setState(() {
        userInfo = data;
        isLogin = loginState;
        String allIntegration =  BaseModel.getString(userInfo, "historyIntegration");
        if (TextUtils.isNotEmpty(allIntegration)) {
          historyIntegration = allIntegration;
        }
      });
      loadSignWeekList();
    } else {
      setState(() {
        isLogin = false;
      });
    }
  }

  void loadSignWeekList() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_SIGN_WEEK_LIST, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<dynamic> signedList = BaseModel.getDynamic(rsp.data, "list");
      LinkedHashMap<String, dynamic> tempMap = LinkedHashMap();
      for (dynamic item in signedList) {
        String date = BaseModel.getString(item, "createTime");
        String ymd = FormatUtil.formatLineYMD(DateTime.parse(date));
        tempMap[ymd] = item;
      }
      setState(() {
        signContinueDay = BaseModel.getInt(rsp.data, "signContinuDay");
        signedDateMap = tempMap;
      });
      //是否已补签
      bool isFillSign = false;
      //封装后端返回数据
      for (SignModel model in weekList) {
        if (signedDateMap.containsKey(model.ymd)) {
          int sourceType = BaseModel.getInt(signedDateMap[model.ymd], "sourceType");
          model.changeCount = BaseModel.getInt(signedDateMap[model.ymd], "changeCount");
          if (sourceType == 1) {
            model.signStatus = SignStatus.signed;
          } else {
            model.signStatus = SignStatus.fillsign;
            isFillSign = true;
          }
        } else {
          model.changeCount = 0;
          model.signStatus = SignStatus.unsign;
        }
      }
      //处理连续签到金额算法
      for (int i = 0; i < weekList.length; i++) {
        SignModel model = weekList[i];
        if (i == 0) {
          //是否第一天
          //未签到
          if (model.isUnsign()) {
            if (model.isBefore() || model.isSame()) {
              model.continueNum = 1;
              model.changeCount = integralInitValue;
            }
          }
        } else {
          if (model.isUnsign()) {
            if (model.isBefore()) {
              model.continueNum = 1;
              model.changeCount = integralInitValue;
            } else {
              SignModel prevModel = weekList[i - 1];
              if ((prevModel.isFillsign() && model.isSame()) || (prevModel.isUnsign() && model.isSame())) { //昨天补签，从今天开始算起，昨天未签到，从今天开始算起
                model.continueNum = 1;
                model.changeCount = integralInitValue;
              } else {
                model.continueNum = prevModel.continueNum + 1;
                model.changeCount = model.continueNum * integralStepValue;
              }
            }
          } else if (model.isSigned()) { //连续已签逻辑
            model.continueNum = FormatUtil.num2int(model.changeCount / integralStepValue);
          }
        }
      }
      //处理补签是否可用
      for (SignModel model in weekList) {
        if (model.isBefore()) {
          if (model.isUnsign() && model.isYesterday() && !isFillSign) {
            model.clickEnable = true;
          } else {
            model.clickEnable = false;
          }
        } else if (model.isUnsign() && model.isToday()) {
          model.clickEnable = true;
        } else {
          model.clickEnable = false;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return EasyRefresh(
        header: const MaterialHeader(color: IConstant.main_color),
        onRefresh: ()=> _onRefresh(), child: buildSign());
  }

  Widget buildSign() {
    return Container(
      decoration: BoxDecoration(
          color: IConstant.white_color,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.w))
      ),
      padding: EdgeInsets.fromLTRB(12.w, 16.w, 16.w, 6.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              buildContinueDay(),
              expandeSpace,
              InkWell(
                onTap: () {
                },
                child: Row(
                  children: [
                    Image.asset("assets/icons/drop.png", width: 18.w, height: 18.w,),
                    SizedBox(width: 4.w),
                    Text(historyIntegration, style: TextStyle(fontSize: 14.sp, color: IConstant.main_color)),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 10.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekList.map((item) => buildSignItem(item)).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildContinueDay() {
    String continueDay = LanguageConfig.get(LanguageConfigKeys.Shop_grow_continue_day);
    var days = continueDay.split("|");
    return RichText(
        text: TextSpan(
            children: [
              TextSpan(
                text: days[0],
                style: TextStyle(fontSize: 14.sp, color: IConstant.text_color),
              ),
              TextSpan(
                text: " $signContinueDay ",
                style: TextStyle(fontSize: 14.sp, color: IConstant.main_color),
              ),
              TextSpan(
                text: days[1],
                style: TextStyle(fontSize: 14.sp, color: IConstant.text_color),
              ),
            ]));
  }

  Widget buildSignItem(SignModel model) {
    return InkWell(
      onTap: () {
        if (model.clickEnable) {
          goSign(model);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40.w,
            height: 50.w,
            decoration: BoxDecoration(
                color: model.getBgColor(),
                borderRadius: BorderRadius.circular(8.w)),
            child: buildSignStatus(model),
          ),
          SizedBox(height: 4.w),
          Text(getWeekName(model), maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10.sp, color: model.isAfter() ? IConstant.grey_color : IConstant.black_color)),
        ],
      ),
    );
  }

  String getWeekName(SignModel model){
    String weekName = "";
    switch (model.day.weekday) {
      case 1:
        weekName = LanguageConfig.get(LanguageConfigKeys.Shop_monday);
        break;
      case 2:
        weekName = LanguageConfig.get(LanguageConfigKeys.Shop_tuesday);
        break;
      case 3:
        weekName = LanguageConfig.get(LanguageConfigKeys.Shop_wednesday);
        break;
      case 4:
        weekName = LanguageConfig.get(LanguageConfigKeys.Shop_thursday);
        break;
      case 5:
        weekName = LanguageConfig.get(LanguageConfigKeys.Shop_friday);
        break;
      case 6:
        weekName = LanguageConfig.get(LanguageConfigKeys.Shop_saturday);
        break;
      case 7:
        weekName = LanguageConfig.get(LanguageConfigKeys.Shop_sunday);
        break;
    }
    if (model.isToday()) {
      weekName = LanguageConfig.get(LanguageConfigKeys.Shop_today);
    }
    return weekName;
  }

  Widget buildSignStatus(SignModel model){
    if(model.isUnsign()) {
      return Column(
        children: [
          SizedBox(height: 8.w),
          Image.asset("assets/icons/drop.png", width: 18.w, height: 18.w, color: model.getTexColor()),
          SizedBox(height: 8.w),
          Text(getIntegral(model), maxLines: 1, textAlign: TextAlign.center, style: TextStyle(fontSize: 10.sp, color: model.getTexColor())),
        ],
      );
    } else if(model.isFillsign()){
      return Column(
        children: [
          SizedBox(height: 8.w),
          Image.asset("assets/icons/check.png", width: 18.w, height: 18.w,),
          SizedBox(height: 4.w),
          Text(LanguageConfig.get(LanguageConfigKeys.Shop_grow_countersigned), maxLines: 1, textAlign: TextAlign.center, style: TextStyle(fontSize: 10.sp, color: model.getTexColor())),
        ],
      );
    } else {
      return Column(
        children: [
          SizedBox(height: 8.w),
          Image.asset("assets/icons/check.png", width: 18.w, height: 18.w,),
          SizedBox(height: 4.w),
          Text(LanguageConfig.get(LanguageConfigKeys.Shop_grow_signed), maxLines: 1, textAlign: TextAlign.center, style: TextStyle(fontSize: 10.sp, color: model.getTexColor())),
        ],
      );
    }
  }

  String getIntegral(SignModel model){
    if (model.isBefore()) {
      if (model.isUnsign() && model.isToday()) {
        return LanguageConfig.get(LanguageConfigKeys.Shop_grow_countersign);
      } else if (model.isUnsign()) {
        return LanguageConfig.get(LanguageConfigKeys.Shop_grow_unsigned);
      } else {
        return model.getIntegral();
      }
    } else {
      return model.getIntegral();
    }
  }

  String getDisplayName() {
    String nickname = BaseModel.getString(userInfo, "nickname");
    String username = BaseModel.getString(userInfo, "username");
    String phoneCode = BaseModel.getString(userInfo, "phoneCode");
    String phone = BaseModel.getString(userInfo, "phone");
    return TextUtils.isNotEmpty(nickname) ? nickname: "$phoneCode $phone";
  }

  String getGenId() {
    String generatorId = BaseModel.getString(userInfo, "generatorId");
    return TextUtils.isNotEmpty(generatorId) ? generatorId : "";
  }

  Widget buildAvatar() {
    String avatar = BaseModel.getString(userInfo, "icon");
    if (TextUtils.isNotEmpty(avatar)) {
      return SizedBox(
        width: 50.w,
        height: 50.w,
        child: GenAvatar(avatar),
      );
    } else {
      String displayName = getDisplayName();
      return Container(
          width: 50.w,
          height: 50.w,
          color: IConstant.black_translucent_color,
          child: Center(
              child: Text(
                  TextUtils.isNotEmpty(displayName) ? displayName.substring(
                      0, 1) : "", textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.sp, color: IConstant.white_color))));
    }
  }

  void goSign(SignModel model) {
    if (model.isSame()) {
      if (model.isUnsign()) {
        sign(model);
      } else if(model.isFillsign()){
        ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_grow_countersigned));
      } else {
        ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_grow_signed));
      }
    } else {
      if (model.isUnsign()) {
        fillSign(model);
      } else if(model.isFillsign()){
        ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_grow_countersigned));
      } else {
        ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_grow_signed));
      }
    }
  }

  void sign(SignModel model) async {
    //签到
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_SIGN, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      loadSignWeekList();
      EventBusUtil.getInstance().emit(UserInfoEvent());
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  void fillSign(SignModel model) async {
    //补签
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_FILL_SIGN, {"signDate": model.ymd});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      loadSignWeekList();
      EventBusUtil.getInstance().emit(UserInfoEvent());
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  double getTimeDouble(dynamic item) {
    DateTime createTime = DateTime.parse(BaseModel.getString(item, "createTime"));
    DateTime endTime = DateTime.parse(BaseModel.getString(item, "endTime"));
    int spaceTime = endTime.millisecondsSinceEpoch - createTime.millisecondsSinceEpoch;
    int currentSpaceTime = endTime.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
    return (currentSpaceTime / spaceTime);
  }


}
