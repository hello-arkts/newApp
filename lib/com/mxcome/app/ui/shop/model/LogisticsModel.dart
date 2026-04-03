
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';

class LogisticsModel {
  int id;
  String logisticsCompanyCode;
  String logisticsContent;
  String logisticsNo;
  String orderItemId;
  String orderShopId;
  String orderSn;
  String sendAddress;
  String sendCity;
  String sendPostCode;
  String sendProvince;
  String sendRegion;
  String sendTel;
  String skuCodes;
  String status;
  String statusName;
  String waybillNum;
  String createTime;
  String updateTime;
  String deliveredTime;
  bool isSelect;

  LogisticsModel(
      this.id,
      this.logisticsCompanyCode,
      this.logisticsContent,
      this.logisticsNo,
      this.orderItemId,
      this.orderShopId,
      this.orderSn,
      this.sendAddress,
      this.sendCity,
      this.sendPostCode,
      this.sendProvince,
      this.sendRegion,
      this.sendTel,
      this.skuCodes,
      this.status,
      this.statusName,
      this.waybillNum,
      this.createTime,
      this.updateTime,
      this.deliveredTime,
      this.isSelect);

  factory LogisticsModel.fromJson(dynamic model, bool isSelect) {
    int id = BaseModel.getInt(model, "id");
    String logisticsCompanyCode = BaseModel.getString(model, "logisticsCompanyCode");
    String logisticsContent = BaseModel.getString(model, "logisticsContent");
    String logisticsNo = BaseModel.getString(model, "logisticsNo");
    String orderItemId = BaseModel.getString(model, "orderItemId");
    String orderShopId = BaseModel.getString(model, "orderShopId");
    String orderSn = BaseModel.getString(model, "orderSn");
    String sendAddress = BaseModel.getString(model, "sendAddress");
    String sendCity = BaseModel.getString(model, "sendCity");
    String sendPostCode = BaseModel.getString(model, "sendPostCode");
    String sendProvince = BaseModel.getString(model, "sendProvince");
    String sendRegion = BaseModel.getString(model, "sendRegion");
    String sendTel = BaseModel.getString(model, "sendTel");
    String skuCodes = BaseModel.getString(model, "skuCodes");
    String status = BaseModel.getString(model, "status");
    String statusName = BaseModel.getString(model, "statusName");
    String waybillNum = BaseModel.getString(model, "waybillNum");
    String createTime = BaseModel.getString(model, "createTime");
    String updateTime = BaseModel.getString(model, "updateTime");
    String deliveredTime = BaseModel.getString(model, "deliveredTime");
    return LogisticsModel(id, logisticsCompanyCode, logisticsContent, logisticsNo, orderItemId,
        orderShopId, orderSn, sendAddress, sendCity, sendPostCode, sendProvince, sendRegion, sendTel,
        skuCodes, status, statusName, waybillNum, createTime, updateTime, deliveredTime, isSelect);
  }

}
