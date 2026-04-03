
import '../../../config/LanguageConfig.dart';

class CountryCodeModel {

  String code;
  String icon;
  String title;

  factory CountryCodeModel.fromLanguage(String language) {
    if (language == LanguageType.EN) {
      return CountryCodeModel("+1", "assets/icons/country_en.png", LanguageConfig.get(LanguageConfigKeys.Login_country_en));
    } else if (language == LanguageType.ZH) {
      return CountryCodeModel("+86", "assets/icons/country_zh.png", LanguageConfig.get(LanguageConfigKeys.Login_country_zh));
    } else {
      return CountryCodeModel("+66", "assets/icons/country_th.png", LanguageConfig.get(LanguageConfigKeys.Login_country_th));
    }
  }

  factory CountryCodeModel.fromCode(String code) {
    if (code == "+1") {
      return CountryCodeModel("+1", "assets/icons/country_en.png", LanguageConfig.get(LanguageConfigKeys.Login_country_en));
    } else if (code == "+86") {
      return CountryCodeModel("+86", "assets/icons/country_zh.png", LanguageConfig.get(LanguageConfigKeys.Login_country_zh));
    } else {
      return CountryCodeModel("+66", "assets/icons/country_th.png", LanguageConfig.get(LanguageConfigKeys.Login_country_th));
    }
  }

  CountryCodeModel(
      this.code,
      this.icon,
      this.title);

}
