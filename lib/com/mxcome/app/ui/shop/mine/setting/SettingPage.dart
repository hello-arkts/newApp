import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/LanguagePage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/UserInfoEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IURLConstant.dart';
import '../../../../config/LanguageConfig.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/AppUtils.dart';
import '../../../../utils/HttpUtils.dart';
import '../../../../utils/ViewUtils.dart';
import '../../model/ReadCount.dart';
import '../../widget/BigTextButton.dart';
import 'AboutPage.dart';
import 'AccountSafePage.dart';

class SettingPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return SettingPageState();
  }

}

class SettingPageState extends BaseKeepAliveState<SettingPage> {

  bool isLogin = false;

  ReadCount _versionCount = ReadCount(IConstant.version_count, 0, 0);

  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    bool loginState = await AppUtils.isLogined();
    ReadCount versionCount = await AppUtils.getReadCount(IConstant.version_count);
    setState(() {
      isLogin = loginState;
      _versionCount = versionCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.5.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_setting_title),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          buildAccountSafe(),
          Divider(height: 1.w),
          InkWell(onTap: () {
            nextPage(LanguagePage(), false);
          }, child: ListTile(
            title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_setting_Language_change), style: TextStyle(fontSize: 16.sp, color: IConstant.text_color)),
            subtitle: Text(LanguageConfig.get(LanguageConfigKeys.Shop_setting_Language_change_detail), style: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color)),
            trailing: Icon(Icons.chevron_right, size: 20.w),
          )),
          Divider(height: 1.w),
          InkWell(onTap: () {
            nextPage(AboutPage(), false);
          }, child: ListTile(
            title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_setting_about), style: TextStyle(fontSize: 16.sp, color: IConstant.text_color)),
            subtitle: Text(LanguageConfig.get(LanguageConfigKeys.Shop_setting_about_detail), style: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color)),
            trailing: SizedBox(
              width: 80.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // _versionCount.isUnread() ? Container(
                  //   padding: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
                  //   decoration: BoxDecoration(
                  //       color: IConstant.main_color,
                  //       borderRadius: BorderRadius.circular(10.w)),
                  //   child: Text("New", style: TextStyle(fontSize: 12.sp, color: IConstant.white_color)),
                  // ) : Container(),
                  Icon(Icons.chevron_right, size: 20.w)
                ],
              ),
            ),
          )),
          Divider(height: 1.w),
          Container(
            height: 150.w,
            margin: EdgeInsets.only(left: 8.w, top: 10.w),
            // child: WebView(
            //   initialUrl: '',
            //   javascriptMode: JavascriptMode.unrestricted,
            //   onWebViewCreated: (WebViewController webViewController) async{
            //     _webViewController = webViewController;
            //     _loadHtmlFromAssets();
            //   },
            //   onPageFinished: (url) async{
            //   },
            child: Image.asset(
              'assets/icons/authorisedInThailand.jpg',
              fit: BoxFit.contain,
            ),
          )
        ],
      ),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildAccountSafe() {
    if (isLogin) {
      return InkWell(onTap: () {
        nextPage(AccountSafePage(), false);
      }, child:  ListTile(
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_setting_account_safe), style: TextStyle(fontSize: 16.sp, color: IConstant.text_color)),
        subtitle: Text(LanguageConfig.get(LanguageConfigKeys.Shop_setting_account_safe_detail), style: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color)),
        trailing: Icon(Icons.chevron_right, size: 20.w),
      ));
    } else {
      return Container();
    }
  }

  Widget buildBottomBar() {
    if (isLogin) {
      return BottomAppBar(
        height: 110.w,
        elevation: 0.w,
        child: Container(
          margin: EdgeInsets.fromLTRB(40.w, 20.w, 40.w, 20.w),
          child: BigTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_setting_exit_login),
              bgColor: IConstant.grey_bg_color, textColor: IConstant.text_color,
              onTap: () {
                exit();
              }),
        ),
      );
    } else {
      return const BottomAppBar();
    }
  }

  Future<void> exit() async {
    ViewUtils.show();
    await HttpUtils.post(IURLConstant.LOGOUT_URL, {});
    await AppUtils.clearData();
    final googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      googleSignIn.signOut();
    }
    EventBusUtil.getInstance().emit(UserInfoEvent(userInfoStatus: UserInfoStatus.complete));
    ViewUtils.dismiss();
    finish();
  }

  _loadHtmlFromAssets() async {
    String fileHtmlContent = await rootBundle.loadString("assets/html/dbd.html");
    _webViewController.loadHtmlString(fileHtmlContent);
  }

}
