
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/LaunchUrlEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/UserInfoEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/wallet/CheckPayPwdPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/PayModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/order/OrderPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/order/PromptQRPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CountDownView.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:mxcome/com/mxcome/app/widget/PartRefreshWidget.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IURLConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseModel.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../../LanguagePage.dart';
import '../mine/setting/SettingPayPwdPage.dart';
import '../utils/FormatUtil.dart';
import '../widget/BigTextButton.dart';
import '../widget/PriceText.dart';
import 'PaySuccessPage.dart';

class PayPage extends StatefulWidget {

  dynamic order;
  bool isShopPay; //true: 店铺订单
  int orderOverTime;
  String productId;
  bool isLottery;

  PayPage(this.order, this.isShopPay, {this.orderOverTime = 15, this.productId = "", this.isLottery = false});

  @override
  State<StatefulWidget> createState() {
    return PayPageState();
  }
}

class PayPageState extends BaseKeepAliveState<PayPage> with WidgetsBindingObserver{
  dynamic order;
  dynamic userInfo;

  List<PayModel> payList = [];

  int _orderOverTime = 0;

  late DateTime endTime;

  static bool showTimeout = false;

  dynamic userInfoEvent;

  GlobalKey<PartRefreshWidgetState> timeKey = GlobalKey();

  String orderSn = "";

  String tradeNo = "";

  int currentPayIndex = 0;

  @override
  void initState() {
    super.initState();
    order = widget.order;
    WidgetsBinding.instance.addObserver(this);
    _orderOverTime = widget.orderOverTime;
    showTimeout = false;
    double payAmount = BaseModel.getDouble(widget.order, "payAmount");
    List<PayModel> dataList = [];
    dataList.add(PayModel("", LanguageConfig.get(LanguageConfigKeys.Shop_order_balance_pay), 4, true));
    dataList.add(PayModel("", LanguageConfig.get(LanguageConfigKeys.Shop_order_prompt_pay), 3, false));
    // dataList.add(PayModel("004", "mBanking", 2, false));
    if(payAmount >= 220) {
      dataList.add(PayModel("014", "mBanking", 2, false));
    }
    setState(() {
      payList = dataList;
    });
    String createTime = BaseModel.getString(order, "createTime");
    endTime = DateTime.parse(createTime);
    endTime = endTime.add(Duration(minutes: _orderOverTime));
    userInfoEvent = EventBusUtil.getInstance().on<UserInfoEvent>((event) {
      if (event.userInfoStatus == UserInfoStatus.complete) {
        loadContentDatas();
      }
    });
    loadContentDatas();
  }

  @override
  void didChangeDependencies() {
    getServiceTime();
  }

