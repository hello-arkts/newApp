
import 'dart:io';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/MainPage.dart';
import 'package:mxcome/com/mxcome/app/ui/login/LoginPage.dart';
import 'package:mxcome/com/mxcome/app/ui/login/RegisterPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/LanguageEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/grow/ActivityPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/grow/ActivityProductPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/pocket/ActivityDetailPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/qrcode/QRCodePage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/utils/Adapt.dart';
import 'package:mxcome/com/mxcome/app/utils/AppUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/PermissionHelper.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import 'package:permission_handler/permission_handler.dart';

import 'IURLConstant.dart';
import 'Logger.dart';
import 'config/LanguageConfig.dart';
import 'model/BaseModel.dart';
import 'model/BaseRsp.dart';

abstract class BaseKeepAliveState<T extends StatefulWidget> extends State<T> with AutomaticKeepAliveClientMixin {
  var page = 1;
  var count = 0;
  bool isErr = false;
  bool isLoading = false;
  List<dynamic> datas = [];
  String serviceTime = '';
  var statusBarHeight;
  var appBarHeight;
  var expandeSpace = Expanded(
    child: Container(),
  );
  dynamic languageEvent;

  IndicatorResult onRefresh() {
    page = 1;
    loadContentDatas();
    return IndicatorResult.success;
  }

  IndicatorResult onLoadMore() {
    if (isLoading) {
      Logger.log('loading>>>');
      return IndicatorResult.success;
    }
    if (datas.length >= count) {
      Logger.log('courses.length >= count>>>');
      return IndicatorResult.noMore;
    }
    this.setState(() {
      page++;
    });
    loadContentDatas();
    return IndicatorResult.success;
  }

  Future<void> loadContentDatas() async {
    return;
  }

  buildHeader() {
    if (datas.isEmpty) {
      if (isLoading) {
        return ViewUtils.buildLoading();
      } else if (isErr) {
        return ViewUtils.buildRetry(loadContentDatas);
      } else {
        return ViewUtils.buildNoData();
      }
    } else {
      if (isLoading) {
        return ViewUtils.buildLoading();
      } else if (datas.length < count) {
        return ViewUtils.buildLoadMore();
      } else {
        return ViewUtils.buildNoMore();
      }
    }
  }

