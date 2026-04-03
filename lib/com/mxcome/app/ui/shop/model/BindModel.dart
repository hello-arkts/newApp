import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';

import '../../../model/BaseModel.dart';

class BindModel {

  String id = ""; //第三方ID
  String email = ""; //第三方邮箱
  int thirdPartyType = 1; //1、facebook, 2、google, 3、apple

  BindModel(this.id, this.email, this.thirdPartyType);

  factory BindModel.fromJson(dynamic item) {
    String id = BaseModel.getString(item, "id");
    String email = BaseModel.getString(item, "email");
    int thirdPartyType = BaseModel.getInt(item, "thirdPartyType");
    return BindModel(id, email, thirdPartyType);
  }

  bool isBind(){
    return TextUtils.isNotEmpty(id);
  }
}
