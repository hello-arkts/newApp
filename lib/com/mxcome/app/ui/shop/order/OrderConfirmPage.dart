
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/OrderEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/address/EditAddressPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/address/SelectAddressPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/CartItem.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/ConfirmModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/ConfirmTitleModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/order/FreightPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/order/PayPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/order/SelectCouponPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';
import 'package:mxcome/com/mxcome/app/utils/NumUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:sprintf/sprintf.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IURLConstant.dart';

import '../../../Logger.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../brand/BrandShopPage.dart';
import '../event/AddressEvent.dart';
import '../model/CouponModel.dart';
import '../model/GiftModel.dart';
import '../utils/EventBusUtil.dart';
import '../widget/BigTextButton.dart';
import '../widget/LoadImageView.dart';
import '../widget/PriceText.dart';
import 'SelectDeliveryPage.dart';

class OrderConfirmPage extends StatefulWidget {

  List<CartItem> selectCartList = [];
  bool fromCart = false;
  List<GiftModel> selectGiftList = [];
  String productId;
  bool isLottery;

  OrderConfirmPage(this.selectCartList, this.fromCart, this.selectGiftList, { this.productId = "", this.isLottery = false });


  @override
  State<OrderConfirmPage> createState() => _OrderConfirmPageState();

}

class _OrderConfirmPageState extends BaseKeepAliveState<OrderConfirmPage> {
  dynamic defaultAddress;

  String name = "";
  String phoneNumber = "";

  int memberIntegration = 0;
  List<dynamic> cartPromotionItemList = [];
  List<dynamic> couponHistoryDetailList = [];

  double freightAmount = 0;
  double productGrowthTax = 0;
  double payAmount = 0;
  double totalAmount = 0;
  dynamic orderData;

  dynamic addressEvent;
  List<ConfirmTitleModel> confirmTitleList = [];

  List<CouponModel> _couponList = [];
  double _couponAmount = 0;

  String email = "";

  final FocusNode _nodeText1 = FocusNode();

  bool nameError = false;

  @override
  void initState() {
    super.initState();
    addressEvent = EventBusUtil.getInstance().on<AddressEvent>((event) {
      if (event.address != null) {
        if (event.operateStatus == OperateStatus.delete) { //处理删除地址逻辑
          if (defaultAddress != null && defaultAddress["id"] == event.address["id"]) {
            setState(() {
              defaultAddress = null;
            });
            getAddressList();
          }
        } else { //处理修改地址、选择地址逻辑
          setState(() {
            defaultAddress = event.address;
            name = defaultAddress["name"];
            phoneNumber = defaultAddress["phoneNumber"];
          });
          getFreightPrice();
          setDefaultCoupon();
        }
      } else { //处理添加地址逻辑
        getAddressList();
      }
    });
    loadContentDatas();
  }

