import 'dart:convert';
import 'dart:ui';

import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/SkuModel.dart';

import '../../../IConstant.dart';
import '../../../utils/TextUtils.dart';

class PrizeModel {
  int id;
  int activityId;
  int productGiftId;
  int giftStock;
  int startNum;
  int endNum;
  String productGiftName;
  String productGiftSubTitle;
  String productGiftPic;
  List<dynamic> giftItemList = [];
  double price = 0;
  double originalPrice = 0;
  int collectionNum = 0;
  int level;
  int type; // 1:关卡奖励 2:排名奖励
  bool isSelect;

  PrizeModel(
      this.id,
      this.activityId,
      this.productGiftId,
      this.giftStock,
      this.startNum,
      this.endNum,
      this.productGiftName,
      this.productGiftSubTitle,
      this.productGiftPic,
      this.giftItemList,
      this.price,
      this.originalPrice,
      this.collectionNum,
      this.level,
      this.type,
      this.isSelect);

  factory PrizeModel.fromJson(dynamic model, int type, bool isSelect) {
    int id = BaseModel.getInt(model, "id");
    int activityId = BaseModel.getInt(model, "activityId");
    int productGiftId = BaseModel.getInt(model, "productGiftId");
    int giftStock = BaseModel.getInt(model, "giftStock");
    int startNum = BaseModel.getInt(model, "startNum");
    int endNum = BaseModel.getInt(model, "endNum");
    String productGiftName = BaseModel.getString(model, "productGiftName");
    String productGiftSubTitle = BaseModel.getString(model, "productGiftSubTitle");
    String productGiftPic = BaseModel.getString(model, "productGiftPic");
    List<dynamic> giftItemList = [];
    if (type == 1) {
      giftItemList = BaseModel.isNotEmpty(model, "giftItemList") ? BaseModel.getDynamic(model, "giftItemList") : [];
    } else {
      giftItemList = BaseModel.isNotEmpty(model, "activityGiftItems") ? BaseModel.getDynamic(model, "activityGiftItems") : [];
    }
    double price = BaseModel.getDouble(model, "price");
    double originalPrice = BaseModel.getDouble(model, "originalPrice");
    int collectionNum = BaseModel.getInt(model, "collectionNum");
    int level = BaseModel.getInt(model, "level");
    return PrizeModel(id, activityId, productGiftId, giftStock, startNum, endNum, productGiftName, productGiftSubTitle, productGiftPic, giftItemList, price, originalPrice, collectionNum, level, type, isSelect);
  }

  Color getBorderColor() {
    if(isDispatched()) {
      return IConstant.white_color;
    }
    return isSelect ? IConstant.main_color : IConstant.grey_bg_color;
  }

  Color getBgColor() {
    return isSelect ? IConstant.red_bg_color : const Color(0xFFF9F9F9);
  }

  bool isDispatched() {
    return giftStock == 0;
  }

  List<int> getSkuList() {
    List<int> skuList = [];
    for (var item in giftItemList) {
      skuList.add(BaseModel.getInt(item, "skuId"));
    }
    return skuList;
  }

}
