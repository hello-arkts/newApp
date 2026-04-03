

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/wallet/WithdrawalPwdCheckPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';
import 'package:sprintf/sprintf.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IURLConstant.dart';
import '../../../../config/LanguageConfig.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/Adapt.dart';
import '../../../../utils/AppUtils.dart';
import '../../../../utils/HttpUtils.dart';
import '../../../../utils/TextUtils.dart';
import '../../../../utils/ViewUtils.dart';
import '../../../../widget/PartRefreshWidget.dart';
import '../../event/BankEvent.dart';
import '../../event/UserInfoEvent.dart';
import '../../utils/EventBusUtil.dart';
import '../../utils/ShowBottomSheetTool.dart';
import '../../widget/CommResultPage.dart';
import '../../widget/BigTextButton.dart';
import '../member/IDCardVerifiedPage.dart';
import '../member/IDCardVerifyingPage.dart';
import '../setting/SettingPayPwdPage.dart';
import 'AddBankPage.dart';

class WithdrawalPage extends StatefulWidget {

  String cardNumber = "";

  WithdrawalPage(this.cardNumber);

  @override
  State<StatefulWidget> createState() {
    return WithdrawalPageState();
  }

}

class WithdrawalPageState extends BaseKeepAliveState<WithdrawalPage> {

  dynamic withdrawInfo;

  int idCardStatus = 0;

  bool isClickEnable = false;

  double feeWithdraw = 0;

  String amount = '';

  List<dynamic> bankList = [];

  int currentIndex = 0;

  dynamic bankEvent;

  final FocusNode _nodeText1 = FocusNode();

