
import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:sprintf/sprintf.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';

import '../../BaseKeepAliveState.dart';
import '../../IConstant.dart';
import '../../IURLConstant.dart';
import '../../model/BaseModel.dart';
import '../../model/BaseRsp.dart';
import '../../utils/HttpUtils.dart';
import '../../utils/ViewUtils.dart';
import '../shop/event/AssetUpdateEvent.dart';
import '../shop/model/SelectModel.dart';
import '../shop/utils/EventBusUtil.dart';
import '../shop/widget/LoadImageView.dart';


class ActionSliderPage extends StatefulWidget {

  String? email;
  String? exchangeAddress;
  dynamic selectCoinInfo;
  List<SelectModel> selectList;

  ActionSliderPage(this.selectCoinInfo, this.selectList, {this.email, this.exchangeAddress, super.key});

  @override
  State<StatefulWidget> createState() => ActionSliderPageState();
}

class ActionSliderPageState extends BaseKeepAliveState<ActionSliderPage> {

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        leading: Container(),
        title: Text(LanguageConfig.get(LanguageConfigKeys.Base_operation_tips),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: StyledText(
            text: sprintf(LanguageConfig.get(LanguageConfigKeys.shop_web3_please_ensure_accurate_and_correct), [ "<black> ${ widget.email != null ? LanguageConfig.get(LanguageConfigKeys.shop_web3_email) : LanguageConfig.get(LanguageConfigKeys.shop_web3_transfer_out_address) } </black>" ]),
            style: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color),
            tags: {
              'black': StyledTextTag(style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.black_color)),
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.w),
          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_web3_financial_losses), style: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color),),
        ),
        Container(
          margin: EdgeInsets.all(16.w),
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
              color: IConstant.line_color,
              borderRadius: BorderRadius.all(Radius.circular(12.w))
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(right: 10.w),
                      child: LoadImageView(30.w, 30.w, BaseModel.getString(widget.selectCoinInfo, "didCoin"))),
                  Text(BaseModel.getString(widget.selectCoinInfo, "didName"), style: TextStyle(fontSize: 15.sp, color: IConstant.text_color, fontWeight: FontWeight.bold)),
                  SizedBox(width: 10.w,),
                  Text("x${widget.selectList.length}", style: TextStyle(fontSize: 13.sp, color: IConstant.main_color),)
                ],
              ),
              Row(
                children: [
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_web3_transfer_fee), style: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color)),
                  Container(
                    margin: EdgeInsets.only(left: 8.w, top: 8.w, bottom: 8.w),
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
                      decoration: BoxDecoration(
                          border: Border.all(color: IConstant.main_color, width: 1.w),
                          borderRadius: BorderRadius.all(Radius.circular(4.w))
                      ),
                    child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_web3_free), style: TextStyle(fontSize: 12.sp, color: IConstant.main_color)),
                  ),
                ],
              ),
              StyledText(
                text: LanguageConfig.get(LanguageConfigKeys.Shop_web3_expected_credited),
                style: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color),
                tags: {
                  'black': StyledTextTag(style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.black_color)),
                },
              ),
            ],
        ),),
        expandeSpace,
        Container(margin: EdgeInsets.symmetric(horizontal: 16.w), child: Center(
          child: ActionSlider.custom(
            backgroundColor: Colors.black,
            foregroundChild: DecoratedBox(
                decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(60.w)),
                child: Icon(Icons.chevron_right, size: 30.w, color: Colors.black)),
            foregroundBuilder: (context, state, child) => child!,
            outerBackgroundBuilder: (context, state, child) => DecoratedBox(
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(60.w)),
              child: Center(child: Text(!_isLoading ? LanguageConfig.get(LanguageConfigKeys.Shop_web3_slide_confirmation) : '', style: TextStyle(fontSize: 16.sp, color: IConstant.white_color),),),
            ),
            backgroundBorderRadius: BorderRadius.circular(60.w),
            action: (controller) async {
              _isLoading = true;
              controller.loading(); //starts loading animation
              submit(controller);
            },
          ),
        )),
        SizedBox(height: 40.w)
      ],
    );
  }

  Future<void> submit(ActionSliderController controller) async {
    if (widget.email != null) {
      ViewUtils.show();
      await Future.delayed(const Duration(seconds: 2));
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_rights_unlocked));
      ViewUtils.dismiss();
      controller.success();
      finish();

      // for (SelectModel model in widget.selectList) {
      //   BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_COIN_TRADE, {
      //     "address": model.value,
      //     "email": widget.email,
      //   });
      //   if (rsp.retCode == RspRetCode.SUCCESS) {
      //     _isLoading = false;
      //     EventBusUtil.getInstance().emit(AssetUpdateEvent());
      //     ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_operation_successful));
      //     controller.success();
      //     finish();
      //   } else {
      //     _isLoading = false;
      //     ViewUtils.displayToast(rsp.msg);
      //     controller.reset();
      //   }
      // }

    } else if (widget.exchangeAddress != null) {
      ViewUtils.show();
      await Future.delayed(const Duration(seconds: 2));
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_rights_unlocked));
      ViewUtils.dismiss();
      controller.success();
      finish();

      // for (SelectModel model in widget.selectList) {
      //   BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_COIN_WITHDRAW, {
      //     "address": model.value,
      //     "exchangeAddress": widget.exchangeAddress,
      //   });
      //   if (rsp.retCode == RspRetCode.SUCCESS) {
      //     _isLoading = false;
      //     EventBusUtil.getInstance().emit(AssetUpdateEvent());
      //     ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_operation_successful));
      //     controller.success();
      //     finish();
      //   } else {
      //     _isLoading = false;
      //     ViewUtils.displayToast(rsp.msg);
      //     controller.reset();
      //   }
      // }

    }
  }

}
