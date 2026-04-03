import 'dart:async';
import 'dart:convert';

import 'package:app_links/app_links.dart';
import 'package:badges/badges.dart' as badges;
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/lottery/RandomLotteryPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/ShopPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/ActivityEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/BalanceEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/CartEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/CollectEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/DelayedEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/HomeEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/LaunchUrlEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/LoginSuccessEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/MainTabEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/OrderEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/PayloadEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/PocketEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/QRCodeEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/UserInfoEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/grow/GrowPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/MinePage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/setting/VersionPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/ReadCount.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/order/PaySuccessPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/order/SCBDownloadPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/pocket/TabPocketPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/Util.dart';
import 'package:mxcome/com/mxcome/app/utils/AppUtils.dart';
import 'package:mxcome/com/mxcome/app/widget/PartRefreshWidget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../IURLConstant.dart';
import '../PageConstant.dart';
import '../config/LanguageConfig.dart';
import '../model/BaseModel.dart';
import '../model/BaseRsp.dart';
import '../utils/Adapt.dart';
import '../utils/HttpUtils.dart';
import '../utils/TextUtils.dart';
import '../utils/ViewUtils.dart';

class MainPage extends StatefulWidget {

  MainPage();

  @override
  State<StatefulWidget> createState() => MainPageState();
}

class MainPageState extends BaseKeepAliveState<MainPage> {
  PageController pageController = PageController();
  late List<Widget> pages;
  int pageIdx = 0;
  GlobalKey<PartRefreshWidgetState> keyMenus = GlobalKey<PartRefreshWidgetState>();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  dynamic loginSuccessEvent;
  dynamic userInfoEvent;
  dynamic homeEvent;
  dynamic cartEvent;
  dynamic collectEvent;
  dynamic pocketEvent;
  dynamic orderEvent;
  dynamic activityEvent;
  dynamic qrcodeEvent;
  dynamic mainTabEvent;
  dynamic launchUrlEvent;
  dynamic payloadEvent;
  dynamic balanceEvent;
  ReadCount pocketCount = ReadCount(IConstant.pocket_count, 0, 0);
  ReadCount activityCount = ReadCount(IConstant.activity_count, 0, 0);

