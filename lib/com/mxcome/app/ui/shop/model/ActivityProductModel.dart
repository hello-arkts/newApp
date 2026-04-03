import '../../../model/BaseModel.dart';

class ActivityProductModel {
  int id;
  int activityId;
  int level;
  String productId;
  String productPic;
  String productName;
  String productSubTitle;
  double price;
  int collectionNum;
  int profitStatus;
  double minProfit;
  double maxProfit;
  bool isSelect;

  ActivityProductModel(this. id, this.activityId, this.level, this.productId,
      this.productPic, this.productName, this.productSubTitle, this.price,
      this.collectionNum, this.profitStatus, this.minProfit, this.maxProfit, this.isSelect);

  factory ActivityProductModel.fromJson(dynamic item, bool isSelect) {
    int id = BaseModel.getInt(item, "id");
    int activityId = BaseModel.getInt(item, "activityId");
    int level = BaseModel.getInt(item, "level");
    String productId = BaseModel.getString(item, "productId");
    String productPic = BaseModel.getString(item, "productPic");
    String productName = BaseModel.getString(item, "productName");
    String productSubTitle = BaseModel.getString(item, "productSubTitle");
    double price = BaseModel.getDouble(item, "price");
    int collectionNum = BaseModel.getInt(item, "collectionNum");
    int profitStatus = BaseModel.getInt(item, "profitStatus");
    double minProfit = BaseModel.getDouble(item, "minProfit");
    double maxProfit = BaseModel.getDouble(item, "maxProfit");
    return ActivityProductModel(id, activityId, level, productId, productPic, productName,
        productSubTitle, price, collectionNum, profitStatus, minProfit, maxProfit, isSelect);
  }
}
