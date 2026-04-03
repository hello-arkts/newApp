import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';

import '../../../model/BaseModel.dart';

class PlatformModel {
  String icon;
  String name;
  String subTitle;
  String totalConsume;
  bool isViolate;
  String time;

  PlatformModel(
      this.icon, this.name, this.subTitle, this.totalConsume, {this.isViolate = false, this.time = ""});
}
