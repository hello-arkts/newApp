import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/IURLConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/model/BaseRsp.dart';
import 'package:mxcome/com/mxcome/app/ui/WebPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/UserInfoEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/BigTextButton.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/LoadImageView.dart';
import 'package:mxcome/com/mxcome/app/utils/Adapt.dart';
import 'package:mxcome/com/mxcome/app/utils/AppUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import 'package:mxcome/com/mxcome/app/widget/PartRefreshWidget.dart';

import 'InviteSuccessPage.dart';

class MineLinkPage extends StatefulWidget {

  MineLinkPage();

  @override
  State<StatefulWidget> createState() => MineLinkPageState();
}

class MineLinkPageState extends BaseKeepAliveState<MineLinkPage> {

  String nickName = '';
  bool isClickEnable = false;

  final FocusNode _nodeText1 = FocusNode();

  dynamic _loginInfo;

  bool nameError = false;

  @override
  void initState() {
    super.initState();
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    dynamic loginInfo = await AppUtils.getUserInfo();
    setState(() {
      _loginInfo =loginInfo;
    });
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
          title: Text(LanguageConfig.get(LanguageConfigKeys.Login_create_mine_link),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)
          )),
      body: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20.w),
              height: 55.w,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(left: 20.w, right: 20.w),
                      padding: EdgeInsets.fromLTRB(60.w, 0, 10.w, 0),
                      decoration: BoxDecoration(border: Border.all(color: nameError ? IConstant.main_color : IConstant.line_color, width: 1.w),
                          borderRadius: BorderRadius.circular(40.w)),
                      child: TextField(
                          textInputAction: TextInputAction.next,
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          focusNode: _nodeText1,
                          style: TextStyle(color: nameError ? IConstant.main_color : IConstant.title_color, fontSize: 14.sp),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]|[0-9]'),),
                            LengthLimitingTextInputFormatter(50)//限制长度
                          ],
                          decoration: InputDecoration(
                            //labelText: '专属名称',
                            //labelStyle: TextStyle(color: nameError ? IConstant.main_color : IConstant.sub_text_color, fontSize: 12.sp),
                            hintText: LanguageConfig.get(LanguageConfigKeys.Login_input_kol_name),
                            hintStyle: TextStyle(color: IConstant.sub_text_color, fontSize: 12.sp),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: nameError ? Colors.transparent : IConstant.line_color, width: 1.w),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: nameError ? Colors.transparent : IConstant.line_color, width: 1.w),
                            ),
                          ),
                          controller: ViewUtils.buildTextEditingController(nickName, listener: (str) {
                            nickName = str;
                            checkInput();
                            if (nameError && TextUtils.isNotEmpty(nickName)) {
                              setState(() {
                                nameError = false;
                              });
                            }
                          })
                      ),
                    ),
                  ),
                  Positioned(left: 16.w,
                    child: _loginInfo != null ? ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(45.w)),
                      child: LoadImageView(55.w, 55.w, "${BaseModel.getString(_loginInfo, "icon")}"),
                    ) : Container(
                        width: 55.w,
                        height: 55.w,
                        decoration: BoxDecoration(
                            color: IConstant.white_bg_color,
                            borderRadius: BorderRadius.all(Radius.circular(50.w)))),
                  ),
                ],
              ),
            ),
            nameError ? Container(
              margin: EdgeInsets.only(left: 80.w, right: 16.w, top: 0.w),
              child: Text(LanguageConfig.get(LanguageConfigKeys.Login_nickname_exists), style: TextStyle(fontSize: 13.sp, color: IConstant.main_color),),) : Container(),
            Container(
              height: 60.w,
              margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 20.w),
              child: Row(
                children: [
                  Container(width: 3.w, color: IConstant.red_bg_color),
                  SizedBox(width: 12.w),
                  Expanded(child: RichText(
                    text: TextSpan(
                    children: [
                      TextSpan(text: LanguageConfig.get(LanguageConfigKeys.Login_kol_name_tip),
                          style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color)),
                      TextSpan(text: " mxcome.com/kol/", style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold, color: IConstant.title_color)),
                      TextSpan(text: "name", style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold, color: IConstant.main_color)),
                    ],
                  )))
                ],
              ),
            ),
            SizedBox(
              height: 100.w,
            ),
            Container(
              width: 300.w,
              height: 45.w,
              margin: EdgeInsets.only(left: 16.w, right: 16.w),
              child: buildConfirm(),
            ),
            SizedBox(
              height: 60.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  LanguageConfig.get(
                      LanguageConfigKeys.Login_login_accept_tip),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Color(0xff999999), fontSize: 11.sp),
                ),
                GestureDetector(
                  child: Text(
                    LanguageConfig.get(LanguageConfigKeys.Login_service),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: IConstant.text_color, fontWeight: FontWeight.bold, fontSize: 11.sp),
                  ),
                  onTap: () {
                    nextPage(WebPage(FormatUtil.getProtocol(),), false);
                  },
                ),
              ],
            ),
            SizedBox(
              height: 30.w,
            ),
          ],
      ),
    ));
  }

  void checkInput() {
    if (TextUtils.isNotEmpty(nickName)) {
      if (isClickEnable) return;
      isClickEnable = true;
      refreshBtn.currentState?.update();
    } else {
      if (!isClickEnable) return;
      isClickEnable = false;
      refreshBtn.currentState?.update();
    }
  }

  GlobalKey<PartRefreshWidgetState> refreshBtn = GlobalKey();

  Widget buildConfirm() {
    return PartRefreshWidget(refreshBtn, () => BigTextButton(text: LanguageConfig.get(LanguageConfigKeys.ViewUtils_confirm), enable: isClickEnable, onTap: () {
      setNickName();
    }));
  }

  Future<void> setNickName() async {
    if (nickName.isEmpty) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Login_kol_name_hint));
      return;
    }
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_CREATE_KOL_LINK, {
      "kolNickName": nickName.toLowerCase()
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      EventBusUtil.getInstance().emit(UserInfoEvent());
      loadUserInfo();
    } else {
      setState(() {
        nameError = true;
      });
    }
    ViewUtils.dismiss();
  }

  Future<void> loadUserInfo() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_SSO_INFO, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      await AppUtils.setUserInfo(rsp.data);
      String kolName = BaseModel.getString(rsp.data, "kolName");
      finish();
      showPop(0.7 * Adapt.getWindowHeight(), InviteSuccessPage(kolName));
    }
  }

}
