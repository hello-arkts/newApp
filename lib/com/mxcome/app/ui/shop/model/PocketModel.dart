import '../../../model/BaseModel.dart';
import 'PocketItemModel.dart';

class PocketModel {
  String productId;
  String profit;
  String receiveStatus;
  String status;
  String taskStock;
  String startTime;
  String endTime;
  double minProfitAmount;
  double maxProfitAmount;
  List<PocketItemModel> itemList;
  List<dynamic> pocketGiftList = [];
  bool isSelect;

  PocketModel(this.productId, this.profit, this.receiveStatus, this.status,
      this.taskStock, this.startTime, this.endTime, this.minProfitAmount, this.maxProfitAmount, this.itemList, this.pocketGiftList, this.isSelect);

  factory PocketModel.fromJson(dynamic pocket) {
    List<PocketItemModel> itemList = [];
    String productId = BaseModel.getString(pocket, "productId");
    String profit = BaseModel.getString(pocket, "profit");
    String receiveStatus = BaseModel.getString(pocket, "receiveStatus");
    String status = BaseModel.getString(pocket, "status");
    String taskStock = BaseModel.getString(pocket, "taskStock");
    String startTime = BaseModel.getString(pocket, "startTime");
    String endTime = BaseModel.getString(pocket, "endTime");
    double minProfitAmount = BaseModel.getDouble(pocket, "minProfitAmount");
    double maxProfitAmount = BaseModel.getDouble(pocket, "maxProfitAmount");
    dynamic tempList = BaseModel.getDynamic(pocket, "itemList");
    for (dynamic item in tempList) {
      itemList.add(PocketItemModel.fromJson(item));
    }
    List<dynamic> pocketGiftList = BaseModel.isNotEmpty(pocket, "pocketGiftList") ? BaseModel.getDynamic(pocket, "pocketGiftList") : [];
    return PocketModel(productId, profit, receiveStatus, status, taskStock,
        startTime, endTime, minProfitAmount, maxProfitAmount, itemList, pocketGiftList, false);
  }
}
