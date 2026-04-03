
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/PageConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import 'package:mxcome/com/mxcome/app/widget/PartRefreshWidget.dart';

class WebPage extends StatefulWidget {

  String url;
  bool showAction = true;

  WebPage(this.url);

  WebPage.Action(this.url, this.showAction);

  @override
  State createState() => WebPageState();
}

class WebPageState extends BaseKeepAliveState<WebPage> {
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
      onWebViewCreated: (controller) {
        webViewController = controller;
        webViewController.loadUrl(urlRequest: URLRequest(url: WebUri(widget.url)));
        controller.addWebMessageListener(WebMessageListener(
            jsObjectName: PageConstant.JS_OBJECT,
            onPostMessage: (message, sourceOrigin, isMainFrame, replyProxy) async {
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
      onLoadStop: (controller, url) {
        firstIn = false;
        firstInKey.currentState?.update();
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
      appBar: widget.showAction
          ? AppBar(
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
      )
          : null,
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
              )
                  : const SizedBox())
        ],
      ),
    );
  }
}
