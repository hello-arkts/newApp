
import 'dart:ui';

import 'package:mxcome/com/mxcome/app/ui/shop/model/ConfirmModel.dart';

import '../../../IConstant.dart';
import '../../../model/BaseModel.dart';

class ConfirmTitleModel {
  String shopId;
  String shopName;
  String shopIcon;
  List<ConfirmModel> dataList;

  ConfirmTitleModel(
      this.shopId,
      this.shopName,
      this.shopIcon,
      this.dataList);

  factory ConfirmTitleModel.fromJson(String shopId, List<dynamic> dataList) {
    String shopName = BaseModel.getString(dataList[0], "shopName");
    String shopIcon = BaseModel.getString(dataList[0], "shopIcon");
    List<ConfirmModel> confirmList = [];
    for (dynamic item in dataList) {
      confirmList.add(ConfirmModel.fromJson(item));
    }
    return ConfirmTitleModel(shopId, shopName, shopIcon, confirmList);
  }

}
