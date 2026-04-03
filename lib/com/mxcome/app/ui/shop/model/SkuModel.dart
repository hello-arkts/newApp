import 'dart:convert';

import '../../../IConstant.dart';
import '../../../model/BaseModel.dart';
import '../../../utils/TextUtils.dart';

class SkuModel {

  String id;
  String pic;
  String productId;
  String skuCode;
  double price;
  String stock;
  String lockStock;
  String spData;
  String taskStock = "100";
  Set<String> valueSet;

  SkuModel(this.id, this.pic, this.productId, this.skuCode, this.price, this.stock, this.lockStock, this.spData, this.valueSet);

  factory SkuModel.fromJson(dynamic sku) {
    String id = BaseModel.getString(sku, "id");
    String pic = BaseModel.getString(sku, "pic");
    String productId = BaseModel.getString(sku, "productId");
    String skuCode = BaseModel.getString(sku, "skuCode");
    double price = BaseModel.getDouble(sku, "price");
    String stock = BaseModel.getString(sku, "stock");
    String lockStock = BaseModel.getString(sku, "lockStock");
    String spData = BaseModel.getString(sku, "spData");
    List<dynamic> spDataList = jsonDecode(spData);
    Set<String> valueSet = {};
    for (var element in spDataList) {
      String value = BaseModel.getString(element, "value");
      valueSet.add(value);
    }
    return SkuModel(id, pic, productId, skuCode, price, stock, lockStock, spData, valueSet);
  }

  String getSelectValues(){
    String choiceValues = "";
    List<dynamic> spDataList = jsonDecode(spData);
    for (var item in spDataList) {
      choiceValues += "${item["value"]}/";
    }
    if (TextUtils.isNotEmpty(choiceValues)) {
      choiceValues = choiceValues.substring(0, choiceValues.length - 1);
    }
    return "$choiceValues/${IConstant.currency}$price";
  }

}