import 'dart:convert';

import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';



class BaseRsp {
  late int retCode;
  late String msg;
  dynamic data;

  static BaseRsp newErrInstance(String? msg) {
    BaseRsp rsp = BaseRsp();
    rsp.retCode = RspRetCode.INTERNAL_ERROR;
    rsp.msg = msg ?? LanguageConfig.get(LanguageConfigKeys.Base_unknown_err);
    return rsp;
  }

  static BaseRsp parserJSON(dynamic json) {
    try {
      if (TextUtils.isEmpty(json)) return newErrInstance(null);
      var data = json is String ? jsonDecode(json) : json;
      if (data == null) return newErrInstance(null);
      BaseRsp item = BaseRsp();

      item.retCode = BaseModel.getInt(data, 'code');
      item.msg = BaseModel.getString(data, 'message');
      if (item.retCode == RspRetCode.SUCCESS) {
        dynamic mData =BaseModel.getDynamic(data, 'data');
        if (!TextUtils.isEmpty(mData)) {
          item.data = mData;
        }
      }
      return item;
    } catch (e) {
      TextUtils.println(e);
    }
    return newErrInstance('parse json error');
  }
}

class RspRetCode {
  static const SUCCESS = 200;
  static const LOGIN_TOKEN_TOUT = -2; //没有登录
  static const INTERNAL_ERROR = -1; //内部错误
}
