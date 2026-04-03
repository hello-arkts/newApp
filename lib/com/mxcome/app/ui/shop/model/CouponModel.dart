
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';

class CouponModel {
  int id;
  int type; //优惠卷类型；0->代金券；1->优惠券；
  String name;
  double amount;
  double minPoint;
  int shopId;
  String shopIcon;
  String shopName;
  String startTime;
  String endTime;
  int useType; //使用类型：0->全场通用；1->指定分类；2->指定商品
  String code;
  int status;
  int isHold;
  bool isSelect;
  int isAllProducts;

  CouponModel(
      this.id,
      this.type,
      this.name,
      this.amount,
      this.minPoint,
      this.shopId,
      this.shopIcon,
      this.shopName,
      this.startTime,
      this.endTime,
      this.useType,
      this.code,
      this.status,
      this.isHold,
      this.isSelect,
      this.isAllProducts);

  factory CouponModel.fromJson(dynamic item, bool isSelect) {
    dynamic coupon = BaseModel.getDynamic(item, "coupon");
    dynamic shop = BaseModel.getDynamic(item, "shop");
    int shopId = BaseModel.getInt(shop, "id");
    String shopIcon = BaseModel.getString(shop, "logo");
    String shopName = BaseModel.getString(shop, "name");
    int id = BaseModel.getInt(coupon, "id");
    int type = BaseModel.getInt(coupon, "type");
    String name = BaseModel.getString(coupon, "name");
    double amount = BaseModel.getDouble(coupon, "amount");
    double minPoint = BaseModel.getDouble(coupon, "minPoint");
    String startTime = BaseModel.getString(coupon, "startTime");
    String endTime = BaseModel.getString(item, "endTime");
    int useType = BaseModel.getInt(coupon, "useType");
    String code = BaseModel.getString(coupon, "code");
    int status = BaseModel.getInt(coupon, "status");
    int isHold = BaseModel.getInt(coupon, "isHold");
    int isAllProducts = BaseModel.getInt(coupon, "isAllProducts");
    return CouponModel(id, type, name, amount, minPoint, shopId, shopIcon, shopName,
        startTime, endTime, useType, code, status, isHold, isSelect, isAllProducts);
  }
}