  @override
  void initState() {
    super.initState();
    pages = [ShopPage(), TabPocketPage(), GrowPage()];
    checkDeepLink();
    loginSuccessEvent = EventBusUtil.getInstance().on<LoginSuccessEvent>((event) async {
      await Future.delayed(const Duration(milliseconds: 200));
      await AppUtils.setToken(event.token);
      loadUserInfo();
      loadPocket();
      loadCart();
      loadCollectList();
      loadActivity();
      loadOrderNum();
    });
    userInfoEvent = EventBusUtil.getInstance().on<UserInfoEvent>((event) {
      if (event.userInfoStatus == UserInfoStatus.query) {
        loadUserInfo();
      } else if (event.userInfoStatus == UserInfoStatus.complete){
        clearReadCount();
      }
    });
    homeEvent = EventBusUtil.getInstance().on<HomeEvent>((event) {
      if (event.homeType == HomeType.query) {
        loadHome();
      }
    });
    pocketEvent = EventBusUtil.getInstance().on<PocketEvent>((event) {
      if (event.pocketType == PocketType.query) {
        loadPocket();
      }
    });
    cartEvent = EventBusUtil.getInstance().on<CartEvent>((event) {
      if (event.cartType == CartType.query) {
        loadCart();
      }
    });
    collectEvent = EventBusUtil.getInstance().on<CollectEvent>((event) {
      if (event.collectType == CollectType.query) {
        loadCollectList();
      }
    });
    activityEvent = EventBusUtil.getInstance().on<ActivityEvent>((event) {
      if (event.activityType == ActivityType.query) {
        loadActivity();
      }
    });
    qrcodeEvent = EventBusUtil.getInstance().on<QRCodeEvent>((event) {
      if (TextUtils.isNotEmpty(event.content)) {
        if (event.content.startsWith(PageConstant.APP_BASE_URI) || event.content.startsWith(PageConstant.WEB_BASE_URI)) {
          parserDeepLink(Uri.parse(event.content));
        } else { //其他内容
        }
      }
    });
    orderEvent = EventBusUtil.getInstance().on<OrderEvent>((event) {
      if (event.orderType == OrderType.query) {
        loadOrderNum();
      }
    });
    mainTabEvent = EventBusUtil.getInstance().on<MainTabEvent>((event) async {
      if (event.pageType == PageType.main) {
        pageIdx = 0;
      } else if (event.pageType == PageType.pocket || event.pageType == PageType.pocketActivity) {
        pageIdx = 1;
      } else if (event.pageType == PageType.grow) {
        pageIdx = 2;
      }
      pageController.jumpToPage(pageIdx);
      keyMenus.currentState?.update();
      if (event.pageType == PageType.pocketActivity) {
        await Future.delayed(const Duration(milliseconds: 400), () {
          EventBusUtil.getInstance().emit(DelayedEvent());
        });
      }
    });
    launchUrlEvent = EventBusUtil.getInstance().on<LaunchUrlEvent>((event) async {
      String path = event.url;
      if (path.indexOf("payResult") > 0) { //支付成功页
        path = path.substring(path.indexOf("payResult"), path.length);
        backHome();
        nextPage(PaySuccessPage(), false);
      } else if (TextUtils.isNotEmpty(path)) { //银行卡支付，跳转银行APP
        Uri uri = Uri.parse(path);
        try {
          if (!await launchUrl(uri)) { //ios返回false
            if (event.launchType == LaunchType.scbPay) {
              nextPage(SCBDownloadPage(), false);
            } else {
              ViewUtils.displayToast("launch url error: $path");
            }
          }
        } catch(e) { //安卓报错
          nextPage(SCBDownloadPage(), false);
        }
      } else {
        backHome();
      }
    });
    payloadEvent = EventBusUtil.getInstance().on<PayloadEvent>((event) async {
    });
    balanceEvent = EventBusUtil.getInstance().on<BalanceEvent>((event) async {
      // checkBalanceStatus();
    });
    loadUserInfo();
    //handleRedInfo();
    getSystemSettingsInfo();
    loadHome();
    loadCart();
    loadCollectList();
    loadPocket();
    loadActivity();
    loadOrderNum();
    loadCount();
    // checkBalanceStatus();
    //checkVersion();
  }

  // Future<void> registerFmToken() async {
  //   String? token = await FirebaseMessaging.instance.getToken();
  //   Logger.log("---fcmToken: $token");
  //   if (token != null && token.isNotEmpty) {
  //     // 将token上传到后端，让后端控制发送推送通知
  //     BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_REGISTER_TOKEN, {
  //       "registrationTokens": token
  //     });
  //     if (rsp.retCode == RspRetCode.SUCCESS) {
  //       FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //         RemoteNotification? notification = message.notification;
  //         Logger.log("---Notification.hashCode ${notification.hashCode}");
  //         Logger.log("---Notification.title ${notification?.title}");
  //         Logger.log("---Notification.body ${notification?.body}");
  //       });
  //     } else {
  //       ViewUtils.displayToast(rsp.msg);
  //     }
  //   }
  // }

  Future<void> loadCount() async {
    ReadCount pocketCnt = await AppUtils.getReadCount(IConstant.pocket_count);
    ReadCount activityCnt = await AppUtils.getReadCount(IConstant.activity_count);
    setState(() {
      pocketCount = pocketCnt;
      activityCount = activityCnt;
    });
  }

