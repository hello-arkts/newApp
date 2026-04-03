import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/setting/SettingPayPwdPage.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IURLConstant.dart';
import '../../../../config/LanguageConfig.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/Adapt.dart';
import '../../../../utils/AppUtils.dart';
import '../../../../utils/HttpUtils.dart';
import '../../event/UserInfoEvent.dart';
import '../../model/BindModel.dart';
import '../../utils/EventBusUtil.dart';
import '../member/ChangeMobilePage.dart';
import '../wallet/VerifyMobilePage.dart';
import 'DeleteAccountPage.dart';
import 'UpdatePasswordPage.dart';

class AccountSafePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return AccountSafePageState();
  }

}

class AccountSafePageState extends BaseKeepAliveState<AccountSafePage> {

  List<BindModel> bindList = [];

  dynamic userInfo = {};

  String phone = "";

  final _auth = FirebaseAuth.instance;

  dynamic userInfoEvent;

  @override
  void initState() {
    super.initState();
    setState(() {
      bindList = [
        BindModel("", "", 1),
        BindModel("", "", 2),
        BindModel("", "", 3),
      ];
    });
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
      phone = BaseModel.getString(userInfo, "phone");
    });
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_THIRD_BIND_LIST, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<BindModel> tempList = [
        BindModel("", "", 1),
        BindModel("", "", 2),
        BindModel("", "", 3),
      ];
      for (dynamic item in rsp.data) {
        int thirdPartyType = BaseModel.getInt(item, "thirdPartyType");
        if (thirdPartyType == 1) {
          tempList[0] = BindModel.fromJson(item);
        } else if (thirdPartyType == 2) {
          tempList[1] = BindModel.fromJson(item);
        } else if (thirdPartyType == 3) {
          tempList[2] = BindModel.fromJson(item);
        }
      }
      setState(() {
        bindList = tempList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.5.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_setting_account_safe),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: ListView(
        children: [
          SizedBox(height: 10.w),
          buildPhone(),
          buildPassword(),
          buildPayPassword(),
          buildDeleteAccount(),
          Divider(height: 1.w),
          SizedBox(height: 16.w),
          // buildBindTitle(),
          // buildBindItem(bindList[0]),
          // buildBindItem(bindList[1]),
          // Platform.isIOS
          //     ? buildBindItem(bindList[2]) : Container(),
        ],
      ),
    );
  }

  Widget buildPhone() {
    return ListTile(
      onTap: () {
        updateMobile();
      },
      title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_setting_phone),  style: TextStyle(fontSize: 16.sp, color: IConstant.text_color)),
      subtitle: Text(LanguageConfig.get(LanguageConfigKeys.Shop_setting_phone_detail), style: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color)),
      trailing: Icon(Icons.chevron_right, size: 20.w),
    );
  }

  Widget buildPassword() {
    return ListTile(
      onTap: () {
        nextPage(UpdatePasswordPage(BaseModel.getString(userInfo, "phoneCode"), BaseModel.getString(userInfo, "phone")), false);
      },
      title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_setting_update_pwd),  style: TextStyle(fontSize: 16.sp, color: IConstant.text_color)),
      subtitle: Text(LanguageConfig.get(LanguageConfigKeys.Shop_setting_update_pwd_detail), style: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color)),
      trailing: Icon(Icons.chevron_right, size: 20.w),
    );
  }

  Widget buildPayPassword() {
    return ListTile(
      onTap: () {
        nextPage(SettingPayPwdPage((ctx) {
          ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_set_successful));
          EventBusUtil.getInstance().emit(UserInfoEvent());
          finishContext(ctx);
        }), false);
      },
      title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_setting_pay_pwd),  style: TextStyle(fontSize: 16.sp, color: IConstant.text_color)),
      subtitle: Text(LanguageConfig.get(LanguageConfigKeys.Shop_setting_pay_pwd_detail), style: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color)),
      trailing: Icon(Icons.chevron_right, size: 20.w),
    );
  }


  Widget buildDeleteAccount() {
    return InkWell(onTap: () {
      nextPage(DeleteAccountPage(), false);
    }, child: ListTile(
      title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_setting_account_cancellation), style: TextStyle(fontSize: 16.sp, color: IConstant.text_color)),
      subtitle: Text(LanguageConfig.get(LanguageConfigKeys.Shop_setting_account_cancellation_detail), style: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color)),
      trailing: Icon(Icons.chevron_right, size: 20.w),
    ));
  }

  Widget buildBindTitle() {
    return Container(
      margin: EdgeInsets.fromLTRB(14.w, 8.w, 10.w, 8.w),
      child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_setting_third_auth), style: TextStyle(fontSize: 13.sp, color: IConstant.title_color)),
    );
  }

  Widget buildBindItem(BindModel item) {
    return Container(
      padding: EdgeInsets.fromLTRB(10.w, 6.w, 10.w, 6.w),
      child: InkWell(
        child: Row(
          children: [
            Image.asset(getThirdIcon(item),
              width: 32.w,
              height: 32.w,
            ),
            SizedBox(width: 6.w),
            Text(getThirdName(item), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
            expandeSpace,
            Container(constraints: BoxConstraints(maxWidth: 180.w),
              child: Text(item.email, maxLines: 2,
                  style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),),
            SizedBox(width: 6.w),
            Switch(
                value: item.isBind(),
                activeColor: IConstant.main_color,
                onChanged: (value){
                  gotoBindOrUnbind(item);
                }
            )
          ],
        ),
      ),
    );
  }

  void gotoBindOrUnbind(BindModel item) async {
    if (item.isBind()) {
      unBind(item);
    } else {
      bind(item);
    }
  }

  String getThirdIcon(BindModel item) {
    if (item.thirdPartyType == 1) {
      return "assets/icons/login_facebook_icon.png";
    } else if(item.thirdPartyType == 2) {
      return "assets/icons/login_google_icon.png";
    } else {
      return "assets/icons/login_apple_icon.png";
    }
  }

  String getThirdName(BindModel item) {
    if (item.thirdPartyType == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_setting_facebook);
    } else if(item.thirdPartyType == 2) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_setting_google);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_setting_apple);
    }
  }

  void updateMobile() {
    showPop(0.7 * Adapt.getWindowHeight(), VerifyMobilePage((ctx, code){
      finishContext(ctx);
      showPop(0.7 * Adapt.getWindowHeight(), ChangeMobilePage((ctx) => {
        setState(() {
          finishContext(ctx);
          loadContentDatas();
        })
      }));
    }));
  }

  Future<User?> signInWithGoogle(BuildContext ctx) async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _auth
            .signInWithCredential(GoogleAuthProvider.credential(
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
      setState(() {
        finishContext(ctx);
      });
      throw UnimplementedError();
    }
  }

  void bind(BindModel model) async {
    User? user;
    if (model.thirdPartyType == 1) { //facebook
      user = await signInWithFacebook(context);
    } else if (model.thirdPartyType == 2) { //google
      user = await signInWithGoogle(context);
    } else if (model.thirdPartyType == 3) { //apple
      user = await signInWithApple(context);
    }
    if (user != null) {
      ViewUtils.show();
      BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_BIND_THIRD, {
        "thirdId": user.uid,
        "thirdPartyType": "${model.thirdPartyType}",
        "email": user.email,
        "nickName": user.displayName,
        "headUrl": user.photoURL
      });
      ViewUtils.dismiss();
      if (rsp.retCode == RspRetCode.SUCCESS) {
        loadContentDatas();
      } else {
        ViewUtils.displayToast(rsp.msg);
      }
    }

  }

  void unBind(BindModel model) async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_UNBINDT_THIRD, {
      "thirdId": model.id,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      loadContentDatas();
    }
    ViewUtils.dismiss();
  }

}
