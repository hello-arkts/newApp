import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/ui/LanguagePage.dart';
import 'package:mxcome/com/mxcome/app/utils/NumUtils.dart';

import '../../../../IURLConstant.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/Adapt.dart';
import '../../../../utils/HttpUtils.dart';
import '../../../../utils/TextUtils.dart';
import '../../../../utils/ViewUtils.dart';
import '../../../../widget/PartRefreshWidget.dart';
import '../../../login/CountryCodePage.dart';
import '../../../login/SetPasswordPage.dart';
import '../../../login/VerifyPage.dart';
import '../../event/CountryCodeEvent.dart';
import '../../model/CountryCodeModel.dart';
import '../../utils/EventBusUtil.dart';
import '../../utils/Util.dart';
import '../../widget/BigTextButton.dart';


class UpdatePasswordPage extends StatefulWidget {

  String phoneCode = '';
  String mobile = '';
  UpdatePasswordPage(this.phoneCode, this.mobile);

  @override
  State<StatefulWidget> createState() => UpdatePasswordPageState();
}

class UpdatePasswordPageState extends BaseKeepAliveState<UpdatePasswordPage> {

  String phoneCode = '';
  String mobile = '';
  String verifyCode = '';
  int delay = 0;
  Timer? timer;

  CountryCodeModel currentCodeModel = CountryCodeModel.fromLanguage(LanguagePage.language);

  GlobalKey<PartRefreshWidgetState> delayKey = GlobalKey();
  bool isClickEnable = false;
  bool isReSend = false;

  dynamic countryCodeEvent;

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();

  @override
  void initState() {
    super.initState();
    setState(() {
      phoneCode = widget.phoneCode;
      mobile = widget.mobile;
      currentCodeModel = CountryCodeModel.fromCode(phoneCode);
    });
    countryCodeEvent = EventBusUtil.getInstance().on<CountryCodeEvent>((event) {
      setState(() {
        currentCodeModel = event.model;
      });
    });
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(countryCodeEvent);
    if (timer != null) {
      timer?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return KeyboardDismissOnTap(
      child: Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
          elevation: 0.w,
          centerTitle: true,
          title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_setting_update_pwd),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)
          )
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 20.w),
            padding: EdgeInsets.only(left: 16.w, right: 16.w),
            decoration: BoxDecoration(
                color: IConstant.line_color,
                border: Border.all(color: IConstant.line_color, width: 1.w),
                borderRadius: BorderRadius.circular(18.w)
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/login_mobile_icon.png',
                  width: 16.w,
                  height: 16.w,
                ),
                InkWell(
                  onTap: () {
                    // showCountryCode();
                  },
                  child: Row(
                    children: [
                      SizedBox(width: 10.w),
                      Text(currentCodeModel.code, style: TextStyle(color: IConstant.sub_text_color, fontSize: 14.sp)),
                      Icon(Icons.arrow_drop_down, color: IConstant.sub_text_color, size: 18.w),
                      SizedBox(width: 10.w),
                    ],
                  ),
                ),
                Expanded(child: TextField(
                  enabled: false,
                  textInputAction: TextInputAction.next,
                  maxLines: 1,
                  keyboardType: TextInputType.phone,
                  focusNode: _nodeText1,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'),),
                    FilteringTextInputFormatter.deny(RegExp(r'^0+'),), //首位不能为0
                  ],
                  style: TextStyle(color: IConstant.sub_text_color, fontSize: 14.sp),
                  decoration: InputDecoration(
                      border: InputBorder.none,
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
                    // showCountryCode();
                  },
                  child: Image.asset(currentCodeModel.icon,
                    width: 18.w,
                    height: 18.w,
                  ),
                )
              ],
            ),
          ),
          Container(
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
                        forgotPassword();
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
                    ) : SizedBox(
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
          ),
        ],
      ),
      bottomNavigationBar: buildBottomBar(),
    ));
  }

  void showCountryCode() {
    showPop(0.6 * Adapt.getWindowHeight(), CountryCodePage());
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
    return PartRefreshWidget(refreshBtn, () => BigTextButton(text: LanguageConfig.get(LanguageConfigKeys.ViewUtils_confirm), enable: isClickEnable, onTap: () {
      forgotPassword();
    }));
  }

  Future<void> forgotPassword() async {
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
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.CHECK_CODE_URL, {
      "authCode": verifyCode,
      "phoneCode": currentCodeModel.code,
      "telephone": mobile,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      showPop(0.7 * Adapt.getWindowHeight(), SetPasswordPage(currentCodeModel.code, mobile, false, authCode: verifyCode));
    } else if(rsp.retCode == 504) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Login_sms_code_error));
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

}
