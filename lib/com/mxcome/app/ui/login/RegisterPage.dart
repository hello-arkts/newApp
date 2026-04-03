import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/IURLConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseRsp.dart';
import 'package:mxcome/com/mxcome/app/ui/LanguagePage.dart';
import 'package:mxcome/com/mxcome/app/ui/WebPage.dart';
import 'package:mxcome/com/mxcome/app/ui/login/BindPhonePage.dart';
import 'package:mxcome/com/mxcome/app/ui/login/InviteCodePage.dart';
import 'package:mxcome/com/mxcome/app/ui/login/ObtainedRedPage.dart';
import 'package:mxcome/com/mxcome/app/ui/login/VerifyPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/CountryCodeModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/BigTextButton.dart';
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/NumUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import 'package:mxcome/com/mxcome/app/widget/PartRefreshWidget.dart';

import '../../model/BaseModel.dart';
import '../../utils/Adapt.dart';
import '../shop/event/CountryCodeEvent.dart';
import '../shop/event/LoginSuccessEvent.dart';
import '../shop/utils/Util.dart';
import 'BetaProtocolPage.dart';
import 'CountryCodePage.dart';
import 'SetPasswordPage.dart';

class RegisterPage extends StatefulWidget {

  Function(BuildContext context) callBack;

  RegisterPage(this.callBack);

  @override
  State<StatefulWidget> createState() => RegisterPageState();

}

class RegisterPageState extends BaseKeepAliveState<RegisterPage> {

  String mobile = '';
  String verifyCode = '';
  String inviteCode = '';
  int delay = 0;
  Timer? timer;

  CountryCodeModel currentCodeModel = CountryCodeModel.fromLanguage(LanguagePage.language);

  GlobalKey<PartRefreshWidgetState> delayKey = GlobalKey();
  bool isClickEnable = false;
  bool isReSend = false;

  dynamic countryCodeEvent;

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();

