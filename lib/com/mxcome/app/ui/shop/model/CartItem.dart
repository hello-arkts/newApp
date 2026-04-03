import 'dart:convert';

import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/SkuModel.dart';

import '../../../utils/TextUtils.dart';

class CartItem {
  int id;
  double price;
  String productAttr;	//商品销售属性:[{'key':'颜色','value':'颜色'},{'key':'容量','value':'4G'}]
  String productBrand;
  String productId;
  String productName;	//商品名称
  String productPic;	//商品主图
  String productSkuCode;	//商品sku条码
  String productSkuId;
  String productSn;
  String productSubTitle;	//商品副标题（卖点）
  int quantity; //数量
  String pocketCode;
  bool isSelect;

  CartItem(
      this.id,
      this.price,
      this.productAttr,
      this.productBrand,
      this.productId,
      this.productName,
      this.productPic,
      this.productSkuCode,
      this.productSkuId,
      this.productSn,
      this.productSubTitle,
      this.quantity,
      this.pocketCode,
      this.isSelect);

  factory CartItem.fromProductToCartItem(dynamic product, SkuModel sku, int quantity, String pocketCode) {
    String productId = sku.productId;
    String productSkuId = sku.id;
    String productSkuCode = sku.skuCode;
    double price = sku.price;
    String productAttr =  sku.spData;
    String productBrand = BaseModel.getString(product, "brand");
    String productName = BaseModel.getString(product, "name");
    String productSn = BaseModel.getString(product, "productSn");
    String productPic = BaseModel.getString(product, "pic");
    String productSubTitle = BaseModel.getString(product, "subTitle");
    return CartItem(0, price, productAttr, productBrand, productId, productName, productPic, productSkuCode, productSkuId, productSn, productSubTitle, quantity, pocketCode, true);
  }

  factory CartItem.toCartItem(dynamic cartItem) {
    int id = BaseModel.getInt(cartItem, "id");
    String productId = BaseModel.getString(cartItem, "productId");
    String productSkuId = BaseModel.getString(cartItem, "productSkuId");
    String productSkuCode = BaseModel.getString(cartItem, "productSkuCode");
    double price = BaseModel.getDouble(cartItem, "price");
    String productAttr = BaseModel.getString(cartItem, "productAttr");
    String productBrand = BaseModel.getString(cartItem, "productBrand");
    String productName = BaseModel.getString(cartItem, "productName");
    String productSn = BaseModel.getString(cartItem, "productSn");
    String productPic = BaseModel.getString(cartItem, "productPic");
    String productSubTitle = BaseModel.getString(cartItem, "productSubTitle");
    int quantity = BaseModel.getInt(cartItem, "quantity");
    String pocketCode = BaseModel.getString(cartItem, "pocketCode");
    return CartItem(id, price, productAttr, productBrand, productId, productName, productPic, productSkuCode, productSkuId, productSn, productSubTitle, quantity, pocketCode, true);
  }

  factory CartItem.toCartItemByProduct(dynamic product, dynamic sku) {
    String productId = BaseModel.getString(sku, "productId");
    String productSkuId = BaseModel.getString(sku, "id");
    String productSkuCode = BaseModel.getString(sku, "skuCode");
    double price = BaseModel.getDouble(sku, "price");
    String productAttr = BaseModel.getString(sku, "spData");
    String productBrand = BaseModel.getString(product, "brand");
    String productName = BaseModel.getString(product, "name");
    String productSn = BaseModel.getString(product, "productSn");
    String productPic = BaseModel.getString(product, "pic");
    String productSubTitle = BaseModel.getString(product, "subTitle");
    return CartItem(0, price, productAttr, productBrand, productId, productName, productPic, productSkuCode, productSkuId, productSn, productSubTitle, 1, "", true);
  }

  factory CartItem.toCartItemNoPrice(dynamic product, dynamic sku) {
    String productId = BaseModel.getString(sku, "productId");
    String productSkuId = BaseModel.getString(sku, "id");
    String productSkuCode = BaseModel.getString(sku, "skuCode");
    double price = 0;
    String productAttr = BaseModel.getString(sku, "spData");
    String productBrand = BaseModel.getString(product, "brand");
    String productName = BaseModel.getString(product, "name");
    String productSn = BaseModel.getString(product, "productSn");
    String productPic = BaseModel.getString(product, "pic");
    String productSubTitle = BaseModel.getString(product, "subTitle");
    return CartItem(0, price, productAttr, productBrand, productId, productName, productPic, productSkuCode, productSkuId, productSn, productSubTitle, 1, "", true);
  }

  static String getProductAttrValues(String productAttr){
    if (TextUtils.isEmpty(productAttr)) return "";
    String choiceValues = "";
    List<dynamic> specList = jsonDecode(productAttr);
    for (var item in specList) {
      choiceValues += "${item["value"]},";
    }
    if (TextUtils.isNotEmpty(choiceValues)) {
      choiceValues = choiceValues.substring(0, choiceValues.length - 1);
    }
    return choiceValues;
  }

  @override
  String toString() {
    return 'CartItem{id: $id, price: $price, productAttr: $productAttr, productBrand: $productBrand, productId: $productId, productName: $productName, productPic: $productPic, productSkuCode: $productSkuCode, productSkuId: $productSkuId, productSn: $productSn, productSubTitle: $productSubTitle, quantity: $quantity, pocketCode: $pocketCode, isSelect: $isSelect}';
  }
}
