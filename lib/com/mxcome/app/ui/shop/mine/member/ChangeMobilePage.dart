
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/UserInfoEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/utils/NumUtils.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IURLConstant.dart';
import '../../../../config/LanguageConfig.dart';
import '../../../../model/BaseModel.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/Adapt.dart';
import '../../../../utils/AppUtils.dart';
import '../../../../utils/HttpUtils.dart';
import '../../../../utils/TextUtils.dart';
import '../../../../utils/ViewUtils.dart';
import '../../../../widget/PartRefreshWidget.dart';
import '../../../LanguagePage.dart';
import '../../../WebPage.dart';
import '../../../login/CountryCodePage.dart';
import '../../../login/VerifyPage.dart';
import '../../event/CountryCodeEvent.dart';
import '../../model/CountryCodeModel.dart';
import '../../utils/FormatUtil.dart';
import '../../utils/Util.dart';
import '../../widget/BigTextButton.dart';
import '../../widget/GenAvatar.dart';

class ChangeMobilePage extends StatefulWidget {

  Function(BuildContext context) callBack;

  ChangeMobilePage(this.callBack);

  @override
  State<StatefulWidget> createState() {
    return ChangeMobilePageState();
  }

}

class ChangeMobilePageState extends BaseKeepAliveState<ChangeMobilePage> {

  dynamic userInfo;
  String mobile = "";

  String verifyCode = '';
  int delay = 0;
  Timer? timer;

  GlobalKey<PartRefreshWidgetState> delayKey = GlobalKey();
  bool isClickEnable = false;
  bool isReSend = false;

  CountryCodeModel currentCodeModel = CountryCodeModel.fromLanguage(LanguagePage.language);

  dynamic countryCodeEvent;

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();