  bool isBeta = false;
  bool invalid = false;
  bool isReadProtocol = false;
  String inviteCodeHint = LanguageConfig.get(LanguageConfigKeys.Login_input_invite_code);

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
  Future<void> loadContentDatas() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_IS_BETA, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        if ("${rsp.data}" == "true") {
          isBeta = true;
          inviteCodeHint = LanguageConfig.get(LanguageConfigKeys.Login_input_invite_code);
        } else {
          isBeta = false;
          inviteCodeHint = LanguageConfig.get(LanguageConfigKeys.Login_input_invite_code);
        }
      });
    }
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(countryCodeEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return KeyboardDismissOnTap(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 60.w,
              ),
              Image.asset(
                'assets/icons/login_icon.png',
                height: 26.w,
              ),
              SizedBox(height: 16.w),
              Text(LanguageConfig.get(LanguageConfigKeys.Login_welcome_world_of_gold), style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
              buildPhone(),
              buildVerifyCode(),
              buildInviteCode(),
              invalid ? Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(top: 8.w, right: 16.w),
                child: Text(
                    LanguageConfig.get(LanguageConfigKeys.Login_input_invite_code_invalid),
                    textAlign: TextAlign.right,
                    style: TextStyle(color: IConstant.main_color, fontSize: 13.sp),
                  ),
              ) : Container(),
              SizedBox(
                height: 40.w,
              ),
              Container(
                  margin: EdgeInsets.only(left: 16.w, right: 16.w), width: double.infinity,
                  child: buildRegister()),
              SizedBox(
                height: 40.w,
              ),
              SizedBox(
                height: 20.w,
              ),
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
              SizedBox(
                height: 20.w,
              ),
            ],
          ),
        ),
    );
  }

  Widget buildPhone() {
    return Container(
      margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 80.w),
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
          )
        ],
      ),
    );
  }

  Future<void> handleRegisterRedSuccess(dynamic registerRes) async {
    int redPower = BaseModel.getInt(registerRes, 'redPower');
    if (redPower == 1) { //状态变化，获得红包资格
      showPop(0.6 * Adapt.getWindowHeight(), ObtainedRedPage(registerRes, callBack: (BuildContext ctx) {
        showPop(0.7 * Adapt.getWindowHeight(), SetPasswordPage(currentCodeModel.code, mobile, true));
      },), enableDrag: false);
    }else{
      showPop(0.7 * Adapt.getWindowHeight(), SetPasswordPage(currentCodeModel.code, mobile, true));
    }
  }

  Widget buildVerifyCode() {
   return Container(
      decoration: BoxDecoration(border: Border.all(color: IConstant.line_color, width: 1.w), borderRadius: BorderRadius.circular(16.w)),
      margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 12.w),
      padding: EdgeInsets.only(left: 16.w, right: 16.w),
      child: Row(
        children: [
          Expanded(
              child: TextField(
                textInputAction: TextInputAction.next,
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

  Widget buildInviteCode() {
    return Container(
      margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 12.w),
      padding: EdgeInsets.only(left: 16.w, right: 16.w),
      decoration: BoxDecoration(border: Border.all(color: IConstant.line_color, width: 1.w), borderRadius: BorderRadius.circular(18.w)),
      child: Row(
        children: [
          Expanded(child: TextField(
            onTap: () {
              if (!isReadProtocol) {
                nextPage(BetaProtocolPage(FormatUtil.getBetaProtocol(), (ctx) {
                  finishContext(ctx);
                  setState(() {
                    isReadProtocol = true;
                    _nodeText3.requestFocus();
                  });
                }), false);
              }
            },
            textInputAction: TextInputAction.done,
            maxLines: 1,
            keyboardType: TextInputType.text,
            focusNode: _nodeText3,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]|[0-9]')),//数字
            ],
            style: TextStyle(color: IConstant.title_color, fontSize: 14.sp),
            decoration: InputDecoration(
                border: InputBorder.none,
                icon: Image.asset(
                  'assets/icons/register_code.png',
                  width: 16.w,
                  height: 16.w,
                ),
                labelStyle: TextStyle(color: IConstant.title_color, fontSize: 14.sp),
                hintText: inviteCodeHint,
                hintStyle: TextStyle(color: IConstant.sub_text_color, fontSize: 14.sp),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: IConstant.line_color, width: 1.w),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: IConstant.line_color, width: 1.w),
                )),
            controller: ViewUtils.buildTextEditingController(inviteCode, listener: (str) {
              inviteCode = str;
              checkInput();
            }),
            onSubmitted: (str) {
              registerNow();
            },
          )),
          InkWell(
            onTap: () {
              showInviteCode();
            },
            child: Image.asset( 'assets/icons/register_warn.png',
              width: 18.w,
              height: 18.w,
            ),
          )
        ],
      ),
    );
  }

  GlobalKey<PartRefreshWidgetState> refreshBtn = GlobalKey();

  Widget buildRegister() {
    return PartRefreshWidget(refreshBtn, () => BigTextButton(text: LanguageConfig.get(LanguageConfigKeys.Login_register), enable: isClickEnable, onTap: () {
      registerNow();
    }));
  }

  String getSendText(){
    if (isReSend) {
      return LanguageConfig.get(LanguageConfigKeys.Login_resend_code);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Login_send_code);
    }
  }

  void showProtocol() {
    nextPage(WebPage(FormatUtil.getProtocol()), false);
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

  Future<void> registerNow() async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.REGISTER_URL, {
      "phoneCode": currentCodeModel.code,
      'telephone': mobile,
      "authCode": verifyCode,
      "invitationCode": inviteCode,
    });
    ViewUtils.dismiss();
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        invalid = false;
      });
      handleRegisterRedSuccess(rsp.data);
    } else if(rsp.retCode == 406) {
      showRegisterTip();
    } else if(rsp.retCode == 416) {
      setState(() {
        invalid = true;
      });
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Login_input_invite_code_invalid));
    } else if(rsp.retCode == 504) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Login_sms_code_error));
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  showRegisterTip(){
    ViewUtils.showConfirmDialog(context, LanguageConfig.get(LanguageConfigKeys.Login_duplicate_register_tip), (ctx, bl) => {
      if (bl) {
        gotoLogin(ctx)
      } else {
        finishContext(ctx)
      }
    });
  }

  gotoLogin(BuildContext ctx){
    finishContext(ctx);
    finish();
    toLogin((ctx1) => {
      setState(() {
        finishContext(ctx1);
      })
    });
  }

  loginEnd(token) async {
    EventBusUtil.getInstance().emit(LoginSuccessEvent(token));
    nextMainPage();
  }

  void bindPhone(User user, int thirdPartyType) {
    showPop(0.7 * Adapt.getWindowHeight(), BindPhonePage(user.uid, "${user.email}", "${user.displayName}", "${user.photoURL}", thirdPartyType));
  }

  void showInviteCode() {
    showPop(0.3 * Adapt.getWindowHeight(), InviteCodePage());
  }

}
