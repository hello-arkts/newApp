
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/UserInfoEvent.dart';
import 'package:mxcome/com/mxcome/app/utils/NumUtils.dart';

import '../../IURLConstant.dart';
import '../../model/BaseRsp.dart';
import '../../utils/HttpUtils.dart';
import '../../utils/TextUtils.dart';
import '../../utils/ViewUtils.dart';
import '../../widget/PartRefreshWidget.dart';
import '../WebPage.dart';
import '../shop/utils/EventBusUtil.dart';
import '../shop/utils/FormatUtil.dart';
import 'WalletManagerPage.dart';

class WalletCreatePage extends StatefulWidget {

  WalletCreatePage();

  @override
  State<StatefulWidget> createState() => WalletCreatePageState();

}

class WalletCreatePageState extends BaseKeepAliveState<WalletCreatePage> {

  String email = '';
  String verifyCode = '';

  GlobalKey<PartRefreshWidgetState> refreshBtn = GlobalKey();
  bool isClickEnable = false;

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();

  bool agree = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return KeyboardDismissOnTap(
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                IConstant.web3_create_bg_color,
                Color(0xffffffff),
                Color(0xffffffff),
                Color(0xffffffff),
                Color(0xffffffff),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ListView(
            children: [
              Padding(padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 30.w),
                child: Text("WELCOME TO", style: TextStyle(color: IConstant.sub_text_color, fontSize: 12.sp),),),
              Padding(padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 6.w),
                child: Text("MXCOME—WEB3 WALLET", style: TextStyle(color: IConstant.text_color,
                    fontFamily: 'SpaceGrotesk', fontSize: 15.sp, fontWeight: FontWeight.bold),),),
              Container(
                decoration: BoxDecoration(border: Border.all(color: IConstant.line_color2, width: 1.w),
                    borderRadius: BorderRadius.circular(10.w)),
                margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 20.w),
                padding: EdgeInsets.only(left: 12.w, right: 12.w),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        textInputAction: TextInputAction.next,
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        focusNode: _nodeText1,
                        style: TextStyle(color: IConstant.title_color, fontSize: 14.sp),
                        decoration: InputDecoration(
                            icon: Image.asset(
                              'assets/icons/web3_email.png',
                              width: 20.w,
                              height: 20.w,
                            ),
                            hintText: LanguageConfig.get(LanguageConfigKeys.Shop_web3_enter_your_email),
                            hintStyle: TextStyle(color: IConstant.sub_text_color, fontSize: 14.sp),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: IConstant.line_color, width: 1.w),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: IConstant.line_color, width: 1.w),
                            )),
                        controller: ViewUtils.buildTextEditingController(email, listener: (str) {
                          email = str;
                          checkInput();
                        }),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        sendCode();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.w),
                        decoration: BoxDecoration(
                            color: IConstant.black_color,
                            borderRadius: BorderRadius.all(Radius.circular(20.w))
                        ),
                        child: Text("Send Code", style: TextStyle(color: Colors.white, fontSize: 14.sp),),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(border: Border.all(color: IConstant.line_color2, width: 1.w),
                    borderRadius: BorderRadius.circular(10.w)),
                margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 12.w),
                padding: EdgeInsets.only(left: 12.w, right: 12.w),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  focusNode: _nodeText2,
                  style: TextStyle(color: IConstant.title_color, fontSize: 14.sp),
                  decoration: InputDecoration(
                      icon: Image.asset(
                        'assets/icons/web3_code.png',
                        width: 20.w,
                        height: 20.w,
                      ),
                      hintText: LanguageConfig.get(LanguageConfigKeys.Shop_web3_enter_email_code),
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
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(value: agree, fillColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return IConstant.main_color;  //选中时的背景颜色
                      }
                      return IConstant.white_color;  //未选中时的背景颜色
                    }), checkColor: IConstant.white_color, onChanged: (check) => {
                      setState(() {
                        agree = check!;
                        checkInput();
                      })
                    }),
                    Text(
                      LanguageConfig.get(LanguageConfigKeys.Shop_web3_agree_accept),
                      style: TextStyle(color: IConstant.black_color, fontSize: 12.sp),
                    ),
                    GestureDetector(
                      child: Text(
                        LanguageConfig.get(LanguageConfigKeys.Shop_web3_mxcome_protocol),
                        style: TextStyle(color: IConstant.web3_create_blue_color, fontSize: 12.sp),
                      ),
                      onTap: () async {
                        showProtocol();
                      },
                    )
                  ],
                ),
              ),
              PartRefreshWidget(
                  refreshBtn,
                      () => isClickEnable ? InkWell(
                        onTap: () {
                          walletRegister();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(40.w)),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xffFF3957),
                                Color(0xffFF3957),
                                Color(0xffFFCC16),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: IConstant.black_color,
                                blurRadius: 1,
                                offset: Offset(0, 6),
                                spreadRadius: 0,
                              ) ,
                            ],
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
                          width: 150.w,
                          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_web3_activate_now), textAlign: TextAlign.center,
                              style: TextStyle(color: IConstant.white_color, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                        ),
                      ) : Container(
                          decoration: BoxDecoration(
                            color: IConstant.grey_bg_color,
                            borderRadius: BorderRadius.all(Radius.circular(40.w)),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
                          width: 150.w,
                          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_web3_activate_now), textAlign: TextAlign.center,
                              style: TextStyle(color: IConstant.sub_text_color, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                        ),
                      ),
              SizedBox(
                height: 40.w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showProtocol() {
    nextPage(WebPage(FormatUtil.getProtocol()), false);
  }

  void checkInput() {
    if (TextUtils.isNotEmpty(email) && TextUtils.isNotEmpty(verifyCode) && agree) {
      if (isClickEnable) return;
      isClickEnable = true;
      refreshBtn.currentState?.update();
    } else {
      if (!isClickEnable) return;
      isClickEnable = false;
      refreshBtn.currentState?.update();
    }
  }

  Future<void> sendCode() async {
    if (!NumUtils.isEmail(email)) {
      ViewUtils.showToastLong(LanguageConfig.get(LanguageConfigKeys.shop_web3_format_incorrect));
      return;
    }
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_SEND_EMAIL, {
      "email": email,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      ViewUtils.showToastLong(LanguageConfig.get(LanguageConfigKeys.shop_web3_email_sent));
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  Future<void> walletRegister() async {
    changeFocus();
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_BINDING_EMAIL, {
      "email": email,
      "authCode": verifyCode,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      EventBusUtil.getInstance().emit(UserInfoEvent());
      finish();
      nextPage(WalletManagerPage(), false);
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

}
