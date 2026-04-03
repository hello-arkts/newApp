
import 'dart:convert';

import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';

import '../../../Logger.dart';
import '../../../utils/TextUtils.dart';

class GiftModel {
  int id; //id
  int pocketId; //口袋任务
  int activityId; //活动id
  int level;	//关卡等级
  int levelGiftId;	//关卡礼品id
  double price;	//价格
  int productGiftId;	//赠送商品id
  String skuCode;	//ku编码
  int skuId;	//skuId
  String skuPic;	//sku图片
  String skuSpData;	//sku参数
  int status; //领奖状态 0待领取 1已领取 -1已过期（8天）
  int type; //0:任务奖励 1:关卡奖励 2:排名奖励
  bool isSelect;
  String productName;
  int collectionNum;
  double productPrice;
  String productPic;

  GiftModel(
      this.id,
      this.pocketId,
      this.activityId,
      this.level,
      this.levelGiftId,
      this.price,
      this.productGiftId,
      this.skuCode,
      this.skuId,
      this.skuPic,
      this.skuSpData,
      this.status,
      this.type,
      this.isSelect,
      this.productName,
      this.collectionNum,
      this.productPrice,
      this.productPic);

  factory GiftModel.fromJson(dynamic model, int type, bool isSelect) {
    int id = BaseModel.getInt(model, "id"); //id
    int pocketId = BaseModel.getInt(model, "pocketId"); //pocketId
    int activityId = BaseModel.getInt(model, "activityId"); //活动id
    int level = BaseModel.getInt(model, "level");	//关卡等级
    int levelGiftId = BaseModel.getInt(model, "levelGiftId");	//关卡礼品id
    double price = BaseModel.getDouble(model, "price");	//价格	number
    int productGiftId = BaseModel.getInt(model, "productGiftId");	//赠送商品id
    String skuCode = BaseModel.getString(model, "skuCode");	//ku编码
    int skuId = BaseModel.getInt(model, "skuId");	//skuId
    String skuPic = BaseModel.getString(model, "skuPic");	//sku图片
    String skuSpData = BaseModel.getString(model, "skuSpdata");	//sku参数
    int status = BaseModel.getInt(model, "status");	//sku参数 //领奖状态 0待领取 1已领取 -1已过期（8天）
    String productName = BaseModel.getString(model, "productName");
    int collectionNum = BaseModel.getInt(model, "collectionNum");
    double productPrice = BaseModel.getDouble(model, "productPrice");
    String productPic = BaseModel.getString(model, "productPic");
    return GiftModel(id, pocketId, activityId, level, levelGiftId, price, productGiftId, skuCode, skuId, skuPic, skuSpData, status, type, isSelect, productName, collectionNum,productPrice,productPic);
  }

  String getSpValues(){
    String choiceValues = "";
    List<dynamic> spDataList = jsonDecode(skuSpData);
    for (var item in spDataList) {
      choiceValues += "${item["value"]}/";
    }
    if (TextUtils.isNotEmpty(choiceValues)) {
      choiceValues = choiceValues.substring(0, choiceValues.length - 1);
    }
    return choiceValues;
  }

  bool prizeEnable() {
    return status == 0;
  }

  String getStatusText() {
    if (status == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_activity_received);
    } else if (status == -1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_activity_expired);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_activity_get);
    }
  }
}
