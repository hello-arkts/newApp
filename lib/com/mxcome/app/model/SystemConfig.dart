class SystemConfig {
  int? id;
  String? token; //登录的token
  String? init_config; //初始化下发的配置
  String? local_config; //本地存储的配置
}

class SystemConfigKeys {
  static const id = "id";
  static const token = "token";
  static const init_config = "init_config";
  static const local_config = "local_config";
}




