import 'dart:convert';

import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/SkuModel.dart';

import '../../../utils/TextUtils.dart';

class ReadCount {
  String key;
  int value = 0;
  int read = 0; // 0:已读 1:未读

  ReadCount(this.key, this.value, this.read);

  factory ReadCount.toReadCount(dynamic item) {
    String key = BaseModel.getString(item, "key");
    int value = BaseModel.getInt(item, "value");
    int read = BaseModel.getInt(item, "read");
    return ReadCount(key, value, read);
  }

  int getNumber() {
    return value;
  }

  String getValue() {
    if (value == 0) {
      return "";
    }
    return "$value";
  }

  dynamic toDynamic() {
    return {
      "key": key,
      "value": value,
      "read": read,
    };
  }

  bool isRead() {
    return !isUnread();
  }

  bool isUnread() {
    return read == 1;
  }

}
