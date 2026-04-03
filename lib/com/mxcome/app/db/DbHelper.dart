
import 'package:mxcome/com/mxcome/app/model/SystemConfig.dart';
import 'package:mxcome/com/mxcome/app/model/LoggedInfo.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

class DbHelper {
  static const DB_NAME = 'mxcome_data.db';
  static const SYSTEM_CONFIG_TABLE = 'system_config';
  static const LOGGED_INFO_TABLE = 'logged_info';
  static int DB_VERSION = 1;

  static DbHelper instant = DbHelper();

  Future<Database> onCreate() async {
    return openDatabase(
      join(await getDatabasesPath(), DB_NAME),
      onCreate: (db, version) async {
        await db.execute('create table if not exists $SYSTEM_CONFIG_TABLE ('
            '${SystemConfigKeys.id} integer primary key AUTOINCREMENT,'
            '${SystemConfigKeys.token} text,'
            '${SystemConfigKeys.init_config} text,'
            '${SystemConfigKeys.local_config} text);');
        await db.execute('create table if not exists $LOGGED_INFO_TABLE ('
            '${LoggedInfoKeys.id} integer primary key,'
            '${LoggedInfoKeys.token} text,'
            '${LoggedInfoKeys.phoneCode} text,'
            '${LoggedInfoKeys.phone} text,'
            '${LoggedInfoKeys.nickname} text,'
            '${LoggedInfoKeys.username} text,'
            '${LoggedInfoKeys.icon} text);');
      },
      version: DB_VERSION,
    );
  }
}
