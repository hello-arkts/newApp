import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/StepperModel.dart';
import 'package:mxcome/com/mxcome/app/widget/PasswordField.dart';
import 'package:mxcome/com/mxcome/app/widget/PasswordKeyboard.dart';

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
import '../../event/CountryCodeEvent.dart';
import '../../model/CountryCodeModel.dart';
import '../../utils/EventBusUtil.dart';
import '../../utils/Util.dart';
import '../../widget/BigTextButton.dart';

class SettingPayPwdPage extends StatefulWidget {

  Function(BuildContext context) callBack;

  SettingPayPwdPage(this.callBack);

  @override
  State<StatefulWidget> createState() {
    return SettingPayPwdPageState();
  }
}

class SettingPayPwdPageState extends BaseKeepAliveState<SettingPayPwdPage> {

  dynamic userInfo;

  String savePwd = '';
  String pwdText = '';

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

  int current = 0;

  StepperModel stepper1 = StepperModel(LanguageConfig.get(LanguageConfigKeys.Shop_order_phone_verify), 20.w, false, true);

  StepperModel stepper2 = StepperModel(LanguageConfig.get(LanguageConfigKeys.Shop_order_set_pay_pwd), 20.w, false, false);

  StepperModel stepper3 = StepperModel(LanguageConfig.get(LanguageConfigKeys.Shop_order_confirm_pay_pwd), 20.w, false, false);

  final FocusNode _nodeText1 = FocusNode();

