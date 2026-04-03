
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/BankModel.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IURLConstant.dart';
import '../../../../config/LanguageConfig.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/Adapt.dart';
import '../../../../utils/AppUtils.dart';
import '../../../../utils/HttpUtils.dart';
import '../../../../utils/ViewUtils.dart';
import '../../event/BankEvent.dart';
import '../../utils/EventBusUtil.dart';
import '../../utils/FormatUtil.dart';
import '../../widget/BigTextButton.dart';
import '../../widget/LoadImageView.dart';
import '../member/IDCardVerifiedPage.dart';
import 'AddBankPage.dart';
import 'BankCardDetailPage.dart';

class BankCardPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return BankCardPageState();
  }

}

class BankCardPageState extends BaseKeepAliveState<BankCardPage> {

  List<BankModel> bankList = [];

  dynamic bankEvent;


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
    isLoading = true;
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_BANK_LIST, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<BankModel> tempList = [];
      List<dynamic> dataList = rsp.data;
      for (var item in dataList) {
        tempList.add(BankModel.fromJson(item));
      }
      setState(() {
        bankList = tempList;
      });
    }
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_bank_card),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return bankList.isEmpty ? buildHeader() : ListView.separated(
          scrollDirection: Axis.vertical,
          itemCount: bankList.length + 1,
          itemBuilder: (context, index) {
            return buildCardItem(index);
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 16.w);
          });
  }

  Widget buildCardItem(int index) {
    if (index >= bankList.length) {
      return InkWell(
        onTap: () {
          nextPage(AddBankPage(null), false);
        },
        child: Container(
          decoration: BoxDecoration(
              color: IConstant.red_bg_color,
              borderRadius: BorderRadius.circular(10.w)),
          padding: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 12.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/icons/add_card.png",
                  width: 20.w, height: 20.w),
              SizedBox(width: 4.w),
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_bank_add_card),
                  style: TextStyle(fontSize: 15.sp, color: IConstant.main_color))
            ],
          ),
      ));
    }
    BankModel item = bankList[index];
    return InkWell(
      onTap: () => nextPage(BankCardDetailPage(item), false),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.w),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFF45656),
              Color(0xFFF4A689),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),

        ),
        child: Stack(
          children: [
            Container(
                width: double.maxFinite,
                padding: EdgeInsets.fromLTRB(18.w, 20.w, 18.w, 20.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: LoadImageView(40.w, 40.w, item.bankLogo),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.bankName, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 25.sp, color: IConstant.white_color)),
                        // Text(LanguageConfig.get(LanguageConfigKeys.Shop_wallet_card_tip), style: TextStyle(fontSize: 12.sp, color: IConstant.white_color)),
                        SizedBox(height: 20.w),
                        Text(FormatUtil.hideCardNumber(item.cardNumber), style: TextStyle(fontSize: 12.sp, color: IConstant.white_color)),
                        SizedBox(height: 20.w),
                        // Text("EXP ${formatValidate(item.validDate)}", style: TextStyle(fontSize: 12.sp, color: IConstant.white_color)),
                      ],
                    ))
                  ],
                )
            ),
            // Positioned(top: 6.w, right: 10.w, child: Switch(
            //     value: item.isSelect,
            //     activeColor: IConstant.main_color,
            //     onChanged: (value) {
            //       setState(() {
            //         item.isSelect = !item.isSelect;
            //       });
            //     }
            // )),
            item.isSelect ? Positioned(top: 10.w, right: 12.w, child: Container(
              padding: EdgeInsets.fromLTRB(8.w, 2.w, 8.w, 2.w),
              decoration: BoxDecoration(
                  color: IConstant.white_color,
                  borderRadius: BorderRadius.all(Radius.circular(30.w))
              ),
              child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_address_default), style: TextStyle(fontSize: 11.sp, color: IConstant.main_color)),
            )) : Container(),
          ],
        ),
      ),
    );
  }

  String formatValidate(String validate) {
    if (TextUtils.isNotEmpty(validate)) {
      DateTime endTime = DateTime.parse(validate);
      return FormatUtil.formatYM(endTime);
    } else {
      return "";
    }
  }

  Future<void> addBank(dynamic item) async {
    nextPage(AddBankPage(item), false);
  }

  void update() {

  }

}
