
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/BankEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/BankModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/OutlineTextButton.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IURLConstant.dart';
import '../../../../config/LanguageConfig.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/HttpUtils.dart';
import '../../../../utils/ViewUtils.dart';
import '../../utils/EventBusUtil.dart';
import '../../utils/FormatUtil.dart';
import '../../widget/LoadImageView.dart';
import 'WithdrawalPage.dart';

class BankCardDetailPage extends StatefulWidget {

  BankModel bank;

  BankCardDetailPage(this.bank);

  @override
  State<StatefulWidget> createState() {
    return BankCardDetailPageState();
  }

}

class BankCardDetailPageState extends BaseKeepAliveState<BankCardDetailPage> {

  late BankModel _bank;

  dynamic bankEvent;

  List<BankModel> bankList = [];


  @override
  void initState() {
    super.initState();
    _bank = widget.bank;
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
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildBody() {
    BankModel item = _bank;
    return Column(
      children: [
        Container(
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
                Padding(padding: EdgeInsets.fromLTRB(18.w, 20.w, 18.w, 20.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipOval(
                          child: LoadImageView(40.w, 40.w, item.bankLogo),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.bankName, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 25.sp, color: IConstant.white_color)),
                              // Text(LanguageConfig.get(LanguageConfigKeys.Shop_wallet_card_tip), style: TextStyle(fontSize: 12.sp, color: IConstant.white_color)),
                              SizedBox(height: 20.w),
                              Text(TextUtil.formatSpace4(item.cardNumber), style: TextStyle(fontSize: 12.sp, color: IConstant.white_color)),
                              SizedBox(height: 20.w),
                              // Text("EXP ${formatValidate(item.validDate)}", style: TextStyle(fontSize: 12.sp, color: IConstant.white_color)),
                            ],
                          ),
                        ),
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
        expandeSpace,
      ],
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

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      child: Container(
        margin: EdgeInsets.only(left: 10.w, right: 10.w),
        height: 60.w,
        child: Row(
          children: [
            SizedBox(width: 20.w),
            // Expanded(
            //   flex: 1,
            //   child: OutlineTextButton(text: LanguageConfig.get(LanguageConfigKeys.Base_delete),
            //     bgColor: IConstant.white_color,
            //     borderColor: IConstant.line_color,
            //     textColor: IConstant.text_color,
            //     onTap: () {
            //       deleteDialog();
            //   },),
            // ),
            // SizedBox(width: 20.w),
            Expanded(
              flex: 1,
              child: OutlineTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_wallet_withdrawal),
                  bgColor: IConstant.red_bg_color3,
                  borderColor: IConstant.red_bg_color3,
                  textColor: IConstant.main_color,
                onTap: () {
                  nextPage(WithdrawalPage(_bank.cardNumber), false);
              },),
            ),
            SizedBox(width: 20.w),
          ],
        ),
      ),
    );
  }

  void deleteDialog() {
    ViewUtils.showConfirmDialog(context, LanguageConfig.get(LanguageConfigKeys.Shop_bank_delete_card), (ctx, bl) {
      if (bl) {
        finishContext(ctx);
        delete();
      } else {
        finishContext(ctx);
      }
    });
  }

  Future<void> delete() async {
    ViewUtils.show();
    String url = IURLConstant.MALL_DELETE_BANK;
    BaseRsp rsp = await HttpUtils.post(url, {
      "id": _bank.id
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_operation_successful));
      EventBusUtil.getInstance().emit(BankEvent());
      setState(() {
        finishContext(context);
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

}
