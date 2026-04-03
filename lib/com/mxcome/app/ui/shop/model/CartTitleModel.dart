
import 'dart:ui';

import 'package:mxcome/com/mxcome/app/ui/shop/model/ConfirmModel.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';

import '../../../IConstant.dart';
import '../../../model/BaseModel.dart';
import 'CartItem.dart';

class CartTitleModel {
  String shopId;
  String shopName;
  String shopIcon;
  List<CartItem> dataList;

  CartTitleModel(
      this.shopId,
      this.shopName,
      this.shopIcon,
      this.dataList);

  factory CartTitleModel.fromJson(String shopId, List<dynamic> dataList) {
    String shopName = BaseModel.getString(dataList[0], "shopName");
    String shopIcon = BaseModel.getString(dataList[0], "shopIcon");
    shopName = TextUtils.isEmpty(shopName) ? "" : shopName;
    List<CartItem> cartList = [];
    for (dynamic item in dataList) {
      cartList.add(CartItem.toCartItem(item));
    }
    return CartTitleModel(shopId, shopName, shopIcon, cartList);
  }
}
