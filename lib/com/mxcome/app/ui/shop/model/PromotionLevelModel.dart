

import '../../../model/BaseModel.dart';

class PromotionLevelModel {

  int redLevel = 1;
  double amount = 0;
  int currentLevel = 0;
  int redStage = 1;

  PromotionLevelModel(this.redLevel, this.amount, this.currentLevel);

  factory PromotionLevelModel.fromJson(dynamic item, int currentLevel) {
    int redLevel = BaseModel.getInt(item, "redLevel");
    double amount = BaseModel.getDouble(item, "amount");
    return PromotionLevelModel(redLevel, amount, currentLevel);
  }

  bool isSelect() {
    return redLevel == currentLevel;
  }

}
