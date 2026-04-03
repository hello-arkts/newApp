
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/order/AfterSalesDetailPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:sprintf/sprintf.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IURLConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../brand/BrandShopPage.dart';
import '../event/OrderSearchEvent.dart';
import '../model/CartItem.dart';
import '../utils/EventBusUtil.dart';
import '../utils/FormatUtil.dart';
import '../widget/ExpandedOutlineText.dart';
import '../widget/LoadImageView.dart';

class SearchAfterSalesList extends StatefulWidget {

  String keyword = "";

  SearchAfterSalesList(this.keyword);

  @override
  State<SearchAfterSalesList> createState() => SearchAfterSalesListState();
}

class SearchAfterSalesListState extends BaseKeepAliveState<SearchAfterSalesList> {

  dynamic orderSearchEvent;
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    orderSearchEvent = EventBusUtil.getInstance().on<OrderSearchEvent>((event) {
      _searchText = event.query;
      loadContentDatas();
    });
    _searchText = widget.keyword;
    loadContentDatas();
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(orderSearchEvent);
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    isLoading = true;
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_AFTER_SALES_LIST,  {
      "keyWord": _searchText,
      "afterSalesStatus": "-2",
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

  Widget buildBody(){
    if(datas.isEmpty){
      return buildHeader();
    } else {
      return EasyRefresh(
          header: MaterialHeader(color: IConstant.main_color),
          footer: CupertinoFooter(emptyWidget: Container(
            padding: EdgeInsets.all(10.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_more),
                style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
          )),
          onRefresh: ()=> onRefresh(),
          onLoad: ()=> onLoadMore(), child: ListView.separated(
          scrollDirection: Axis.vertical,
          itemCount: datas.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                nextPage(AfterSalesDetailPage(datas[index]), false);
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
        expandeSpace,
        SizedBox(width: 16.w),
        buildStatus(order),
      ],
    );
  }

  Widget buildStatus(dynamic order) {
    int afterSalesStatus = BaseModel.getInt(order, "afterSalesStatus");
    return Text(getApplyInfo(afterSalesStatus), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color));
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

  Widget buildOrder(dynamic item) {
    return Row(
      children: [
        Expanded(flex: 3, child: buildOrderItem(item)),
        Expanded(flex: 1, child: buildOrderPrice(item)),
      ],
    );
  }

  Widget buildOrderItem(dynamic item) {
    return Row(
      children: [
        Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(8.w)),
            clipBehavior: Clip.antiAlias,
            elevation: 2,
            child: LoadImageView(70.w, 70.w, BaseModel.getString(item, "productPic"))),
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Text(
                    BaseModel.getString(item, "productName"),
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
                    CartItem.getProductAttrValues(BaseModel.getString(item, "productAttr")),
                    style: TextStyle(
                        fontSize: 12.sp, color: IConstant.text_color),
                  ),
                ),
              ],
            ))
      ],
    );
  }

  Widget buildOrderPrice(dynamic item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        PriceText(BaseModel.getDouble(item, "productPrice"), fontSize: 14.sp),
        Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_order_piece_in_total), [BaseModel.getInt(item, "productCount")]), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
      ],
    );
  }

  String handleDate(DateTime dateTime) {
    return FormatUtil.formatLineYMDHMS(dateTime); //格式化日期
  }

  Widget buildButtons(dynamic order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // ExpandedOutlineText(text: LanguageConfig.get(LanguageConfigKeys.Shop_sales_platform_in),
        //     textColor: IConstant.text_color,
        //     borderColor: IConstant.grey_line_color,
        //     bgColor: IConstant.white_color,
        //     fontSize: 12.sp, onTap: () => platformIn(order)),
        // ExpandedOutlineText(text: LanguageConfig.get(LanguageConfigKeys.Shop_sales_cancel_apply),
        //     textColor: IConstant.text_color,
        //     borderColor: IConstant.grey_line_color,
        //     bgColor: IConstant.white_color,
        //     fontSize: 12.sp, onTap: () => cancelApply(order)),
        // ExpandedOutlineText(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_contact_customer_service),
        //     fontSize: 12.sp, onTap: () => contactCustomer(order)),
        expandeSpace,
        expandeSpace,
        ExpandedOutlineText(text: LanguageConfig.get(LanguageConfigKeys.Shop_sales_detail),
          fontSize: 12.sp, onTap: () {
              nextPage(AfterSalesDetailPage(order), false);
        }),
      ],
    );
  }

  Future<void> cancelApply(dynamic order) async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_RETURN_APPLY_CANCEL, {
      "returnId": BaseModel.getString(order, "id"),
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_sales_cancel_success));
      loadContentDatas();
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  void contactCustomer(dynamic order) {
    ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_coming_soon));
  }

  Future<void> logisticsInfo(dynamic order) async {
    String orderSn = BaseModel.getString(order, "orderSn");
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_LOGISTICS_INFO, {
      "orderShopSn": orderSn
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {

    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  void platformIn(dynamic order) async {
    // BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_RETURN_APPLY_PLATFORM_IN, {
    //   "afterSalesId": BaseModel.getString(order, "id"),
    //   "orderId": BaseModel.getString(order, "orderId")
    // });
    // if (rsp.retCode == RspRetCode.SUCCESS) {
    //   showPop(0.7 * Adapt.getWindowHeight(), PlatformInPage());
    // } else {
    //   ViewUtils.displayToast(rsp.msg);
    // }
    ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_coming_soon));
  }

}
