
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/Logger.dart';
import 'package:mxcome/com/mxcome/app/PageConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import 'package:mxcome/com/mxcome/app/widget/PartRefreshWidget.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../shop/widget/BigTextButton.dart';

class BetaProtocolPage extends StatefulWidget {

  String url;

  Function(BuildContext context) callBack;

  BetaProtocolPage(this.url, this.callBack);


  @override
  State createState() => BetaProtocolPageState();
}

class BetaProtocolPageState extends BaseKeepAliveState<BetaProtocolPage> {
  late InAppWebView webView;
  int progress = 0;
  late InAppWebViewController webViewController;
  GlobalKey<PartRefreshWidgetState> progressKey = GlobalKey();
  GlobalKey<PartRefreshWidgetState> firstInKey = GlobalKey();
  GlobalKey<PartRefreshWidgetState> errKey = GlobalKey();
  String? title = '';
  bool firstIn = true;

  @override
  void initState() {
    super.initState();
    webView = InAppWebView(
      initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            useShouldOverrideUrlLoading: true,
            javaScriptEnabled: true,
            mediaPlaybackRequiresUserGesture: false,
          ),
          android: AndroidInAppWebViewOptions(
            useHybridComposition: true,
          )),
      onWebViewCreated: (controller) {
        webViewController = controller;
        webViewController.loadUrl(urlRequest: URLRequest(url: WebUri(widget.url)));
        controller.addWebMessageListener(WebMessageListener(
            jsObjectName: PageConstant.JS_OBJECT,
            onPostMessage: (message, sourceOrigin, isMainFrame, replyProxy) async {
              TextUtils.println('onPostMessage->>>$message');
              if (TextUtils.isEmpty(message)) return;
              var data = jsonDecode(message?.data ?? "{}");
              String key = BaseModel.getString(data, 'key');
              switch (key) {
                case PageConstant.JS_CLOSE_WINDOW:
                  finish();
                  break;
              }
            }));
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        TextUtils.println("shouldOverrideUrlLoading>>>${navigationAction.request.url}");
        String url = navigationAction.request.url.toString();
        if(!url.startsWith("http")&&await launchUrlString(url,mode: LaunchMode.externalApplication)){
          return NavigationActionPolicy.CANCEL;
        }
        // if (url.startsWith(IConstant.WEB_BASE_URL)) return NavigationActionPolicy.ALLOW; //官网不作拦截处理
        // if ((await launchUrlString(url,mode: LaunchMode.externalApplication))) {
        // return NavigationActionPolicy.CANCEL;
        //}
        // loadUrl(widget.url, headers);
        return NavigationActionPolicy.ALLOW;
      },
      onLoadStop: (controller, url) {
        firstIn = false;
        firstInKey.currentState?.update();
      },
      onConsoleMessage: (controller, consoleMessage) {
        TextUtils.println("onConsoleMessage>>>${consoleMessage.message}");
      },
      onLoadError: (controller, url, code, message) {
        TextUtils.println("onLoadError>>>$url,$code,$message");
      },
      onLoadHttpError: (controller, url, code, message) {
        TextUtils.println("onLoadHttpError>>>$url,$code,$message");
      },
      onProgressChanged: (controller, value) async {
        progress = value;
        progressKey.currentState?.update();
      },
      onTitleChanged: (controller, title) {
        this.title = title;
        progressKey.currentState?.update();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0,
        leading: ViewUtils.buildBackBtn(finish),
        title: PartRefreshWidget(
            progressKey,
                () => progress >= 100
                ? Text('$title'.toUpperCase(),
              style: TextStyle(color: IConstant.title_color, fontSize: 17.sp),
            )
                : SizedBox(
              width: 30.w,
              height: 30.w,
              child: CircularProgressIndicator(
                strokeWidth: 2.w,
              ),
            )),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          webView,
          PartRefreshWidget(
              firstInKey,
                  () => firstIn
                  ? Container(
                color: IConstant.white_color,
                child: Center(
                  child: ViewUtils.buildLoading(),
                ),
              )
                  : Container()),
          PartRefreshWidget(
              errKey,
                  () => isErr
                  ? InkWell(
                child: Container(
                  color: IConstant.white_color,
                  child: Center(
                    child: Text(
                      LanguageConfig.get(LanguageConfigKeys.WebPage_click_reload),
                      style: TextStyle(color: IConstant.title_color, fontSize: 12.sp),
                    ),
                  ),
                ),
                onTap: () {
                  webViewController.reload();
                },
              ) : Container())
        ],
      ),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      child: Container(
        margin: EdgeInsets.fromLTRB(20.w, 16.w, 20.w, 16.w),
        child: BigTextButton(text: LanguageConfig.get(LanguageConfigKeys.Login_invite_consent_agreement), onTap: () {
          widget.callBack(context);
        }),
      ),
    );
  }
}