  void checkBalanceStatus() async{
    // BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_SSO_GET_BALANCE_WINDOW, {});
    // if (rsp.retCode == RspRetCode.SUCCESS) {
    //   int isWindow = BaseModel.getInt(rsp.data, "isWindow");
    //   double changeBalance = BaseModel.getDouble(rsp.data, "changeBalance");
    //   String balanceInfoId = BaseModel.getString(rsp.data, "id");
    //   if (isWindow == 1) {
    //     showPop(0.55 * Adapt.getWindowHeight(), BalanceChangeWindow(changeBalance, balanceInfoId), enableDrag: false);
    //   }
    // }
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(loginSuccessEvent);
    EventBusUtil.getInstance().off(userInfoEvent);
    EventBusUtil.getInstance().off(homeEvent);
    EventBusUtil.getInstance().off(pocketEvent);
    EventBusUtil.getInstance().off(cartEvent);
    EventBusUtil.getInstance().off(collectEvent);
    EventBusUtil.getInstance().off(activityEvent);
    EventBusUtil.getInstance().off(orderEvent);
    EventBusUtil.getInstance().off(qrcodeEvent);
    EventBusUtil.getInstance().off(mainTabEvent);
    EventBusUtil.getInstance().off(launchUrlEvent);
    EventBusUtil.getInstance().off(payloadEvent);
    EventBusUtil.getInstance().off(balanceEvent);
    _linkSubscription?.cancel();
    super.dispose();
  }

  clearReadCount() async {
    bool loginState = await AppUtils.isLogined();
    if (!loginState) {
      setState(() {
        pocketCount = ReadCount(IConstant.pocket_count, 0, 0);
        activityCount = ReadCount(IConstant.activity_count, 0, 0);
      });
    } else {
      loadCount();
    }
  }

