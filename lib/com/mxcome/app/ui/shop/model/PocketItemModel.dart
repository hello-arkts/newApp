import 'dart:convert';

import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/SkuModel.dart';

import '../../../IConstant.dart';
import '../../../utils/TextUtils.dart';

class PocketItemModel {
  String id;
  String lockStock;
  String pocketId;
  String price;
  String productId;
  String receiveStatus;
  String skuCode;
  String skuId;
  int taskStock;
  double memberProfitAmount;
  double platformProfitAmount;
  double shopMemberAmount;
  String skuSpData;

  PocketItemModel(
      this.id,
      this.lockStock,
      this.pocketId,
      this.price,
      this.productId,
      this.receiveStatus,
      this.skuCode,
      this.skuId,
      this.taskStock,
      this.memberProfitAmount,
      this.platformProfitAmount,
      this.shopMemberAmount,
      this.skuSpData);

  factory PocketItemModel.fromJson(dynamic pocket) {
    String id = BaseModel.getString(pocket, "id");
    String lockStock = BaseModel.getString(pocket, "lockStock");
    String pocketId = BaseModel.getString(pocket, "pocketId");
    String price = BaseModel.getString(pocket, "price");
    String productId = BaseModel.getString(pocket, "productId");
    String receiveStatus = BaseModel.getString(pocket, "receiveStatus");
    String skuCode = BaseModel.getString(pocket, "skuCode");
    String skuId = BaseModel.getString(pocket, "skuId");
    int taskStock = BaseModel.getInt(pocket, "taskStock");
    double memberProfitAmount = BaseModel.getDouble(pocket, "memberProfitAmount");
    double platformProfitAmount = BaseModel.getDouble(pocket, "platformProfitAmount");
    double shopMemberAmount = BaseModel.getDouble(pocket, "shopMemberAmount");
    String skuSpData = BaseModel.getString(pocket, "skuSpdata");
    return PocketItemModel(id, lockStock, pocketId, price, productId,
        receiveStatus, skuCode, skuId, taskStock,
        memberProfitAmount, platformProfitAmount, shopMemberAmount, skuSpData);
  }

  String getSelectValues() {
    String choiceValues = "";
    List<dynamic> spDataList = TextUtils.isNotEmpty(skuSpData) ? jsonDecode(skuSpData) : [];
    for (var item in spDataList) {
      choiceValues += "${item["value"]}， ";
    }
    if (TextUtils.isNotEmpty(choiceValues)) {
      choiceValues = choiceValues.substring(0, choiceValues.length - 2);
    }
    return "$choiceValues, ${IConstant.currency}$price";
  }

}