  void getAddressList() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_MEMBER_ADDRESS_LIST, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<dynamic> addressList = rsp.data;
      setAddress(addressList);
      if (addressList.isNotEmpty) {
        getFreightPrice();
      } else {
        setState(() {
          defaultAddress = null;
        });
      }
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  @override
  Future<void> loadContentDatas() async {
    dynamic data = await AppUtils.getUserInfo();
    setState(() {
      email = BaseModel.getString(data, "email");
    });
    if (widget.selectGiftList.isNotEmpty) { //赠品下单
      List<dynamic> levelGiftList = [];
      dynamic activityGiftItem = {};
      List<dynamic> pocketGiftList = [];
      for (GiftModel item in widget.selectGiftList) {
        if (item.type == 0) {
          pocketGiftList.add({
            "price": item.price,
            "pocketId": item.pocketId,
            "productGiftId": item.productGiftId,
            "skuCode": item.skuCode,
            "skuId": item.skuId,
            "skuPic": item.skuPic,
          });
        } else if(item.type == 1) {
          levelGiftList.add({
            "activityId": item.activityId,
            "level": item.level,
            "levelGiftId": item.levelGiftId,
            "price": item.price,
            "productGiftId": item.productGiftId,
            "skuCode": item.skuCode,
            "skuId": item.skuId,
            "skuPic": item.skuPic,
          });
        } else if(item.type == 2) {
          activityGiftItem = {
            "activityId": item.activityId,
            "price": item.price,
            "productGiftId": item.productGiftId,
            "skuCode": item.skuCode,
            "skuId": item.skuId,
            "skuPic": item.skuPic,
          };
        }
      }
      BaseRsp rsp = await HttpUtils.postJSON(
          IURLConstant.MALL_GENERATE_CONFIRM_GIFT_ORDER, null,
          body: {
            "activityGiftItem": activityGiftItem,
            "levelGiftItemList": levelGiftList,
            "pocketGiftItemList": pocketGiftList
          });
      if (rsp.retCode == RspRetCode.SUCCESS) {
        dynamic orderDetail = rsp.data;
        List<dynamic> addressList = BaseModel.getDynamic(orderDetail, "memberReceiveAddressList");
        setAddress(addressList);
        setState(() {
          cartPromotionItemList = BaseModel.getDynamic(orderDetail, "cartPromotionItemList");
          couponHistoryDetailList = BaseModel.getDynamic(orderDetail, "couponHistoryDetailList");
          memberIntegration = BaseModel.getInt(orderDetail, "memberIntegration");
          dynamic calcAmount = BaseModel.getDynamic(orderDetail, "calcAmount");
          productGrowthTax = BaseModel.getDouble(calcAmount, "productGrowthTax");
          freightAmount = BaseModel.getDouble(calcAmount, "freightAmount");
          payAmount = BaseModel.getDouble(calcAmount, "payAmount");
          totalAmount = BaseModel.getDouble(calcAmount, "totalAmount");
        });
        getFreightPrice();
        setDefaultCoupon();
        List<ConfirmTitleModel> tempTitleList = toGroupList();
        setState(() {
          confirmTitleList = tempTitleList;
        });
      } else {
        ViewUtils.displayToast(rsp.msg);
      }
    } else {
      if (widget.fromCart) {
        //购物车下单
        List<String> cartIds = [];
        for (CartItem item in widget.selectCartList) {
          cartIds.add("${item.id}");
        }
        BaseRsp rsp = await HttpUtils.postJSON(
            IURLConstant.MALL_ORDER_GENERATE_CONFIRM_ORDER, null,
            body: cartIds);
        if (rsp.retCode == RspRetCode.SUCCESS) {
          dynamic orderDetail = rsp.data;
          dynamic addressList = BaseModel.getDynamic(orderDetail, "memberReceiveAddressList");
          setAddress(addressList);
          setState(() {
            cartPromotionItemList = BaseModel.getDynamic(orderDetail, "cartPromotionItemList");
            couponHistoryDetailList = BaseModel.getDynamic(orderDetail, "couponHistoryDetailList");
            memberIntegration = BaseModel.getInt(orderDetail, "memberIntegration");
            dynamic calcAmount = BaseModel.getDynamic(orderDetail, "calcAmount");
            productGrowthTax = BaseModel.getDouble(calcAmount, "productGrowthTax");
            freightAmount = BaseModel.getDouble(calcAmount, "freightAmount");
            payAmount = BaseModel.getDouble(calcAmount, "payAmount");
            totalAmount = BaseModel.getDouble(calcAmount, "totalAmount");
          });
          getFreightPrice();
          setDefaultCoupon();
          List<ConfirmTitleModel> tempTitleList = toGroupList();
          setState(() {
            confirmTitleList = tempTitleList;
          });
        } else {
          ViewUtils.displayToast(rsp.msg);
        }
      } else {
        //立即购买
        CartItem item = widget.selectCartList[0];
        BaseRsp rsp = await HttpUtils.postJSON(
            IURLConstant.MALL_ORDER_PLACE_CONFIRM_ORDER, {
          "id": item.id,
          "price": item.price,
          "productAttr": item.productAttr,
          "productBrand": item.productBrand,
          "productId": item.productId,
          "productName": item.productName,
          "productPic": item.productPic,
          "productSkuCode": item.productSkuCode,
          "productSkuId": item.productSkuId,
          "productSn": item.productSn,
          "productSubTitle": item.productSubTitle,
          "quantity": item.quantity,
          "pocketCode": item.pocketCode,
        });
        if (rsp.retCode == RspRetCode.SUCCESS) {
          dynamic orderDetail = rsp.data;
          dynamic addressList = BaseModel.getDynamic(orderDetail, "memberReceiveAddressList");
          setAddress(addressList);
          setState(() {
            cartPromotionItemList = BaseModel.getDynamic(orderDetail, "cartPromotionItemList");
            couponHistoryDetailList = BaseModel.getDynamic(orderDetail, "couponHistoryDetailList");
            memberIntegration = BaseModel.getInt(orderDetail, "memberIntegration");
            dynamic calcAmount = BaseModel.getDynamic(orderDetail, "calcAmount");
            freightAmount = BaseModel.getDouble(calcAmount, "freightAmount");
            productGrowthTax = BaseModel.getDouble(calcAmount, "productGrowthTax");
            payAmount = BaseModel.getDouble(calcAmount, "payAmount");
            totalAmount = BaseModel.getDouble(calcAmount, "totalAmount");
          });
          getFreightPrice();
          setDefaultCoupon();
          List<ConfirmTitleModel> tempTitleList = toGroupList();
          setState(() {
            confirmTitleList = tempTitleList;
          });
        } else {
          ViewUtils.displayToast(rsp.msg);
        }
      }
    }
  }

