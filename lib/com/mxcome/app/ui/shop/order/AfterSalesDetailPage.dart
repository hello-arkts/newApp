

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/Logger.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/CartItem.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IURLConstant.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../brand/BrandShopPage.dart';
import '../detail/ProductDetailPage.dart';
import '../model/OrderTitleModel.dart';
import '../utils/ClipboardUtil.dart';
import '../utils/FormatUtil.dart';
import '../widget/ExpandedOutlineText.dart';
import '../widget/LoadImageView.dart';
import '../widget/PriceText.dart';
import '../widget/SmallTextButton.dart';

class AfterSalesDetailPage extends StatefulWidget {

  dynamic afterSales;

  AfterSalesDetailPage(this.afterSales);

  @override
  State<AfterSalesDetailPage> createState() => _AfterSalesDetailPageState();
}

class _AfterSalesDetailPageState extends BaseKeepAliveState<AfterSalesDetailPage> {

  String title = '';

  int afterSalesType = 0; //1：未发货退款；2：退货退款；3：超时免单
  int afterSalesStatus = 0;

  List<OrderTitleModel> orderTitleList = [];

  dynamic afterSales;

  @override
  void initState() {
    super.initState();
    setState(() {
      afterSales = widget.afterSales;
      afterSalesStatus = BaseModel.getInt(afterSales, "status");
      afterSalesType = BaseModel.getInt(afterSales, "type");
    });
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    List<dynamic> newList = [];
    newList.add(afterSales);
    String shopId = BaseModel.getString(afterSales, "shopId");
    List<OrderTitleModel> titleList = [
      OrderTitleModel.fromJson(shopId, newList)
    ];
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
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_status),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: ListView(children: [
        buildRowType(),
        buildBuyList(),
        buildOrderInfo(),
        buildFee(),
      ]),
      // bottomNavigationBar: buildBottomBar(),
    );
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
    return Row(
      children: [
        InkWell(
            onTap: () {
              nextPage(BrandShopPage(orderTitleModel.shopId), false);
            },
            child: Row(
              children: [
                ClipOval(child: LoadImageView(22.w, 22.w, orderTitleModel.shopIcon)),
                SizedBox(width: 6.w),
                Text(orderTitleModel.shopName, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                Icon(Icons.chevron_right, size: 20.w, color: IConstant.text_color,),
              ],
            )
        ),
        expandeSpace,
      ],
    );
  }

  Widget buildBuyItem(dynamic item) {
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
                  child: LoadImageView(70.w, 70.w, BaseModel.getString(item, "productPic"))),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: Text(
                              BaseModel.getString(item, "productName"),
                              style:
                              TextStyle(fontSize: 12.sp, color: IConstant.text_color),
                            ),
                          )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10.w),
                                child: PriceText(BaseModel.getDouble(item, "productPrice"), fontSize: 12.sp, color: IConstant.title_color,),
                              ),
                              Text("×${BaseModel.getString(item, "productCount")}")
                            ],
                          )
                        ],
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
          )
        ]),
      ),
    );
  }

  Widget buildClipOval(double size, Color bgColor, bool isSolid) {
    if(isSolid) {
      return Center(child: ClipOval(
          child: Container(width: size, height: size, color: IConstant.main_color)));
    } else {
      return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: IConstant.main_color, width: 1.w)
      ),);
    }
  }

  Widget buildRowType() {
    if (afterSalesType == 1) { //未发货退款
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 30.w),
            padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 26.w),
            decoration: BoxDecoration(
                color: const Color(0xFFFDF1F1),
                borderRadius: BorderRadius.circular(15.w)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_refund), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.main_color)),
                SizedBox(height: 10.w),
                Row(children: [
                  SizedBox(width: 22.w),
                  buildClipOval(20.w, IConstant.white_color, true),
                  Expanded(child: Container(height: 2.w, color: IConstant.main_color)),
                  buildClipOval(20.w, IConstant.white_color, afterSalesStatus == 3),
                  //Expanded(child: Container(height: 2.w, color: IConstant.main_color)),
                  // buildClipOval(20.w, IConstant.white_color, true),
                  SizedBox(width: 22.w),
                ]),
                SizedBox(height: 10.w),
                Row(children: [
                  SizedBox(width: 10.w),
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_apply_submit), style: TextStyle(fontSize: 11.sp, color: IConstant.main_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_after_sales), style: TextStyle(fontSize: 11.sp, color: IConstant.main_color)),
                  //expandeSpace,
                  // Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_serivce_score), style: TextStyle(fontSize: 11.sp, color: IConstant.main_color)),
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
            child: SizedBox(
              height: 50.w,
              child: Row(
                children: [
                  SizedBox(width: 10.w),
                  Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_after_sales),
                      style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))),
                  SizedBox(width: 10.w),
                  Expanded(flex: 3, child: Text(getAfterSalesStatus(), textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))),
                  // ExpandedOutlineText(flex: 2, text: LanguageConfig.get(LanguageConfigKeys.Shop_sales_detail),
                  //     bgColor: IConstant.white_color,
                  //     borderColor: IConstant.line_color,
                  //     textColor: IConstant.text_color,
                  //     fontSize: 12.sp,
                  //     left: 8.w,
                  //     right: 8.w,
                  //     onTap: () {ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_coming_soon));
                  //     })
                ],
              ),
            ),
          )
        ],
      );
    } else if (afterSalesType == 2) { //退货退款
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 30.w),
            padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 26.w),
            decoration: BoxDecoration(
                color: const Color(0xFFFDF1F1),
                borderRadius: BorderRadius.circular(15.w)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_return_refund), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.main_color)),
                SizedBox(height: 10.w),
                Row(children: [
                  SizedBox(width: 22.w),
                  buildClipOval(20.w, IConstant.white_color, true),
                  Expanded(child: Container(height: 2.w, color: IConstant.main_color)),
                  buildClipOval(20.w, IConstant.white_color, false),
                  Expanded(child: Container(height: 2.w, color: IConstant.main_color)),
                  buildClipOval(20.w, IConstant.white_color, false),
                  Expanded(child: Container(height: 2.w, color: IConstant.main_color)),
                  buildClipOval(20.w, IConstant.white_color, false),
                  Expanded(child: Container(height: 2.w, color: IConstant.main_color)),
                  buildClipOval(20.w, IConstant.white_color, false),
                  SizedBox(width: 22.w),
                ]),
                SizedBox(height: 10.w),
                Row(children: [
                  SizedBox(width: 10.w),
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_submit_order), style: TextStyle(fontSize: 11.sp, color: IConstant.main_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_merchant_verify), style: TextStyle(fontSize: 11.sp, color: IConstant.main_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_delivery_serive), style: TextStyle(fontSize: 11.sp, color: IConstant.main_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_verify_product), style: TextStyle(fontSize: 11.sp, color: IConstant.main_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_after_sales), style: TextStyle(fontSize: 11.sp, color: IConstant.main_color)),
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
            child: SizedBox(
              height: 50.w,
              child: Row(
                children: [
                  SizedBox(width: 10.w),
                  Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_after_sales),
                      style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))),
                  SizedBox(width: 10.w),
                  Expanded(flex: 3, child: Text(getAfterSalesStatus(), textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp, color: IConstant.main_color))),
                  // ExpandedOutlineText(flex: 2, text: LanguageConfig.get(LanguageConfigKeys.Shop_sales_detail),
                  //     bgColor: IConstant.white_color,
                  //     borderColor: IConstant.line_color,
                  //     textColor: IConstant.text_color,
                  //     fontSize: 12.sp,
                  //     left: 8.w,
                  //     right: 8.w,
                  //     onTap: () {ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_coming_soon));
                  //     })
                ],
              ),
            ),
          )
        ],
      );
    } else if (afterSalesType == 3) { //超时免单
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 30.w),
            padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 26.w),
            decoration: BoxDecoration(
                color: const Color(0xFFFDF1F1),
                borderRadius: BorderRadius.circular(15.w)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_overtime), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.main_color)),
                SizedBox(height: 10.w),
                Row(children: [
                  SizedBox(width: 22.w),
                  buildClipOval(20.w, IConstant.white_color, true),
                  Expanded(child: Container(height: 2.w, color: IConstant.main_color)),
                  buildClipOval(20.w, IConstant.white_color, false),
                  Expanded(child: Container(height: 2.w, color: IConstant.main_color)),
                  buildClipOval(20.w, IConstant.white_color, false),
                  SizedBox(width: 22.w),
                ]),
                SizedBox(height: 10.w),
                Row(children: [
                  SizedBox(width: 10.w),
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_submit_order), style: TextStyle(fontSize: 11.sp, color: IConstant.main_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_merchant_verify), style: TextStyle(fontSize: 11.sp, color: IConstant.main_color)),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_serivce_score), style: TextStyle(fontSize: 11.sp, color: IConstant.main_color)),
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
            child: SizedBox(
              height: 50.w,
              child: Row(
                children: [
                  SizedBox(width: 10.w),
                  Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_after_sales),
                      style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))),
                  SizedBox(width: 10.w),
                  Expanded(flex: 3, child: Text(getAfterSalesStatus(), textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp, color: IConstant.main_color))),
                  // ExpandedOutlineText(flex: 2, text: LanguageConfig.get(LanguageConfigKeys.Shop_sales_detail),
                  //     bgColor: IConstant.white_color,
                  //     borderColor: IConstant.line_color,
                  //     textColor: IConstant.text_color,
                  //     fontSize: 12.sp,
                  //     left: 8.w,
                  //     right: 8.w,
                  //     onTap: () {ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_coming_soon));
                  // })
                ],
              ),
            ),
          )
        ],
      );
    } else {
      return Container();
    }
  }

  String getAfterSalesStatus(){
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

  String getRefundTime() {
    String handleTime = BaseModel.getString(afterSales, "handleTime");
    Logger.log("----handleTime: $handleTime");
    if(TextUtils.isNotEmpty(handleTime)) {
      return "${LanguageConfig.get(LanguageConfigKeys.Shop_sales_refunded)}  ${FormatUtil.formatMDHMS(DateTime.parse(handleTime))}";
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_sales_refunded);
    }
  }

  Widget buildPromiseItem(String name) {
    return Row(
      children: [
        Image.asset("assets/icons/star.png", width: 20.w, height: 20.w),
        SizedBox(width: 2.w),
        Text(name,
            style: TextStyle(
                fontSize: 11.sp,
                color: IConstant.text_color)),
      ],
    );
  }

  Widget buildOrderInfo() {
    String orderSn = BaseModel.getString(afterSales, "orderSn");
    String returnOrderNo = BaseModel.getString(afterSales, "returnOrderNo");
    String createTime = BaseModel.getString(afterSales, "createTime");
    String applyReason = BaseModel.getString(afterSales, "reason");
    int reasonId = BaseModel.getInt(afterSales, "reasonId");
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
      padding: EdgeInsets.fromLTRB(0.w, 6.w, 0.w, 6.w),
      decoration: BoxDecoration(
          border: Border.all(color: IConstant.grey_bg_color, width: 1.w),
          borderRadius: BorderRadius.circular(12.w)),
      child: Column(children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 6.w, 16.w, 6.w),
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
          padding: EdgeInsets.fromLTRB(16.w, 6.w, 16.w, 6.w),
          child: Row(
            children: [
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_number),
                  style: TextStyle(
                      fontSize: 14.sp, color: IConstant.sub_text_color)),
              SizedBox(width: 20.w),
              Expanded(
                  child: Text(returnOrderNo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 14.sp, color: IConstant.sub_text_color))),
              SizedBox(width: 8.w),
              InkWell(onTap: () => ClipboardUtil.setDataToast(returnOrderNo),
                child: Image.asset("assets/icons/copy_icon.png", width: 30.w, height: 30.w),)
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 6.w, 16.w, 6.w),
          child: Row(
            children: [
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_apply_time),
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
          padding: EdgeInsets.fromLTRB(16.w, 6.w, 16.w, 6.w),
          child: Row(
            children: [
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_apply_type),
                  style: TextStyle(
                      fontSize: 14.sp, color: IConstant.sub_text_color)),
              SizedBox(width: 20.w),
              Expanded(
                  child: Text(getApplyInfo(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 14.sp, color: IConstant.sub_text_color))),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 6.w, 16.w, 6.w),
          child: Row(
            children: [
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_apply_reason),
                  style: TextStyle(
                      fontSize: 14.sp, color: IConstant.sub_text_color)),
              SizedBox(width: 20.w),
              Expanded(
                  child: Text(getApplyReason(reasonId),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 14.sp, color: IConstant.sub_text_color))),
            ],
          ),
        ),
        afterSalesType == 2 ? buildDeliver() : Container()
      ]),
    );
  }
  
  String getApplyReason(int reasonId) {
    if(reasonId == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_sales_refund_item1);
    }else if(reasonId == 2) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_sales_refund_item2);
    }else if(reasonId == 3) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_sales_refund_item3);
    }else {
      return '';
    }
  }

  Widget buildDeliver() {
    String receiverName = BaseModel.getString(afterSales, "receiverName");
    String receiverPhone = BaseModel.getString(afterSales, "receiverPhone");
    String receiverProvince = BaseModel.getString(afterSales, "receiverProvince");
    String receiverCity = BaseModel.getString(afterSales, "receiverCity");
    String receiverRegion = BaseModel.getString(afterSales, "receiverRegion");
    String receiverDetailAddress = BaseModel.getString(afterSales, "receiverDetailAddress");
    return Column(
      children: [
        Container(height: 1.w, color: IConstant.grey_bg_color),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 6.w, 16.w, 6.w),
          child: Row(
            children: [
              Expanded(
                  flex: 2, child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_take_info),
                  style: TextStyle(
                      fontSize: 14.sp, color: IConstant.sub_text_color))),
              SizedBox(width: 30.w),
              Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("$receiverName $receiverPhone",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp, color: IConstant.sub_text_color)),
                      Text(getAddressDetail(receiverProvince, receiverCity, receiverRegion, receiverDetailAddress),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 12.sp, color: IConstant.sub_text_color)),
                    ],
                  )),
            ],
          ),
        )
      ],
    );
  }

  Widget buildFee() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0.w),
      decoration: BoxDecoration(
          border: Border.all(color: IConstant.grey_bg_color, width: 1.w),
          borderRadius: BorderRadius.circular(12.w)),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16.w, 6.w, 16.w, 6.w),
            decoration: BoxDecoration(
                color: IConstant.red_bg_color3,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.w))),
            child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_return_balance),
                style: TextStyle(fontSize: 12.sp, color: IConstant.main_color)),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 12.w),
            decoration: BoxDecoration(
                color: IConstant.white_color,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.w))),
            child: Row(
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_return_amount),
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.text_color)),
                expandeSpace,
                Text("+",
                    style: TextStyle(fontSize: 15.sp, color: IConstant.green_color)),
                SizedBox(width: 2.w),
                PriceText(BaseModel.getDouble(afterSales, "returnAmount"),  color: IConstant.green_color, fontSize: 15.sp,)
              ],
            ),
          )
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

  String getApplyInfo(){
    if (afterSalesType == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_sales_refund);
    } else if (afterSalesType == 2) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_sales_return_refund);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_sales_overtime);
    }
  }

  String getAddressDetail(String province, String city, String region, String detailAddress) {
    return "$detailAddress $region $city $province";
  }

  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ExpandedOutlineText(text: LanguageConfig.get(LanguageConfigKeys.Shop_sales_platform_in),
            textColor: IConstant.text_color,
            borderColor: IConstant.grey_line_color,
            bgColor: IConstant.white_color,
            fontSize: 12.sp, onTap: () => platformIn(afterSales)),
        ExpandedOutlineText(text: LanguageConfig.get(LanguageConfigKeys.Shop_sales_cancel_apply),
            textColor: IConstant.text_color,
            borderColor: IConstant.grey_line_color,
            bgColor: IConstant.white_color,
            fontSize: 12.sp, onTap: () => cancelApply(afterSales)),
        ExpandedOutlineText(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_contact_customer_service),
            fontSize: 12.sp, onTap: () => contactCustomer(afterSales)),
      ],
    );
  }

  Future<void> cancelApply(dynamic afterSales) async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_RETURN_APPLY_CANCEL, {
      "returnId": BaseModel.getString(afterSales, "id"),
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_sales_cancel_success));
      finish();
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  void contactCustomer(dynamic afterSales) {
    // ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_coming_soon));
  }

  Future<void> logisticsInfo(dynamic afterSales) async {
    String orderSn = BaseModel.getString(afterSales, "orderSn");
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
    // ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_coming_soon));
  }

}
