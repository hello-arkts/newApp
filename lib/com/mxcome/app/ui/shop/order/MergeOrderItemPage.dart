
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/coupon/UseCouponPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/OutlineTextButton.dart';
import 'package:sprintf/sprintf.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseModel.dart';
import '../utils/FormatUtil.dart';
import '../widget/LoadImageView.dart';
import '../widget/PriceText.dart';
import '../widget/SmallTextButton.dart';


class MergeOrderItemPage extends StatefulWidget {

  List<dynamic> orderShopDetailsList;

  int orderType;

  Function(BuildContext ctx,) cancelOrderCallBack;

  Function(BuildContext ctx,) commitOrderCallBack;

  MergeOrderItemPage(this.orderShopDetailsList, this.orderType, {required this.commitOrderCallBack, required this.cancelOrderCallBack,});

  @override
  State<StatefulWidget> createState() {
    return MergeOrderItemPageState();
  }

}

class MergeOrderItemPageState extends BaseKeepAliveState<MergeOrderItemPage> {

  List<dynamic> _orderShopDetailsList = [];

  @override
  void initState() {
    super.initState();
    _orderShopDetailsList = widget.orderShopDetailsList;
    loadContentDatas();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(widget.orderType == 0 ? LanguageConfig.get(LanguageConfigKeys.Shop_order_merge_pay): LanguageConfig.get(LanguageConfigKeys.Shop_order_merge_cancel),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: ListView.separated(
          scrollDirection: Axis.vertical,
          itemCount: _orderShopDetailsList.length,
          itemBuilder: (context, idx) {
            return buildMergeOrderShopItem(idx);
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 16.w);
          }),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildMergeOrderShopItem(int index) {
    dynamic item = _orderShopDetailsList[index];
    return Container(
      padding: EdgeInsets.only(left: 16.5.w, right: 26.w, top: 10.w, bottom: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  LoadImageView(32.w, 32.w, BaseModel.getString(item, 'shopIcon')),
                  SizedBox(width: 9.w,),
                  Text(BaseModel.getString(item, 'shopName'), style: TextStyle(color: IConstant.text_color, fontSize: 16.sp),)
                ],
              ),
              PriceText(BaseModel.getDouble(item, 'payAmount'), fontSize: 14.sp, color: IConstant.main_color,),
            ],
          ),
          Padding(padding: EdgeInsets.only(left: 41.w), child: Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_order_piece_in_total), [BaseModel.getInt(item, 'buyQuantity')]), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),)
        ],
      ),
    );
  }

  BottomAppBar buildBottomBar() {
    return widget.orderType == 0 ? BottomAppBar(
      height: 110.w,
      elevation: 0.w,
      child: Container(
        height: 40.w,
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: 29.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 128.w,
              child: SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.ViewUtils_cancel), bgColor: IConstant.white_bg_color, textColor: IConstant.text_color, onTap: () {
                Navigator.pop(context);
              }),
            ),
            SizedBox(width: 12.w),
            SizedBox(
              width: 128.w,
              child: SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_now_pay), onTap: () {
                widget.commitOrderCallBack(context);
              }),
            )
          ],
        ),
      ),
    ): BottomAppBar(
      height: 110.w,
      elevation: 0.w,
      child: Container(
        height: 40.w,
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: 29.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 128.w,
              child: SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_cancel_back), bgColor: IConstant.white_bg_color, textColor: IConstant.text_color, onTap: () {
                Navigator.pop(context);
              }),
            ),
            SizedBox(width: 12.w),
            SizedBox(
              width: 128.w,
              child: SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_cancel_order), onTap: () {
                widget.cancelOrderCallBack(context);
              }),
            )
          ],
        ),
      ),
    );
  }

}