  @override
  void initState() {
    super.initState();
    bankEvent = EventBusUtil.getInstance().on<BankEvent>((event) {
      loadContentDatas();
      setState(() {
        amount = "";
      });
      checkInput();
    });
    loadContentDatas();
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(bankEvent);
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    dynamic data = await AppUtils.getUserInfo();
    setState(() {
      idCardStatus = BaseModel.getInt(data, "idCardStatus");
    });
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_BANK_LIST, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        bankList = rsp.data;
        for (int i= 0; i < bankList.length; i++) {
          if(BaseModel.getString(bankList[i], "cardNumber") == widget.cardNumber) {
            currentIndex = i;
            break;
          }
        }
      });
    }
    loadWithdrawInfo();
  }

  Future<void> loadWithdrawInfo() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_OSS_GET_WITHDRAW_INFO, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        withdrawInfo = rsp.data;
        if (BaseModel.getInt(withdrawInfo, "feeWithdrawMemberOpen") == 1) { //关闭：0；开启：1
          feeWithdraw = BaseModel.getDouble(withdrawInfo, "feeWithdraw");
        } else {
          feeWithdraw = 0;
        }
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return KeyboardDismissOnTap(child: Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.5.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_wallet_withdrawal),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: ListView(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 4.w),
              child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_wallet_bank_card_bind),
                  style: TextStyle(fontSize: 15.sp, color: IConstant.text_color)),
            ),
            buildBank(),
            Container(
              margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 10.w),
              decoration: BoxDecoration(
                  border: Border.all(color: IConstant.line_color, width: 1.w),
                  borderRadius: BorderRadius.all(Radius.circular(10.w))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 0.w),
                      child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_withdrawal_amount),
                          style: TextStyle(fontSize: 15.sp, color: IConstant.text_color))),
                  Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 0.w),
                      child: Row(
                        children: [
                          Text(IConstant.currency,
                              style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
                          SizedBox(width: 4.w),
                          Expanded(child: TextField(
                            textInputAction: TextInputAction.done,
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            focusNode: _nodeText1,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp("[0-9.]")),//数字.
                            ],
                            style: TextStyle(color: IConstant.title_color, fontSize: 24.sp),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelStyle: TextStyle(fontSize: 24.sp, color: IConstant.grey_color),
                            ),
                            controller: ViewUtils.buildTextEditingController(amount, listener: (str) {
                              amount = str;
                              checkInput();
                            }),
                          ))
                        ],
                      )),
                  Container(
                      height: 1.w, color: IConstant.line_color),
                  Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
                      child: Row(
                        children: [
                          Expanded(child:  Text(getWithdrawalBalance(),
                              style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))),
                          Container(
                              margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 0.w),
                              width: 1.w, height: 20.w, color: IConstant.grey_line_color),
                          Expanded(child:  Text(getTodayWithdrawalBalance(),
                              style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)))
                        ],
                      )
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 10.w),
              padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 16.w),
              decoration: BoxDecoration(
                  color: IConstant.line_color,
                  border: Border.all(color: IConstant.line_color, width: 1.w),
                  borderRadius: BorderRadius.all(Radius.circular(10.w))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(LanguageConfig.get(LanguageConfigKeys.Shop_wallet_cash_withdrawal_rules),
                          style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                      Text("*",
                          style: TextStyle(fontSize: 12.sp, color: IConstant.main_color))
                    ],
                  ),
                  SizedBox(height: 10.w),
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_withdrawal_amount_tip1),
                      style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color)),
                  SizedBox(height: 10.w),
                  Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_withdrawal_amount_tip2), [ feeWithdraw ]),
                      style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color)),
                  SizedBox(height: 10.w),
                  Text(LanguageConfig.get(LanguageConfigKeys. Shop_wallet_withdrawal_time_tip),
                      style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color)),
                ],
              ),
            )
          ]
      ),
      bottomNavigationBar: buildBottomBar(),
    ));
  }

  Widget buildBank() {
    return bankList.isEmpty ? InkWell(
        onTap: () async {
          if (await checkIDCard()) {
            nextPage(AddBankPage(null), false);
          }
        },
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 10.w),
        padding: EdgeInsets.fromLTRB(0.w, 10.w, 0.w, 10.w),
        child: Row(
          children: [
            Text(LanguageConfig.get(LanguageConfigKeys.Shop_bank_add_card),
                style: TextStyle(fontSize: 15.sp, color: IConstant.text_color)),
            expandeSpace,
            Icon(Icons.chevron_right, size: 20.w)
          ],
        ),
      ),
    ) : InkWell(
      onTap: () {
        List<String> bankArr = [];
        for (int i = 0; i < bankList.length; i++){
          bankArr.add("${getBankName(i)}${getCardNumber(i)}");
        }
        ShowBottomSheetTool().showSingleRowPicker(context, data: bankArr, title: LanguageConfig.get(LanguageConfigKeys.Shop_mine_select_bank), normalIndex: currentIndex, clickCallBack: (int selectIndex, Object selectStr){
          setState(() {
            currentIndex = selectIndex;
          });
        });
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 10.w),
        padding: EdgeInsets.fromLTRB(0.w, 10.w, 0.w, 10.w),
        child: Row(
          children: [
            Text(getBankName(currentIndex),
                style: TextStyle(fontSize: 15.sp, color: IConstant.text_color)),
            Expanded(child: Text(getCardNumber(currentIndex),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15.sp, color: IConstant.text_color))),
            Icon(Icons.chevron_right, size: 20.w)
          ],
        ),
      ),
    );
  }

  Future<bool> checkIDCard() async {
    if (!await checkIDCardVerified()) { //先实名认证
      if (idCardStatus == -1) { //审核不通过
        nextPage(IDCardVerifyingPage(verifying: false), false);
      } else if (idCardStatus == 1) { //审核中
        nextPage(IDCardVerifyingPage(verifying: true), false);
      } else { //未提交，审核通过
        nextPage(IDCardVerifiedPage(), false);
      }
      return false;
    }
    return true;
  }

  String getBankName(int index) {
    dynamic item = bankList[index];
    return BaseModel.getString(item, "bankName");
  }

  String getCardNumber(int index) {
    dynamic item = bankList[index];
    String cardNumber = BaseModel.getString(item, "cardNumber");
    return "(${FormatUtil.hideCardNumber(cardNumber)})";
  }

  String getWithdrawalBalance() {
    double withdrawalBalance = BaseModel.getDouble(withdrawInfo, "balance");
    return "${LanguageConfig.get(LanguageConfigKeys.Shop_mine_withdrawal_balance)}: ${FormatUtil.price2String(withdrawalBalance)}";
  }

  String getTodayWithdrawalBalance() {
    double remainderAmount = BaseModel.getDouble(withdrawInfo, "remainderAmount");
    return "${LanguageConfig.get(LanguageConfigKeys.Shop_mine_today_withdrawal_balance)}: ${FormatUtil.price2String(remainderAmount)}";
  }

  void checkInput() {
    if (bankList.isNotEmpty && TextUtils.isNotEmpty(amount)) {
      if (isClickEnable) return;
      isClickEnable = true;
      refreshBtn.currentState?.update();
    } else {
      if (!isClickEnable) return;
      isClickEnable = false;
      refreshBtn.currentState?.update();
    }
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      elevation: 0.w,
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
        height: 50.w,
        alignment: Alignment.center,
        child: SizedBox(
          width: 180.w,
          child: buildSubmit(),
        ),
      ),
    );
  }

  GlobalKey<PartRefreshWidgetState> refreshBtn = GlobalKey();

  Widget buildSubmit() {
    return PartRefreshWidget(refreshBtn, () => BigTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_mine_verify_confirm), enable: isClickEnable, onTap: () {
      withdrawal();
    }));
  }

  void withdrawal() {
    if(!check()) return;
    checkIsSetPayPwd();
  }

  Future<void> startWithdrawal() async {
    ViewUtils.show();
    dynamic item = bankList[currentIndex];
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_OSS_WITHDRAW, {
      "bankId": BaseModel.getString(item, "id"),
      "amount": amount,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      showPop(0.3 * Adapt.getWindowHeight(), CommResultPage(
          title: LanguageConfig.get(LanguageConfigKeys.Base_submit_success),
          message: Text(LanguageConfig.get(LanguageConfigKeys.Shop_wallet_withdrawal_tip), style: TextStyle(fontSize: 14.sp, color: IConstant.title_color)),
          callBack: (BuildContext ctx1) {
            finishContext(ctx1);
            backHome();
          }));
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  bool check() {
    double inputBalance = double.parse(amount);
    double balance = BaseModel.getDouble(withdrawInfo, "balance");
    double remainderAmount = BaseModel.getDouble(withdrawInfo, "remainderAmount");
    if (inputBalance <= 0) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_wallet_withdrawal_amount_tip));
      return false;
    }
    if (inputBalance > remainderAmount) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_wallet_today_withdrawal_balance_tip));
      return false;
    }
    if (inputBalance > balance) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_wallet_withdrawal_balance_tip));
      return false;
    }
    if (inputBalance % 100 != 0) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_mine_withdrawal_amount_tip1));
      return false;
    }
    return true;
  }

  Future<void> checkIsSetPayPwd() async {
    dynamic userInfo = await AppUtils.getUserInfo();
    int isSetPay = BaseModel.getInt(userInfo, "isSetPay");
    if (isSetPay == 1) {
      showPop(0.8 * Adapt.getWindowHeight(), WithdrawalPwdCheckPage(double.parse(amount), feeWithdraw, (ctx) {
        finishContext(ctx);
        startWithdrawal();
      }));
    } else {
      nextPage(SettingPayPwdPage((ctx) { //设置支付密码
        setPayPwdEnd(ctx);
      }), false);
    }
  }

  void setPayPwdEnd(BuildContext ctx) {
    finishContext(ctx);
    EventBusUtil.getInstance().emit(UserInfoEvent());
    showPop(0.8 * Adapt.getWindowHeight(), WithdrawalPwdCheckPage(double.parse(amount), feeWithdraw, (ctx) {
      finishContext(ctx);
      startWithdrawal();
    }));
  }
}
