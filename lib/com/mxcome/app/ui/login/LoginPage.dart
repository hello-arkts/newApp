import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/IURLConstant.dart';
import 'package:mxcome/com/mxcome/app/Logger.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/model/BaseRsp.dart';
import 'package:mxcome/com/mxcome/app/model/LoggedInfo.dart';
import 'package:mxcome/com/mxcome/app/ui/WebPage.dart';
import 'package:mxcome/com/mxcome/app/ui/login/ForgotPasswordPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/LoginSuccessEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/CountryCodeModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/BigTextButton.dart';
import 'package:mxcome/com/mxcome/app/utils/AppUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/DbUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/NumUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import 'package:mxcome/com/mxcome/app/widget/PartRefreshWidget.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../utils/Adapt.dart';
import '../LanguagePage.dart';
import '../shop/event/CountryCodeEvent.dart';
import '../shop/widget/GenAvatar.dart';
import 'BindPhonePage.dart';
import 'CountryCodePage.dart';

class LoginPage extends StatefulWidget {
  Function(BuildContext context) callBack;

  LoginPage(this.callBack);

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends BaseKeepAliveState<LoginPage> {
  String mobile = '';
  String password = '';

  CountryCodeModel currentCodeModel = CountryCodeModel.fromLanguage(LanguagePage.language);

  bool isClickEnable = false;
  bool isReSend = false;

  dynamic userInfo = {};
  dynamic countryCodeEvent;

  final _auth = FirebaseAuth.instance;

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();

  bool passwordVisible = true;

  bool isBeta = false;

  bool isShowRegister = true;

  @override
  void initState() {
    super.initState();
    loadContentDatas();
    countryCodeEvent = EventBusUtil.getInstance().on<CountryCodeEvent>((event) {
      setState(() {
        currentCodeModel = event.model;
      });
    });
    _nodeText2.addListener(() async {
      if (_nodeText2.hasFocus) {
        //获取焦点
        LoggedInfo? loggedInfo = await DbUtils.getLoggedInfoByPhone(mobile);
        if (loggedInfo != null) {
          setState(() {
            userInfo = {
              "icon": loggedInfo.icon,
              "nickname": loggedInfo.nickname,
              "username": loggedInfo.username,
              "phoneCode": loggedInfo.phoneCode,
              "phone": loggedInfo.phone,
            };
          });
        }
      }
    });
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(countryCodeEvent);
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    dynamic data = await AppUtils.getUserInfo();
    BaseRsp res = await HttpUtils.post(IURLConstant.MALL_GET_SYSTEM_SETTINGS, {});
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_IS_BETA, {});
    setState(() {
      userInfo = data;
      int isPublish = BaseModel.getInt(res.data, "isPublish");
      isShowRegister = (isPublish == 1);
      isBeta = ("${rsp.data}" == "true");
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return KeyboardDismissOnTap(
        child: SingleChildScrollView(
          child: Column(
            children: [
              isShowRegister ? Container(
                alignment: Alignment.topRight,
                height: 60.w,
                child: InkWell(
                  onTap: () async {
                    finish();
                    toRegister((ctx) => {});
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 14.w, right: 14.w),
                    padding: EdgeInsets.fromLTRB(10.w, 4.w, 10.w, 4.w),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: IConstant.line_color, width: 1.w),
                        borderRadius: BorderRadius.circular(18.w)),
                    child: Text(
                        LanguageConfig.get(
                            LanguageConfigKeys.Login_register_new),
                        style: TextStyle(
                            fontSize: 12.sp, color: IConstant.text_color)),
                  ),
                ),
              ): Container(),
              SizedBox(height: 20.w,),
              Image.asset(
                'assets/icons/login_icon.png',
                height: 26.w,
              ),
              SizedBox(height: 16.w),
              Text(LanguageConfig.get(LanguageConfigKeys.Login_welcome_login),
                  style:
                      TextStyle(fontSize: 15.sp, color: IConstant.text_color)),
              SizedBox(height: 20.w),
              buildIconUser(),
              buildPhone(),
              buildPwd(),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(top: 8.w, right: 16.w),
                child: InkWell(
                  onTap: () {
                    showForgotPassword();
                  },
                  child: Text(
                    LanguageConfig.get(LanguageConfigKeys.Login_forgot_password),
                    textAlign: TextAlign.right,
                    style: TextStyle(color: IConstant.blue_color, fontSize: 13.sp),
                  ),
                ),
              ),
              SizedBox(
                height: 40.w,
              ),
              Container(
                  margin: EdgeInsets.only(left: 16.w, right: 16.w),
                  width: double.infinity,
                  child: buildLogin()),
              isShowRegister? Column(
                children: [
                  SizedBox(
                    height: 10.w,
                  ),
                  // Text(
                  //   LanguageConfig.get(LanguageConfigKeys.Login_other_login_type),
                  //   style:
                  //       TextStyle(color: IConstant.sub_text_color, fontSize: 12.sp),
                  // ),
                  // SizedBox(
                  //   height: 20.w,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     GestureDetector(
                  //       behavior: HitTestBehavior.translucent,
                  //       onTap: () async {
                  //         gotoThirdLogin(1);
                  //       },
                  //       child: Image.asset(
                  //         'assets/icons/login_facebook_icon.png',
                  //         width: 35.w,
                  //         height: 35.w,
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: 40.w,
                  //     ),
                  //     GestureDetector(
                  //       behavior: HitTestBehavior.translucent,
                  //       onTap: () async {
                  //         gotoThirdLogin(2);
                  //       },
                  //       child: Image.asset(
                  //         'assets/icons/login_google_icon.png',
                  //         width: 28.w,
                  //         height: 28.w,
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: Platform.isIOS ? 40.w : 0,
                  //     ),
                  //     Platform.isIOS
                  //         ? GestureDetector(
                  //       behavior: HitTestBehavior.translucent,
                  //       onTap: () async {
                  //         gotoThirdLogin(3);
                  //       },
                  //       child: Image.asset(
                  //         'assets/icons/login_apple_icon.png',
                  //         width: 32.w,
                  //         height: 32.w,
                  //       ),
                  //     )
                  //         : const SizedBox()
                  //   ],
                  // ),
                ],
              ) : Container(),
              SizedBox(height: 100.w,),
              Container(
                margin: EdgeInsets.all(10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      LanguageConfig.get(
                          LanguageConfigKeys.Login_login_accept_tip),
                      style: TextStyle(
                          color: IConstant.grey_color, fontSize: 12.sp),
                    ),
                    GestureDetector(
                      child: Text(
                        LanguageConfig.get(LanguageConfigKeys.Login_service),
                        style: TextStyle(
                            color: IConstant.title_color, fontSize: 12.sp),
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
      margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 40.w),
      padding: EdgeInsets.only(left: 16.w, right: 16.w),
      decoration: BoxDecoration(
          border: Border.all(color: IConstant.line_color, width: 1.w),
          borderRadius: BorderRadius.circular(18.w)),
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
                Text(currentCodeModel.code,
                    style: TextStyle(
                        color: IConstant.title_color, fontSize: 14.sp)),
                Icon(Icons.arrow_drop_down,
                    color: IConstant.title_color, size: 18.w),
                SizedBox(width: 10.w),
              ],
            ),
          ),
          Expanded(
              child: TextField(
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
                labelStyle:
                    TextStyle(color: IConstant.title_color, fontSize: 14.sp),
                hintText:
                    LanguageConfig.get(LanguageConfigKeys.Login_mobile_tip),
                hintStyle:
                    TextStyle(color: IConstant.sub_text_color, fontSize: 14.sp),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: IConstant.line_color, width: 1.w),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: IConstant.line_color, width: 1.w),
                )),
            controller:
                ViewUtils.buildTextEditingController(mobile, listener: (str) {
              mobile = str;
              checkInput();
            }),
          )),
          InkWell(
            onTap: () {
              showCountryCode();
            },
            child: Image.asset(
              currentCodeModel.icon,
              width: 18.w,
              height: 18.w,
            ),
          )
        ],
      ),
    );
  }

  Widget buildPwd() {
    return Container(
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
          border: Border.all(color: IConstant.line_color, width: 1.w),
          borderRadius: BorderRadius.circular(16.w)),
      margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 13.w),
      padding: EdgeInsets.only(left: 16.w, right: 16.w),
      child: Row(
        children: [
          Expanded(child: TextField(
            textInputAction: TextInputAction.done,
            maxLines: 1,
            keyboardType: TextInputType.text,
            obscureText: passwordVisible,
            focusNode: _nodeText2,
            style: TextStyle(color: IConstant.title_color, fontSize: 14.sp),
            decoration: InputDecoration(
              icon: Image.asset(
                'assets/icons/password.png',
                width: 16.w,
                height: 16.w,
              ),
              hintText: LanguageConfig.get(
                  LanguageConfigKeys.Login_password_tip),
              hintStyle: TextStyle(
                  color: IConstant.sub_text_color, fontSize: 14.sp),
              border: InputBorder.none,
            ),
            controller: ViewUtils.buildTextEditingController(password,
                listener: (str) {
                  password = str;
                  checkInput();
                }),
            onSubmitted: (str) {
              login();
            },
          )),
          InkWell(
            onTap: () {
              setState(() {
                passwordVisible = !passwordVisible;
              });
            },
            child: Icon(
              passwordVisible
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: IConstant.text_color,
              size: 22.w,
            ),
          )
        ],
      ),
    );
  }

  String getDisplayName() {
    String nickname = BaseModel.getString(userInfo, "nickname");
    String phoneCode = BaseModel.getString(userInfo, "phoneCode");
    String phone = BaseModel.getString(userInfo, "phone");
    return TextUtils.isNotEmpty(nickname) ? nickname: "$phoneCode $phone";
  }

  Widget buildIconUser() {
    if (userInfo != null) {
      String avatar = BaseModel.getString(userInfo, "icon");
      String displayName = getDisplayName();
      if (TextUtils.isNotEmpty(avatar)) {
        return InkWell(
          onTap: () {
            setState(() {
              mobile = BaseModel.getString(userInfo, "phone");
              currentCodeModel = CountryCodeModel.fromCode(
                  BaseModel.getString(userInfo, "phoneCode"));
            });
          },
          child: Column(
            children: [
              ClipOval(
                  child: SizedBox(
                      width: 60.w,
                      height: 60.w,
                      child: GenAvatar(avatar))),
              SizedBox(height: 4.w),
              Text(displayName,
                  style:
                      TextStyle(fontSize: 14.sp, color: IConstant.grey_color)),
            ],
          ),
        );
      } else if (TextUtils.isNotEmpty(displayName) && displayName != " ") {
        return InkWell(
          onTap: () {
            setState(() {
              mobile = BaseModel.getString(userInfo, "phone");
              currentCodeModel = CountryCodeModel.fromCode(
                  BaseModel.getString(userInfo, "phoneCode"));
            });
          },
          child: Column(
            children: [
              ClipOval(
                  child: Container(
                      width: 60.w,
                      height: 60.w,
                      color: IConstant.red_translucent_color,
                      child: Center(
                          child: Text(
                              TextUtils.isNotEmpty(displayName)
                                  ? displayName.substring(0, 1)
                                  : "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 30.sp,
                                  color: IConstant.white_color))))),
              SizedBox(height: 4.w),
              Text(displayName,
                  style:
                      TextStyle(fontSize: 14.sp, color: IConstant.grey_color)),
            ],
          ),
        );
      } else {
        return InkWell(
          onTap: () {
            setState(() {
              mobile = BaseModel.getString(userInfo, "phone");
              currentCodeModel = CountryCodeModel.fromCode(
                  BaseModel.getString(userInfo, "phoneCode"));
            });
          },
          child: Column(
            children: [
              Image.asset(
                'assets/icons/default_user.png',
                width: 60.w,
                height: 60.w,
              ),
              SizedBox(height: 4.w),
              Text(BaseModel.getString(userInfo, "phone"),
                  style:
                      TextStyle(fontSize: 14.sp, color: IConstant.grey_color)),
            ],
          ),
        );
      }
    } else {
      return Column(
        children: [
          Image.asset(
            'assets/icons/default_user.png',
            width: 60.w,
            height: 60.w,
          ),
          SizedBox(height: 4.w),
          Text("",
              style: TextStyle(fontSize: 14.sp, color: IConstant.grey_color)),
        ],
      );
    }
  }

  GlobalKey<PartRefreshWidgetState> refreshBtn = GlobalKey();

  Widget buildLogin() {
    return PartRefreshWidget(
        refreshBtn,
        () => BigTextButton(
            text: LanguageConfig.get(LanguageConfigKeys.Login_login),
            enable: isClickEnable,
            onTap: () {
              login();
            }));
  }

  void showProtocol() {
    nextPage(WebPage(FormatUtil.getProtocol()), false);
  }

  void checkInput() {
    if (TextUtils.isNotEmpty(mobile) && TextUtils.isNotEmpty(password)) {
      if (isClickEnable) return;
      isClickEnable = true;
      refreshBtn.currentState?.update();
    } else {
      if (!isClickEnable) return;
      isClickEnable = false;
      refreshBtn.currentState?.update();
    }
  }

  void showForgotPassword() {
    showPop(0.7 * Adapt.getWindowHeight(), ForgotPasswordPage(mobile, currentCodeModel));
  }

  void showCountryCode() {
    showPop(0.6 * Adapt.getWindowHeight(), CountryCodePage());
  }

  loginEnd(token) {
    EventBusUtil.getInstance().emit(LoginSuccessEvent(token));
    widget.callBack(context);
  }

  login() async {
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
    BaseRsp rsp = await HttpUtils.post(IURLConstant.LOGIN_URL, {
      "telephone": mobile,
      "password": password,
      "phoneCode": currentCodeModel.code,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      String token = BaseModel.getString(rsp.data, "token");
      loginEnd(token);
    } else if (rsp.retCode == RspRetCode.INTERNAL_ERROR) {
      ViewUtils.displayToast(rsp.msg);
    } else if (rsp.retCode == 503) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Login_user_or_password_error));
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  Future<void> gotoThirdLogin(int thirdPartyType) async {
    User? user;
    if (thirdPartyType == 1) {
      //facebook
      user = await signInWithFacebook(context);
    } else if (thirdPartyType == 2) {
      //google
      user = await signInWithGoogle(context);
    } else if (thirdPartyType == 3) {
      //apple
      user = await signInWithApple(context);
    }
    if (user != null) {
      ViewUtils.show();
      BaseRsp rsp = await HttpUtils.post(IURLConstant.THREE_CHECK_PHONE, {
        "id": user.uid,
      });
      ViewUtils.dismiss();
      if (rsp.retCode == RspRetCode.SUCCESS) {
        Map<String, dynamic> data = rsp.data;
        String token = BaseModel.getString(data, "token");
        if (TextUtils.isNotEmpty(token)) {
          loginEnd(token);
        } else {
          bindPhone(user, thirdPartyType);
        }
      } else {
        ViewUtils.displayToast(rsp.msg);
      }
    }
  }

  void bindPhone(User user, int thirdPartyType) {
    showPop(
        0.7 * Adapt.getWindowHeight(),
        BindPhonePage(user.uid, "${user.email}", "${user.displayName}",
            "${user.photoURL}", thirdPartyType));
  }

  Future<User?> signInWithGoogle(BuildContext ctx) async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential =
            await _auth.signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return userCredential.user;
      } else {
        setState(() {
          finishContext(ctx);
        });
        throw FirebaseAuthException(
          code: 'ERROR_MESSAGE_ID_TOKEN',
          message: 'Missing Google ID Token',
        );
      }
    } else {
      setState(() {
        finishContext(ctx);
      });
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  Future<User?> signInWithFacebook(BuildContext ctx) async {
    // final fb = FacebookAuth.instance;
    // final response = await fb.login();
    // switch (response.status) {
    //   case LoginStatus.success:
    //     final accessToken = response.accessToken;
    //     final userCredential = await _auth.signInWithCredential(
    //       FacebookAuthProvider.credential(accessToken!.token),
    //     );
    //     return userCredential.user;
    //   case LoginStatus.cancelled:
    //     setState(() {
    //       finishContext(ctx);
    //     });
    //     throw FirebaseAuthException(
    //       code: 'ERROR_ABORTED_BY_USER',
    //       message: 'Sign in aborted by user',
    //     );
    //   case LoginStatus.failed:
    //     setState(() {
    //       finishContext(ctx);
    //     });
    //     throw FirebaseAuthException(
    //       code: 'ERROR_FACEBOOK_LOGIN_FAILED',
    //       message: response.message,
    //     );
    //   default:
    //     setState(() {
    //       finishContext(ctx);
    //     });
    //     throw UnimplementedError();
    // }
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<User?> signInWithApple(BuildContext ctx) async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );
      final userCredential = await _auth.signInWithCredential(oauthCredential);
      return userCredential.user;
    } catch (e) {
      Logger.info(e);
      setState(() {
        finishContext(ctx);
      });
      throw UnimplementedError();
    }
  }
}