  int isSetPay = 0;

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
      isSetPay = BaseModel.getInt(userInfo, "isSetPay");
      phoneCode = BaseModel.getString(userInfo, "phoneCode");
      mobile = BaseModel.getString(userInfo, "phone");
      currentCodeModel = CountryCodeModel.fromCode(phoneCode);
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
        title: Text(isSetPay == 1 ? LanguageConfig.get(LanguageConfigKeys.Shop_setting_change_pay_pwd) : LanguageConfig.get(LanguageConfigKeys.Shop_setting_set_pay_pwd),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildStepper(),
            current == 0 ? buildMobile() : Container(),
            current == 0 ? buildVerifyCode() : Container(),
            current == 1 ? buildPwd(LanguageConfig.get(LanguageConfigKeys.Shop_order_set_pay_pwd_tip)) : Container(),
            current == 2 ? buildPwd(LanguageConfig.get(LanguageConfigKeys.Shop_order_confirm_pay_pwd_tip)) : Container(),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomBar(),
    ));
  }

  Widget buildMobile() {
    return Container(
      margin: EdgeInsets.only(left: 16.w, right: 16.w),
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
            // onTap: () {
            //   showCountryCode();
            // },
            child: Row(
              children: [
                SizedBox(width: 10.w),
                Text(phoneCode, style: TextStyle(color: IConstant.title_color, fontSize: 14.sp)),
                Icon(Icons.arrow_drop_down, color: IConstant.title_color, size: 18.w),
                SizedBox(width: 10.w),
              ],
            ),
          ),
          Expanded(child: TextField(
            enabled: false,
            textInputAction: TextInputAction.next,
            maxLines: 1,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[0-9]")),//数字
              // FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),//只允许输入字母
            ],
            style: TextStyle(color: IConstant.title_color, fontSize: 14.sp),
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
            // onTap: () {
            //   showCountryCode();
            // },
            child: Image.asset(currentCodeModel.icon,
              width: 18.w,
              height: 18.w,
            ),
          )
        ],
      ),
    );
  }

  Widget buildVerifyCode() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: IConstant.line_color, width: 1.w),
          borderRadius: BorderRadius.circular(16.w)),
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
    nextPage(VerifyPage(lister: (randomX1, randomY1, randomX2, randomY2) {
      sendCode(randomX1, randomY1, randomX2, randomY2);
    }), false);
  }

  Future<void> sendCode(int randomX1, int randomY1, int randomX2, int randomY2) async {
    ViewUtils.show();
    String appSign = await Util.encode3aesMd5("$randomX1,$randomY1,$randomX2,$randomY2");
    BaseRsp rsp = await HttpUtils.post(IURLConstant.AUTH_CODE_URL, {
      "phoneCode": phoneCode,
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

  Widget buildStepper() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 16.w),
      padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.w),
          Row(children: [
            SizedBox(width: 22.w),
            buildClipOval(stepper1),
            Expanded(child: Container(height: 1.w, color: IConstant.line_color)),
            buildClipOval(stepper2),
            Expanded(child: Container(height: 1.w, color: IConstant.line_color)),
            buildClipOval(stepper3),
            SizedBox(width: 22.w),
          ]),
          SizedBox(height: 10.w),
          Row(children: [
            SizedBox(width: 10.w),
            Expanded(child: Text(stepper1.title, textAlign: TextAlign.left, style: TextStyle(fontSize: 10.sp, color: IConstant.text_color))),
            SizedBox(width: 16.w),
            Expanded(child: Text(stepper2.title, textAlign: TextAlign.center, style: TextStyle(fontSize: 10.sp, color: IConstant.text_color))),
            SizedBox(width: 16.w),
            Expanded(child: Text(stepper3.title, textAlign: TextAlign.right, style: TextStyle(fontSize: 10.sp, color: IConstant.text_color))),
            SizedBox(width: 10.w),
          ]),
        ],
      ),
    );
  }

  Widget buildClipOval(StepperModel model) {
    if (model.isFinish){
      return Image.asset('assets/icons/confirm.png', width: model.size, height: model.size);
    } else if (model.isSelect) {
      return Center(child: ClipOval(
          child: Container(width: model.size, height: model.size, color: IConstant.main_color)));
    } else {
      return Center(child: ClipOval(
          child: Container(width: model.size, height: model.size, color: IConstant.grey_bg_color)));
    }
  }
 
  Widget buildPwd(String title) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(16.w, 25.w, 16.w, 0.w),
          child: Text(title, textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp, color: IConstant.text_color),
          ),
        ),
        Container(
          margin: EdgeInsets.all(30.w),
          width: double.infinity,
          height: 50.w,
          child: PasswordField(pwdText),
        ),
      ],
    );
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 247.w,
      elevation: 0.w,
      child: current == 0 ? Container(
        margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
        height: 50.w,
        alignment: Alignment.center,
        child: SizedBox(
          width: 180.w,
          child: buildSubmit(),
        ),
      ) :  PasswordKeyboard((ctx, item) => {
        setState(() {
          if (item == "del") {
            pwdText = pwdText.substring(0, pwdText.length - 1);
          } else {
            if (pwdText.length < 6) {
              pwdText += item;
              autoSubmit();
            }
          }
        })
      }),
    );
  }

  GlobalKey<PartRefreshWidgetState> refreshBtn = GlobalKey();

  Widget buildSubmit() {
    return PartRefreshWidget(refreshBtn, () => BigTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_bank_next_step), enable: isClickEnable, onTap: () {
      setState(() {
        checkCode();
      });
    }));
  }

  Future<void> autoSubmit() async {
    if (pwdText.length == 6) {
      if (current == 1) {
        savePwd = pwdText;
      }
      await Future.delayed(const Duration(milliseconds: 300),() {
        if (current == 2 && savePwd != pwdText) { //判断两次密码相同
          ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_order_password_error));
          current = 1;
          setState(() {
            setStepper();
          });
          return;
        }
        current++;
        setState(() {
          setStepper();
        });
      });
    }
  }

  void setStepper() {
    if (current == 0) {
      stepper1.isFinish = false;
      stepper1.isSelect = true;
      stepper2.isFinish = false;
      stepper2.isSelect = false;
      stepper3.isFinish = false;
      stepper3.isSelect = false;
      pwdText = '';
    } else if(current == 1) {
      stepper1.isFinish = true;
      stepper1.isSelect = true;
      stepper2.isFinish = false;
      stepper2.isSelect = true;
      stepper3.isFinish = false;
      stepper3.isSelect = false;
      pwdText = '';
    } else if(current == 2) {
      stepper1.isFinish = true;
      stepper1.isSelect = true;
      stepper2.isFinish = true;
      stepper2.isSelect = true;
      stepper3.isFinish = false;
      stepper3.isSelect = true;
      pwdText = '';
    } else {
      stepper1.isFinish = true;
      stepper1.isSelect = true;
      stepper2.isFinish = true;
      stepper2.isSelect = true;
      stepper3.isFinish = true;
      stepper3.isSelect = true;
      setPayPassword();
    }
  }

  void checkCode() async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.CHECK_CODE_URL, {
      "authCode": verifyCode,
      "phoneCode": phoneCode,
      "telephone": mobile,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      current++;
      setState(() {
        setStepper();
      });
    } else if(rsp.retCode == 504) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Login_sms_code_error));
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  Future<void> setPayPassword() async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.SET_PAY_PASSWORD_URL, {
      "newPassword": pwdText,
      "password": pwdText,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      widget.callBack(context);
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

}
 