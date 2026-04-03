import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/SmallTextButton.dart';
import 'package:mxcome/com/mxcome/app/utils/AppUtils.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IURLConstant.dart';
import '../../../../config/LanguageConfig.dart';
import '../../../../model/BaseModel.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/HttpUtils.dart';
import '../../../../utils/TextUtils.dart';
import '../../../../utils/ViewUtils.dart';
import '../../event/BankEvent.dart';
import '../../utils/EventBusUtil.dart';
import '../../utils/FormatUtil.dart';
import '../../widget/GenAvatar.dart';
import '../../widget/LoadImageView.dart';
import '../../widget/PriceText.dart';
import '../member/IDCardVerifiedPage.dart';
import '../member/IDCardVerifyingPage.dart';
import 'AddBankPage.dart';
import 'BalanceListPage.dart';
import 'BankCardPage.dart';
import 'IncomeDetailPage.dart';
import 'WithdrawalPage.dart';

class WalletPage extends StatefulWidget {

  WalletPage();

  @override
  State<StatefulWidget> createState() {
    return WalletPageState();
  }
}

class WalletPageState extends BaseKeepAliveState<WalletPage> {

  dynamic userInfo;

  dynamic bankEvent;

  int idCardStatus = -1;

  List<dynamic> balanceList = [];

  List<dynamic> incomeList = [];

  bool isHide = false;

  @override
  void initState() {
    super.initState();
    bankEvent = EventBusUtil.getInstance().on<BankEvent>((event) {
      loadContentDatas();
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
    bool hide = await AppUtils.getBalanceHide();
    setState(() {
      isHide = hide;
      userInfo = data;
      idCardStatus = BaseModel.getInt(userInfo, "idCardStatus");
    });
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_BALANCE_LIST, {
      "pageNum": "$page", "pageSize": "10"
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        balanceList = BaseModel.isNotEmpty(rsp.data, "list") ? BaseModel.getDynamic(rsp.data, "list") : [];
      });
    }
    loadIncomeInfo();
  }

  Future<void> loadBankCount() async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_BANK_LIST, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<dynamic> bankList = rsp.data;
      if (bankList.isEmpty) { //-1审核不通过, 0未提交，1审核中，2审核通过
        nextPage(AddBankPage(null), false);
      } else {
        nextPage(BankCardPage(), false);
      }
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  Future<void> loadIncomeInfo() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_INCOME_INFO, {
      "pageNum": "$page", "pageSize": "100"
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        incomeList =  BaseModel.isNotEmpty(rsp.data, "list") ? BaseModel.getDynamic(rsp.data, "list") : [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_wallet),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
        actions: [
          InkWell(
            onTap: () async {
              if (await checkIDCard()) {
                loadBankCount();
              }
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
              child: Image.asset("assets/icons/bank_card.png"),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          buildMember(),
          buildBalance(),
          buildRecord(),
        ],
      ),
    );
  }