  Future<bool> payResult() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_GET_PAY_RESULT, {
      "orderSn": orderSn,
      "tradeNo": tradeNo
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      int tradeStatus = BaseModel.getInt(rsp.data, "tradeStatus");
      if (tradeStatus == 0) {
        return false;
        // ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_order_not_pay), context);
      } else if(tradeStatus == 2) {
        return false;
        // ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_order_paying), context);
      } else if(tradeStatus == 3) {
        return true;
      } else if(tradeStatus == 4) {
        return false;
        // ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_order_pay_failed), context);
      }
    } else {
      return false;
      // ViewUtils.displayToast(rsp.msg, context);
    }
    return false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed: // 应用程序可见，前台
        if (TextUtils.isNotEmpty(orderSn) && TextUtils.isNotEmpty(tradeNo) && payList[currentPayIndex].payType == 2) { //银行支付查询
          bool isPaySuccess = await payResult();
          if (isPaySuccess) {
            nextPage(PaySuccessPage(productId: widget.productId, isLottery: widget.isLottery), false);
          }
        }
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    EventBusUtil.getInstance().off(userInfoEvent);
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    isLoading = true;
    dynamic data = await AppUtils.getUserInfo();
    setState(() {
      userInfo = data;
    });
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_SSO_INFO, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        userInfo = rsp.data;
      });
      await AppUtils.setUserInfo(userInfo);
    }
    isLoading = false;
    double balance =  BaseModel.getDouble(userInfo, "balance");
    double payAmount =  BaseModel.getDouble(userInfo, "payAmount");
    setState(() {
      if (balance >= payAmount) {
        payList[0].isSelect = true;
        payList[1].isSelect = false;
      } else {
        payList[0].isSelect = false;
        payList[1].isSelect = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope(
      canPop: false, // 允许返回
      onPopInvoked: (bool didPop) async {
        showExitDialog();
      },
      child: Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        leading: InkWell(
          onTap: () {
            showExitDialog();
          },
          child: const Icon(Icons.close),
        ),
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_cashier),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    ));
  }

  Widget buildBody() {
    return payList.isEmpty
        ? buildHeader()
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80.w,
              margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
              padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
              decoration: BoxDecoration(
                  color: IConstant.red_bg_color3,
                  borderRadius: BorderRadius.circular(15.w)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_pay_amount), style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: IConstant.text_color)),
                      Expanded(child: PriceText(BaseModel.getDouble(order, "payAmount"), fontSize: 24.sp, fontWeight: FontWeight.bold, textAlign: TextAlign.right, isFormat: false)),
                    ],
                  ),
                  Expanded(child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_pay_remaining_time), style: TextStyle(fontSize: 14.sp, color: IConstant.title_color)),
                      SizedBox(width: 6.w),
                      buildClock()
                    ],
                  ))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 0.w),
              child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_select_pay), style: TextStyle(fontSize: 14.sp, color: IConstant.title_color)),
            ),
            Expanded(child: PartRefreshWidget(
              timeKey, () => ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemCount: payList.length,
                  itemBuilder: (context, index) {
                    PayModel model = payList[index];
                    return InkWell(
                        onTap: () {
                          currentPayIndex = index;
                          setPayType(model);
                        },
                        child: buildPayItem(model));
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(height: 1.w, color: IConstant.line_color);
                  }),
            ))
          ],
    );
  }

  Widget buildClock() {
    // String createTime = BaseModel.getString(order, "createTime");
    // Logger.log("----createTime: $createTime");
    // if (BaseModel.isNotEmpty(order, "orderOverTime")) {
    //   _orderOverTime = BaseModel.getInt(order, "orderOverTime");
    //   Logger.log("----replace orderOverTime: $_orderOverTime");
    // }
    // Logger.log("----last orderOverTime: $_orderOverTime");
    // DateTime endTime = DateTime.parse(createTime);
    // endTime = endTime.add(Duration(minutes: _orderOverTime));
    return CountDownView(startTime: serviceTime.isEmpty ? '' : handleDate(DateTime.parse(serviceTime)), endTime: handleDate(endTime), fontSize: 15.sp,
      textColor: IConstant.main_color,
      textAlign: TextAlign.right,
      prefix: "",
      stop: LanguageConfig.get(LanguageConfigKeys.Shop_activity_closed),
      callBack: () async {
        await Future.delayed(const Duration(milliseconds: 200),() {
          showTimeoutDialog();
        });
      },
    );
  }

  String handleDate(DateTime dateTime) {
    return FormatUtil.formatLineYMDHMS(dateTime); //格式化日期
  }

  Widget buildPayItem(PayModel model) {
    if (model.payType == 4) {
      return Container(
        margin: EdgeInsets.fromLTRB(16.w, 20.w, 16.w, 16.w),
        padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
        decoration: BoxDecoration(
            color: model.getBgColor(),
            border: Border.all(color: model.getBorderColor(), width: 1.w),
            borderRadius: BorderRadius.circular(15.w)),
        child: Row(
          children: [
            Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset("assets/icons/official_icon.png", width: 25.w, height: 25.w),
                      SizedBox(width: 6.w),
                      Text("MXCOME",
                          style: TextStyle(fontSize: 13.sp, color: IConstant.text_color))
                    ],
                  ),
                  SizedBox(height: 6.w),
                  Row(
                    children: [
                      Text(model.title,
                          style: TextStyle(fontSize: 12.sp, color: IConstant.title_color)),
                      SizedBox(width: 10.w),
                      Expanded(child: Text("${LanguageConfig.get(LanguageConfigKeys.Shop_sales_balance)} ${FormatUtil.price2String(BaseModel.getDouble(userInfo, "balance"))}",
                          style: TextStyle(fontSize: 12.sp, color: IConstant.main_color))),
                      SizedBox(width: 10.w),
                    ],
                  )
                ]
            )),
            getIcon(model.isSelect),
          ],
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextUtils.isNotEmpty(model.title ) ? Container(
            margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 4.w),
            child: Text(model.title, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: IConstant.title_color)),
          ) : Container(),
          Container(
            margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 16.w),
            padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 16.w),
            decoration: BoxDecoration(
                color: model.getBgColor(),
                border: Border.all(color: model.getBorderColor(), width: 1.w),
                borderRadius: BorderRadius.circular(15.w)),
            child: Row(
              children: [
                buildBankIcon(model),
                expandeSpace,
                getIcon(model.isSelect),
              ],
            ),
          )
        ],
      );
    }
  }

  Widget buildBankIcon(PayModel model) {
    String bankIcon = "prompt_qr";
    if (model.bankCode == "004") {
      bankIcon = "kbank";
    } else if(model.bankCode == "014") {
      bankIcon = "scb";
    }
    return Image.asset("assets/icons/$bankIcon.png", height: 32.w);
  }

  setPayType(PayModel model) {
    for (PayModel model in payList) {
      model.isSelect = false;
    }
    model.isSelect = true;
    timeKey.currentState?.update();
  }

  Widget getIcon(bool check) {
    return check
        ? const Icon(Icons.check_circle, color: IConstant.main_color)
        : const Icon(Icons.circle, color: IConstant.grey_bg_color);
  }

  void checkIsSetPayPwd() {
    PayModel? payModel = getSelectPay();
    int isSetPay = BaseModel.getInt(userInfo, "isSetPay");
    if (isSetPay == 1) {
      showPop(0.8 * Adapt.getWindowHeight(), CheckPayPwdPage(order, payModel, (ctx) => {
        checkPayPwdEnd(ctx)
      })); //检查支付密码
    } else {
      nextPage(SettingPayPwdPage((ctx) => { //设置支付密码
        setPayPwdEnd(ctx)
      }), false);
    }
  }

  void setPayPwdEnd(BuildContext ctx) {
    finishContext(ctx);
    EventBusUtil.getInstance().emit(UserInfoEvent());
    PayModel? payModel = getSelectPay();
    showPop(0.8 * Adapt.getWindowHeight(), CheckPayPwdPage(order, payModel, (ctx) => {
      checkPayPwdEnd(ctx)
    })); //检查支付密码
  }

  void checkPayPwdEnd(BuildContext ctx) {
    finishContext(ctx);
    confirmPay();
  }

  Future<void> confirmPay() async {
    String url = getHttpUrl();
    Map<String, dynamic> params = getHttpParams();
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.postJSON(url, params);
    PayModel? payModel = getSelectPay();
    if (rsp.retCode == RspRetCode.SUCCESS) {
      if(payModel?.payType == 2) { //银行卡
        String redirectUrl = BaseModel.getString(rsp.data, "redirectUrl");
        orderSn = BaseModel.getString(rsp.data, "orderSn");
        tradeNo = BaseModel.getString(rsp.data, "tradeNo");
        EventBusUtil.getInstance().emit(LaunchUrlEvent(redirectUrl, LaunchType.scbPay));
      } else if (payModel?.payType == 3) { //PromptQR二维码
        String qrImage = BaseModel.getString(rsp.data, "qrImage");
        String orderSn = BaseModel.getString(rsp.data, "orderSn");
        String tradeNo = BaseModel.getString(rsp.data, "tradeNo");
        nextPage(PromptQRPage(order, qrImage, orderSn, tradeNo, productId: widget.productId, isLottery: widget.isLottery), false);
      } else if(payModel?.payType == 4) { //余额支付
        nextPage(PaySuccessPage(productId: widget.productId, isLottery: widget.isLottery), false);
      } else {
        ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_order_not_support_pay));
      }
    } else {
      if (payModel?.payType == 4) { //余额支付
        ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_order_insufficient_balance));
      } else {
        ViewUtils.displayToast(rsp.msg);
      }
    }
    ViewUtils.dismiss();
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
        child: Container(
          margin: EdgeInsets.fromLTRB(70.w, 20.w, 70.w, 20.w),
          child: BigTextButton(
              text: LanguageConfig.get(LanguageConfigKeys.Shop_order_confirm_pay),
              onTap: () async{
                if(showTimeout) {
                  ViewUtils.showRemindDialog(context,
                      LanguageConfig.get(LanguageConfigKeys.Shop_order_timeout),
                      LanguageConfig.get(LanguageConfigKeys.Shop_order_place_new_order),
                      LanguageConfig.get(LanguageConfigKeys.Shop_order_iknow), barrierDismissible: true, (ctx) {
                        backHome();
                      }
                  );
                  return;
                }
                PayModel? payModel = getSelectPay();
                if (payModel?.payType == 4) { //余额支付，才需要支付密码
                  double balance = BaseModel.getDouble(userInfo, "balance");
                  double payAmount = BaseModel.getDouble(order, "payAmount");
                  if (payAmount > balance) {
                    ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_order_insufficient_balance));
                    return;
                  }
                  checkIsSetPayPwd();
                } else { //其他支付不需要密码
                  if (TextUtils.isNotEmpty(orderSn) && TextUtils.isNotEmpty(tradeNo) && payModel?.payType == 2) { //银行支付查询
                    bool isPaySuccess = await payResult();
                    if (isPaySuccess) {
                      nextPage(PaySuccessPage(productId: widget.productId, isLottery: widget.isLottery), false);
                    }else {
                      confirmPay();
                    }
                  } else {
                    confirmPay();
                  }
                }
              }
          ),
    ));
  }

  String getHttpUrl() {
    PayModel? payModel = getSelectPay();
    if (widget.isShopPay) {
      if(payModel?.payType == 4) {
        return IURLConstant.MALL_ORDER_BALANCE_PAYAPPLY_SHOP;
      } else {
        return IURLConstant.MALL_ORDER_PAYAPPLY_SHOP;
      }
    } else {
      if(payModel?.payType == 4) {
        return IURLConstant.MALL_ORDER_BALANCE_PAYAPPLY;
      } else {
        return IURLConstant.MALL_ORDER_PAYAPPLY;
      }
    }
  }

  PayModel? getSelectPay() {
    PayModel? payModel;
    for (PayModel model in payList) {
      if (model.isSelect) {
        payModel = model;
        break;
      }
    }
    return payModel;
  }

  Map<String, dynamic> getHttpParams() {
    PayModel? payModel = getSelectPay();
    String orderId = BaseModel.getString(order, "id");
    String orderSn = BaseModel.getString(order, "orderSn");
    String returnUrl = FormatUtil.getReturnUrl(orderSn);
    String language = "en";
    switch (LanguagePage.language) {
      case "ZH":
        language = "zh-CN";
        break;
      case "TH":
        language = "th";
        break;
      default:
        language = "en";
        break;
    }
    if (widget.isShopPay) {
      return {
        "orderShopId": orderId,
        "sourceType": "1",
        "returnUrl": returnUrl,
        "language": language,
        "payType": "${payModel?.payType}",
        "bankCode": payModel?.bankCode,
      };
    } else {
      return {
        "orderId": orderId,
        "sourceType": "1",
        "returnUrl": returnUrl,
        "language": language,
        "payType": "${payModel!.payType}",
        "bankCode": payModel.bankCode
      };
    }
  }

  void showTimeoutDialog() {
     if(!showTimeout) {
       showTimeout = true;
       ViewUtils.showRemindDialog(context,
           LanguageConfig.get(LanguageConfigKeys.Shop_order_timeout),
           LanguageConfig.get(LanguageConfigKeys.Shop_order_place_new_order),
           LanguageConfig.get(LanguageConfigKeys.Shop_order_iknow), barrierDismissible: true, (ctx) {
             backHome();
           }
       );
     }
  }

  void showExitDialog() {
    ViewUtils.showRemindDialog2(context,
        LanguageConfig.get(LanguageConfigKeys.Shop_order_confirm_close_title),
        LanguageConfig.get(LanguageConfigKeys.Shop_order_confirm_close_message),
        LanguageConfig.get(LanguageConfigKeys.Shop_order_confirm_close),
        LanguageConfig.get(LanguageConfigKeys.Shop_order_confirm_continue), (ctx, event) {
          if (event == DialogEvent.cancel) {
            backHome();
            nextPage(OrderPage("0"), false);
          } else {
            finishContext(ctx);
          }
        }
    );
  }

}