  @override
  void initState() {
    super.initState();
    countryCodeEvent = EventBusUtil.getInstance().on<CountryCodeEvent>((event) {
      setState(() {
        currentCodeModel = event.model;
      });
    });
    loadContentDatas();
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(countryCodeEvent);
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    dynamic data = await AppUtils.getUserInfo();
    setState(() {
      userInfo = data;
      setState(() {
        currentCodeModel = CountryCodeModel.fromCode(BaseModel.getString(userInfo, "phoneCode"));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return KeyboardDismissOnTap(child: Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.5.w,
        centerTitle: true,
        title: Text("${LanguageConfig.get(LanguageConfigKeys.Shop_setting_update)}${LanguageConfig.get(LanguageConfigKeys.Shop_setting_phone)}",
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: ListView(
          children: [
            // buildMember(),
            buildPhone(),
            buildVerifyCode(),
            SizedBox(
              height: 16.w,
            ),
          ]
      ),
      bottomNavigationBar: buildBottomBar(),
    ));
  }

  void showProtocol() {
    nextPage(WebPage(FormatUtil.getProtocol()), false);
  }

  Widget buildMember() {
    return Center(child: Container(
      margin: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(child: buildAvatar()),
          SizedBox(height: 4.w),
          Text(getDisplayName(), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
          SizedBox(height: 4.w),
          Text(BaseModel.getString(userInfo, "generatorId"), style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color))
        ],
      ),
    ));
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
          color: IConstant.red_translucent_color,
          child: Center(
              child: Text(TextUtils.isNotEmpty(displayName) ? displayName.substring(0, 1) : "",
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 20.sp, color: IConstant.white_color))));
    }
  }

  String getDisplayName() {
    String nickname = BaseModel.getString(userInfo, "nickname");
    String username = BaseModel.getString(userInfo, "username");
    String phoneCode = BaseModel.getString(userInfo, "phoneCode");
    String phone = BaseModel.getString(userInfo, "phone");
    return TextUtils.isNotEmpty(nickname) ? nickname: "$phoneCode $phone";
  }

  Widget buildPhone() {
    return Container(
      margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 25.w),
      padding: EdgeInsets.only(left: 16.w, right: 16.w),
      decoration: BoxDecoration(border: Border.all(color: IConstant.line_color, width: 1.w), borderRadius: BorderRadius.circular(18.w)),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/login_mobile_icon.png',
            width: 16.w,
            height: 16.w,
          ),
          InkWell(
            onTap: () {
              showCountryCode();
            },
            child: Row(
              children: [
                SizedBox(width: 10.w),
                Text(currentCodeModel.code, style: TextStyle(color: IConstant.title_color, fontSize: 14.sp)),
                Icon(Icons.arrow_drop_down, color: IConstant.title_color, size: 18.w),
                SizedBox(width: 10.w),
              ],
            ),
          ),
          Expanded(child: TextField(
            textInputAction: TextInputAction.next,
            maxLines: 1,
            keyboardType: TextInputType.phone,
            focusNode: _nodeText1,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]'),),
              FilteringTextInputFormatter.deny(RegExp(r'^0+'),), //首位不能为0
            ],
            style: TextStyle(color: IConstant.title_color, fontSize: 14.sp),
            decoration: InputDecoration(
                labelStyle: TextStyle(color: IConstant.title_color, fontSize: 14.sp),
                hintText: LanguageConfig.get(LanguageConfigKeys.Login_mobile_tip),
                hintStyle: TextStyle(color: IConstant.sub_text_color, fontSize: 14.sp),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: IConstant.line_color, width: 1.w),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: IConstant.line_color, width: 1.w),
                )),
            controller: ViewUtils.buildTextEditingController(mobile, listener: (str) {
              mobile = str;
              checkInput();
            }),
          )),
          InkWell(
            onTap: () {
              showCountryCode();
            },
            child: Image.asset(currentCodeModel.icon,
              width: 18.w,
              height: 18.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildVerifyCode() {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: IConstant.line_color, width: 1.w), borderRadius: BorderRadius.circular(16.w)),
      margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 13.w),
      padding: EdgeInsets.only(left: 16.w, right: 16.w),
      child: Row(
        children: [
          Expanded(
              child: TextField(
                textInputAction: TextInputAction.done,
                maxLines: 1,
                keyboardType: TextInputType.number,
                focusNode: _nodeText2,
                style: TextStyle(color: IConstant.title_color, fontSize: 14.sp),
                decoration: InputDecoration(
                    icon: Image.asset(
                      'assets/icons/login_code_icon.png',
                      width: 16.w,
                      height: 16.w,
                    ),
                    hintText: LanguageConfig.get(LanguageConfigKeys.Login_code_tip),
                    hintStyle: TextStyle(color: IConstant.sub_text_color, fontSize: 14.sp),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: IConstant.line_color, width: 1.w),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: IConstant.line_color, width: 1.w),
                    )),
                controller: ViewUtils.buildTextEditingController(verifyCode, listener: (str) {
                  verifyCode = str;
                  checkInput();
                }),
                onSubmitted: (str) {
                  updateMobile();
                },
              )),
          PartRefreshWidget(
              delayKey,
                  () => delay <= 0
                  ? InkWell(
                onTap: () {
                  safeVerify();
                },
                child: SizedBox(
                  width: 80.w,
                  child: Center(
                    child: Text(
                      getSendText(),
                      style: TextStyle(color: IConstant.main_color, fontSize: 14.sp),
                    ),
                  ),
                ),
              )
                  : SizedBox(
                width: 80.w,
                child: Center(
                  child: Text(
                    '${delay}s',
                    style: TextStyle(color: IConstant.main_color, fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  void checkInput() {
    if (TextUtils.isNotEmpty(mobile) && TextUtils.isNotEmpty(verifyCode)) {
      if (isClickEnable) return;
      isClickEnable = true;
      refreshBtn.currentState?.update();
    } else {
      if (!isClickEnable) return;
      isClickEnable = false;
      refreshBtn.currentState?.update();
    }
  }

  void showCountryCode() {
    showPop(0.6 * Adapt.getWindowHeight(), CountryCodePage());
  }

  String getSendText(){
    if (isReSend) {
      return LanguageConfig.get(LanguageConfigKeys.Login_resend_code);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Login_send_code);
    }
  }

  void startTimer() {
    if (delay <= 0) return;
    if (timer != null && timer!.isActive) timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      delayKey.currentState?.update();
      if (delay > 0) {
        delay--;
      } else {
        timer.cancel();
      }
    });
  }

  void safeVerify() {
    if (mobile.length < 6) {
      ViewUtils.displayToast(
          LanguageConfig.get(LanguageConfigKeys.Login_mobile_error));
      return;
    }else{
      switch(currentCodeModel.code) {
        case '+86':
          if(!NumUtils.isCNPhoneNumber(mobile)){
            ViewUtils.displayToast(
                LanguageConfig.get(LanguageConfigKeys.Login_mobile_error));
            return;
          }
          break;
        case '+66':
          if(!NumUtils.isTHPhoneNumber(mobile)){
            ViewUtils.displayToast(
                LanguageConfig.get(LanguageConfigKeys.Login_mobile_error));
            return;
          }
          break;
        default:
          break;
      }
    }
    nextPage(VerifyPage(lister: (randomX1, randomY1, randomX2, randomY2) {
      sendCode(randomX1, randomY1, randomX2, randomY2);
    }), false);
  }

  Future<void> sendCode(int randomX1, int randomY1, int randomX2, int randomY2) async {
    ViewUtils.show();
    String appSign = await Util.encode3aesMd5("$randomX1,$randomY1,$randomX2,$randomY2");
    BaseRsp rsp = await HttpUtils.post(IURLConstant.AUTH_CODE_URL, {
      "phoneCode": currentCodeModel.code,
      "telephone": mobile,
      "randomX1": "$randomX1",
      "randomY1": "$randomY1",
      "randomX2": "$randomX2",
      "randomY2": "$randomY2",
      "appSign": appSign
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      delay = 60;
      startTimer();
      if (IConstant.SMS_TIP) {
        ViewUtils.showToastLong("${LanguageConfig.get(LanguageConfigKeys.Login_sms_code)} ${rsp.data}");
      }
      setState(() {
        isReSend = true;
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      elevation: 0.w,
      height: 150.w,
      child: SizedBox(
        height: 150.w,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
              child: buildConfirm(),
            ),
            SizedBox(height: 20.w),
            Container(
              margin: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LanguageConfig.get(LanguageConfigKeys.Login_login_accept_tip),
                    style: TextStyle(color: IConstant.grey_color, fontSize: 12.sp),
                  ),
                  GestureDetector(
                    child: Text(
                      LanguageConfig.get(LanguageConfigKeys.Login_service),
                      style: TextStyle(color: IConstant.title_color, fontSize: 12.sp),
                    ),
                    onTap: () async {
                      showProtocol();
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: 10.w),
          ],
        ),
      ),
    );
  }

  GlobalKey<PartRefreshWidgetState> refreshBtn = GlobalKey();

  Widget buildConfirm() {
    return PartRefreshWidget(refreshBtn, () => BigTextButton(text: LanguageConfig.get(LanguageConfigKeys.ViewUtils_confirm), enable: isClickEnable, onTap: () {
      updateMobile();
    }));
  }

  void updateMobile() async {
    if (mobile.length < 6) {
      ViewUtils.displayToast(
          LanguageConfig.get(LanguageConfigKeys.Login_mobile_error));
      return;
    }else{
      switch(currentCodeModel.code) {
        case '+86':
          if(!NumUtils.isCNPhoneNumber(mobile)){
            ViewUtils.displayToast(
                LanguageConfig.get(LanguageConfigKeys.Login_mobile_error));
            return;
          }
          break;
        case '+66':
          if(!NumUtils.isTHPhoneNumber(mobile)){
            ViewUtils.displayToast(
                LanguageConfig.get(LanguageConfigKeys.Login_mobile_error));
            return;
          }
          break;
        default:
          break;
      }
    }
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_UPDATE_PHONE,
        {
          "phoneCode": currentCodeModel.code,
          "authCode": verifyCode,
          "telephone": mobile,
        }
    );
    if (rsp.retCode == RspRetCode.SUCCESS) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_operation_successful));
      EventBusUtil.getInstance().emit(UserInfoEvent());
      setState(() {
        widget.callBack(context);
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

}
