
import '../../../model/BaseModel.dart';

class UseCouponModel {
  int id;
  String code;
  int status; //状态：0->待使用；1->已使用; -1->已过期
  String useTime; //使用时间

  UseCouponModel(
      this.id,
      this.code,
      this.status,
      this.useTime);

  factory UseCouponModel.fromJson(dynamic item) {
    int id = BaseModel.getInt(item, "id");
    String code = BaseModel.getString(item, "code");
    int status = BaseModel.getInt(item, "status");
    String useTime = BaseModel.getString(item, "useTime");
    return UseCouponModel(id, code, status, useTime);
  }

}
