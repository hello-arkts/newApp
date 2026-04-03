
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';

class RedModel {
  int id;
  String createTime;
  String pocketCode;
  String pocketEndTime;
  int activityId;
  int level;
  int memberId;
  int orderItemId;
  double amount;
  int recommendMemberId;
  int status;
  int memberRedInfoId;
  int edRelationId;
  String memberIcon;
  String productPic;

  RedModel(
    this.id,
    this.createTime,
    this.pocketCode,
    this.pocketEndTime,
    this.activityId,
    this.level,
    this.memberId,
    this.orderItemId,
    this.amount,
    this.recommendMemberId,
    this.status,
    this.memberRedInfoId,
    this.edRelationId,
    this.memberIcon,
    this.productPic);

  factory RedModel.fromJson(dynamic item) {
    int id = BaseModel.getInt(item, "id");
    String createTime = BaseModel.getString(item, "createTime");
    String pocketCode = BaseModel.getString(item, "pocketCode");
    String pocketEndTime = BaseModel.getString(item, "pocketEndTime");
    int activityId = BaseModel.getInt(item, "activityId");
    int level = BaseModel.getInt(item, "level");
    int memberId = BaseModel.getInt(item, "memberId");
    int orderItemId = BaseModel.getInt(item, "orderItemId");
    double amount = BaseModel.getDouble(item, "amount");
    int recommendMemberId = BaseModel.getInt(item, "recommendMemberId");
    int status = BaseModel.getInt(item, "status");
    int memberRedInfoId = BaseModel.getInt(item, "memberRedInfoId");
    int edRelationId = BaseModel.getInt(item, "edRelationId");
    String memberIcon = BaseModel.getString(item, "memberIcon");
    String productPic = BaseModel.getString(item, "productPic");
    return RedModel(id, createTime, pocketCode, pocketEndTime, activityId, level,
        memberId, orderItemId, amount, recommendMemberId, status, memberRedInfoId,
        edRelationId, memberIcon, productPic);
  }

}
