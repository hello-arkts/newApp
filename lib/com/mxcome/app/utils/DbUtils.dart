import 'dart:async';
import 'dart:convert';

import 'package:mxcome/com/mxcome/app/db/DbHelper.dart';
import 'package:mxcome/com/mxcome/app/model/LoggedInfo.dart';
import 'package:mxcome/com/mxcome/app/model/SystemConfig.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:sqflite/sqflite.dart';

class DbUtils {
  static Future<SystemConfig?> getSystemConfig() async {
    try {
      Database db = await DbHelper.instant.onCreate();
      List<Map<String, dynamic>> list =
          await db.query(DbHelper.SYSTEM_CONFIG_TABLE);
      SystemConfig? systemConfig;
      if (list.isNotEmpty && list.first.isNotEmpty) {
        var map = list.first;
        systemConfig = SystemConfig();
        systemConfig.id = map[SystemConfigKeys.id];
        systemConfig.token = map[SystemConfigKeys.token];
        systemConfig.init_config = map[SystemConfigKeys.init_config];
        systemConfig.local_config = map[SystemConfigKeys.local_config];
      }
      if (systemConfig == null) {
        systemConfig = SystemConfig();
        systemConfig.local_config = jsonEncode({});
        systemConfig.init_config = jsonEncode({});
        var values = <String, dynamic>{};
        values[SystemConfigKeys.init_config] = systemConfig.init_config;
        values[SystemConfigKeys.local_config] = systemConfig.local_config;
        await db.insert(DbHelper.SYSTEM_CONFIG_TABLE, values);
      }
      return systemConfig;
    } catch (e) {
      TextUtils.println('db get system_config>>>>$e');
    }
    return null;
  }

  static updateSystemConfig(Map<String, dynamic> values) async {
    try {
      Database db = await DbHelper.instant.onCreate();
      await db.update(DbHelper.SYSTEM_CONFIG_TABLE, values);
    } catch (e) {
      TextUtils.println('db update system_config>>>>$e');
    }
  }

  static Future<List<LoggedInfo>> getLoggedInfo() async {
    List<LoggedInfo> result = [];
    try {
      Database db = await DbHelper.instant.onCreate();
      List<Map<String, dynamic>> list =
          await db.query(DbHelper.LOGGED_INFO_TABLE);
      for (Map<String, dynamic> map in list) {
        LoggedInfo loggedInfo = LoggedInfo();
        loggedInfo.id = map[LoggedInfoKeys.id];
        loggedInfo.token = map[LoggedInfoKeys.token];
        loggedInfo.phoneCode = map[LoggedInfoKeys.phoneCode];
        loggedInfo.phone = map[LoggedInfoKeys.phone];
        loggedInfo.nickname = map[LoggedInfoKeys.nickname];
        loggedInfo.icon = map[LoggedInfoKeys.icon];
        result.add(loggedInfo);
      }
    } catch (e) {
      TextUtils.println('db get logged_info>>>>$e');
    }
    return result;
  }

  static Future<LoggedInfo?> getLoggedInfoByPhone(String phone) async {
    try {
      Database db = await DbHelper.instant.onCreate();
      List<Map<String, dynamic>> list = await db.query(DbHelper.LOGGED_INFO_TABLE,
          where: '${LoggedInfoKeys.phone} = ?',
          whereArgs: [phone]);
      var map = list.first;
      LoggedInfo loggedInfo = LoggedInfo();
      loggedInfo.id = map[LoggedInfoKeys.id];
      loggedInfo.token = map[LoggedInfoKeys.token];
      loggedInfo.phoneCode = map[LoggedInfoKeys.phoneCode];
      loggedInfo.phone = map[LoggedInfoKeys.phone];
      loggedInfo.nickname = map[LoggedInfoKeys.nickname];
      loggedInfo.username = map[LoggedInfoKeys.username];
      loggedInfo.icon = map[LoggedInfoKeys.icon];
      return loggedInfo;
    } catch (e) {
      TextUtils.println('db getLoggedInfoByPhone logged_info>>>>$e');
    }
    return null;
  }

  static Future<LoggedInfo?> getLoggedInfoById(int id) async {
    try {
      Database db = await DbHelper.instant.onCreate();
      List<Map<String, dynamic>> list = await db.query(DbHelper.LOGGED_INFO_TABLE,
          where: '${LoggedInfoKeys.id} = ?',
          whereArgs: [id]);
      var map = list.first;
      LoggedInfo loggedInfo = LoggedInfo();
      loggedInfo.id = map[LoggedInfoKeys.id];
      loggedInfo.token = map[LoggedInfoKeys.token];
      loggedInfo.phoneCode = map[LoggedInfoKeys.phoneCode];
      loggedInfo.phone = map[LoggedInfoKeys.phone];
      loggedInfo.nickname = map[LoggedInfoKeys.nickname];
      loggedInfo.username = map[LoggedInfoKeys.username];
      loggedInfo.icon = map[LoggedInfoKeys.icon];
      return loggedInfo;
    } catch (e) {
      TextUtils.println('db getById logged_info>>>>$e');
    }
    return null;
  }

  static Future<LoggedInfo?> getLoggedInfoByToken(String token) async {
    try {
      Database db = await DbHelper.instant.onCreate();
      List<Map<String, dynamic>> list = await db.query(DbHelper.LOGGED_INFO_TABLE,
          where: '${LoggedInfoKeys.token} = ?',
          whereArgs: [token]);
      var map = list.first;
      LoggedInfo loggedInfo = LoggedInfo();
      loggedInfo.id = map[LoggedInfoKeys.id];
      loggedInfo.token = map[LoggedInfoKeys.token];
      loggedInfo.phoneCode = map[LoggedInfoKeys.phoneCode];
      loggedInfo.phone = map[LoggedInfoKeys.phone];
      loggedInfo.nickname = map[LoggedInfoKeys.nickname];
      loggedInfo.username = map[LoggedInfoKeys.username];
      loggedInfo.icon = map[LoggedInfoKeys.icon];
      return loggedInfo;
    } catch (e) {
      TextUtils.println('db getLoggedInfoByPhone logged_info>>>>$e');
    }
    return null;
  }

  static addLoggedInfo(LoggedInfo loggedInfo) async {
    try {
      Database db = await DbHelper.instant.onCreate();
      await db.insert(DbHelper.LOGGED_INFO_TABLE, {
        LoggedInfoKeys.id: loggedInfo.id,
        LoggedInfoKeys.phoneCode: loggedInfo.phoneCode,
        LoggedInfoKeys.phone: loggedInfo.phone,
        LoggedInfoKeys.nickname: loggedInfo.nickname,
        LoggedInfoKeys.username: loggedInfo.username,
        LoggedInfoKeys.icon: loggedInfo.icon,
      });
    } catch (e) {
      TextUtils.println('db add logged_info>>>>$e');
    }
  }

  static updateLoggedInfo(LoggedInfo loggedInfo) async {
    try {
      Database db = await DbHelper.instant.onCreate();
      await db.update(
          DbHelper.LOGGED_INFO_TABLE,
          {
            LoggedInfoKeys.phoneCode: loggedInfo.phoneCode,
            LoggedInfoKeys.phone: loggedInfo.phone,
            LoggedInfoKeys.nickname: loggedInfo.nickname,
            LoggedInfoKeys.username: loggedInfo.username,
            LoggedInfoKeys.icon: loggedInfo.icon,
          },
          where: '${LoggedInfoKeys.id} = ?',
          whereArgs: [loggedInfo.id]);
    } catch (e) {
      TextUtils.println('db update logged_info>>>>$e');
    }
  }
}
