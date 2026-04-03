
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';

class LevelGiftModel {
  int id;
  int activityId;
  int productGiftId;
  int level;
  int giftStock;
  String productGiftName;
  String productGiftSubTitle;
  String productGiftPic;
  double productGiftPrice;
  bool isWinning;

  LevelGiftModel(
      this.id,
      this.activityId,
      this.productGiftId,
      this.level,
      this.giftStock,
      this.productGiftName,
      this.productGiftSubTitle,
      this.productGiftPic,
      this.productGiftPrice,
      this.isWinning);

  factory LevelGiftModel.fromJson(dynamic model, double? price, bool isWinning) {
    int id = BaseModel.getInt(model, "id");
    int activityId = BaseModel.getInt(model, "activityId");
    int productGiftId = BaseModel.getInt(model, "productGiftId");
    int level = BaseModel.getInt(model, "level");
    int giftStock = BaseModel.getInt(model, "giftStock");
    String productGiftName = BaseModel.getString(model, "productGiftName");
    String productGiftSubTitle = BaseModel.getString(model, "productGiftSubTitle");
    String productGiftPic = BaseModel.getString(model, "productGiftPic");
    double productGiftPrice = price ?? 0;
    return LevelGiftModel(id, activityId, productGiftId, level, giftStock, productGiftName, productGiftSubTitle, productGiftPic, productGiftPrice, isWinning);
  }

}
