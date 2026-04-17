import 'dart:convert';

import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';

class BaseModel {
  static getInt(dynamic json, String key) {
    try {
      var value = json[key];
      if (!TextUtils.isEmpty(value)) return int.parse(value.toString());
    } catch (e) {
      TextUtils.println('getInt>>>err$e>>>$key');
    }
    return 0;
  }

  static getDynamic(dynamic json, String key) {
    try {
      return json[key];
    } catch (e) {
      TextUtils.println('getDynamic>>>err$e>>>$key');
    }
    return null;
  }

  static getDouble(dynamic json, String key) {
    try {
      var value = json[key];
      if (!TextUtils.isEmpty(value)) return double.parse(value.toString());
    } catch (e) {
      TextUtils.println('getDouble>>>err$e>>>$key');
    }
    return 0.0;
  }

  static getString(dynamic json, String key) {
    try {
      var value = json[key];
      if (!TextUtils.isEmpty(value)) return value.toString();
    } catch (e) {
      TextUtils.println('getString>>>err$e>>>$key');
    }
    return '';
  }

  static getDynamicList(dynamic json, String key) {
    try {
      if (isNotEmpty(json, key)) {
        return json[key];
      } else {
        return [];
      }
    } catch (e) {
      TextUtils.println('getDynamicList>>>err$e>>>$key');
    }
    return [];
  }

  static getStringList(dynamic json, String key) {
    try {
      var value = json[key];
      if (!TextUtils.isEmpty(value)) {
        List<dynamic> list = jsonDecode(value);
        List<String> datas = [];
        for (var item in list) {
          datas.add(item.toString());
        }
        return datas;
      }
    } catch (e) {
      TextUtils.println('getStringList>>>err$e>>>$key');
    }
    return null;
  }

  static getStringListNoDecode(dynamic json, String key) {
    try {
      var value = json[key];
      if (!TextUtils.isEmpty(value)) {
        List<dynamic> list = value;
        List<String> datas = [];
        for (var item in list) {
          datas.add(item.toString());
        }
        return datas;
      }
    } catch (e) {
      TextUtils.println('getStringListNoDecode>>>err$e>>>$key');
    }
    return null;
  }

  static bool isEmpty(dynamic json, String key) {
    try {
      var value = json[key];
      return TextUtils.isEmpty(value);
    } catch (e) {
      TextUtils.println('isEmpty>>>err$e>>>$key');
    }
    return false;
  }

  static bool isNotEmpty(dynamic json, String key) {
    try {
      var value = json[key];
      return TextUtils.isNotEmpty(value);
    } catch (e) {
      TextUtils.println('isNotEmpty>>>err$e>>>$key');
    }
    return false;
  }
}
