
import 'dart:ui';

import '../../../IConstant.dart';
import '../../../model/BaseModel.dart';

class ConfirmModel {
  String activityId;
  String createDate;
  String deleteStatus;
  double freightAmount;
  String giftType;
  String growth;
  String id;
  String integration;
  int isFreePackage;
  String logisticsCode;
  String logisticsName;
  String memberId;
  String memberNickname;
  String merchantId;
  String modifyDate;
  String pocketCode;
  String pocketId;
  double price;
  String productAttr;
  String productBrand;
  String productCategoryId;
  String productCategoryId2;
  String productCategoryId3;
  String productCategoryId4;
  String productId;
  String productName;
  String productPic;
  String productSkuCode;
  String productSkuId;
  String productSn;
  String productSubTitle;
  String promotionMessage;
  String quantity;
  String realStock;
  String reduceAmount;
  String shopAddressId;
  String shopIcon;
  String shopId;
  String shopName;
  int templateId;
  int transportType;
  int type;
  int property;

  ConfirmModel(
      this.activityId,
      this.createDate,
      this.deleteStatus,
      this.freightAmount,
      this.giftType,
      this.growth,
      this.id,
      this.integration,
      this.isFreePackage,
      this.logisticsCode,
      this.logisticsName,
      this.memberId,
      this.memberNickname,
      this.merchantId,
      this.modifyDate,
      this.pocketCode,
      this.pocketId,
      this.price,
      this.productAttr,
      this.productBrand,
      this.productCategoryId,
      this.productCategoryId2,
      this.productCategoryId3,
      this.productCategoryId4,
      this.productId,
      this.productName,
      this.productPic,
      this.productSkuCode,
      this.productSkuId,
      this.productSn,
      this.productSubTitle,
      this.promotionMessage,
      this.quantity,
      this.realStock,
      this.reduceAmount,
      this.shopAddressId,
      this.shopIcon,
      this.shopId,
      this.shopName,
      this.templateId,
      this.transportType,
      this.type,
      this.property);

  factory ConfirmModel.fromJson(dynamic item) {
    String activityId = BaseModel.getString(item, "activityId");
    String createDate = BaseModel.getString(item, "createDate");
    String deleteStatus = BaseModel.getString(item, "deleteStatus");
    double freightAmount = BaseModel.getDouble(item, "freightAmount");
    String giftType = BaseModel.getString(item, "giftType");
    String growth = BaseModel.getString(item, "growth");
    String id = BaseModel.getString(item, "id");
    String integration = BaseModel.getString(item, "integration");
    int isFreePackage = BaseModel.getInt(item, "isFreePackage");
    String logisticsCode = BaseModel.getString(item, "logisticsCode");
    String logisticsName = BaseModel.getString(item, "logisticsName");
    String memberId = BaseModel.getString(item, "memberId");
    String memberNickname = BaseModel.getString(item, "memberNickname");
    String merchantId = BaseModel.getString(item, "merchantId");
    String modifyDate = BaseModel.getString(item, "modifyDate");
    String pocketCode = BaseModel.getString(item, "pocketCode");
    String pocketId = BaseModel.getString(item, "pocketId");
    double price = BaseModel.getDouble(item, "price");
    String productAttr = BaseModel.getString(item, "productAttr");
    String productBrand = BaseModel.getString(item, "productBrand");
    String productCategoryId = BaseModel.getString(item, "productCategoryId");
    String productCategoryId2 = BaseModel.getString(item, "productCategoryId2");
    String productCategoryId3 = BaseModel.getString(item, "productCategoryId3");
    String productCategoryId4 = BaseModel.getString(item, "productCategoryId4");
    String productId = BaseModel.getString(item, "productId");
    String productName = BaseModel.getString(item, "productName");
    String productPic = BaseModel.getString(item, "productPic");
    String productSkuCode = BaseModel.getString(item, "productSkuCode");
    String productSkuId = BaseModel.getString(item, "productSkuId");
    String productSn = BaseModel.getString(item, "productSn");
    String productSubTitle = BaseModel.getString(item, "productSubTitle");
    String promotionMessage = BaseModel.getString(item, "promotionMessage");
    String quantity = BaseModel.getString(item, "quantity");
    String realStock = BaseModel.getString(item, "realStock");
    String reduceAmount = BaseModel.getString(item, "reduceAmount");
    String shopAddressId = BaseModel.getString(item, "shopAddressId");
    String shopIcon = BaseModel.getString(item, "shopIcon");
    String shopId = BaseModel.getString(item, "shopId");
    String shopName = BaseModel.getString(item, "shopName");
    int templateId = BaseModel.getInt(item, "templateId");
    int transportType = BaseModel.getInt(item, "transportType");
    int type = BaseModel.getInt(item, "type");
    int property = BaseModel.getInt(item, "property");
    return ConfirmModel(activityId, createDate, deleteStatus, freightAmount, giftType,
        growth, id, integration, isFreePackage, logisticsCode, logisticsName, memberId, memberNickname,
        merchantId, modifyDate, pocketCode, pocketId, price, productAttr, productBrand,
        productCategoryId, productCategoryId2, productCategoryId3, productCategoryId4, productId,
        productName, productPic, productSkuCode, productSkuId, productSn, productSubTitle, promotionMessage,
        quantity, realStock, reduceAmount, shopAddressId, shopIcon, shopId, shopName, templateId, transportType, type, property);
  }

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'activityId': activityId,
        'createDate': createDate,
        'deleteStatus': deleteStatus,
        'freightAmount': freightAmount,
        'giftType': giftType,
        'growth': growth,
        'id': id,
        'integration': integration,
        'isFreePackage': isFreePackage,
        'logisticsCode': logisticsCode,
        'logisticsName': logisticsName,
        'memberId': memberId,
        'memberNickname': memberNickname,
        'merchantId': merchantId,
        'modifyDate': modifyDate,
        'pocketCode': pocketCode,
        'pocketId': pocketId,
        'price': price,
        'productAttr': productAttr,
        'productBrand': productBrand,
        'productCategoryId': productCategoryId,
        'productCategoryId2': productCategoryId2,
        'productCategoryId3': productCategoryId3,
        'productCategoryId4': productCategoryId4,
        'productId': productId,
        'productName': productName,
        'productPic': productPic,
        'productSkuCode': productSkuCode,
        'productSkuId': productSkuId,
        'productSn': productSn,
        'productSubTitle': productSubTitle,
        'promotionMessage': promotionMessage,
        'quantity': quantity,
        'realStock': realStock,
        'reduceAmount': reduceAmount,
        'shopAddressId': shopAddressId,
        'shopIcon': shopIcon,
        'shopId': shopId,
        'shopName': shopName,
        'templateId': templateId,
        'transportType': transportType,
        'type': type,
        'property': property
      };

}
