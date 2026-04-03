
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/Logger.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/CartItem.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/OrderTitleModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/order/MergeOrderItemPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/ClipboardUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CountDownView.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IURLConstant.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../brand/BrandShopPage.dart';
import '../detail/ProductDetailPage.dart';
import '../detail/ReceiveTaskPage.dart';
import '../event/OrderEvent.dart';
import '../utils/EventBusUtil.dart';
import '../utils/FormatUtil.dart';
import '../widget/ClockComponent.dart';
import '../widget/ExpandedOutlineText.dart';
import '../widget/LoadImageView.dart';
import '../widget/PriceText.dart';
import 'ApplyAfterSalesPage.dart';
import 'ChangeAddressPage.dart';
import 'LogisticsInfoPage.dart';
import 'PayPage.dart';
import 'SelectOrderItemPage.dart';

class OrderDetailPage extends StatefulWidget {

  dynamic order;

  OrderDetailPage(this.order);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends BaseKeepAliveState<OrderDetailPage> {

  String title = '';

  int status = 0;

  dynamic order;

  List<OrderTitleModel> orderTitleList = [];

  List<dynamic> orderItemList = [];

  double payAmount = 0;

  double totalAmount = 0;

  double freightAmount = 0;

  double couponAmount = 0;

  double plateCouponAmount = 0;

  double productGrowthTax = 0;

  Map<String, String> promiseList = {};

  @override
  void initState() {
    super.initState();
    promiseList.putIfAbsent("1", () => LanguageConfig.get(LanguageConfigKeys.Shop_order_service1));
    promiseList.putIfAbsent("2", () => LanguageConfig.get(LanguageConfigKeys.Shop_order_service2));
    promiseList.putIfAbsent("3", () => LanguageConfig.get(LanguageConfigKeys.Shop_order_service3));
    promiseList.putIfAbsent("4", () => LanguageConfig.get(LanguageConfigKeys.Shop_order_service4));
    promiseList.putIfAbsent("5", () => LanguageConfig.get(LanguageConfigKeys.Shop_order_service5));
    promiseList.putIfAbsent("6", () => LanguageConfig.get(LanguageConfigKeys.Shop_order_service6));
    promiseList.putIfAbsent("7", () => LanguageConfig.get(LanguageConfigKeys.Shop_order_service7));
    promiseList.putIfAbsent("8", () => LanguageConfig.get(LanguageConfigKeys.Shop_order_service8));
    setState(() {
      order = widget.order;
      orderItemList = BaseModel.getDynamic(order, "orderItemList");
      totalAmount = BaseModel.getDouble(order, "totalAmount");
      payAmount = BaseModel.getDouble(order, "payAmount");
      freightAmount = BaseModel.getDouble(order, "freightAmount");
      couponAmount = BaseModel.getDouble(order, "couponAmount");
      plateCouponAmount = BaseModel.getDouble(order, "plateCouponAmount");
      productGrowthTax = BaseModel.getDouble(order, "productGrowthTax");
      //0->待付款；1->待发货；2->已发货；3->已完成；4->已取消；5->无效订单
      status = BaseModel.getInt(order, "status");
      title = getStatusText(status);
    });
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    String orderId = BaseModel.getString(order, "id");
    String url = "${IURLConstant.MALL_ORDER_DETAIL}$orderId";
    BaseRsp rsp = await HttpUtils.post(url, {
      "orderId": orderId,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        order = rsp.data;
        orderItemList = BaseModel.getDynamic(order, "orderItemList");
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    LinkedHashMap<String, List<dynamic>> orderMaps = LinkedHashMap();
    for (dynamic item in orderItemList) {
      String shopId = BaseModel.getString(item, "shopId");
      if (orderMaps.containsKey(shopId)) {
        //存在直接添加
        List<dynamic>? oldList = orderMaps[shopId];
        oldList?.add(item);
      } else {
        //不存在创建再添加
        List<dynamic> newList = [];
        newList.add(item);
        orderMaps.putIfAbsent(shopId, () => newList);
      }
    }
    List<OrderTitleModel> titleList = [];
    orderMaps.forEach((key, value) {
      titleList.add(OrderTitleModel.fromJson(key, value));
    });
    setState(() {
      orderTitleList = titleList;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.5.w,
        centerTitle: true,
        title: Text(title,
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: ListView(children: [
        buildRowType(),
        buildBuyList(),
        buildBrandPromise(),
        buildOrderInfo(),
        buildDeliver(),
        buildTotal(),
      ]),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  @override
  void didChangeDependencies() {
    getServiceTime();
  }

  Widget buildBuyList() {
    return Column(
      children: orderTitleList.map((item) => buildTitle(item)).toList(),
    );
  }

  Widget buildTitle(OrderTitleModel model) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0.w),
      decoration: BoxDecoration(
          border: Border.all(color: IConstant.grey_bg_color, width: 1.w),
          borderRadius: BorderRadius.circular(12.w)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 0.w),
            child: buildMerchant(model),
          ),
          Column(
            children: model.dataList.map((item) => buildBuyItem(item)).toList(),
          )
        ],
      ),
    );
  }

  Widget buildMerchant(OrderTitleModel orderTitleModel) {
    String shopId = TextUtils.isEmpty(orderTitleModel.shopId) ? BaseModel.getString(order, "shopId") : orderTitleModel.shopId;
    String shopName = TextUtils.isEmpty(orderTitleModel.shopName) ? BaseModel.getString(order, "shopName") : orderTitleModel.shopName;
    String shopIcon = TextUtils.isEmpty(orderTitleModel.shopIcon) ? BaseModel.getString(order, "shopIcon") : orderTitleModel.shopIcon;
    return Row(
      children: [
        InkWell(
            onTap: () {
              nextPage(BrandShopPage(shopId), false);
            },
            child: Row(
              children: [
                ClipOval(child: LoadImageView(22.w, 22.w, shopIcon)),
                SizedBox(width: 6.w),
                Container(constraints: BoxConstraints(maxWidth: 160.w),child: Text(shopName, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))),
                Icon(Icons.chevron_right, size: 20.w, color: IConstant.text_color,),
              ],
            )
        ),
        expandeSpace,
        Text(getStatusText(BaseModel.getInt(order, "status")), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))
      ],
    );
  }

  Widget buildBuyItem(dynamic item) {
    int afterSalesStatus = BaseModel.getInt(item, "afterSalesStatus");
    return InkWell(
      onTap: () {
        nextPageState(ProductDetailPage(BaseModel.getString(item, "productId")), false);
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 6.w, 14.w, 6.w),
        child: Column(children: [
          SizedBox(height: 4.w),
          Row(
            children: [
              Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(8.w)),
                  clipBehavior: Clip.antiAlias,
                  elevation: 2,
                  child: LoadImageView(70.w, 70.w, item["productPic"])),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: Text(
                              item["productName"],
                              style:
                              TextStyle(fontSize: 13.sp, color: IConstant.text_color),
                            ),
                          )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 16.w, bottom: 4.w),
                                child: PriceText(item["productPrice"], fontSize: 12.sp, color: IConstant.title_color),
                              ),
                              Text("×${item["productQuantity"]}")
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10.w, top: 2.w),
                            padding: EdgeInsets.fromLTRB(12.w, 4.w, 12.w, 4.w),
                            decoration: BoxDecoration(
                                color: IConstant.grey_bg_color,
                                borderRadius: BorderRadius.all(Radius.circular(10.w))),
                            child: Text(
                              CartItem.getProductAttrValues(item["productAttr"]),
                              style: TextStyle(
                                  fontSize: 12.sp, color: IConstant.text_color),
                            ),
                          ),
                          expandeSpace,
                          afterSalesStatus != -2 ? Text(getApplyInfo(afterSalesStatus), style: TextStyle(
                              fontSize: 12.sp, color: IConstant.sub_text_color)) : Container()
                        ],
                      )
                    ],
                  ))
            ],
          )
        ]),
      ),
    );
  }

  String getApplyInfo(int afterSalesStatus){
    if (afterSalesStatus == 0) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_verifying);
    } else if (afterSalesStatus == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_order_wait_receipt);
    } else if (afterSalesStatus == 2){
      return LanguageConfig.get(LanguageConfigKeys.Shop_sales_pending_refunded);
    }else if (afterSalesStatus == 3){
      return LanguageConfig.get(LanguageConfigKeys.Shop_sales_refunded);
    }else {
      return "";
    }
  }

  Widget buildClipOval(double size, Color bgColor, bool isSolid) {
    if(isSolid) {
      return Center(child: ClipOval(
          child: Container(width: size, height: size, color: bgColor)));
    } else {
      return ClipOval(
          child: Container(
          width: size,
          height: size,
          color: IConstant.white_color,
          child: buildClipOval(size - 4.w, IConstant.main_color, true)));
    }
  }

  Widget buildRowType() {
    String intransitTime = BaseModel.getString(order, "intransitTime");
    if (status == 0) { //待付款
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 22.w),
            padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 26.w),
            decoration: BoxDecoration(
                color: IConstant.main_color,
                borderRadius: BorderRadius.circular(15.w)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_status), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.white_color)),
                SizedBox(height: 10.w),
                Row(children: [
                  SizedBox(width: 22.w),
                  buildClipOval(20.w, IConstant.white_color, true),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, false),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, false),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, false),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, false),
                  SizedBox(width: 22.w),
                ]),
                SizedBox(height: 10.w),
                Row(children: [
                  SizedBox(width: 10.w),
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_submit_order), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_user_pay), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_shop_deliver), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_express_delivery), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_user_receipt), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  SizedBox(width: 10.w),
                ]),
              ],
            ),
          ),
          Card(
             margin: EdgeInsets.fromLTRB(30.w, 10.w, 30.w, 0.w),
            elevation: 5.w,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadiusDirectional.circular(12.w)),
            child: Container(
              height: 40.w,
              padding: EdgeInsets.only(left: 10.w),
              child: Row(
                children: [
                  Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_detail_tip1),
                      style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))),
                  SizedBox(width: 10.w),
                  Expanded(child: buildClock(order)),
                  ExpandedOutlineText(
                    text: LanguageConfig.get(LanguageConfigKeys.Shop_order_now_pay),
                    bgColor: IConstant.main_color,
                    textColor: IConstant.white_color,
                    fontSize: 12.sp,
                    left: 8.w,
                    right: 8.w,
                    onTap: () {
                      gotoPay(order);
                    },
                  )
                ],
              ),
            ),
          )
        ],
      );
    } else if (status == 1) { //待发货
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 22.w),
            padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 26.w),
            decoration: BoxDecoration(
                color: IConstant.main_color,
                borderRadius: BorderRadius.circular(15.w)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_status), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.white_color)),
                SizedBox(height: 10.w),
                Row(children: [
                  SizedBox(width: 22.w),
                  buildClipOval(20.w, IConstant.white_color, true),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, true),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, false),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, false),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, false),
                  SizedBox(width: 22.w),
                ]),
                SizedBox(height: 10.w),
                Row(children: [
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_submit_order), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_user_pay), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_shop_deliver), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_express_delivery), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_user_receipt), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                ]),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.fromLTRB(30.w, 10.w, 30.w, 0.w),
            elevation: 5.w,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadiusDirectional.circular(12.w)),
            child: Container(
              height: 40.w,
              padding: EdgeInsets.only(left: 10.w, right: 10.w),
              child: Row(
                children: [
                  Expanded(flex: 2, child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_detail_tip3),
                  style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))),
                  SizedBox(width: 10.w),
                  Expanded(flex: 7, child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_detail_tip4),
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 12.sp, color: IConstant.main_color))),
                ],
              ),
            ),
          )
        ],
      );
    } else if (status == 2) { //已发货
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 30.w),
            padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 26.w),
            decoration: BoxDecoration(
                color: IConstant.main_color,
                borderRadius: BorderRadius.circular(15.w)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_status), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.white_color)),
                SizedBox(height: 10.w),
                Row(children: [
                  SizedBox(width: 22.w),
                  buildClipOval(20.w, IConstant.white_color, true),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, true),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, true),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, intransitTime.isNotEmpty ? true : false),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, false),
                  SizedBox(width: 22.w),
                ]),
                SizedBox(height: 10.w),
                Row(children: [
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_submit_order), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_user_pay), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_shop_deliver), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_express_delivery), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_user_receipt), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                ]),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.fromLTRB(30.w, 10.w, 30.w, 0.w),
            elevation: 5.w,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadiusDirectional.circular(12.w)),
            child: SizedBox(
              height: 50.w,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 10.w),
                  Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_delivery_serive), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))),
                  SizedBox(width: 10.w),
                  Expanded(child: Text(getDeliveryTime(),
                      style: TextStyle(fontSize: 12.sp, color: IConstant.main_color))),
                  ExpandedOutlineText(
                    text: LanguageConfig.get(LanguageConfigKeys.Shop_order_delivery_detail),
                    bgColor: IConstant.white_color,
                    borderColor: IConstant.line_color,
                    textColor: IConstant.text_color,
                    fontSize: 12.sp,
                    left: 8.w,
                    right: 8.w,
                    onTap: () {
                      logisticsInfo(order);
                    },
                  )
                ],
              ),
            ),
          )
        ],
      );
    } else if (status == 3) { //已完成
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 30.w),
            padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 26.w),
            decoration: BoxDecoration(
                color: IConstant.main_color,
                borderRadius: BorderRadius.circular(15.w)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_status), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.white_color)),
                SizedBox(height: 10.w),
                Row(children: [
                  SizedBox(width: 22.w),
                  buildClipOval(20.w, IConstant.white_color, true),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, true),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, true),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, true),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, true),
                  SizedBox(width: 22.w),
                ]),
                SizedBox(height: 10.w),
                Row(children: [
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_submit_order), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_user_pay), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_shop_deliver), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_express_delivery), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_user_receipt), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                ]),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.fromLTRB(30.w, 10.w, 30.w, 0.w),
            elevation: 5.w,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadiusDirectional.circular(12.w)),
            child: SizedBox(
              height: 50.w,
              child: Row(
                children: [
                  SizedBox(width: 10.w),
                  Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_order_completed), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))),
                  SizedBox(width: 10.w),
                  Expanded(child: Text(getReceiveTime(),
                      style: TextStyle(fontSize: 12.sp, color: IConstant.main_color))),
                  ExpandedOutlineText(
                    text: LanguageConfig.get(LanguageConfigKeys.Shop_order_delivery_detail),
                    bgColor: IConstant.white_color,
                    borderColor: IConstant.line_color,
                    textColor: IConstant.text_color,
                    fontSize: 12.sp,
                    left: 8.w,
                    right: 8.w,
                    onTap: () {
                      logisticsInfo(order);
                    },
                  )
                ],
              ),
            ),
          )
        ],
      );
    } else if (status == 4) { //已取消
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 30.w),
            padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 26.w),
            decoration: BoxDecoration(
                color: IConstant.main_color,
                borderRadius: BorderRadius.circular(15.w)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_status), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.white_color)),
                SizedBox(height: 10.w),
                Row(children: [
                  SizedBox(width: 22.w),
                  buildClipOval(20.w, IConstant.white_color, false),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, false),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, false),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, false),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, false),
                  SizedBox(width: 22.w),
                ]),
                SizedBox(height: 10.w),
                Row(children: [
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_submit_order), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_user_pay), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_shop_deliver), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_express_delivery), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_user_receipt), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                ]),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.fromLTRB(30.w, 10.w, 30.w, 0.w),
            elevation: 5.w,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadiusDirectional.circular(12.w)),
            child: SizedBox(
              height: 50.w,
              child: Row(
                children: [
                  SizedBox(width: 10.w),
                  Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_order_canceled), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))),
                  SizedBox(width: 10.w),
                  Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_again_patronage),
                      style: TextStyle(fontSize: 12.sp, color: IConstant.main_color))),
                  // ExpandedOutlineText(
                  //   text: LanguageConfig.get(LanguageConfigKeys.Shop_order_suggestions),
                  //   bgColor: IConstant.white_color,
                  //   borderColor: IConstant.line_color,
                  //   textColor: IConstant.text_color,
                  //   fontSize: 12.sp,
                  //   left: 8.w,
                  //   right: 8.w,
                  //   onTap: () {
                  //     ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_coming_soon));
                  //   },
                  // )
                ],
              ),
            ),
          )
        ],
      );
    } else if (status == 5) { //无效订单
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 30.w),
            padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 26.w),
            decoration: BoxDecoration(
                color: IConstant.main_color,
                borderRadius: BorderRadius.circular(15.w)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_status), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.white_color)),
                SizedBox(height: 10.w),
                Row(children: [
                  SizedBox(width: 22.w),
                  buildClipOval(20.w, IConstant.white_color, false),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, false),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, false),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, false),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, false),
                  SizedBox(width: 22.w),
                ]),
                SizedBox(height: 10.w),
                Row(children: [
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_submit_order), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_user_pay), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_shop_deliver), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_express_delivery), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_user_receipt), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                ]),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.fromLTRB(30.w, 10.w, 30.w, 0.w),
            elevation: 5.w,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadiusDirectional.circular(12.w)),
            child: SizedBox(
              height: 50.w,
              child: Row(
                children: [
                  SizedBox(width: 10.w),
                  Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_order_canceled), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))),
                  SizedBox(width: 10.w),
                  Expanded(child: Text("",
                      style: TextStyle(fontSize: 12.sp, color: IConstant.main_color))),
                  // ExpandedOutlineText(
                  //   text: LanguageConfig.get(LanguageConfigKeys.Shop_order_suggestions),
                  //   bgColor: IConstant.white_color,
                  //   borderColor: IConstant.line_color,
                  //   textColor: IConstant.text_color,
                  //   fontSize: 12.sp,
                  //   left: 8.w,
                  //   right: 8.w,
                  //   onTap: () {
                  //     ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_coming_soon));
                  //   },
                  // )
                ],
              ),
            ),
          )
        ],
      );
    } else if (status == 7) { //已签收
      String receiveTime = BaseModel.getString(order, "receiveTime");
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 30.w),
            padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 26.w),
            decoration: BoxDecoration(
                color: IConstant.main_color,
                borderRadius: BorderRadius.circular(15.w)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_status), style: TextStyle(fontSize: 14.sp, color: IConstant.white_color)),
                SizedBox(height: 10.w),
                Row(children: [
                  SizedBox(width: 22.w),
                  buildClipOval(20.w, IConstant.white_color, true),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, true),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, true),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, true),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, true),
                  SizedBox(width: 22.w),
                ]),
                SizedBox(height: 10.w),
                Row(children: [
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_submit_order), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_user_pay), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_shop_deliver), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_express_delivery), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_user_receipt), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                ]),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.fromLTRB(30.w, 10.w, 30.w, 0.w),
            elevation: 5.w,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadiusDirectional.circular(12.w)),
            child: SizedBox(
              height: 50.w,
              child: Row(
                children: [
                  SizedBox(width: 10.w),
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_signed_in), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                  SizedBox(width: 10.w),
                  Expanded(child: Text(receiveTime.isEmpty ? "" : FormatUtil.formatMDHMS(DateTime.parse(receiveTime)),
                      style: TextStyle(fontSize: 12.sp, color: IConstant.main_color))),
                  // ExpandedOutlineText(
                  //   text: LanguageConfig.get(LanguageConfigKeys.Shop_order_suggestions),
                  //   bgColor: IConstant.white_color,
                  //   borderColor: IConstant.line_color,
                  //   textColor: IConstant.text_color,
                  //   fontSize: 12.sp,
                  //   left: 8.w,
                  //   right: 8.w,
                  //   onTap: () {
                  //     ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_coming_soon));
                  //   },
                  // )
                ],
              ),
            ),
          )
        ],
      );
    } else {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 30.w),
            padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 26.w),
            decoration: BoxDecoration(
                color: IConstant.main_color,
                borderRadius: BorderRadius.circular(15.w)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_status), style: TextStyle(fontSize: 14.sp, color: IConstant.white_color)),
                SizedBox(height: 10.w),
                Row(children: [
                  SizedBox(width: 22.w),
                  buildClipOval(20.w, IConstant.white_color, false),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, false),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, false),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, false),
                  Expanded(child: Container(height: 2.w, color: IConstant.white_color)),
                  buildClipOval(20.w, IConstant.white_color, false),
                  SizedBox(width: 22.w),
                ]),
                SizedBox(height: 10.w),
                Row(children: [
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_submit_order), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_user_pay), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_shop_deliver), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_express_delivery), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_user_receipt), style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
                  expandeSpace,
                ]),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.fromLTRB(30.w, 10.w, 30.w, 0.w),
            elevation: 5.w,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadiusDirectional.circular(12.w)),
            child: SizedBox(
              height: 50.w,
              child: Row(
                children: [
                  SizedBox(width: 10.w),
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_refund_success), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                  SizedBox(width: 10.w),
                  Expanded(child: Container()),
                  // ExpandedOutlineText(
                  //   text: LanguageConfig.get(LanguageConfigKeys.Shop_order_suggestions),
                  //   bgColor: IConstant.white_color,
                  //   borderColor: IConstant.line_color,
                  //   textColor: IConstant.text_color,
                  //   fontSize: 12.sp,
                  //   left: 8.w,
                  //   right: 8.w,
                  //   onTap: () {
                  //     ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_coming_soon));
                  //   },
                  // )
                ],
              ),
            ),
          )
        ],
      );
    }
  }

  String getStatusText(int status) {
    switch (status) {
      case 0:
        return LanguageConfig.get(LanguageConfigKeys.Shop_order_wait_pay);
      case 1:
        return LanguageConfig.get(LanguageConfigKeys.Shop_order_wait_deliver);
      case 2:
        return LanguageConfig.get(LanguageConfigKeys.Shop_order_wait_receipt);
      case 3:
        return LanguageConfig.get(LanguageConfigKeys.Shop_order_completed);
      case 4:
        return LanguageConfig.get(LanguageConfigKeys.Shop_order_canceled);
      case 5:
        return LanguageConfig.get(LanguageConfigKeys.Shop_order_invalid);
      case 6:
        return LanguageConfig.get(LanguageConfigKeys.Shop_order_after_sales_order);
      case 7:
        return LanguageConfig.get(LanguageConfigKeys.Shop_order_signed_in);
      default:
        return LanguageConfig.get(LanguageConfigKeys.Shop_order_invalid);
    }
  }

  String getPayInfo(String payType) {
    if (payType == "1") {
      return LanguageConfig.get(LanguageConfigKeys.Shop_brand_period);
    } else if (payType == "2") {
      return LanguageConfig.get(LanguageConfigKeys.Shop_order_bank_card_pay);
    } else if (payType == "3") {
      return LanguageConfig.get(LanguageConfigKeys.Shop_order_prompt_pay);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_order_balance_pay);
    }
  }

  String getAddressDetail(String province, String city, String region, String detailAddress) {
    return "$detailAddress $region $city $province";
  }

  String getDeliveryTime() {
    String deliveryTime = BaseModel.getString(order, "deliveryTime");
    String intransitTime = BaseModel.getString(order, "intransitTime");
    if(TextUtils.isNotEmpty(intransitTime)) {
      return "${LanguageConfig.get(LanguageConfigKeys.Shop_order_express_delivery)}  ${FormatUtil.formatMDHMS(DateTime.parse(intransitTime))}";
    }else {
      if(TextUtils.isNotEmpty(deliveryTime)) {
        return "${LanguageConfig.get(LanguageConfigKeys.Shop_order_delivery_collect)}  ${FormatUtil.formatMDHMS(DateTime.parse(deliveryTime))}";
      } else {
        return LanguageConfig.get(LanguageConfigKeys.Shop_order_delivery_collect);
      }
    }
  }

  String getReceiveTime() {
    String receiveTime = BaseModel.getString(order, "receiveTime");
    if(TextUtils.isNotEmpty(receiveTime)) {
      return "${LanguageConfig.get(LanguageConfigKeys.Shop_order_confirm_receipt)}  ${FormatUtil.formatMDHMS(DateTime.parse(receiveTime))}";
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_order_confirm_receipt);
    }
  }

  Widget buildBrandPromise() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
      decoration: BoxDecoration(
          color: IConstant.blue_bg_color2,
          borderRadius: BorderRadius.circular(12.w)),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(14.w, 10.w, 0.w, 0.w),
                child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_brand_commitment),
                    style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
              ),
              expandeSpace,
              Container(
                margin: EdgeInsets.fromLTRB(0.w, 10.w, 14.w, 0.w),
                child:Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_platform_policy),
                  style: TextStyle(fontSize: 12.sp, color: IConstant.blue_color)),
              )
            ],
          ),
          buildServiceIds(),
        ],
      ));
  }

  Widget buildServiceIds() {
    String servId = BaseModel.getString(order, "serviceIds");
    if(TextUtils.isEmpty(servId)) {
      servId = "1,2,5,8";
    }
    List<String> selectList = [];
    List<String> serviceIds = servId.split(",");
    for (String item in serviceIds) {
      if (promiseList.containsKey(item)) {
        selectList.add("${promiseList[item]}");
      }
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(10.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisExtent: 28.w,
        mainAxisSpacing: 10.w, //item上下间隔
        crossAxisSpacing: 4.w, //item左右间隔
      ),
      itemCount: selectList.length,
      itemBuilder: (BuildContext context, int index) {
        return buildPromiseItem(selectList[index]);
      },
    );
  }

  Widget buildPromiseItem(String name) {
    return Row(
      children: [
        Image.asset("assets/icons/star.png", width: 18.w, height: 18.w),
        SizedBox(width: 2.w),
        Expanded(child: Text(name,
            maxLines: 2,
            overflow: TextOverflow.clip,
            style: TextStyle(
                fontSize: 11.sp,
                color: IConstant.text_color))),
      ],
    );
  }

  Widget buildOrderInfo() {
    String orderSn = BaseModel.getString(order, "orderShopSn");
    String createTime = BaseModel.getString(order, "createTime");
    String payType = BaseModel.getString(order, "payType");
    String paymentTime = BaseModel.getString(order, "paymentTime");
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
      decoration: BoxDecoration(
          border: Border.all(color: IConstant.grey_bg_color, width: 1.w),
          borderRadius: BorderRadius.circular(12.w)),
      padding: EdgeInsets.fromLTRB(16.w, 6.w, 16.w, 6.w),
      child: Column(children: [
        Padding(
          padding: EdgeInsets.only(top: 6.w, bottom: 6.w),
          child: Row(
            children: [
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_order_sn),
                  style: TextStyle(
                      fontSize: 14.sp, color: IConstant.sub_text_color)),
              SizedBox(width: 20.w),
              Expanded(
                  child: Text(orderSn,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 14.sp, color: IConstant.sub_text_color))),
              SizedBox(width: 8.w),
              InkWell(onTap: () => ClipboardUtil.setDataToast(orderSn),
                child: Image.asset("assets/icons/copy_icon.png", width: 30.w, height: 30.w),)
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 6.w, bottom: 6.w),
          child: Row(
            children: [
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_order_time),
                  style: TextStyle(
                      fontSize: 14.sp, color: IConstant.sub_text_color)),
              SizedBox(width: 20.w),
              Expanded(
                  child: Text(createTime,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 14.sp, color: IConstant.sub_text_color))),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 6.w, bottom: 6.w),
          child: Row(
            children: [
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_payment_type),
                  style: TextStyle(
                      fontSize: 14.sp, color: IConstant.sub_text_color)),
              SizedBox(width: 20.w),
              Expanded(
                  child: Text(getPayInfo(payType),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 14.sp, color: IConstant.sub_text_color))),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 6.w, bottom: 6.w),
          child: Row(
            children: [
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_payment_time),
                  style: TextStyle(
                      fontSize: 14.sp, color: IConstant.sub_text_color)),
              SizedBox(width: 20.w),
              Expanded(
                  child: Text(paymentTime,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 14.sp, color: IConstant.sub_text_color))),
            ],
          ),
        )
      ]),
    );
  }

  Widget buildDeliver() {
    String receiverName = BaseModel.getString(order, "receiverName");
    String receiverPhone = BaseModel.getString(order, "receiverPhone");
    String receiverProvince = BaseModel.getString(order, "receiverProvince");
    String receiverCity = BaseModel.getString(order, "receiverCity");
    String receiverRegion = BaseModel.getString(order, "receiverRegion");
    String receiverDetailAddress = BaseModel.getString(order, "receiverDetailAddress");
    String deliveryTime = "";
    String paymentTime = BaseModel.getString(order, "paymentTime");
    if(TextUtils.isNotEmpty(paymentTime)) {
      DateTime calcTime = DateTime.parse(paymentTime);
      calcTime = calcTime.add(Duration(hours: 48));
      deliveryTime = FormatUtil.formatYMDHMS(calcTime);

    }
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
      decoration: BoxDecoration(
          border: Border.all(color: IConstant.grey_bg_color, width: 1.w),
          borderRadius: BorderRadius.circular(12.w)),
      padding: EdgeInsets.fromLTRB(16.w, 6.w, 16.w, 6.w),
      child: Column(children: [
        Padding(
          padding: EdgeInsets.only(top: 6.w, bottom: 6.w),
          child: Row(
            children: [
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_receive_address),
                  style: TextStyle(
                      fontSize: 14.sp, color: IConstant.sub_text_color)),
              SizedBox(width: 20.w),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("$receiverName $receiverPhone",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 14.sp, color: IConstant.sub_text_color)),
                      Text(getAddressDetail(receiverProvince, receiverCity, receiverRegion, receiverDetailAddress),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 14.sp, color: IConstant.sub_text_color)),
                    ],
                  )),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 6.w, bottom: 6.w),
          child: Row(
            children: [
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_calc_delivery_time),
                  style: TextStyle(
                      fontSize: 14.sp, color: IConstant.sub_text_color)),
              SizedBox(width: 20.w),
              Expanded(
                  child: Text(deliveryTime,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 14.sp, color: IConstant.sub_text_color))),
            ],
          ),
        ),
      ]),
    );
  }

  Widget buildTotal() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 16.w),
      decoration: BoxDecoration(
          border: Border.all(color: IConstant.grey_bg_color, width: 1.w),
          borderRadius: BorderRadius.circular(12.w)),
      padding: EdgeInsets.fromLTRB(0.w, 6.w, 0.w, 6.w),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 6.w, 16.w, 6.w),
            child: Row(
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_goods_total),
                    style: TextStyle(
                        fontSize: 14.sp, color: IConstant.sub_text_color)),
                SizedBox(width: 20.w),
                Expanded(
                    child: PriceText(totalAmount, color: IConstant.text_color, textAlign: TextAlign.end)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 6.w, 16.w, 6.w),
            child: Row(
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_freight),
                    style: TextStyle(
                        fontSize: 14.sp, color: IConstant.sub_text_color)),
                SizedBox(width: 20.w),
                Expanded(
                    child: PriceText(freightAmount, color: IConstant.text_color, textAlign: TextAlign.end)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 6.w, 16.w, 6.w),
            child: Row(
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_coupons),
                    style: TextStyle(
                        fontSize: 14.sp, color: IConstant.sub_text_color)),
                SizedBox(width: 20.w),
                Expanded(child: PriceText(couponAmount + plateCouponAmount, color: IConstant.main_color, textAlign: TextAlign.end)),
              ],
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.fromLTRB(16.w, 6.w, 16.w, 6.w),
          //   child: Row(
          //     children: [
          //       Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_tax),
          //           style: TextStyle(
          //               fontSize: 14.sp, color: IConstant.sub_text_color)),
          //       SizedBox(width: 20.w),
          //       Expanded(child: PriceText(productGrowthTax, color: IConstant.text_color, textAlign: TextAlign.end)),
          //     ],
          //   ),
          // ),
          Container(
            color: IConstant.line_color,
            height: 1.w,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 6.w, 16.w, 6.w),
            child: Row(
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_total),
                    style: TextStyle(
                        fontSize: 14.sp, color: IConstant.sub_text_color)),
                SizedBox(width: 20.w),
                Expanded(child: PriceText(payAmount, textAlign: TextAlign.end)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      child: Container(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        height: 60,
        child: buildButtons(),
      ),
    );
  }

  Widget buildButtons() {
    int status = BaseModel.getInt(order, "status");
    if (status == 0) { //待付款
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // ExpandedOutlineText(
          //     text: LanguageConfig.get(LanguageConfigKeys.Shop_order_contact_customer_service),
          //     textColor: IConstant.text_color,
          //     borderColor: IConstant.grey_line_color,
          //     bgColor: IConstant.white_color,
          //     fontSize: 12.sp,
          //     onTap: () => contactCustomer(order)),
          expandeSpace,
          expandeSpace,
          // ExpandedOutlineText(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_cancel_order),
          //     textColor: IConstant.text_color,
          //     borderColor: IConstant.grey_line_color,
          //     bgColor: IConstant.white_color,
          //     fontSize: 12.sp, onTap: () => cancelOrder(order)),
          // ExpandedOutlineText(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_change_address),
          //     textColor: IConstant.text_color,
          //     borderColor: IConstant.grey_line_color,
          //     bgColor: IConstant.white_color,
          //     fontSize: 12.sp, onTap: () => changeAddress(order)),
          ExpandedOutlineText(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_now_pay),
              fontSize: 12.sp, onTap: () => gotoPay(order)),
        ],
      );
    } else if (status == 1) { //待发货
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // ExpandedOutlineText(
          //     text: LanguageConfig.get(LanguageConfigKeys.Shop_order_contact_customer_service),
          //     textColor: IConstant.text_color,
          //     borderColor: IConstant.grey_line_color,
          //     bgColor: IConstant.white_color,
          //     fontSize: 12.sp,
          //     onTap: () => contactCustomer(order)),
          // ExpandedOutlineText(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_change_address),
          //     textColor: IConstant.text_color,
          //     borderColor: IConstant.grey_line_color,
          //     bgColor: IConstant.white_color,
          //     fontSize: 12.sp, onTap: () => changeAddress(order)),
          expandeSpace,
          expandeSpace,
          buildAfterSales(order),
        ],
      );
    } else if (status == 2) { //待收货
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          expandeSpace,
          ExpandedOutlineText(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_view_logistics),
              textColor: IConstant.text_color,
              borderColor: IConstant.grey_line_color,
              bgColor: IConstant.white_color,
              fontSize: 12.sp, onTap: () => logisticsInfo(order)),
          ExpandedOutlineText(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_confirm_receipt),
              fontSize: 12.sp, onTap: () => confirmReceipt(order)),
        ],
      );
    } else if (status == 3) { //已完成
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          expandeSpace,
          expandeSpace,
          ExpandedOutlineText( textColor: IConstant.text_color,
              borderColor: IConstant.grey_line_color,
              bgColor: IConstant.white_color,
              text: LanguageConfig.get(LanguageConfigKeys.Shop_order_again_buy),
              fontSize: 12.sp, onTap: () => againBuy(order)),
          // buildAfterSales(order),
          // ExpandedOutlineText(text: LanguageConfig.get(LanguageConfigKeys.Shop_product_mxget),
          //     fontSize: 12.sp, onTap: () => startMXGet(order)),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          expandeSpace,
          ExpandedOutlineText(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_delete_order),
              textColor: IConstant.text_color,
              borderColor: IConstant.grey_line_color,
              bgColor: IConstant.white_color,
              fontSize: 12.sp, onTap: () => deleteConfirm(order)),
          ExpandedOutlineText(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_again_buy),
              fontSize: 12.sp, onTap: () => againBuy(order)),
        ],
      );
    }
  }

  Widget buildAfterSales(dynamic order) {
    List<dynamic> orderItemList = BaseModel.getDynamic(order, "orderItemList");
    if(orderItemList.length > 1) {
      return ExpandedOutlineText(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_apply_service),
          textColor: IConstant.text_color,
          borderColor: IConstant.grey_line_color,
          bgColor: IConstant.white_color,
          fontSize: 12.sp, onTap: () {
            showPop(0.7 * Adapt.getWindowHeight(), SelectOrderItemPage(orderItemList, (ctx, item) {
              finishContext(ctx);
              showPop(0.9 * Adapt.getWindowHeight(), ApplyAfterSalesPage(order, item));
            }));
          });
    }else {
      int afterSalesStatus = BaseModel.getInt(orderItemList[0], "afterSalesStatus");
      if(afterSalesStatus == 0 || afterSalesStatus == 3) {
        return Container();
      }else {
        return ExpandedOutlineText(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_apply_service),
            textColor: IConstant.text_color,
            borderColor: IConstant.grey_line_color,
            bgColor: IConstant.white_color,
            fontSize: 12.sp, onTap: () {
              showPop(0.9 * Adapt.getWindowHeight(), ApplyAfterSalesPage(order, orderItemList[0]));
            });
      }
    }
  }

  void againBuy(dynamic order) {
    List<dynamic> orderItemList = BaseModel.getDynamic(order, "orderItemList");
    if (orderItemList.length > 1) {
      showPop(0.7 * Adapt.getWindowHeight(), SelectOrderItemPage(orderItemList, from: 1, (ctx, item) {
        finishContext(ctx);
        nextPageState(ProductDetailPage(BaseModel.getString(item, "productId")), false);
      }));
    } else {
      nextPageState(ProductDetailPage(BaseModel.getString(orderItemList[0], "productId")), false);
    }
  }

  void contactCustomer(dynamic order) {
    // ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_coming_soon));
  }

  void startMXGet(dynamic order) async {
    List<dynamic> orderItemList = BaseModel.getDynamic(order, "orderItemList");
    if (orderItemList.length > 1) {
      showPop(0.7 * Adapt.getWindowHeight(), SelectOrderItemPage(orderItemList, (ctx, item) {
        finishContext(ctx);
        gotoMXGet(item);
      }));
    } else {
      gotoMXGet(orderItemList[0]);
    }
  }

  Future<void> gotoMXGet(dynamic orderItem) async {
    String productId = BaseModel.getString(orderItem, "productId");
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post("${IURLConstant.MALL_PRODUCT_DETAIL}$productId", {"id": productId});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      dynamic product = rsp.data;
      rsp = await HttpUtils.post(IURLConstant.MALL_PRODUCT_POCKET_LIST, {"productId": productId});
      if (rsp.retCode == RspRetCode.SUCCESS) {
        List<dynamic> pocketList = [];
        List<dynamic> tempList = rsp.data;
        for (var item in tempList) {
          int type = BaseModel.getInt(item, "type"); //只添加普通任务
          if (type == 0) {
            pocketList.add(item);
          }
        }
        if (pocketList.isNotEmpty) {
          showPop(0.8 * Adapt.getWindowHeight(), ReceiveTaskPage(product, pocketList));
        } else {
          ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_late_task_over));
        }
      } else {
        ViewUtils.displayToast(rsp.msg);
      }
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  Future<void> logisticsInfo(dynamic order) async {
    String orderSn = BaseModel.getString(order, "orderSn");
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_LOGISTICS_INFO, {
      "orderShopSn": orderSn
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<dynamic> logisticsList = rsp.data;
      if (logisticsList.isNotEmpty) {
        showPop(0.9 * Adapt.getWindowHeight(), LogisticsInfoPage(logisticsList));
      } else {
        ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_data));
      }
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  void appleAfterSales(dynamic order) {
    List<dynamic> orderItemList = BaseModel.getDynamic(order, "orderItemList");
    if (orderItemList.length > 1) {
      showPop(0.7 * Adapt.getWindowHeight(), SelectOrderItemPage(orderItemList, (ctx, item) {
        finishContext(ctx);
        showPop(0.9 * Adapt.getWindowHeight(), ApplyAfterSalesPage(order, item));
      }));
    } else {
      showPop(0.9 * Adapt.getWindowHeight(), ApplyAfterSalesPage(order, orderItemList[0]));
    }
  }

  void changeAddress(dynamic order) {
    showPop(0.7 * Adapt.getWindowHeight(), ChangeAddressPage(order));
  }

  Future<void> cancelOrder(dynamic order) async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_ORDER_CANCEL_USER_ORDER, {
      "orderId": BaseModel.getString(order, "id")
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_operation_successful));
      EventBusUtil.getInstance().emit(OrderEvent());
      finish();
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  void deleteConfirm(dynamic order) {
    ViewUtils.showRemindDialog2(context,
        LanguageConfig.get(LanguageConfigKeys.Shop_order_delete_title),
        LanguageConfig.get(LanguageConfigKeys.Shop_order_delete_content),
        LanguageConfig.get(LanguageConfigKeys.ViewUtils_cancel),
        LanguageConfig.get(LanguageConfigKeys.ViewUtils_confirm), (ctx, event) {
          if (event == DialogEvent.confirm) {
            finishContext(ctx);
            deleteOrder(order);
          } else {
            finishContext(ctx);
          }
        }
    );
  }

  Future<void> deleteOrder(dynamic order) async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_ORDER_DELETE_ORDER, {
      "orderId": BaseModel.getString(order, "id")
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_operation_successful));
      List<dynamic> tempList = datas;
      tempList.remove(order);
      setState(() {
        datas = tempList;
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  void gotoPay(dynamic order) async{
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_MERGE_PAY_POPUP, {
      "orderId": BaseModel.getString(order, "orderId")
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<dynamic> orderShopDetailsList = BaseModel.getDynamic(rsp.data, "orderShopDetails");
      double plateCouponAmount = BaseModel.getDynamic(rsp.data, "plateCouponAmount");
      if(plateCouponAmount > 0 && orderShopDetailsList.length > 1) {
        showPop(0.6 * Adapt.getWindowHeight(), MergeOrderItemPage(orderShopDetailsList, 0 , commitOrderCallBack: (ctx) {
          finishContext(ctx);
          checkPay(rsp.data);
        },cancelOrderCallBack: (ctx) {

        },),enableDrag: false);
      }else {
        nextPage(PayPage(order, true), false);
      }
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  void checkPay(dynamic orderData) async {
    int orderOverTime = BaseModel.getInt(orderData, "orderOverTime");
    nextPage(PayPage(orderData, false, orderOverTime: orderOverTime), false);
  }

  void confirmReceipt(dynamic order) async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_CONFIRM_RECEIVE_ORDER, {
      "orderId": BaseModel.getString(order, "id")
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      finish();
      ViewUtils.displayToast(rsp.msg);
      EventBusUtil.getInstance().emit(OrderEvent());
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  Widget buildClock(dynamic item) {
    String createTime = BaseModel.getString(item, "createTime");
    int orderOverTime = BaseModel.getInt(item, "orderOverTime");
    Logger.log("----detail orderOverTime: $orderOverTime");
    DateTime endTime = DateTime.parse(createTime);
    endTime = endTime.add(Duration(minutes: orderOverTime));
    return CountDownView(startTime: serviceTime.isEmpty ? '' : handleDate(DateTime.parse(serviceTime)), endTime: handleDate(endTime), fontSize: 12.sp,
        textColor: IConstant.main_color,
        prefix: LanguageConfig.get(LanguageConfigKeys.Shop_order_remain),
        stop: LanguageConfig.get(LanguageConfigKeys.Shop_activity_closed));
  }

  String handleDate(DateTime dateTime) {
    return FormatUtil.formatLineYMDHMS(dateTime); //格式化日期
  }

}
