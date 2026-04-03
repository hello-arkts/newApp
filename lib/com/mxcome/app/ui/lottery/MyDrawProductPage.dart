
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/LoadImageView.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';

import '../../IURLConstant.dart';
import '../../model/BaseRsp.dart';
import '../../utils/HttpUtils.dart';
import '../../utils/ViewUtils.dart';
import '../shop/detail/ProductDetailPage.dart';
import '../shop/model/CartItem.dart';
import '../shop/order/OrderConfirmPage.dart';

class MyDrawProductPage extends StatefulWidget {

  MyDrawProductPage();

  @override
  State<StatefulWidget> createState() => MyDrawProductPageState();

}

class MyDrawProductPageState extends BaseKeepAliveState<MyDrawProductPage> {

  @override
  void initState() {
    super.initState();
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    isLoading = true;
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_DRAW_PRODUCT_HISTORY, {
      "pageNum": "$page",
      "pageSize": "20",
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<dynamic> tempList = BaseModel.isNotEmpty(rsp.data, "list") ? BaseModel.getDynamic(rsp.data, "list") : [];
      setState(() {
        count = rsp.data["total"];
        if (page == 1) {
          datas = tempList;
        } else {
          datas.addAll(tempList);
        }
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_my_prize),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return datas.isEmpty ? buildHeader() : EasyRefresh(
      header: const MaterialHeader(color: IConstant.main_color),
      footer: CupertinoFooter(emptyWidget: Container(
        padding: EdgeInsets.all(10.w),
        child: Text(LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_more), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
      )),
      onRefresh: ()=> onRefresh(),
      onLoad: ()=> onLoadMore(),
      child: ListView.separated(
          scrollDirection: Axis.vertical,
          itemCount: datas.length,
          padding: EdgeInsets.only(bottom: 16.w),
          itemBuilder: (context, index) {
            dynamic item = datas[index];
            return ListTile(
              contentPadding: EdgeInsets.only(left: 16.w, right: 10.w),
              leading: LoadImageView(40.w, 40.w, BaseModel.getString(item, "productPic")),
              title: Text(BaseModel.getString(item, "productName"),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 17.sp, color: IConstant.text_color, fontWeight: FontWeight.bold)),
              subtitle: PriceText(BaseModel.getDouble(item, "productPrice"),
                  fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.main_color),
              trailing: buildStatus(item),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Container(height: 1.w, color: IConstant.line_color,);
          }),
    );
  }

  Widget buildStatus(dynamic item) {
    int status = BaseModel.getInt(item, "status");
    if (status == 0) {
      return InkWell(
        onTap: () {
          buy(item);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40.w)),
            gradient: const LinearGradient(
              colors: [
                Color(0xffFF3957),
                Color(0xffFF3957),
                Color(0xffFFCC16),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: const [
              BoxShadow(
                color: IConstant.black_color,
                blurRadius: 1,
                offset: Offset(0, 6),
                spreadRadius: 0,
              ) ,
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
          width: 100.w,
          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_get), textAlign: TextAlign.center,
              style: TextStyle(color: IConstant.white_color, fontSize: 14.sp, fontWeight: FontWeight.bold)),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: IConstant.grey_bg_color,
          borderRadius: BorderRadius.all(Radius.circular(20.w)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
        width: 100.w,
        child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_received), textAlign: TextAlign.center,
            style: TextStyle(color: IConstant.sub_text_color, fontSize: 14.sp, fontWeight: FontWeight.bold)),
      );
    }
  }


  Future<void> buy(dynamic product) async {
    String productId = BaseModel.getString(product, "productId");
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post("${IURLConstant.MALL_DRAW_PRODUCT_DETAIL}$productId", {"id": productId});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<dynamic> skuStockList = BaseModel.getDynamic(rsp.data, "skuStockList");
      if (skuStockList.isNotEmpty) {
        List<CartItem> selectCartList = [];
        CartItem cartItem =  CartItem.toCartItemNoPrice(product, skuStockList[0]);
        selectCartList.add(cartItem);
        nextPage(OrderConfirmPage(selectCartList, false, [], productId: productId), false);
      }
    } else {
      nextPageState(ProductDetailPage(productId), false);
    }
    ViewUtils.dismiss();
  }
}
