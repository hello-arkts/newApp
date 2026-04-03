
import 'RedModel.dart';

class RedTitleModel {
  int status;
  double totalAmount;
  String pocketEndTime;
  List<RedModel> redList;
  int memberNum;
  String redGrantTime;

  RedTitleModel(
      this.status,
      this.totalAmount,
      this.pocketEndTime,
      this.redList,
      this.memberNum,
      this.redGrantTime);

}
