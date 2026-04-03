
import '../../../model/BaseModel.dart';

class BankModel {

  int id;
  String cardNumber;
  String bankIcon;
  String bankName;
  String branchName;
  int status;
  bool isSelect;
  String validDate;
  String bankLogo;

  BankModel(this.id, this.cardNumber, this.bankIcon, this.bankName, this.branchName, this.status, this.isSelect, this.validDate, this.bankLogo);

  factory BankModel.fromJson(dynamic item) {
    int id = BaseModel.getInt(item, "id");
    String cardNumber = BaseModel.getString(item, "cardNumber");
    String bankIcon = BaseModel.getString(item, "bankIcon");
    String bankName = BaseModel.getString(item, "bankName");
    String branchName = BaseModel.getString(item, "branchName");
    int status = BaseModel.getInt(item, "status");
    int isSelect = BaseModel.getInt(item, "isSelect");
    bool isDefault = false;
    if(isSelect == 1) {
      isDefault = true;
    }
    String validDate = BaseModel.getString(item, "validDate");
    String bankLogo = BaseModel.getString(item, "bankLogo");
    return BankModel(id, cardNumber, bankIcon, bankName, branchName, status, isDefault, validDate, bankLogo);
  }

}
