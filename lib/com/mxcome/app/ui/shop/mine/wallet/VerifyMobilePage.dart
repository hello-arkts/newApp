
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/UserInfoEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';

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
import '../../../login/CountryCodePage.dart';
import '../../../login/VerifyPage.dart';
import '../../model/CountryCodeModel.dart';
import '../../utils/Util.dart';
import '../../widget/BigTextButton.dart';

class VerifyMobilePage extends StatefulWidget {

  Function(BuildContext context, String code) callBack;

  VerifyMobilePage(this.callBack);

  @override
  State<StatefulWidget> createState() {
    return VerifyMobilePageState();
  }
}

class VerifyMobilePageState extends BaseKeepAliveState<VerifyMobilePage> {

  dynamic userInfo;
  String mobile = '';
  String phoneCode = '';

  String verifyCode = '';
  int delay = 0;
  Timer? timer;

  GlobalKey<PartRefreshWidgetState> delayKey = GlobalKey();
  bool isClickEnable = false;
  bool isReSend = false;

  CountryCodeModel currentCodeModel = CountryCodeModel.fromLanguage(LanguagePage.language);

  dynamic userInfoEvent;

  final FocusNode _nodeText1 = FocusNode();

  @override
  void initState() {
    super.initState();
    userInfoEvent = EventBusUtil.getInstance().on<UserInfoEvent>((event) {
      if (event.userInfoStatus == UserInfoStatus.complete) {
        loadContentDatas();
      }
    });
    loadContentDatas();
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(userInfoEvent);
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    dynamic data = await AppUtils.getUserInfo();
    setState(() {
      userInfo = data;
      mobile = BaseModel.getString(userInfo, "phone");
      phoneCode = BaseModel.getString(userInfo, "phoneCode");
      setState(() {
        currentCodeModel = CountryCodeModel.fromCode(BaseModel.getString(userInfo, "phoneCode"));
      });
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        safeVerify();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return KeyboardDismissOnTap(child: Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Login_verify_phone),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 30.w, bottom: 20.w),
              child: Text("${LanguageConfig.get(LanguageConfigKeys.Verify_code_tip)} $phoneCode $mobile", textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
            ),
            buildVerifyCode(),
          ]
      ),
      bottomNavigationBar: buildBottomBar(),
    ));
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
                focusNode: _nodeText1,
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
                  checkCode();
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
    if (TextUtils.isNotEmpty(verifyCode)) {
      if (isClickEnable) return;
      isClickEnable = true;
      refreshBtn.currentState?.update();refreshBtn.currentState?.update();
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
      height: 110.w,
      elevation: 0.w,
      child: Container(
        margin: EdgeInsets.all(20.w),
        child: buildConfirm(),
      ),
    );
  }

  GlobalKey<PartRefreshWidgetState> refreshBtn = GlobalKey();

  Widget buildConfirm() {
    return PartRefreshWidget(
        refreshBtn, () =>
        BigTextButton(text: LanguageConfig.get(LanguageConfigKeys.ViewUtils_confirm), enable: isClickEnable, onTap: () {
          checkCode();
        }));
  }

  void checkCode() async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.CHECK_CODE_URL, {
      "authCode": verifyCode,
      "phoneCode": currentCodeModel.code,
      "telephone": mobile,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      EventBusUtil.getInstance().emit(UserInfoEvent());
      widget.callBack(context, verifyCode);
    } else if(rsp.retCode == 504) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Login_sms_code_error));
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }
}