  bool amountLoading = false;

  void getFreightPrice() async {
    if(defaultAddress == null) return;
    amountLoading = true;
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.postJSON(IURLConstant.MALL_GET_PRICE_ADDRESS_ID, null, body: {
      "addressId": BaseModel.getString(defaultAddress, "id"),
      "cartPromotionItemList": cartPromotionItemList
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      dynamic orderDetail = rsp.data;
      setState(() {
        cartPromotionItemList = BaseModel.getDynamic(orderDetail, "cartPromotionItemList");
        couponHistoryDetailList = BaseModel.getDynamic(orderDetail, "couponHistoryDetailList");
        memberIntegration = BaseModel.getInt(orderDetail, "memberIntegration");
        dynamic calcAmount = BaseModel.getDynamic(orderDetail, "calcAmount");
        freightAmount = BaseModel.getDouble(calcAmount, "freightAmount");
        productGrowthTax = BaseModel.getDouble(calcAmount, "productGrowthTax");
        payAmount = BaseModel.getDouble(calcAmount, "payAmount");
        totalAmount = BaseModel.getDouble(calcAmount, "totalAmount");
      });
      Logger.log("productGrowthTax: $productGrowthTax freightAmount: $freightAmount payAmount: $payAmount");
      List<ConfirmTitleModel> tempTitleList = toGroupList();
      setState(() {
        confirmTitleList = tempTitleList;
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
    amountLoading = false;
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().emit(OrderEvent());
    EventBusUtil.getInstance().off(addressEvent);
    super.dispose();
  }

  void setAddress(List<dynamic> addressList) {
    List<dynamic> tempList = [];
    for (dynamic item in addressList) {
      tempList.add(item);
      if (BaseModel.getString(item, "defaultStatus") == "1") {
        defaultAddress = item;
        break;
      }
    }
    if (defaultAddress == null && tempList.isNotEmpty) {
      defaultAddress = tempList[0];
    }
    if (defaultAddress != null) {
      setState(() {
        name = defaultAddress["name"];
        phoneNumber = defaultAddress["phoneNumber"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return KeyboardDismissOnTap(
      child: Scaffold(
        drawerScrimColor: Colors.transparent,
        backgroundColor: IConstant.white_color,
        appBar: AppBar(
          elevation: 0.5.w,
          centerTitle: true,
          title: Text(
              LanguageConfig.get(LanguageConfigKeys.Shop_order_confirm_order),
              style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
        ),
        body: cartPromotionItemList.isEmpty ? ViewUtils.buildLoading() : SingleChildScrollView(
          child: Column(
              children: [
                isShowGoodsAddress() ? buildAddress() : Container(),
                buildBuyList(),
                buildTotal(),
                buildEmail()
              ]),
        ),
        bottomNavigationBar: buildBottomBar(),
      ),
    );
  }

  void reloadCartList(List<ConfirmTitleModel> result) {
    List<dynamic> cartTempList = [];
    for (ConfirmTitleModel titleModel in result) {
      for (ConfirmModel model in titleModel.dataList) {
        cartTempList.add(model.toJson());
      }
    }
    setState(() {
      cartPromotionItemList = cartTempList;
    });
    getFreightPrice();
  }

  Widget buildAddress() {
    if (defaultAddress != null) {
      return Container(
        height: 40.w,
        color: IConstant.white_bg_color,
        child: Row(
          children: [
            SizedBox(width: 10.w),
            Expanded(
              child: InkWell(
                onTap: () {
                  showPop(0.8 * Adapt.getWindowHeight(), SelectAddressPage(BaseModel.getString(defaultAddress, "id")));
                },
                child: Row(
                  children: [
                    Icon(Icons.location_on_sharp, size: 20.w, color: IConstant.main_color),
                    SizedBox(width: 4.w),
                    Expanded(child: Text(getAddressDetail(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13.sp, color: IConstant.text_color))),
                    Icon(Icons.keyboard_arrow_down, size: 24.w, color: IConstant.text_color),
                    SizedBox(width: 16.w),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return InkWell(
          onTap: () {
            showPop(0.8 * Adapt.getWindowHeight(), EditAddressPage(null));
          },
          child: ListTile(
              title: Text(LanguageConfig.get(
                  LanguageConfigKeys.Shop_address_add_receipt_address)),
              trailing: Icon(Icons.chevron_right, size: 24.w)));
    }
  }

  String getAddressDetail() {
    return "${LanguageConfig.get(LanguageConfigKeys.Shop_order_delivery_to)} ${defaultAddress["name"]} ${defaultAddress["phoneNumber"]} ${defaultAddress["detailAddress"]}";
  }

  Widget buildBuyList() {
    return Column(
      children: confirmTitleList.map((item) => buildTitle(item)).toList(),
    );
  }

  Widget buildTitle(ConfirmTitleModel model) {
    bool isAllVirtualGoods = model.dataList.every((obj) => obj.property == 2);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildMerchant(model),
        Column(
          children: model.dataList.map((item) => buildBuyItem(item)).toList(),
        ),
        isAllVirtualGoods ? Container() : Container(
            margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 0.w),
            padding: EdgeInsets.fromLTRB(14.w, 8.w, 10.w, 8.w),
            decoration: BoxDecoration(
                color: IConstant.line_color,
                borderRadius: BorderRadius.all(Radius.circular(10.w))),
            child: Row(
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_product_delivery),
                    style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
                expandeSpace,
                buildDelivery(model),
              ],
            ),
        ),
        SizedBox(height: 8.w)
      ],
    );
  }

  Widget buildDelivery(ConfirmTitleModel model) {
    ConfirmModel? selectModel;
    for (ConfirmModel item in model.dataList) {
      if (item.templateId != 0) {
        selectModel = item;
        break;
      }
    }
    if(selectModel != null) {
      return InkWell(
        onTap: () {
          if(defaultAddress == null) return;
          showPop(0.6 * Adapt.getWindowHeight(), SelectDeliveryPage(model.shopId, confirmTitleList, (ctx, cartList) {
            finishContext(ctx);
            setState(() {
              confirmTitleList = cartList;
            });
            reloadCartList(cartList);
          }));
        },
        child: Row(
          children: [
            Text(getDeliveryModel(selectModel),
                style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
            Icon(Icons.chevron_right, size: 22.w, color: IConstant.text_color)
          ],
        ),
      );
    } else {
      return Container(
          padding: EdgeInsets.fromLTRB(8.w, 2.w, 8.w, 2.w),
          decoration: BoxDecoration(
              border: Border.all(width: 1.w, color: IConstant.main_color),
              borderRadius: BorderRadius.all(Radius.circular(15.w))),
          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_brand_free_package),
            style: TextStyle(fontSize: 13.sp, color: IConstant.main_color),
          )
      );
    }
  }

  Widget buildBuyItem(ConfirmModel item) {
    return Column(
      children: [
        Container(
          height: 90.w,
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
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: PriceText(item.price, fontWeight: FontWeight.bold, fontSize: 15.sp),
                          ),
                          Expanded(child: Container()),
                          Text("×${item.quantity}",
                              style: TextStyle(fontSize: 13.sp, color: IConstant.text_color))
                        ],
                      ),
                    ],
                  ))
            ],
          ),
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
          margin: EdgeInsets.only(left: 10.w, right: 10.w),
          height: 40.w,
          child: Row(
            children: [
              ClipOval(child: LoadImageView(36.w, 36.w, item.shopIcon)),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(item.shopName, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.text_color)),
              ),
              Icon(Icons.chevron_right, size: 20.w, color: IConstant.text_color,),
            ],
          ),
        )
    );
  }

  Widget buildCoupon() {
    return Text("-${FormatUtil.price2String(_couponAmount)}",
        textAlign: TextAlign.end,
        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: IConstant.main_color));
  }