  Widget buildMember() {
    return Container(
      margin: EdgeInsets.fromLTRB(12.w, 0.w, 12.w, 0.w),
      padding: EdgeInsets.only(top: 10.w, bottom: 10.w),
      child: Row(
        children: [
          ClipOval(child: buildAvatar()),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(constraints: BoxConstraints(maxWidth: 130.w),child: Text(getDisplayName(), style: TextStyle(fontSize: 15.sp, color: IConstant.text_color), maxLines: 3,)),
                  //Text(getDisplayName()),
                  SizedBox(width: 4.w),
                  idCardStatus == 2 ? Image.asset("assets/icons/flower.png", width: 18.w, height: 18.w) : Container(),
                ],
              ),
              SizedBox(height: 4.w,),
              Text(BaseModel.getString(userInfo, "generatorId"), style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color))
            ],
          ),
          expandeSpace,
          Container(
            padding: EdgeInsets.fromLTRB(10.w, 2.w, 10.w, 2.w),
            decoration: BoxDecoration(
              color: IConstant.red_bg_color3,
              border: Border.all(width: 1, color: IConstant.white_color),
              borderRadius: BorderRadius.all(Radius.circular(12.w)),
            ),
            child: Row(
              children: [
                Image.asset("assets/icons/safe.png", height: 11.w),
                SizedBox(width: 4.w),
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_wallet_mxcome),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11.sp, color: IConstant.main_color))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildBalance() {
    return Card(
      margin: EdgeInsets.fromLTRB(12.w, 12.w, 12.w, 0),
      elevation: 4.w,
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadiusDirectional.circular(8)),
      child: Container(
          padding: EdgeInsets.all(12.w),
          child: Column(
            children: [
              ListTile(
                title: Row(
                  children: [
                    Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_account_balance),
                        style: TextStyle(fontSize: 15.sp, color: IConstant.text_color)),
                    SizedBox(width: 6.w),
                    buildEye()
                  ],
                ),
                subtitle: buildBalanceAmount(),
                trailing: SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_wallet_withdrawal), onTap: () => {
                  nextPage(WithdrawalPage(""), false)
                }),
              ),
              SizedBox(height: 16.w),
              Divider(height: 1.w),
              SizedBox(height: 16.w),
              Row(
                children: [
                  SizedBox(width: 20.w),
                  Expanded(flex: 1, child: SizedBox(height: 50.w, child: InkWell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            LanguageConfig.get(LanguageConfigKeys.Shop_mine_gold_coin),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 13.sp, color: IConstant.sub_text_color)),
                        expandeSpace,
                        PriceText(BaseModel.getDouble(userInfo, "goldCoin"), fontSize: 15.sp, fontWeight: FontWeight.bold, color: IConstant.main_color, isFormat: false),
                      ],
                    ),
                  ))),
                  SizedBox(width: 20.w),
                  Expanded(flex: 1, child: SizedBox(height: 55.w, child: InkWell(
                    onTap: () => nextPage(IncomeDetailPage(), false),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 60.w, child: Text(
                                LanguageConfig.get(LanguageConfigKeys.Shop_wallet_mxget_income),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13.sp, color: IConstant.sub_text_color)),),
                            incomeList.isNotEmpty ? buildIncomeDetail() : Container(),
                            expandeSpace,
                          ],
                        ),
                        expandeSpace,
                        PriceText(BaseModel.getDouble(userInfo, "withdrawalBalance"), fontSize: 15.sp, fontWeight: FontWeight.bold, color: IConstant.main_color),
                      ],
                    ),
                  ))),
                ],
              ),
            ],
          )),
    );
  }

  Widget buildIncomeDetail() {
    dynamic selectModel;
    for (var item in incomeList) {
      int status = BaseModel.getInt(item, "status"); //动态收益：0 1  转入余额：-1  退单：-2
      if (status == 0 || status == 0 ||status == -2 ) {
        selectModel = item;
        break;
      }
    }
    if (selectModel != null) {
      int status = BaseModel.getInt(selectModel, "status"); //动态收益：0 1  转入余额：-1  退单：-2
      if (status == 0 || status == 1) {
        return Container(
          padding: EdgeInsets.fromLTRB(4.w, 2.w, 4.w, 2.w),
          child: Text("+${FormatUtil.price2String(BaseModel.getDouble(selectModel, "balance"))}",
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.green_color)),
        );
      } else {
        return Container(
          padding: EdgeInsets.fromLTRB(4.w, 2.w, 4.w, 2.w),
          child: Text("-${FormatUtil.price2String(BaseModel.getDouble(selectModel, "balance"))}",
              style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.bold, color: IConstant.main_color)),
        );
      }
    } else {
      return Text(FormatUtil.price2String(0),
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.green_color));
    }
  }

  Future<bool> checkIDCard() async {
    if (!await checkIDCardVerified()) { //先实名认证
      int idCardStatus = BaseModel.getInt(userInfo, "idCardStatus"); //-1审核不通过, 0未提交，1审核中，2审核通过
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

  Widget buildBalanceAmount() {
    if (isHide) {
      return Text("******", style: TextStyle(fontSize: 30.sp, color: IConstant.title_color));
    } else {
      double balance = BaseModel.getDouble(userInfo, "balance");
      return Text(FormatUtil.price2String(balance), style: TextStyle(fontSize: 24.sp, color: IConstant.title_color));
    }
  }

  Widget buildEye() {
    if (isHide) {
      return InkWell(onTap: () async {
        setState(() {
          isHide = !isHide;
        });
        await AppUtils.setBalanceHide(isHide);
      }, child: Image.asset("assets/icons/eye_hide.png", width: 18.w, height: 18.w));
    } else {
      return InkWell(onTap: () async {
        setState(() {
          isHide = !isHide;
        });
        await AppUtils.setBalanceHide(isHide);
      }, child: Image.asset("assets/icons/eye.png", width: 18.w, height: 18.w));
    }
  }

  Widget buildRecord() {
    return Card(
      margin: EdgeInsets.fromLTRB(12.w, 12.w, 12.w, 0),
      elevation: 0.2.w,
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadiusDirectional.circular(8)
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_wallet_balance_detail), style: TextStyle(fontSize: 15.sp, color: IConstant.text_color)),
            trailing: InkWell(
              onTap: () {
                nextPage(BalanceListPage(), false);
              },
              child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_wallet_all), style: TextStyle(fontSize: 15.sp, color: IConstant.grey_color)),
            ),
          ),
          Column(
            children: balanceList.map((item) => buildListItem(item)).toList()
          )
        ],
    ));
  }

  String getDisplayName() {
    String nickname = BaseModel.getString(userInfo, "nickname");
    String username = BaseModel.getString(userInfo, "username");
    String phoneCode = BaseModel.getString(userInfo, "phoneCode");
    String phone = BaseModel.getString(userInfo, "phone");
    return TextUtils.isNotEmpty(nickname) ? nickname: "$phoneCode $phone";
  }

  Widget buildAvatar() {
    String avatar = BaseModel.getString(userInfo, "icon");
    if (TextUtils.isNotEmpty(avatar)) {
      return SizedBox(
        width: 60.w,
        height: 60.w,
        child: GenAvatar(avatar),
      );
    } else {
      String displayName = getDisplayName();
      return Container(
          width: 60.w,
          height: 60.w,
          color: IConstant.red_translucent_color,
          child: Center(
              child: Text(TextUtils.isNotEmpty(displayName) ? displayName.substring(0, 1) : "",
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 20.sp, color: IConstant.white_color))));
    }
  }

  Widget buildListItem(dynamic item) {
    return ListTile(
      title: Text(getItemType(item),
          style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
      subtitle: Text(BaseModel.getString(item, "createTime"),
          style: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color)),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          buildChangeBalance(item),
          Text("${LanguageConfig.get(LanguageConfigKeys.Shop_wallet_balance)} ${FormatUtil.price2String(BaseModel.getDouble(item, "accountBalance"))}",
              style: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color)),
        ],
      ),
    );
  }

  Widget buildChangeBalance(dynamic item) {
    int type = BaseModel.getInt(item, "type");
    if (type == 2 || type == 4 || type == 6 || type == 10) {
      return Container(
        padding: EdgeInsets.fromLTRB(4.w, 2.w, 4.w, 2.w),
        decoration: BoxDecoration(
          color: IConstant.red_bg_color3,
          borderRadius: BorderRadius.all(Radius.circular(4.w)),
        ),
        child: Text("-${FormatUtil.priceAbs2String(BaseModel.getDouble(item, "changeBalance"))}",
            style: TextStyle(fontSize: 12.sp, color: IConstant.main_color)),
      );
    } else {
      return Container(
        padding: EdgeInsets.fromLTRB(4.w, 2.w, 4.w, 2.w),
        decoration: BoxDecoration(
          color: IConstant.green_bg_color,
          borderRadius: BorderRadius.all(Radius.circular(4.w)),
        ),
        child: Text("+${FormatUtil.price2String(BaseModel.getDouble(item, "changeBalance"))}",
            style: TextStyle(fontSize: 12.sp, color: IConstant.green_color)),
      );
    }
  }

  String getItemType(dynamic item){
    int type = BaseModel.getInt(item, "type"); //1充值，2提现，3任务分润，4购买商品，5退款，6提现手续费
    if (type == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_recharge);
    } else if (type == 2) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_withdrawal);
    } else if (type == 3) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_task_profit_sharing);
    } else if (type == 4)  {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_buy_goods);
    } else if (type == 5)  {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_refund);
    } else if (type == 6)  {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_service_charges_fee);
    } else if (type == 7)  {
      return "${LanguageConfig.get(LanguageConfigKeys.Shop_wallet_withdrawal)}     ${LanguageConfig.get(LanguageConfigKeys.Shop_wallet_withdrawal_fail)}";
    } else if (type == 8)  {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_service_charges_fee);
    } else if (type == 9)  {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_red_packet_withdrawal);
    }else if (type == 10)  {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_chargeback);
    }else if (type == 11)  {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_rebate);
    }else if (type == 12)  {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_daily_benefits);
    }else if (type == 13)  {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_newcomer_join);
    }else {
      return "Unknown";
    }
  }

}