  void nextPageState(Widget widget, bool state) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget, maintainState: state));
  }

  void nextPage(Widget widget, bool isFinish) {
    changeFocus();
    if (isFinish) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => widget),
            (route) => false,
      );
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
    }
  }

  void nextMainPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          settings: const RouteSettings(name: "/main"),
          builder: (context) => MainPage()),
          (route) => false,
    );
  }

  void backHome() {
    Navigator.popUntil(context, ModalRoute.withName('/main'));
  }

  void nextPageName(String routeName, bool isFinish) {
    changeFocus();
    if (isFinish) {
      Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false, arguments: context);
    } else {
      Navigator.pushNamed(context, routeName, arguments: context);
    }
  }

  void onLanguageUpdate() {
    if (!mounted) return;
    this.setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
    languageEvent = EventBusUtil.getInstance().on<LanguageEvent>((event) {
      onLanguageUpdate();
    });
  }

  var isDispose = false;

  getServiceTime() async{
    BaseRsp res = await HttpUtils.post(IURLConstant.MALL_GET_SERVICE_TIME, {});
    serviceTime = res.data;
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(languageEvent);
    isDispose = true;
    super.dispose();
  }

  showPop(double height, Widget widget, {bool enableDrag=true, Color topColor=Colors.white}) {
    showPop2(height, widget, null, enableDrag, topColor);
  }

  showPop2(double height, Widget widget, Function(BuildContext context)? callBack, bool enableDrag, Color topColor) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        enableDrag: enableDrag,
        builder: (context) {
          if (callBack != null) callBack(context);
          return Container(
            height: height,
            decoration: BoxDecoration(
                color: topColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.w))
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 50.w,
                    height: 8.w,
                    margin: EdgeInsets.only(top: 4.w, bottom: 2.w),
                    decoration: BoxDecoration(
                        color: IConstant.line_color,
                        borderRadius: BorderRadius.all(Radius.circular(30.w))
                    ),
                  ),
                ),
                Expanded(child: widget)
              ],
            ),
          );
        });
  }

  showPopDialog(Widget widget, bool barrierDismissible) {
    showDialog(
        context: context,
        useSafeArea: false,
        barrierDismissible: barrierDismissible,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            alignment: Alignment.center,
            child: widget,
          );
        });
  }

  toLogin(Function(BuildContext context) callBack) {
    showPop2(0.9 * Adapt.getWindowHeight(), LoginPage(callBack), null, true, Colors.white);
  }

  toRegister(Function(BuildContext context) callBack) {
    showPop2(0.9 * Adapt.getWindowHeight(), RegisterPage(callBack), null, true, Colors.white);
  }

  void finish() {
    finishContext(context);
  }

  @override
  void setState(fn) {
    if (isDispose) return;
    if (!mounted) return;
    super.setState(fn);
  }

  void finishContext(BuildContext? context) {
    changeFocus();
    try {
      if (context == null) return;
      Navigator.pop(context);
    } catch (e) {
      Logger.log(e);
    }
  }

  changeFocus() {
    setFocus(FocusNode());
  }

  setFocus(FocusNode fn) {
    if (!mounted) return;
    FocusScope.of(context).requestFocus(fn);
  }

  @override
  Widget build(BuildContext context) {
    statusBarHeight = Adapt.getStatusBarHeight(context);
    appBarHeight = Adapt.getAppBarHeight();
    return super.build(context);
  }

  @override
  bool get wantKeepAlive => true;

  Future<bool> checkIDCardVerified() async {
    dynamic userInfo = await AppUtils.getUserInfo();
    if (BaseModel.getInt(userInfo, "idCardStatus") == 2) {
      return true;
    } else {
      return false;
    }
  }

  void activityStart(dynamic activity, bool gotoDetail) async {
    if (!await checkLogin(activity, gotoDetail)) return;
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_ACTIVITY_MEMBER_INFO, {
      "activityId": BaseModel.getString(activity, "id")
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      gotoPage(activity, rsp.data, gotoDetail);
    } else {
      ViewUtils.displayToast(rsp.msg);
      ViewUtils.dismiss();
    }
  }

  Future<bool> checkLogin(dynamic activity, bool gotoDetail) async {
    if (!await AppUtils.isLogined()) {
      toLogin((ctx) => {
        this.setState(() {
          finishContext(ctx);
          activityStart(activity, gotoDetail);
        })
      });
      return false;
    }
    return true;
  }

  void gotoPage(dynamic activity, dynamic activityMember, bool gotoDetail) async {
    if (TextUtils.isEmpty(activityMember)) { //活动未领取
      ViewUtils.dismiss();
      showPop(0.8 * Adapt.getWindowHeight(), ActivityPage(activity));
    } else { //活动已领取
      if (gotoDetail) {
        ViewUtils.dismiss();
        nextPage(ActivityDetailPage(activityMember), false);
      } else {
        String activityId = BaseModel.getString(activity, "id");
        BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_ACTIVITY_GET_INFO, {
          "activityId": activityId
        });
        ViewUtils.dismiss();
        if (rsp.retCode == RspRetCode.SUCCESS) {
          showPop(0.95 * Adapt.getWindowHeight(), ActivityProductPage(rsp.data, activityMember: activityMember));
        } else {
          ViewUtils.displayToast(rsp.msg);
        }
      }
    }
  }

  Future<void> showScanDialog() async {
    if (Platform.isIOS) {
      nextPage(QRCodePage(), false);
      return;
    }
    String denied = LanguageConfig.get(LanguageConfigKeys.Shop_permission_denied);
    String granted = LanguageConfig.get(LanguageConfigKeys.Shop_permission_granted);
    String cancel = LanguageConfig.get(LanguageConfigKeys.Shop_permission_setting_cancel);
    String open = LanguageConfig.get(LanguageConfigKeys.Shop_permission_setting_open);
    String title = LanguageConfig.get(LanguageConfigKeys.Shop_permission_scan_title);
    String content = LanguageConfig.get(LanguageConfigKeys.Shop_permission_scan_content);
    String settingTitle = LanguageConfig.get(LanguageConfigKeys.Shop_permission_scan_setting_title);
    String settingContent = LanguageConfig.get(LanguageConfigKeys.Shop_permission_scan_setting_content);
    PermissionHelper.check(Permission.camera,
        onSuccess: () {
          nextPage(QRCodePage(), false);
        }, onFailed: () {
          ViewUtils.showRemindDialog2(context,
              title,
              content,
              denied,
              granted, (ctx, event) {
                if (event == DialogEvent.confirm) {
                  PermissionHelper.requestPermission(Permission.location,
                      onSuccess: () {
                        nextPage(QRCodePage(), false);
                      }, onFailed: () {
                      }, onOpenSetting: () {
                        ViewUtils.showRemindDialog2(context,
                            settingTitle,
                            settingContent,
                            cancel,
                            open, (ctx, event) {
                              if (event == DialogEvent.confirm) {
                                openAppSettings();
                                finishContext(ctx);
                              } else {
                                finishContext(ctx);
                              }
                            }
                        );
                      });
                  finishContext(ctx);
                } else {
                  finishContext(ctx);
                }
              }
          );
        }, onOpenSetting: () {
          ViewUtils.showRemindDialog2(context,
              settingTitle,
              settingContent,
              cancel,
              open, (ctx, event) {
                if (event == DialogEvent.confirm) {
                  openAppSettings();
                  finishContext(ctx);
                } else {
                  finishContext(ctx);
                }
              }
          );
        });
    }

}
