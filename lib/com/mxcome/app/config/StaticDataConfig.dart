import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';

class StaticDataConfig {
  /// 首页 - 底部六宫格广告菜单数据
  static List<Map<String, String>> get productAdvertiseMenus => [
        {
          "icon": "assets/icons/lalu_pantas.png",
          "title": LanguageConfig.get(LanguageConfigKeys.Shop_menu_fast_pass),
          "subtitle":
              LanguageConfig.get(LanguageConfigKeys.Shop_menu_fast_pass_sub),
          "subtitleColor": "red",
        },
        {
          "icon": "assets/icons/airport_car_hire.png",
          "title": LanguageConfig.get(LanguageConfigKeys.Shop_menu_car_rental),
          "subtitle":
              LanguageConfig.get(LanguageConfigKeys.Shop_menu_car_rental_sub),
        },
        {
          "icon": "assets/icons/kad_telekom_malaysia.png",
          "title": LanguageConfig.get(LanguageConfigKeys.Shop_menu_thai_sim),
          "subtitle":
              LanguageConfig.get(LanguageConfigKeys.Shop_menu_thai_sim_sub),
        },
        {
          "icon": "assets/icons/store_brand.png",
          "title": LanguageConfig.get(LanguageConfigKeys.Shop_menu_brand_store),
          "subtitle":
              LanguageConfig.get(LanguageConfigKeys.Shop_menu_brand_store_sub),
        },
        {
          "icon": "assets/icons/pesta_pengembara.png",
          "title":
              LanguageConfig.get(LanguageConfigKeys.Shop_menu_party_travel),
          "subtitle":
              LanguageConfig.get(LanguageConfigKeys.Shop_menu_party_travel_sub),
        },
        {
          "icon": "assets/icons/consumer_rebate.png",
          "title":
              LanguageConfig.get(LanguageConfigKeys.Shop_menu_consumer_rebate),
          "subtitle": LanguageConfig.get(
              LanguageConfigKeys.Shop_menu_consumer_rebate_sub),
        },
      ];
}
