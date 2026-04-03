
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../config/LanguageConfig.dart';
import '../brand/BrandShopPage.dart';
import '../model/CartItem.dart';
import '../model/ConfirmModel.dart';
import '../model/ConfirmTitleModel.dart';
import '../widget/LoadImageView.dart';
import '../widget/OutlineTextButton.dart';
import '../widget/PriceText.dart';
import 'OrderPage.dart';

class FreightPage extends StatefulWidget {

  double freightAmount = 0;

  List<ConfirmTitleModel> confirmTitleList = [];

  FreightPage(this.freightAmount, this.confirmTitleList);

  @override
  State<StatefulWidget> createState() {
    return FreightPageState();
  }
}

class FreightPageState extends BaseKeepAliveState<FreightPage> {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        title: Text(
            LanguageConfig.get(LanguageConfigKeys.Shop_order_freight_details),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: buildFreightList(),
    );
  }

  Widget buildFreightList() {
    List<ConfirmTitleModel> freightList = [];
    for (var titleModel in widget.confirmTitleList) {
      List<ConfirmModel> dataList = [];
      for (var confirmModel in titleModel.dataList) {
        dataList.add(confirmModel);
      }
      if (dataList.isNotEmpty) {
        freightList.add(ConfirmTitleModel(titleModel.shopId, titleModel.shopName, titleModel.shopIcon, dataList));
      }
    }
    return Column(
      children: freightList.map((item) => buildFreightTitle(item)).toList(),
    );
  }

  Widget buildFreightTitle(ConfirmTitleModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildMerchant(model),
        Column(
          children: model.dataList.map((item) => buildFreightItem(item)).toList(),
        ),
      ],
    );
  }

  Widget buildMerchant(ConfirmTitleModel item) {
    return InkWell(
        onTap: () {
          nextPage(BrandShopPage(item.shopId), false);
        },
        child: Container(
          margin: EdgeInsets.only(left: 10.w),
          height: 40.w,
          child: Row(
            children: [
              ClipOval(child: LoadImageView(36.w, 36.w, item.shopIcon)),
              SizedBox(width: 6.w),
              Text(item.shopName, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
              Icon(Icons.chevron_right, size: 20.w, color: IConstant.text_color,),
            ],
          ),
        )
    );
  }

  Widget buildFreightItem(ConfirmModel item) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(16.w, 6.w, 18.w, 0.w),
          child: Row(
            children: [
              Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(8.w)),
                  clipBehavior: Clip.antiAlias,
                  elevation: 1.w,
                  child: LoadImageView(70.w, 70.w, item.productPic)),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: Text(item.productName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13.sp, color: IConstant.text_color),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: Text(
                          CartItem.getProductAttrValues(item.productAttr),
                          style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color),
                        ),
                      ),
                      SizedBox(height: 4.w),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: Text(
                              LanguageConfig.get(LanguageConfigKeys.Shop_order_freight),
                              style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color),
                            ),
                          ),
                          expandeSpace,
                          PriceText(item.freightAmount, fontSize: 12.sp, color: IConstant.text_color)
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ),
      ],
    );
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      child: Container(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        height: 60,
        child: Row(
          children: [
            Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_total_freight),
                style: TextStyle(fontSize: 14.sp, color: IConstant.title_color)),
            expandeSpace,
            PriceText(widget.freightAmount, color: IConstant.text_color)
          ],
        ),
      ),
    );
  }

}
