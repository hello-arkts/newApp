import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../IURLConstant.dart';
import '../../model/BaseModel.dart';
import '../../model/BaseRsp.dart';
import '../../utils/AppUtils.dart';
import '../../utils/HttpUtils.dart';
import '../../utils/TextUtils.dart';
import '../../utils/ViewUtils.dart';
import '../../widget/PartRefreshWidget.dart';
import '../shop/event/ActivityEvent.dart';
import '../shop/event/CartEvent.dart';
import '../shop/event/OrderEvent.dart';
import '../shop/event/PocketEvent.dart';
import '../shop/event/UserInfoEvent.dart';
import '../shop/utils/EventBusUtil.dart';
import '../shop/widget/BigTextButton.dart';

class SetPasswordPage extends StatefulWidget {

  String phoneCode = "";
  String mobile = "";
  bool fromRegister = false;
  String authCode = "";

  SetPasswordPage(this.phoneCode, this.mobile, this.fromRegister, {this.authCode = ""});

  @override
  State<StatefulWidget> createState() => SetPasswordPageState();
}

class SetPasswordPageState extends BaseKeepAliveState<SetPasswordPage> {

  String password = '';
  String rePassword = '';
  bool isClickEnable = false;
  bool passwordVisible = true;
  bool rePasswordVisible = true;
  bool formatError = false;

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return KeyboardDismissOnTap(
      child: Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
          elevation: 0.w,
          centerTitle: true,
          title: Text(widget.fromRegister ? LanguageConfig.get(LanguageConfigKeys.Login_register_success) : LanguageConfig.get(LanguageConfigKeys.Login_reset_password),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)
          )),
      body: ListView(
          children: [
            Container(
              decoration: BoxDecoration(border: Border.all(color: IConstant.line_color, width: 1.w), borderRadius: BorderRadius.circular(16.w)),
              margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 20.w),
              padding: EdgeInsets.only(left: 16.w, right: 16.w),
              child: TextField(
                  textInputAction: TextInputAction.next,
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  obscureText: passwordVisible,
                  focusNode: _nodeText1,
                  style: TextStyle(color: IConstant.title_color, fontSize: 14.sp),
                  decoration: InputDecoration(
                      icon: Image.asset(
                        'assets/icons/password.png',
                        width: 16.w,
                        height: 16.w,
                      ),
                      hintText: LanguageConfig.get(LanguageConfigKeys.Login_password_first_tip),
                      hintStyle: TextStyle(color: IConstant.sub_text_color, fontSize: 14.sp),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: IConstant.line_color, width: 1.w),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: IConstant.line_color, width: 1.w),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: IConstant.text_color,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      )
                  ),
                  controller: ViewUtils.buildTextEditingController(password, listener: (str) {
                    password = str;
                    checkInput();
                  })
              ),
            ),
            Container(
              decoration: BoxDecoration(border: Border.all(color: IConstant.line_color, width: 1.w), borderRadius: BorderRadius.circular(16.w)),
              margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 13.w),
              padding: EdgeInsets.only(left: 16.w, right: 16.w),
              child: TextField(
                textInputAction: TextInputAction.done,
                maxLines: 1,
                keyboardType: TextInputType.text,
                focusNode: _nodeText2,
                obscureText: rePasswordVisible,
                style: TextStyle(color: IConstant.title_color, fontSize: 14.sp),
                decoration: InputDecoration(
                    icon: Image.asset(
                      'assets/icons/password.png',
                      width: 16.w,
                      height: 16.w,
                    ),
                    hintText: LanguageConfig.get(LanguageConfigKeys.Login_password_again_tip),
                    hintStyle: TextStyle(color: IConstant.sub_text_color, fontSize: 14.sp),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: IConstant.line_color, width: 1.w),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: IConstant.line_color, width: 1.w),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        rePasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: IConstant.text_color,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          rePasswordVisible = !rePasswordVisible;
                        });
                      },
                    )
                ),
                controller: ViewUtils.buildTextEditingController(rePassword, listener: (str) {
                  rePassword = str;
                  checkInput();
                }),
                onSubmitted: (str) {
                  setPassword();
                },
              ),
            ),
            Container(
              height: 60.w,
              margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 20.w),
              child: Row(
                children: [
                  Container(width: 3.w, color: IConstant.red_bg_color),
                  SizedBox(width: 12.w),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Login_set_password_tip1), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.sp, color: formatError ? IConstant.main_color : IConstant.sub_text_color)),),
                      Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Login_set_password_tip2), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color))),
                    ],
                  ))
                ],
              ),
            )
          ],
      ),
      bottomNavigationBar: buildBottomBar(),
    ));
  }

  void checkInput() {
    if (TextUtils.isNotEmpty(password) && TextUtils.isNotEmpty(rePassword)) {
      if (isClickEnable) return;
      isClickEnable = true;
      refreshBtn.currentState?.update();
    } else {
      if (!isClickEnable) return;
      isClickEnable = false;
      refreshBtn.currentState?.update();
    }
  }

  bool check() {
    return RegExp(r'^[A-Z]+$').hasMatch(password[0]);
  }

  Future<void> setPassword() async {
    if (!check() || (password.length < 8 || password.length >32) || !RegExp(r'\d').hasMatch(password)) { //首字母大写或者长度最少8位,最多32位
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Login_password_format_error));
      setState(() {
        formatError = true;
      });
      return;
    }
    if (password != rePassword) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Login_password_or_confirm_password_error));
      setState(() {
        formatError = false;
      });
      return;
    }
    if (widget.fromRegister) { //设置密码
      ViewUtils.show();
      BaseRsp rsp = await HttpUtils.post(IURLConstant.SET_PASSWORD_URL, {
        "telephone": widget.mobile,
        "password": password,
        'newPassword': rePassword,
        "phoneCode": widget.phoneCode,
      });
      ViewUtils.dismiss();
      if (rsp.retCode == RspRetCode.SUCCESS) {
        ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Login_password_set_success));
        autoLogin();
      } else {
        ViewUtils.displayToast(rsp.msg);
      }

    } else { //修改密码
      ViewUtils.show();
      BaseRsp rsp = await HttpUtils.post(IURLConstant.UPDATE_PASSWORD_URL, {
        "authCode": widget.authCode,
        "phoneCode": widget.phoneCode,
        "telephone": widget.mobile,
        "password": password,
      });
      ViewUtils.dismiss();
      if (rsp.retCode == RspRetCode.SUCCESS) {
        ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Login_password_modify_success));
        autoLogin();
      } else {
        ViewUtils.displayToast(rsp.msg);
      }
    }
  }

  Future<void> autoLogin() async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.LOGIN_URL, {
      "telephone": widget.mobile,
      "password": password,
      "phoneCode": widget.phoneCode,
    });
    ViewUtils.dismiss();
    if (rsp.retCode == RspRetCode.SUCCESS) {
      Map<String, dynamic> data = rsp.data;
      String token = BaseModel.getString(data, "token");
      loginEnd(token);
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  loginEnd(String token) async {
    await AppUtils.setToken(token);
    EventBusUtil.getInstance().emit(UserInfoEvent());
    EventBusUtil.getInstance().emit(PocketEvent());
    EventBusUtil.getInstance().emit(CartEvent());
    EventBusUtil.getInstance().emit(ActivityEvent());
    EventBusUtil.getInstance().emit(OrderEvent());
    nextMainPage();
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      elevation: 0.w,
      child: Container(
        margin: EdgeInsets.all(20.w),
        child: buildConfirm(),
      )
    );
  }

  GlobalKey<PartRefreshWidgetState> refreshBtn = GlobalKey();

  Widget buildConfirm() {
    return PartRefreshWidget(refreshBtn, () => BigTextButton(text: LanguageConfig.get(LanguageConfigKeys.ViewUtils_confirm), enable: isClickEnable, onTap: () {
      setPassword();
    }));
  }

}
