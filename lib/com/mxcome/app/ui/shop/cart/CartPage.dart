import 'dart:collection';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/Logger.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/CartEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/CartItem.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/CartTitleModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/order/OrderConfirmPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IURLConstant.dart';

import '../../../config/LanguageConfig.dart';
import '../../../model/BaseModel.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/HttpUtils.dart';
import '../brand/BrandShopPage.dart';
import '../detail/ProductDetailPage.dart';
import '../search/SearchCartBar.dart';
import '../widget/SmallCartNumberView.dart';
import '../widget/SmallTextButton.dart';
import '../widget/LoadImageView.dart';
import '../widget/PriceText.dart';

class CartPage extends StatefulWidget {

  bool fromDetail = false;

  CartPage({this.fromDetail = false});

  @override
  State<CartPage> createState() => _CartPageState();

}

class _CartPageState extends BaseKeepAliveState<CartPage> {

  double totalPrice = 0.00;
  bool isSelectAll = false;
  List<CartTitleModel> cartTitleList = [];
  dynamic addCartEvent;
  dynamic systemInfo;

  @override
  void initState() {
    super.initState();
    addCartEvent = EventBusUtil.getInstance().on<CartEvent>((event) {
      if(event.cartType == CartType.delete) {
        if (event.fromDetail == widget.fromDetail) {
          checkSelect();
        }
      } else if (event.cartType == CartType.complete){
        loadContentDatas();
      }
    });
    loadContentDatas();
    EventBusUtil.getInstance().emit(CartEvent());
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(addCartEvent);
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    List<dynamic> dataList = await AppUtils.getCartData();
    systemInfo = await AppUtils.getSystemSettingsInfo();
    cartListToGroupList(dataList);
    checkState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: SearchCartBar(fromDetail: widget.fromDetail),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  void checkSelect() {
    List<CartItem> cartList = getCartList();
    List<CartItem> selectCartList = [];
    for (CartItem item in cartList) {
      if (item.isSelect) {
        selectCartList.add(item);
      }
    }
    if (selectCartList.isEmpty) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_cart_select_goods));
      return;
    }
    deleteConfirm();
  }

  void deleteConfirm(){
    ViewUtils.showConfirmDialog(context, LanguageConfig.get(LanguageConfigKeys.Shop_cart_is_delete), (ctx, bl) => {
      if (bl) {
        deleteCart()
      } else {
        finishContext(ctx)
      }
    });
  }

  Widget buildBody(){
    if(cartTitleList.isEmpty){
      return Center(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_cart_empty), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)));
    } else {
      return EasyRefresh(
          header: MaterialHeader(color: IConstant.main_color),
          onRefresh: ()=> _onRefresh(), child: ListView.separated(
        padding: EdgeInsets.fromLTRB(10.w, 16.w, 16.w, 16.w),
        scrollDirection: Axis.vertical,
        itemCount: cartTitleList.length,
        itemBuilder: (context, index) {
          return buildTitle(cartTitleList[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 10.w,
          );
        },
      ));
    }
  }

  Future<void> _onRefresh() async {
    EventBusUtil.getInstance().emit(CartEvent());
    await Future.delayed(const Duration(milliseconds: 800),() {
    });
  }

  Widget buildTitle(CartTitleModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildMerchant(model),
        Column(
          children: model.dataList.map((item) => buildCartItem(item)).toList(),
        )
      ],
    );
  }

  Widget buildMerchant(CartTitleModel item) {
    return InkWell(
        onTap: () {
          nextPage(BrandShopPage(item.shopId), false);
        },
        child: SizedBox(
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

  Widget buildCartItem(CartItem item) {
    return Container(
      margin: EdgeInsets.only(top: 10.w),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              selectItem(item);
            },
            child: Container(
              width: 30,
              height: 30,
              padding: EdgeInsets.only(right: 10.w),
              child: getIcon(item.isSelect),
            ),
          ),
          InkWell(
            onTap: () {
              nextMainPage();
              nextPageState(ProductDetailPage(item.productId), false);
            },
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(8.w)),
                clipBehavior: Clip.antiAlias,
                elevation: 2.w,
                child: LoadImageView(70.w, 70.w, item.productPic)),
          ),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      nextMainPage();
                      nextPageState(ProductDetailPage(item.productId), false);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: Text(
                        item.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 13.sp, color: IConstant.text_color),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 4.w, left: 10.w),
                    padding: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
                    decoration: BoxDecoration(
                        color: IConstant.grey_bg_color,
                        borderRadius: BorderRadius.circular(10.w)
                    ),
                    child: Text(
                      CartItem.getProductAttrValues(item.productAttr),
                      style: TextStyle(
                          fontSize: 12.sp, color: IConstant.sub_text_color),
                    ),
                  ),
                  SizedBox(height: 2.w,),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: PriceText(item.price, fontSize: 15.sp),
                      ),
                      Expanded(child: Container()),
                      SmallCartNumberView(
                          item.quantity, (number) => {updateCart(item, number)}, limitNum: BaseModel.getInt(systemInfo, 'productQuantityLimit'),)
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }

  updateCart(CartItem item, int quantity) async {
    int cartId = item.id;
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_CART_UPDATE_QUANTITY,
        {"id": cartId.toString(), "quantity": quantity.toString()});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        item.quantity = quantity;
        setTotalPrice();
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  deleteCart() async {
    List<CartItem> cartList = getCartList();
    Navigator.of(context).pop();
    String choiceIds = "";
    for (CartItem item in getCartList()) {
      if (item.isSelect) {
        choiceIds += "${item.id},";
      }
    }
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_CART_DELETE, {"ids": choiceIds});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      EventBusUtil.getInstance().emit(CartEvent());
      List<String> selectedList = [];
      for (CartItem item in cartList) {
        if (item.isSelect) {
          selectedList.add("${item.id}");
        }
      }
      List<CartTitleModel> tempList = cartTitleList;
      Logger.log("---tempList: ${tempList.length}---");
      for (CartTitleModel model in cartTitleList) {
        model.dataList.removeWhere((item) {
          return selectedList.contains("${item.id}");
        });
      }
      tempList.removeWhere((title) {
        return title.dataList.isEmpty;
      });
      Logger.log("---tempList: ${tempList.length}---");
      setState(() {
        cartTitleList = tempList;
        checkState();
      });
    }
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      child: Container(
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        height: 60.w,
        child: Row(
          children: [
            InkWell(
              onTap: () {
                selectAll();
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 30.w,
                    height: 30.w,
                    child: getIcon(isSelectAll),
                  ),
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_cart_select_all),
                      style: TextStyle(
                          fontSize: 12.sp, color: IConstant.text_color))
                ],
              ),
            ),
            expandeSpace,
            Row(
              children: [
                SizedBox(width: 10.w),
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_cart_total),
                    style: TextStyle(
                        fontSize: 14.sp, color: IConstant.text_color)),
                SizedBox(width: 6.w),
                PriceText(totalPrice, fontSize: 16.sp),
                SizedBox(width: 6.w),
              ],
            ),
            SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_cart_settlement), onTap: () {
              goOrder();
            }),
          ],
        ),
      ),
    );
  }

  void goOrder() {
    List<CartItem> cartList = getCartList();
    List<CartItem> selectCartList = [];
    for (CartItem item in cartList) {
      if (item.isSelect) {
        selectCartList.add(item);
      }
    }
    if(selectCartList.isEmpty){
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_cart_select_goods_settlement));
      return;
    }
    nextPage(OrderConfirmPage(selectCartList, true, []), false);
  }

  void selectItem(CartItem item) {
    setState(() {
      item.isSelect = !item.isSelect;
    });
    checkState();
  }

  void checkState(){
    int count = 0;
    List<CartItem> cartList = getCartList();
    for (CartItem item in cartList) {
      if (item.isSelect) {
        count++;
      }
    }
    if (count > 0 && count == cartList.length) {
      setState(() {
        isSelectAll = true;
      });
    } else {
      setState(() {
        isSelectAll = false;
      });
    }
    setTotalPrice();
  }

  void selectAll() {
    List<CartItem> cartList = getCartList();
    setState(() {
      isSelectAll = !isSelectAll;
      for (CartItem item in cartList) {
        item.isSelect = isSelectAll;
      }
    });
    setTotalPrice();
  }

  void setTotalPrice() {
    List<CartItem> cartList = getCartList();
    double total = 0.00;
    for (CartItem item in cartList) {
      if (item.isSelect) {
        total += (item.price * item.quantity);
      }
    }
    setState(() {
      totalPrice = total;
    });
  }

  Widget getIcon(bool check) {
    return check
        ? const Icon(Icons.check_circle, color: IConstant.main_color)
        : const Icon(Icons.circle, color: IConstant.grey_bg_color);
  }

  void cartListToGroupList(List<dynamic> cartList) {
    LinkedHashMap<String, List<dynamic>> cartMaps = LinkedHashMap();
    for (dynamic item in cartList) {
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
    List<CartTitleModel> titleList = [];
    cartMaps.forEach((key, value) {
      titleList.add(CartTitleModel.fromJson(key, value));
    });
    setState(() {
      cartTitleList = titleList;
    });
  }

  List<CartItem> getCartList() {
    List<CartItem> cartList = [];
    for (CartTitleModel item in cartTitleList){
      cartList.addAll(item.dataList);
    }
    return cartList;
  }

}
