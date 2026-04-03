import 'dart:convert';
import 'dart:math';

import 'package:common_utils/common_utils.dart';
import 'package:intl/intl.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/IURLConstant.dart';
import 'package:mxcome/com/mxcome/app/model/BaseRsp.dart';
import 'package:mxcome/com/mxcome/app/ui/LanguagePage.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';

import '../../../PageConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../utils/HttpUtils.dart';

class FormatUtil {
  ///数字转成Int
  ///[number] 可以是String 可以是int 可以是double 出错了就返回0;
  static int num2int(number) {
    try {
      if (number is String) {
        return int.parse(number);
      } else if (number is int) {
        return number;
      } else if (number is double) {
        return number.toInt();
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  ///数字转成double
  ///[number] 可以是String 可以是int 可以是double 出错了就返回0;
  static double num2double(number) {
    try {
      if (number is String) {
        return double.parse(number);
      } else if (number is int) {
        return number.toDouble();
      } else if (number is double) {
        return number;
      } else {
        return 0.0;
      }
    } catch (e) {
      return 0.0;
    }
  }

  static String priceAbs2String(double price, {fixed = 2}) {
    String formatPrice = price.abs().toStringAsFixed(fixed);
    return "${IConstant.currency}$formatPrice";
  }

  static String price2String(double price, {fixed = 2}) {
    String formatPrice = price.toStringAsFixed(fixed);
    return "${IConstant.currency}$formatPrice";
  }

  static String hideCardNumber(String cardNumber) {
    String replacement = '****';
    if (cardNumber.length > 8) {
      String firstNumber = cardNumber.substring(0, 4);
      String lastNumber = cardNumber.substring(8, cardNumber.length);
      return TextUtil.formatSpace4("$firstNumber$replacement$lastNumber");
    } else {
      return "$replacement$cardNumber";
    }
  }

  static String profitAmount(double price, {double maxPrice = 0, bool unit = true}) {
    String formatPrice = price.toStringAsFixed(2);
    String pieceUnit = "";
    if (unit) {
      pieceUnit = "/${LanguageConfig.get(LanguageConfigKeys.Shop_pocket_piece)}";
    }
    if (price == 0) {
      return "${IConstant.currency}$formatPrice$pieceUnit";
    }
    if (maxPrice > 0 && maxPrice > price) {
      String formatMaxPrice = maxPrice.toStringAsFixed(2);
      return "${IConstant.currency}$formatPrice-$formatMaxPrice$pieceUnit";
    } else {
      return "${IConstant.currency}$formatPrice$pieceUnit";
    }
  }

  static String getShareContent(String baseURL, String content) {
    return "$baseURL$content";
  }

  static String getBetaProtocol() {
    if (LanguagePage.language == LanguageType.EN) {
      return "${PageConstant.WEB_BASE_URI}assets/html/product-protocol-en.md";
    } else if(LanguagePage.language == LanguageType.ZH) {
      return "${PageConstant.WEB_BASE_URI}assets/html/product-protocol-zh.html";
    } else {
      return "${PageConstant.WEB_BASE_URI}assets/html/product-protocol-th.html";
    }
  }

  static String getProtocol() {
    if (LanguagePage.language == LanguageType.EN) {
      return "${PageConstant.WEB_BASE_URI}assets/html/user-protocol-en.html";
    } else if(LanguagePage.language == LanguageType.ZH) {
      return "${PageConstant.WEB_BASE_URI}assets/html/user-protocol-zh.html";
    } else {
      return "${PageConstant.WEB_BASE_URI}assets/html/user-protocol-th.html";
    }
  }

  static String formatLineYMDHMS(DateTime date, {bool isUtc = false}){
    final fmt = DateFormat('yyyy-MM-dd HH:mm:ss');
    return fmt.format(DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch, isUtc: isUtc));
  }

  static String formatYM(DateTime date){
    final fmt = DateFormat('yyyy MM');
    return fmt.format(DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch));
  }

  static String formatYMD(DateTime date){
    final fmt = DateFormat('yyyy/MM/dd');
    return fmt.format(DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch));
  }

  static String formaMD(DateTime date){
    final fmt = DateFormat('MM/dd');
    return fmt.format(DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch));
  }

  static String formatLineYMD(DateTime date){
    final fmt = DateFormat('yyyy-MM-dd');
    return fmt.format(DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch));
  }

  static String formatYMDHM(DateTime date){
    final fmt = DateFormat('yyyy/MM/dd HH:mm');
    return fmt.format(DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch));
  }

  static String formatMDHM(DateTime date){
    final fmt = DateFormat('MM/dd HH:mm');
    return fmt.format(DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch));
  }

  static String formatMDHMS(DateTime date){
    final fmt = DateFormat('MM/dd HH:mm:ss');
    return fmt.format(DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch));
  }

  static String formatYMDHMS(DateTime date){
    final fmt = DateFormat('yyyy/MM/dd HH:mm:ss');
    return fmt.format(DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch));
  }

  static String formatHMS(DateTime date){
    final fmt = DateFormat('HH:mm:ss');
    return fmt.format(DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch));
  }

  static String formatMS(DateTime date){
    final fmt = DateFormat('HH:mm:ss');
    return fmt.format(DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch));
  }

  static DateTime getTHNowTime(){
    if (IConstant.IS_DEBUG) {
      var nowTime = DateTime.now();
      return DateTime.parse(formatLineYMDHMS(nowTime));
    } else {
      var utcTime = DateTime.now().toUtc();
      var utcZone = utcTime.add(const Duration(hours: 7));
      return DateTime.parse(formatLineYMDHMS(utcZone, isUtc: true));
    }
  }

  static String getReturnUrl(String orderSn) {
    return "${PageConstant.APP_BASE_URI}payResult/$orderSn";
  }

  static String showIcon(String name) {
    if (TextUtils.isNotEmpty(name) && name.length > 1) {
      name = name.substring(name.length - 1, name.length);
    }
    return name;
  }

  static String showName(String name){
    return name;
    // if (TextUtils.isNotEmpty(name) && name.length > 5) {
    //   return name.replaceRange(2, name.length - 4, "*");
    // } else {
    //   return name;
    // }
  }

  static String getLanguage(){
    String title;
    switch (LanguagePage.language) {
      case "ZH":
        title = "zh";
        break;
      case "TH":
        title = "th";
        break;
      default:
        title = "en";
        break;
    }
    return title;
  }

  static String getAddressLanguage(){
    String title;
    switch (LanguagePage.language) {
      case "TH":
        title = "th";
        break;
      default:
        title = "en";
        break;
    }
    return title;
  }

}