  Widget buildTotal() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
      padding: EdgeInsets.fromLTRB(16.w, 10.w, 10.w, 10.w),
      decoration: BoxDecoration(
          border: Border.all(width: 1.w, color: IConstant.line_color),
          borderRadius: BorderRadius.all(Radius.circular(15.w))),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.w, bottom: 6.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_goods_total),
                        style: TextStyle(
                            fontSize: 14.sp, color: IConstant.title_color)),
                    SizedBox(width: 10.w),
                    Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_order_total_baby), [ getTotalQuantity() ]),
                        style: TextStyle(
                            fontSize: 12.sp, color: IConstant.sub_text_color)),
                  ],
                ),
                PriceText(totalAmount, fontSize: 15.sp, textAlign: TextAlign.end, color: IConstant.text_color,),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 6.w, bottom: 6.w),
            child: Row(
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_freight),
                    style: TextStyle(
                        fontSize: 14.sp, color: IConstant.title_color)),
                SizedBox(width: 4.w),
                InkWell(
                  onTap: () {
                    showPop(0.8 * Adapt.getWindowHeight(), FreightPage(freightAmount, confirmTitleList));
                  },
                  child: Icon(Icons.error_outline, size: 18.w, color: IConstant.main_color),
                ),
                SizedBox(width: 20.w),
                expandeSpace,
                amountLoading ? LottieBuilder.asset(
                  'assets/lotties/loading.json', width: 30.w, height: 30.w, repeat: true,
                ): PriceText(freightAmount, fontSize: 15.sp, textAlign: TextAlign.end, color: IConstant.text_color),
                SizedBox(width: 6.w),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              nextPage(SelectCouponPage(_couponList, (ctx, couponList) {
                finishContext(ctx);
                setState(() {
                  _couponList = couponList;
                });
                setSelectTotal();
              }), false);
            },
            child: Padding(
              padding: EdgeInsets.only(top: 6.w, bottom: 6.w),
              child: Row(
                children: [
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_coupons),
                      style: TextStyle(
                          fontSize: 14.sp, color: IConstant.title_color)),
                  SizedBox(width: 10.w),
                  Container(
                    padding: EdgeInsets.fromLTRB(4.w, 2.w, 4.w, 2.w),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.w, color: IConstant.main_color),
                      borderRadius: BorderRadius.all(Radius.circular(8.w))
                    ),
                    child: Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_order_selected), [ getVoucherCount() ]),
                        style: TextStyle(
                            fontSize: 12.sp, color: IConstant.main_color)),
                  ),
                  SizedBox(width: 20.w),
                  expandeSpace,
                  buildCoupon(),
                  Icon(Icons.chevron_right,
                      size: 24.w, color: IConstant.sub_text_color),
                ],
              ),
            ),
          ),
          buildCouponDetail(),
          Row(
            children: [
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_payment_required),
                  style: TextStyle(fontSize: 14.sp, color: IConstant.title_color)),
              expandeSpace,
              PriceText(getActualAmount(),
                  textAlign: TextAlign.end, fontSize: 15.sp, fontWeight: FontWeight.bold, color: IConstant.main_color),
              SizedBox(width: 6.w),
            ],
          )
        ],
      ),
    );
  }

  Widget buildEmail() {
    return isShowGoodsEmail() ? Container(
      margin: EdgeInsets.only(top: 30.w, left: 18.w, right: 18.w, bottom: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LanguageConfig.get(LanguageConfigKeys.shop_order_card_email_title),
            style: TextStyle(
              color: IConstant.text_color,
              fontSize: 12.sp,
            ),
          ),
      SizedBox(height: 15.w,),
      Container(
        padding: EdgeInsets.fromLTRB(10.w, 0.w, 10.w, 0),
        decoration: BoxDecoration(
            border: Border.all(color: nameError ? IConstant.main_color : IConstant.text_color, width: 1.w),
            borderRadius: BorderRadius.circular(10.w)),
        child: Row(
          children: [
            Image.asset("assets/icons/ic_order_email.png",width: 18.w, height: 18.w,),
            SizedBox(width: 8.w,),
            Expanded(
              child: TextField(
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                focusNode: _nodeText1,
                style: TextStyle(color: IConstant.text_color, fontSize: 14.sp),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: LanguageConfig.get(LanguageConfigKeys.shop_order_card_email_error),
                    hintStyle: TextStyle(color: const Color(0x8C292929), fontSize: 14.sp)),
                controller: ViewUtils.buildTextEditingController(email, listener: (str) {
                  email = str;
                  if(nameError) {
                    if(TextUtils.isEmpty(email) || NumUtils.isEmail(email)) {
                      setState(() {
                        nameError = false;
                      });
                    }
                  }
                }),
              ),
            ),
          ],
        ),),
          nameError ? Container(
            margin: EdgeInsets.only(top: 6.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.shop_order_card_email_error), style: TextStyle(fontSize: 12.sp, color: IConstant.main_color),),) : Container(height: 10.w,),
          SizedBox(height: 20.w,),
          Text(LanguageConfig.get(LanguageConfigKeys.shop_order_virtual_product_tip), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color),)
        ],
      ),
    ) : Container();
  }

  getActualAmount() {
    return totalAmount - _couponAmount <= 0 ? freightAmount : payAmount - _couponAmount;
  }

  Widget buildCouponDetail() {
    CouponModel? voucherModel;
    CouponModel? platformModel;
    List<CouponModel> merchantList = [];
    for (CouponModel item in _couponList) {
      if (item.isSelect) {
        if (item.shopId == 0 && item.type == 0) {
          voucherModel = item;
        } else if (item.shopId == 0) {
          platformModel = item;
        } else {
          merchantList.add(item);
        }
      }
    }
    return Column(
      children: [
        voucherModel != null ? Container(
          margin: EdgeInsets.only(right: 6.w, bottom: 8.w),
          padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 8.w),
          decoration: BoxDecoration(
              color: IConstant.grey_bg_color,
              borderRadius: BorderRadius.all(Radius.circular(10.w))
          ),
          child: Row(
            children: [
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_voucher),
                  style: TextStyle(fontSize: 13.sp, color: IConstant.title_color)),
              SizedBox(width: 10.w),
              Text(getUseType(voucherModel.useType, voucherModel.minPoint), textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
              expandeSpace,
              Text("-${FormatUtil.price2String(voucherModel.amount)}",
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 13.sp, color: IConstant.text_color))
            ],
          ),
        ) : Container(),
        platformModel != null ? Container(
          margin: EdgeInsets.only(right: 6.w, bottom: 8.w),
          padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 8.w),
          decoration: BoxDecoration(
            color: IConstant.grey_bg_color,
            borderRadius: BorderRadius.all(Radius.circular(10.w))
          ),
          child: Row(
            children: [
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_platform_voucher),
                  style: TextStyle(fontSize: 13.sp, color: IConstant.title_color)),
              SizedBox(width: 10.w),
              Text(getUseType(platformModel.useType, platformModel.minPoint), textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
              expandeSpace,
              Text("-${FormatUtil.price2String(platformModel.amount)}",
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 13.sp, color: IConstant.text_color))
            ],
          ),
        ) : Container(),
        Column(
          children: merchantList.map((item) => buildMerchantItem(item)).toList(),
        ),
      ],
    );
  }

  Widget buildMerchantItem(CouponModel item) {
    return Container(
      margin: EdgeInsets.only(right: 6.w, bottom: 8.w),
      padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 8.w),
      decoration: BoxDecoration(
          color: IConstant.grey_bg_color,
          borderRadius: BorderRadius.all(Radius.circular(10.w))
      ),
      child: Row(
        children: [
          Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_merchant_voucher),
              style: TextStyle(fontSize: 13.sp, color: IConstant.title_color)),
          SizedBox(width: 10.w),
          Text(getUseType(item.useType, item.minPoint), textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
          expandeSpace,
          Text("-${FormatUtil.price2String(item.amount)}",
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 13.sp, color: IConstant.text_color))
        ],
      ),
    );
  }

  String getDeliveryModel(ConfirmModel model) {
    int transportType = model.transportType;
    Logger.log("---${model.templateId} transportType: $transportType logisticsCode: ${model.logisticsCode} logisticsName: ${model.logisticsName}");
    String logisticsName = TextUtils.isEmpty(model.logisticsName) ? model.logisticsCode: model.logisticsName;
    String title = "";
    if (transportType == 1) {
      title = LanguageConfig.get(LanguageConfigKeys.Shop_order_delivery1);
    } else if(transportType == 2) {
      title = LanguageConfig.get(LanguageConfigKeys.Shop_order_delivery2);
    } else if(transportType == 3){
      title = LanguageConfig.get(LanguageConfigKeys.Shop_order_delivery3);
    }
    if (TextUtils.isNotEmpty(title) && TextUtils.isNotEmpty(logisticsName)) {
      return "$title/$logisticsName";
    } else {
      return "";
    }
  }

  String getUseType(int type, double minPoint) {
    if (minPoint > 0) {
      return sprintf("(${LanguageConfig.get(LanguageConfigKeys.Shop_mine_full_available)})", [ FormatUtil.price2String(minPoint) ]);
    } else {
      return "";
    }
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      child: Container(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_total),
                        style: TextStyle(
                            fontSize: 13.sp, color: IConstant.title_color)),
                    SizedBox(width: 10.w),
                    PriceText(payAmount, fontWeight: FontWeight.bold, fontSize: 14.sp)
                  ],
                ),
                Row(
                  children: [
                    Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_total_discount),
                        style: TextStyle(
                            fontSize: 13.sp, color: IConstant.title_color)),
                    SizedBox(width: 10.w),
                    PriceText(totalAmount - _couponAmount <= 0 ? totalAmount: _couponAmount, fontWeight: FontWeight.bold, fontSize: 14.sp)
                  ],
                )
              ],
            ),
            //expandeSpace,
            BigTextButton(
                text: LanguageConfig.get(LanguageConfigKeys.Shop_order_place_order),
                onTap: () {
                  checkPay();
                })
          ],
        ),
      ),
    );
  }

  Future<void> generateOrder() async {
    if (isShowGoodsAddress() && defaultAddress == null) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_order_select_receive_address));
      return;
    }
    if(isShowGoodsEmail()) {
      if(TextUtils.isEmpty(email)) {
        ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.shop_order_card_email_not_empty));
        return;
      }else {
        if(!NumUtils.isEmail(email)) {
          setState(() {
            nameError = true;
          });
          return;
        }
      }
    }
    ViewUtils.show();
    List<String> cartIds = [];
    for (dynamic item in cartPromotionItemList) {
      cartIds.add(BaseModel.getString(item, "id"));
    }
    BaseRsp rsp = await HttpUtils.postJSON(IURLConstant.MALL_ORDER_GENERATE_ORDER, {
      "cartIds": cartIds,
      "couponIds": getCouponIds(),
      "memberReceiveAddressId": isAllVirtualGoods() ? '' : defaultAddress["id"],
      "payType": "",
      "plateCouponId": getVoucherId(),
      "sourceType": "1",
      "useIntegration": 0,
      "receiverEmail": email
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      orderData = rsp.data;
      int orderOverTime = BaseModel.getInt(orderData, "orderOverTime");
      Logger.info("---isLottery 2: ${widget.isLottery}");
      nextPage(PayPage(BaseModel.getDynamic(orderData, "order"), false, orderOverTime: orderOverTime, productId: widget.productId, isLottery: widget.isLottery), false);
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  void checkPay() async {
    if (orderData != null) {
      Logger.log("---Goto Pay---");
      int orderOverTime = BaseModel.getInt(orderData, "orderOverTime");
      Logger.info("---isLottery 3: ${widget.isLottery}");
      nextPage(PayPage(BaseModel.getDynamic(orderData, "order"), false, orderOverTime: orderOverTime, productId: widget.productId, isLottery: widget.isLottery), false);
    } else {
      Logger.log("---Generate Order---");
      generateOrder();
    }
  }

  List<ConfirmTitleModel> toGroupList() {
    LinkedHashMap<String, List<dynamic>> cartMaps = LinkedHashMap();
    for (dynamic item in cartPromotionItemList) {
      String shopId = BaseModel.getString(item, "shopId");
      if (cartMaps.containsKey(shopId)) {
        //存在直接添加
        List<dynamic>? oldList = cartMaps[shopId];
        oldList?.add(item);
      } else {
        //不存在创建再添加
        List<dynamic> newList = [];
        newList.add(item);
        cartMaps.putIfAbsent(shopId, () => newList);
      }
    }
    List<ConfirmTitleModel> titleList = [];
    cartMaps.forEach((key, value) {
      titleList.add(ConfirmTitleModel.fromJson(key, value));
    });
    return titleList;
  }

  bool isShowGoodsAddress() {
    for (dynamic item in cartPromotionItemList) {
      int property = BaseModel.getInt(item, "property");
      if(property == 0) {
        return true;
      }
    }
    return false;
  }

  bool isShowGoodsEmail() {
    for (dynamic item in cartPromotionItemList) {
      int property = BaseModel.getInt(item, "property");
      if(property == 2) {
        return true;
      }
    }
    return false;
  }

  bool isAllOriginalGoods() {
    return cartPromotionItemList.every((obj) => obj["property"] == "");
  }

  bool isAllVirtualGoods() {
    return cartPromotionItemList.every((obj) => obj["property"] == 2);
  }

  void setDefaultCoupon() {
    Logger.log("---couponHistoryDetailList: $couponHistoryDetailList");
    List<CouponModel> tempList = [];
    for (var item in couponHistoryDetailList) {
      tempList.add(CouponModel.fromJson(item, false));
    }
    tempList.sort((a, b) => a.type.compareTo(b.type));
    tempList.sort((a, b) => a.useType.compareTo(b.useType));
    tempList.sort((a, b) => a.shopId.compareTo(b.shopId));
    setSelectModel(tempList);
    setSelectTotal();
  }

  void setSelectModel(List<CouponModel> tempList) {
    List<int> selectIds = []; //默认选择优惠券
    List<CouponModel> platformList = []; //代金券和平台券
    Set<int> merchantIds = {}; //商家券
    for (CouponModel item in tempList) {
      if ( item.type == 0 || item.shopId == 0) { //代金券和平台券
        platformList.add(item);
      } else {
        merchantIds.add(item.shopId);
      }
    }
    if (platformList.isNotEmpty) { //找到代金券最大金额
      platformList.sort((a, b) => b.amount.compareTo(a.amount));
      selectIds.add(platformList[0].id);
    }
    for (int shopId in merchantIds) {
      List<CouponModel> shopList = [];
      for (CouponModel item in tempList) {
        if (shopId == item.shopId) {
          shopList.add(item);
        }
      }
      shopList.sort((a, b) => b.amount.compareTo(a.amount));
      if (shopList.isNotEmpty) { //找到店铺最大的金额
        selectIds.add(shopList[0].id);
      }
    }
    tempList = removeDuplicates(tempList);
    for (CouponModel item in tempList) {
      if (selectIds.contains(item.id)) {
        item.isSelect = true;
      }
    }
    setState(() {
      _couponList = tempList;
    });
  }

  List<CouponModel> removeDuplicates(List<CouponModel> list) {
    List<CouponModel> uniqueList = [];
    List<int> uniqueIds = [];
    for (int i = 0; i < list.length; i++) {
      if (!uniqueIds.contains(list[i].id)) {
        uniqueIds.add(list[i].id);
        uniqueList.add(list[i]);
      }
    }
    return uniqueList;
  }

  void setSelectTotal() {
    double total = 0;
    for (CouponModel item in _couponList) {
      if (item.isSelect) {
        total += item.amount;
      }
    }
    setState(() {
      _couponAmount = total;
    });
  }

  List<int> getCouponIds() {
    List<int> couponIds = [];
    for (CouponModel item in _couponList) {
      if (item.isSelect && item.shopId != 0) {
        couponIds.add(item.id);
      }
    }
    return couponIds;
  }

  int getVoucherId() {
    int id = 0;
    for (CouponModel item in _couponList) {
      if (item.shopId == 0 && item.isSelect) {
        id = item.id;
      }
    }
    return id;
  }

  int getVoucherCount() {
    int count = 0;
    for (CouponModel item in _couponList) {
      if (item.isSelect) {
        count++;
      }
    }
    return count;
  }

  int getTotalQuantity() {
    int count = 0;
    for (var item in cartPromotionItemList) {
      int quantity = BaseModel.getInt(item, "quantity");
      count += quantity;
    }
    return count;
  }
}
