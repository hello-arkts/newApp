
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/brand/BrandShopPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/order/ApplyAfterSalesPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/order/LogisticsInfoPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/order/MergeOrderItemPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/order/OrderDetailPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/order/SelectOrderItemPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CountDownView.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:sprintf/sprintf.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IURLConstant.dart';
import '../../../Logger.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../detail/ProductDetailPage.dart';
import '../detail/ReceiveTaskPage.dart';
import '../event/OrderEvent.dart';
import '../model/CartItem.dart';
import '../utils/EventBusUtil.dart';
import '../utils/FormatUtil.dart';
import '../widget/ClockComponent.dart';
import '../widget/ExpandedOutlineText.dart';
import '../widget/LoadImageView.dart';
import 'ChangeAddressPage.dart';
import 'PayPage.dart';

class OrderList extends StatefulWidget {

  String orderStatus = "-1";

  OrderList(this.orderStatus, {super.key});

  @override
  State<OrderList> createState() => OrderListState();
}

class OrderListState extends BaseKeepAliveState<OrderList> {

  dynamic orderEvent;

  @override
  void initState() {
    super.initState();
    orderEvent = EventBusUtil.getInstance().on<OrderEvent>((event) {
      if (event.orderType == OrderType.complete){
        loadContentDatas();
      }
    });
    loadContentDatas();
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(orderEvent);
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    isLoading = true;
    getServiceTime();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_ORDER_LIST,  {
      "status": widget.orderStatus,
      "pageNum": "$page",
      "pageSize": "10"
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        List<dynamic> list = BaseModel.isNotEmpty(rsp.data, "list") ? BaseModel.getDynamic(rsp.data, "list") : [];
        count = rsp.data["total"];
        if (page == 1) {
          datas = list;
        } else {
          datas.addAll(list);
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
    return buildBody();
  }

  @override
  void didChangeDependencies() {
    getServiceTime();
  }

  Widget buildBody(){
    if(datas.isEmpty){
      return buildHeader();
    } else {
      return EasyRefresh(
          header: MaterialHeader(color: IConstant.main_color),
          footer: CupertinoFooter(emptyWidget: Container(
            padding: EdgeInsets.all(10.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_more), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
          )),
          onRefresh: ()=> onRefresh(),
          onLoad: ()=> onLoadMore(), child: ListView.separated(
          scrollDirection: Axis.vertical,
          itemCount: datas.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                nextPage(OrderDetailPage(datas[index]), false);
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                    color: IConstant.white_color,
                    border: Border.all(width: 1.w, color: IConstant.line_color),
                    borderRadius: BorderRadius.all(Radius.circular(18.w))),
                child: Column(
                  children: [
                    buildMerchant(datas[index]),
                    SizedBox(height: 2.w),
                    buildOrder(datas[index]),
                    buildButtons(datas[index])
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 10.w);
          }));
    }
  }
  
  Widget buildMerchant(dynamic order) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            nextPage(BrandShopPage(BaseModel.getString(order, "shopId")), false);
          },
          child: Row(
            children: [
              ClipOval(child: LoadImageView(22.w, 22.w, BaseModel.getString(order, "shopIcon"))),
              SizedBox(width: 6.w),
              Container(constraints: BoxConstraints(maxWidth: 160.w), child: Text(BaseModel.getString(order, "shopName"), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))),
              Icon(Icons.chevron_right, size: 20.w, color: IConstant.text_color,),
            ],
          )
        ),
        Expanded(child: buildStatus(order))
      ],
    );
  }

  Widget buildStatus(dynamic order) {
    int status = BaseModel.getInt(order, "status");
    if (status == 0) {
      return Row(
        children: [
          expandeSpace,
          Text(getStatusText(BaseModel.getInt(order, "status")), style: TextStyle(fontSize: 11.sp, color: IConstant.text_color)),
          SizedBox(width: 8.w),
          buildClock(order)
        ],
      );
    } else {
      return Text(getStatusText(BaseModel.getInt(order, "status")), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color));
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
        return LanguageConfig.get(LanguageConfigKeys.Shop_sales_refund_success);
      case 7:
        return LanguageConfig.get(LanguageConfigKeys.Shop_order_signed_in);
      default:
        return LanguageConfig.get(LanguageConfigKeys.Shop_order_invalid);
    }
  }

  String getApplyInfo(int afterSalesType){
    if (afterSalesType == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_sales_refund);
    } else if (afterSalesType == 2) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_sales_return_refund);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_sales_overtime);
    }
  }

  Widget buildOrder(dynamic order) {
    dynamic payAmount = order["payAmount"];
    List<dynamic> orderItemList = BaseModel.getDynamic(order, "orderItemList");
     if (orderItemList.length > 1) {
       return Row(
         children: [
           Expanded(flex: 3, child: buildImages(orderItemList)),
           Expanded(flex: 1, child: buildOrderPrice(payAmount, orderItemList)),
         ],
       );
     } else {
       return Row(
         children: [
           Expanded(flex: 3, child: buildOrderItem(payAmount, orderItemList)),
           Expanded(flex: 1, child: buildOrderPrice(payAmount, orderItemList)),
         ],
       );
     }
  }

  Widget buildImages(List<dynamic> orderItemList) {
    List showItemList = orderItemList.length > 3 ? orderItemList.sublist(0, 3) : orderItemList;
    return Row(
      children: showItemList.map((item) => Container(
        margin: EdgeInsets.only(left: 2.w),
        child: LoadImageView(70.w, 70.w, item["productPic"],
      ))).toList(),
    );
  }

  Widget buildOrderItem(double totalAmount, List<dynamic> orderItemList) {
    dynamic item = orderItemList[0];
    return Row(
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
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Text(
                    item["productName"],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 13.sp, color: IConstant.text_color),
                  ),
                ),
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
              ],
            ))
      ],
    );
  }

  Widget buildOrderPrice(double totalAmount, List<dynamic> orderItemList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        PriceText(totalAmount, fontSize: 14.sp),
        Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_order_piece_in_total), [getOrderTotal(orderItemList)]), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
      ],
    );
  }

  int getOrderTotal(List<dynamic> orderItemList) {
    int total = 0;
    for (var item in orderItemList) {
      int quantity = BaseModel.getInt(item, "productQuantity");
      total += quantity;
    }
    return total;
  }

  Widget buildClock(dynamic item) {
    String createTime = BaseModel.getString(item, "createTime");
    int orderOverTime = BaseModel.getInt(item, "orderOverTime");
    Logger.log("----list orderOverTime: $orderOverTime");
    DateTime endTime = DateTime.parse(createTime);
    endTime = endTime.add(Duration(minutes: orderOverTime));
    return CountDownView(startTime: serviceTime.isEmpty ? '' : handleDate(DateTime.parse(serviceTime)), endTime: handleDate(endTime), fontSize: 11.sp,
          textColor: IConstant.main_color,
          textAlign: TextAlign.right,
          prefix: "",
          stop: LanguageConfig.get(LanguageConfigKeys.Shop_activity_closed),
    );
  }

  String handleDate(DateTime dateTime) {
    return FormatUtil.formatLineYMDHMS(dateTime); //格式化日期
  }

  Widget buildButtons(dynamic order) {
    int status = BaseModel.getInt(order, "status");
    if (status == 0) { //待付款
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          expandeSpace,
          ExpandedOutlineText(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_cancel_order),
              textColor: IConstant.text_color,
              borderColor: IConstant.grey_line_color,
              bgColor: IConstant.white_color,
              fontSize: 12.sp, onTap: () => cancelMergeOrder(order)),
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
          expandeSpace,
          expandeSpace,
          // ExpandedOutlineText(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_change_address),
          //     textColor: IConstant.text_color,
          //     borderColor: IConstant.grey_line_color,
          //     bgColor: IConstant.white_color,
          //     fontSize: 12.sp, onTap: () => changeAddress(order)),
          // ExpandedOutlineText(
          //         text: LanguageConfig.get(LanguageConfigKeys.Shop_order_contact_customer_service),
          //         textColor: IConstant.text_color,
          //         borderColor: IConstant.grey_line_color,
          //         bgColor: IConstant.white_color,
          //         fontSize: 12.sp,
          //         onTap: () => contactCustomer(order)),
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
    int afterSalesStatus = BaseModel.getInt(order, "afterSalesStatus");
    if (afterSalesStatus == 0) {
      return ExpandedOutlineText(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_apply_service),
          textColor: IConstant.text_color,
          borderColor: IConstant.grey_line_color,
          bgColor: IConstant.white_color,
          fontSize: 12.sp, onTap: () => appleAfterSales(order));
    } else {
      return ExpandedOutlineText(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_apply_service),
          bgColor: IConstant.grey_bg_color,
          borderColor: IConstant.grey_bg_color,
          textColor: IConstant.sub_text_color,
          fontSize: 12.sp, onTap: () => null);
    }
  }

  void againBuy(dynamic order) {
    List<dynamic> orderItemList = BaseModel.getDynamic(order, "orderItemList");
    if (orderItemList.length > 1) {
      showPop(0.7 * Adapt.getWindowHeight(), SelectOrderItemPage(orderItemList, from: 1,(ctx, item) {
        finishContext(ctx);
        nextPageState(ProductDetailPage(BaseModel.getString(item, "productId")), false);
      }));
    } else {
      nextPageState(ProductDetailPage(BaseModel.getString(orderItemList[0], "productId")), false);
    }
  }

  void contactCustomer(dynamic order) {
    ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_coming_soon));
  }

  void startMXGet(dynamic order) async {
    List<dynamic> orderItemList = BaseModel.getDynamic(order, "orderItemList");
    if (orderItemList.length > 1) {
      showPop(0.7 * Adapt.getWindowHeight(), SelectOrderItemPage(orderItemList, from: 1, (ctx, item) {
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
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  void cancelMergeOrder(dynamic order) async{
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_MERGE_PAY_POPUP, {
      "orderId": BaseModel.getString(order, "orderId")
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<dynamic> orderShopDetailsList = BaseModel.getDynamic(rsp.data, "orderShopDetails");
      double plateCouponAmount = BaseModel.getDynamic(rsp.data, "plateCouponAmount");
      if(plateCouponAmount > 0 && orderShopDetailsList.length > 1) {
        showPop(0.6 * Adapt.getWindowHeight(), MergeOrderItemPage(orderShopDetailsList, 1 , commitOrderCallBack: (ctx) {
        },cancelOrderCallBack: (ctx) async{
          BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_MERGE_ORDER_CANCEL, {
            "orderId": BaseModel.getString(order, "orderId")
          });
          if (rsp.retCode == RspRetCode.SUCCESS) {
            finishContext(ctx);
            loadContentDatas();
          }
        },),enableDrag: false);
      }else {
        cancelOrder(order);
      }
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
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
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_order_confirm_receipt));
      EventBusUtil.getInstance().emit(OrderEvent());
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

}
