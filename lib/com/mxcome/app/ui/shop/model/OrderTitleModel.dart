
import 'dart:ui';

import 'package:mxcome/com/mxcome/app/ui/shop/model/ConfirmModel.dart';

import '../../../IConstant.dart';
import '../../../model/BaseModel.dart';
import '../../../utils/TextUtils.dart';

class OrderTitleModel {
  String shopId;
  String shopName;
  String shopIcon;
  List<dynamic> dataList;

  OrderTitleModel(
      this.shopId,
      this.shopName,
      this.shopIcon,
      this.dataList);

  factory OrderTitleModel.fromJson(String shopId, List<dynamic> dataList) {
    String shopName = BaseModel.getString(dataList[0], "shopName");
    String shopIcon = BaseModel.getString(dataList[0], "shopIcon");
    shopName = TextUtils.isEmpty(shopName) ? "" : shopName;
    return OrderTitleModel(shopId, shopName, shopIcon, dataList);
  }
}