  checkDeepLink() async {
    try {
      _appLinks = AppLinks();
      _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
        parserDeepLink(uri);
      });
      Uri? uri = await _appLinks.getLatestAppLink();
      parserDeepLink(uri);
    } catch (e) {
      TextUtils.println(e);
    }
  }

  //外部处理结构:mxcome://app/routes/encode({})
  parserDeepLink(Uri? uri) {
    try {
      if (uri == null) return;
      TextUtils.println("---parserDeepLink>>>$uri");
      if (checkPay(uri)) return; //检查支付回调
      String path = uri.path;
      if (TextUtils.isEmpty(path) || path.length <= 1) return;
      TextUtils.println("---parserDeepLink>>>$path");
      Map<String, dynamic> params = uri.queryParameters;
      if (TextUtils.isNotEmpty(path) && path.length > 1) {
        path = path.substring(1); //去掉开头的反斜杠
        if (params.isNotEmpty &&
            params.keys.contains(PageConstant.URI_PARAMS_KEY)) {
          String value = params[PageConstant.URI_PARAMS_KEY] ?? '';
          value = HttpUtils.decode(Uri.decodeComponent(value));
          TextUtils.println(value);
          if (TextUtils.isNotEmpty(value)) {
            params = jsonDecode(value);
          }
        } else {
          params = {};
        }
        TextUtils.println(params);
      } else {
        String fragment = uri.fragment;
        if (TextUtils.isEmpty(fragment) || fragment.length <= 1) {
          return;
        } else {
          int paramsIndex = fragment.indexOf(PageConstant.URI_PARAMS_KEY);
          path = fragment.substring(1, paramsIndex - 1);
          String value = fragment.substring(paramsIndex + PageConstant.URI_PARAMS_KEY.length + 1, fragment.length);
          value = HttpUtils.decode(Uri.decodeComponent(value));
          if (TextUtils.isNotEmpty(value)) {
            params = jsonDecode(value);
          }
          TextUtils.println(params);
        }
      }
      // int open_type = BaseModel.getInt(params, PageConstant.OPEN_TYPE);
      switch (path) { //此处针对不同路由以及对应的参数进行界面处理
        case "activity":
          String activityId = BaseModel.getString(params, "activityId");
          activityIsLogin(activityId);
          break;
        case "lottery":
          lotteryIsLogin();
          break;
      }
    } catch (e) {
      TextUtils.println(e);
    }
  }

  Future<void> lotteryIsLogin() async {
    if (await AppUtils.isLogined()) {
      nextPage(RandomLotteryPage(), false);
    } else {
      toLogin((ctx) =>
      {
        setState(() {
          finishContext(ctx);
          nextPage(RandomLotteryPage(), false);
        })
      });
    }
  }

  bool checkPay(Uri uri) {
    String path = uri.path;
    if (path.indexOf("payResult") > 0) { //余额支付
      path = path.substring(path.indexOf("payResult"), path.length);
      backHome();
      nextPage(PaySuccessPage(), false);
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: PageView.builder(
        itemBuilder: (ctx, idx) => pages[idx],
        itemCount: pages.length,
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: PartRefreshWidget(
          keyMenus,
              () => BottomNavigationBar(
            currentIndex: pageIdx,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12.sp,
            unselectedFontSize: 12.sp,
            selectedItemColor: IConstant.main_color,
            unselectedItemColor: IConstant.main_inactive_color,
            items: [
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/icons/shop_menu_inactive_icon.png',
                    width: 26.w,
                    height: 26.w,
                    color: IConstant.text_color,
                  ),
                  activeIcon: Image.asset(
                    'assets/icons/shop_menu_active_icon.png',
                    width: 26.w,
                    height: 26.w,
                  ),
                  label: LanguageConfig.get(LanguageConfigKeys.Shop_home)),
              BottomNavigationBarItem(
                  icon: buildBadgeTask("task_menu_inactive_icon"),
                  activeIcon: buildBadgeTask("task_menu_active_icon"),
                  label: LanguageConfig.get(LanguageConfigKeys.Shop_pocket)),
              // BottomNavigationBarItem(
              //     icon: buildBadgeGrow("growth_menu_inactive_icon"),
              //     activeIcon: buildBadgeGrow("growth_menu_active_icon"),
              //     label: LanguageConfig.get(LanguageConfigKeys.Shop_grow))
            ],
            onTap: (idx) async {
              if (idx == 0) {
                loadActivity();
              } else if (idx == 1) {
                loadPocket();
              } else if (idx  == 2) {
                bool isLogin = await AppUtils.isLogined();
                if (!isLogin) {
                  toLogin((ctx) => {
                    setState(() {
                      finishContext(ctx);
                    })
                  });
                  return;
                }
              }
              pageIdx = idx;
              pageController.jumpToPage(idx);
              keyMenus.currentState?.update();
            },
          )),
      drawer: MinePage(),
    );
  }

  Widget buildBadgeTask(String iconName) {
    return badges.Badge(
      showBadge: pocketCount.getNumber() > 0,
      position: badges.BadgePosition.topEnd(top: -8, end: -10),
      badgeContent: Text("", style: TextStyle(fontSize: 10.sp, color: Colors.white)),
      child: Image.asset("assets/icons/$iconName.png", width: 26.w, height: 26.w),
    );
  }

  Widget buildBadgeGrow(String iconName) {
    return badges.Badge(
      showBadge: activityCount.getNumber() > 0,
      position: badges.BadgePosition.topEnd(top: -8, end: -10),
      badgeContent: Text("", style: TextStyle(fontSize: 10.sp, color: Colors.white)),
      child: Image.asset("assets/icons/$iconName.png", width: 26.w, height: 26.w),
    );
  }

  void loadUserInfo() async {
    bool isLogin = await AppUtils.isLogined();
    if (isLogin) {
      BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_SSO_INFO, {});
      if (rsp.retCode == RspRetCode.SUCCESS) {
        await AppUtils.setUserInfo(rsp.data);
        EventBusUtil.getInstance().emit(UserInfoEvent(userInfoStatus: UserInfoStatus.complete));
        await AppUtils.addOrUpdateLoggedInfo(rsp.data);
      }
    }
  }

  void getSystemSettingsInfo() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_GET_SYSTEM_SETTINGS, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      await AppUtils.setSystemSettingsInfo(rsp.data);
    }
  }

  void loadHome() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_HOME_CONTENT, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      await AppUtils.setHomeData(rsp.data);
      EventBusUtil.getInstance().emit(HomeEvent(homeType: HomeType.complete));
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  loadPocket() async {
    bool isLogin = await AppUtils.isLogined();
    if (isLogin) {
      BaseRsp res = await HttpUtils.post(IURLConstant.MALL_SSO_INFO, {});
      BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_POCKET_HOME, {});
      if (rsp.retCode == RspRetCode.SUCCESS) {
        await AppUtils.setPocketData(rsp.data);
        await AppUtils.setUserInfo(res.data);
        EventBusUtil.getInstance().emit(PocketEvent(pocketType: PocketType.complete));
        List<dynamic> activityMemberList = BaseModel.getDynamic(rsp.data, "activityMemberList");
        List<dynamic> pocketMemberList = BaseModel.getDynamic(rsp.data, "pocketMemberList");
        int activityCount = 0; //进行中活动数
        for (var item in activityMemberList) {
          String endTime = BaseModel.getString(item, "endTime");
          if (!Util.isTimeout2(startTime: serviceTime, endTime: endTime)) {
            activityCount++;
          }
        }
        int taskingCount = 0; //进行中任务数
        for (var item in pocketMemberList) {
          String endTime = BaseModel.getString(item, "endTime");
          if (!Util.isTimeout2(startTime: serviceTime, endTime: endTime)) {
            taskingCount++;
          }
        }
        int count = activityCount + taskingCount;
        ReadCount readCount = pocketCount;
        readCount.value = count;
        await AppUtils.setReadCount(IConstant.pocket_count, readCount);
        loadCount();
      }
    }
  }

  loadCart() async {
    bool isLogin = await AppUtils.isLogined();
    if (isLogin) {
      BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_CART_LIST, {});
      if (rsp.retCode == RspRetCode.SUCCESS) {
        List<dynamic> dataList = rsp.data;
        await AppUtils.setCartData(dataList);
        EventBusUtil.getInstance().emit(CartEvent(cartType: CartType.complete));
      }
    }
  }

  loadOrderNum() async {
    bool isLogin = await AppUtils.isLogined();
    if (isLogin) {
      BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_GET_ORDER_STATUS_NUM, {});
      if (rsp.retCode == RspRetCode.SUCCESS) {
        ReadCount orderCount0 = ReadCount(IConstant.order_count_0, 0, 1);
        ReadCount orderCount1 = ReadCount(IConstant.order_count_1, 0, 1);
        ReadCount orderCount2 = ReadCount(IConstant.order_count_2, 0, 1);
        ReadCount orderCount3 = ReadCount(IConstant.order_count_3, 0, 1);
        int waitPayCount = BaseModel.getInt(rsp.data, "waitPayCount");
        int waitDeliverCount = BaseModel.getInt(rsp.data, "waitDeliverCount");
        int waitReceiptCount = BaseModel.getInt(rsp.data, "waitReceiptCount");
        int afterSalesCount = BaseModel.getInt(rsp.data, "afterSalesCount");
        orderCount0.value = waitPayCount;
        orderCount1.value = waitDeliverCount;
        orderCount2.value = waitReceiptCount;
        orderCount3.value = afterSalesCount;
        await AppUtils.setReadCount(IConstant.order_count_0, orderCount0);
        await AppUtils.setReadCount(IConstant.order_count_1, orderCount1);
        await AppUtils.setReadCount(IConstant.order_count_2, orderCount2);
        await AppUtils.setReadCount(IConstant.order_count_3, orderCount3);
        EventBusUtil.getInstance().emit(OrderEvent(orderType: OrderType.complete));
      }
    }
  }

  void loadCollectList() async {
    bool isLogin = await AppUtils.isLogined();
    if (isLogin) {
      BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_COLLECTION_LIST, {
        "pageNum": "$page",
        "pageSize": "1000",
      });
      if (rsp.retCode == RspRetCode.SUCCESS) {
        List<dynamic> dataList = BaseModel.isNotEmpty(rsp.data, "list") ? BaseModel.getDynamic(rsp.data, "list") : [];
        await AppUtils.setCollectData(dataList);
        EventBusUtil.getInstance().emit(CollectEvent(collectType: CollectType.complete));
      }
    }
  }

  loadActivity() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_ACTIVITY_LIST, {
      "isReceive": "0",
      "pageNum": "$page",
      "pageSize": "10"

    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<dynamic> dataList = BaseModel.isNotEmpty(rsp.data, "list") ? BaseModel.getDynamic(rsp.data, "list") : [];
      await AppUtils.setActivityData(dataList);
      EventBusUtil.getInstance().emit(ActivityEvent(activityType: ActivityType.complete));
      ReadCount tmpCount = activityCount;
      tmpCount.value = dataList.length;
      await AppUtils.setReadCount(IConstant.activity_count, tmpCount);
      loadCount();
    }
  }

  activityIsLogin(String activityId) async {
    List<dynamic> dataList = await AppUtils.getActivityData();
    dynamic activity;
    for (var item in dataList) {
      if (activityId == BaseModel.getString(item, "id")) {
        activity = item;
        break;
      }
    }
    if (activity == null) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_activity_not_exist));
      return;
    }
    if (await AppUtils.isLogined()) {
      activityStart(activity, false);
    } else {
      toLogin((ctx) => {
        setState(() {
          finishContext(ctx);
          activityStart(activity, false);
        })
      });
    }
  }

  checkVersion() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_VERSION_INFO, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      String version = BaseModel.getString(rsp.data, "version");
      String localVersion = await Util.getVersion();
      if (version != localVersion) {
        await AppUtils.setReadCount(IConstant.version_count, ReadCount(IConstant.version_count, 0, 1));
        String updateTime = BaseModel.getString(rsp.data, "updateTime");
        String versionInfo = BaseModel.getString(rsp.data, "versionInfo");
        showUpdateDialog(updateTime, versionInfo);
      } else {
        await AppUtils.setReadCount(IConstant.version_count, ReadCount(IConstant.version_count, 0, 0));
      }
    }
  }

  void showUpdateDialog(String updateTime, String versionInfo) {
    showPop(0.6 * Adapt.getWindowHeight(), VersionPage(updateTime, versionInfo));
  }

  // Future<void> handleRedInfo() async {
  //   bool isLogin = await AppUtils.isLogined();
  //   if (isLogin) {
  //     BaseRsp res = await HttpUtils.post(IURLConstant.MALL_SSO_INFO, {});
  //     dynamic localUser = await AppUtils.getUserInfo();
  //     int localRedPower = BaseModel.getInt(localUser, "redPower");
  //     int networkRedPower = BaseModel.getInt(res.data, "redPower");
  //     int isRedWindow = BaseModel.getInt(res.data, "isRedWindow");
  //     if ((networkRedPower ==1 && networkRedPower == 2) && isRedWindow == 1) { //有资格 isRedWindow (0：不需要弹窗；1：需要弹窗)
  //       // await AppUtils.setUserInfo(res.data);
  //       // EventBusUtil.getInstance().emit(UserInfoEvent(userInfoStatus: UserInfoStatus.complete));
  //       BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_RED_HOME, {});
  //       if (rsp.retCode == RspRetCode.SUCCESS) {
  //         int currentLevel = BaseModel.getInt(res.data, "redLevel");
  //         List<dynamic> dataList = BaseModel.getDynamic(rsp.data, "amountLevelList");
  //         for (var item in dataList) {
  //           int redLevel = BaseModel.getInt(item, "redLevel");
  //           double amount = BaseModel.getDouble(item, "amount");
  //           if (redLevel == currentLevel - 1) {
  //             showPop(0.55 * Adapt.getWindowHeight(), RedLevelPage(amount, callBack: (BuildContext ctx) {
  //             }),);
  //             break;
  //           }
  //         }
  //       }
  //     }
  //   }
  // }

  finishRedWindow() async{
    await HttpUtils.post(IURLConstant.MALL_FINISH_RED_WINDOW, {});
  }

}
