import 'dart:convert';

import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:mxcome/com/mxcome/app/Logger.dart';
import 'package:mxcome/com/mxcome/app/model/SystemConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/LanguagePage.dart';
import 'package:mxcome/com/mxcome/app/utils/DbUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../IConstant.dart';
import '../model/BaseModel.dart';
import '../model/LoggedInfo.dart';
import '../ui/shop/model/ReadCount.dart';

class AppUtils {
  static const app_language = "language";
  static const is_load_guide = "is_load_guide";
  static const install_referer = "install_referer";
  static const user_info = "user_info";
  static const system_info = "system_info";
  static const home_data = "home_data";
  static const pocket_data = "pocket_data";
  static const cart_data = "cart_data";
  static const collect_data = "collect_data";
  static const activity_data = "activity_data";
  static const search_data = "search_data";
  static const balance_hide = "balance_hide";
  static const activity_success = "activity_success";

  //是否登录
  static isLogined() async {
    String token = await getToken();
    Logger.log("token: $token");
    return TextUtils.isNotEmpty(token);
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(SystemConfigKeys.token);
    return token ?? '';
  }

  static setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SystemConfigKeys.token, token);
  }

  static Future<String> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? language = prefs.getString(app_language);
    return language ?? LanguagePage.language;
  }

  static setLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(app_language, language);
  }

  static Future<bool> getBalanceHide() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isHide = prefs.getBool(balance_hide);
    return isHide ?? false;
  }

  static setBalanceHide(bool isHide) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(balance_hide, isHide);
  }

  static Future<String> getInstallReferer() async {
    return await AppUtils.getLocalConfigByKey(install_referer) ?? '';
  }

  static setInstallReferer(String referer) async {
    await setLocalConfigByKey(install_referer, referer);
  }

  static Future<bool> isLoadGuide() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? isLoadGuide = prefs.getString(is_load_guide);
    if (isLoadGuide == null || TextUtils.isEmpty(isLoadGuide)) {
      return false;
    } else {
      return true;
    }
  }

  static setLoadGuide(bool isLoad) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(is_load_guide, "$isLoad");
  }

  static getLocalConfigByKey(String key) async {
    SystemConfig? systemConfig = await DbUtils.getSystemConfig();
    String localConfig = systemConfig?.local_config ?? '{}';
    dynamic data = jsonDecode(localConfig);
    return data[key];
  }

  static setLocalConfigByKey(String key, dynamic value) async {
    SystemConfig? systemConfig = await DbUtils.getSystemConfig();
    String localConfig = systemConfig?.local_config ?? '{}';
    dynamic data = jsonDecode(localConfig);
    data[key] = value;
    await DbUtils.updateSystemConfig(
        {SystemConfigKeys.local_config: jsonEncode(data)});
  }

  static getInitConfigByKey(String key) async {
    if (TextUtils.isEmpty(key)) return '';
    SystemConfig? systemConfig = await DbUtils.getSystemConfig();
    String initConfig = systemConfig?.init_config ?? '{}';
    Map<String, dynamic> map = jsonDecode(initConfig);
    if (!map.containsKey(key)) return '';
    return map[key];
  }

  static setInitConfigByKey(String key, dynamic value) async {
    SystemConfig? systemConfig = await DbUtils.getSystemConfig();
    String localConfig = systemConfig?.init_config ?? '{}';
    dynamic data = jsonDecode(localConfig);
    data[key] = value;
    await DbUtils.updateSystemConfig(
        {SystemConfigKeys.init_config: jsonEncode(data)});
  }

  static Future<dynamic> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(user_info);
    return data != null ? jsonDecode(data) : {};
  }

  static setUserInfo(dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(user_info, jsonEncode(data));
  }

  static Future<dynamic> getSystemSettingsInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(system_info);
    return data != null ? jsonDecode(data) : {};
  }

  static setSystemSettingsInfo(dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(system_info, jsonEncode(data));
  }

  static Future<dynamic> getHomeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(home_data);
    return data != null ? jsonDecode(data) : {};
  }

  static setHomeData(dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(home_data, jsonEncode(data));
  }

  static Future<dynamic> getPocketData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(pocket_data);
    return data != null ? jsonDecode(data) : {};
  }

  static setPocketData(dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(pocket_data, jsonEncode(data));
  }

  static Future<List<dynamic>> getCartData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(cart_data);
    return data != null ? jsonDecode(data) : [];
  }

  static setCartData(dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(cart_data, jsonEncode(data));
  }

  static Future<List<dynamic>> getCollectData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(collect_data);
    return data != null ? jsonDecode(data) : [];
  }

  static setCollectData(dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(collect_data, jsonEncode(data));
  }

  static Future<List<dynamic>> getActivityData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(activity_data);
    return data != null ? jsonDecode(data) : [];
  }

  static setActivityData(dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(activity_data, jsonEncode(data));
  }

  static Future<ReadCount> getReadCount(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(key);
    return data != null
        ? ReadCount.toReadCount(jsonDecode(data))
        : ReadCount(key, 0, 1);
  }

  static setReadCount(String key, ReadCount value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(value.toDynamic()));
  }

  static Future<List<dynamic>> getSearchData() async {
    dynamic userInfo = await getUserInfo();
    String userId = BaseModel.getString(userInfo, "id");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString("${search_data}_$userId");
    return data != null ? jsonDecode(data) : [];
  }

  static setSearchData(dynamic data) async {
    dynamic userInfo = await getUserInfo();
    String userId = BaseModel.getString(userInfo, "id");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> dataList = await getSearchData();
    if (!dataList.contains(data)) {
      dataList.add(data);
      await prefs.setString("${search_data}_$userId", jsonEncode(dataList));
    }
  }

  static setSearchDataList(List<dynamic> dataList) async {
    dynamic userInfo = await getUserInfo();
    String userId = BaseModel.getString(userInfo, "id");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("${search_data}_$userId", jsonEncode(dataList));
  }

  static getActivity(String activityId) async {
    List<dynamic> dataList = await AppUtils.getActivityData();
    dynamic activity;
    for (var item in dataList) {
      if (activityId == BaseModel.getString(item, "id")) {
        activity = item;
        break;
      }
    }
    return activity;
  }

  static getActivityMember(String activityId) async {
    dynamic data = await AppUtils.getPocketData();
    List<dynamic> activityMemberList =
        BaseModel.isNotEmpty(data, "activityMemberList")
            ? BaseModel.getDynamic(data, "activityMemberList")
            : [];
    dynamic activityMember;
    for (var item in activityMemberList) {
      if (activityId == BaseModel.getString(item, "activityId")) {
        activityMember = item;
        break;
      }
    }
    return activityMember;
  }

  static Future<List<String>> getActivityMemberIds() async {
    dynamic data = await AppUtils.getPocketData();
    List<dynamic> activityMemberList =
        BaseModel.isNotEmpty(data, "activityMemberList")
            ? BaseModel.getDynamic(data, "activityMemberList")
            : [];
    List<String> activityIds = [];
    for (var item in activityMemberList) {
      activityIds.add(BaseModel.getString(item, "activityId"));
    }
    return activityIds;
  }

  static getPocketMember(String activityId, String productId) async {
    dynamic data = await AppUtils.getPocketData();
    List<dynamic> pocketMemberList =
        BaseModel.isNotEmpty(data, "pocketMemberList")
            ? BaseModel.getDynamic(data, "pocketMemberList")
            : [];
    dynamic pocketMember;
    for (var item in pocketMemberList) {
      if (activityId == BaseModel.getString(item, "activityId") &&
          productId == BaseModel.getString(item, "productId")) {
        pocketMember = item;
        break;
      }
    }
    return pocketMember;
  }

  static getPocketMemberByProduct(String productId) async {
    dynamic data = await AppUtils.getPocketData();
    List<dynamic> pocketMemberList =
        BaseModel.isNotEmpty(data, "pocketMemberList")
            ? BaseModel.getDynamic(data, "pocketMemberList")
            : [];
    dynamic pocketMember;
    for (var item in pocketMemberList) {
      if (productId == BaseModel.getString(item, "productId")) {
        pocketMember = item;
        break;
      }
    }
    return pocketMember;
  }

  static Future<List<dynamic>> getPocketMemberByIds(String activityId) async {
    dynamic data = await AppUtils.getPocketData();
    List<dynamic> pocketMemberList =
        BaseModel.isNotEmpty(data, "pocketMemberList")
            ? BaseModel.getDynamic(data, "pocketMemberList")
            : [];
    List<dynamic> tempList = [];
    for (var item in pocketMemberList) {
      if (activityId == BaseModel.getString(item, "activityId")) {
        tempList.add(item);
      }
    }
    return tempList;
  }

  static addOrUpdateLoggedInfo(dynamic data) async {
    int id = BaseModel.getInt(data, "id");
    String token = await getToken();
    String phoneCode = BaseModel.getString(data, "phoneCode");
    String phone = BaseModel.getString(data, "phone");
    String nickname = BaseModel.getString(data, "nickname");
    String username = BaseModel.getString(data, "username");
    String icon = BaseModel.getString(data, "icon");
    LoggedInfo? loggedInfo = await DbUtils.getLoggedInfoById(id);
    if (loggedInfo == null) {
      // 插入数据
      LoggedInfo loggedInfo = LoggedInfo();
      loggedInfo.id = id;
      loggedInfo.token = token;
      loggedInfo.phoneCode = phoneCode;
      loggedInfo.phone = phone;
      loggedInfo.nickname = nickname;
      loggedInfo.username = username;
      loggedInfo.icon = icon;
      await DbUtils.addLoggedInfo(loggedInfo);
    } else {
      // 更新数据
      if (token != loggedInfo.token ||
          phoneCode != loggedInfo.phoneCode ||
          phone != loggedInfo.phone ||
          nickname != loggedInfo.nickname ||
          icon != loggedInfo.icon) {
        LoggedInfo newLoggedInfo = LoggedInfo();
        newLoggedInfo.id = id;
        newLoggedInfo.token = token;
        newLoggedInfo.phoneCode = phoneCode;
        newLoggedInfo.phone = phone;
        newLoggedInfo.nickname = nickname;
        newLoggedInfo.username = username;
        newLoggedInfo.icon = icon;
        await DbUtils.updateLoggedInfo(newLoggedInfo);
      }
    }
  }

  static clearData() async {
    await AppUtils.setToken("");
    await AppUtils.setPocketData("");
    await AppUtils.setCartData([]);
    await AppUtils.setActivityData([]);
    await AppUtils.setReadCount(
        IConstant.pocket_count, ReadCount(IConstant.pocket_count, 0, 1));
    await AppUtils.setReadCount(
        IConstant.activity_count, ReadCount(IConstant.activity_count, 0, 1));
    await AppUtils.setReadCount(IConstant.activity_detail_count,
        ReadCount(IConstant.activity_detail_count, 0, 1));
    await AppUtils.setReadCount(
        IConstant.order_count_0, ReadCount(IConstant.order_count_0, 0, 1));
    await AppUtils.setReadCount(
        IConstant.order_count_1, ReadCount(IConstant.order_count_1, 0, 1));
    await AppUtils.setReadCount(
        IConstant.order_count_2, ReadCount(IConstant.order_count_2, 0, 1));
    await AppUtils.setReadCount(
        IConstant.order_count_3, ReadCount(IConstant.order_count_3, 0, 1));
  }

  static DateTimePickerLocale getLocaleType() {
    DateTimePickerLocale localeType = DateTimePickerLocale.en_us;
    switch (LanguagePage.language) {
      case "ZH":
        localeType = DateTimePickerLocale.zh_cn;
        break;
      case "TH":
        localeType = DateTimePickerLocale.en_us;
        break;
      default:
        localeType = DateTimePickerLocale.en_us;
        break;
    }
    return localeType;
  }

  static Future<String> getActivitySuccess(String activityId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString("${activity_success}_$activityId");
    return data ?? '';
  }

  static setActivitySuccess(String activityId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("${activity_success}_$activityId", "true");
  }

}
