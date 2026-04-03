import 'dart:convert';
import 'dart:ui';

import 'package:common_utils/common_utils.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';

class SignModel {
  DateTime day;
  String ymd;
  int changeCount;
  DateStatus dateStatus;
  SignStatus signStatus;
  int continueNum;
  bool clickEnable;

  SignModel(
      this.day, this.ymd, this.changeCount, this.dateStatus, {this.continueNum = 1, this.signStatus = SignStatus.unsign, this.clickEnable = false});

  String getIntegral() {
    return "+ $changeCount";
  }

  bool isUnsign() {
    return signStatus == SignStatus.unsign;
  }

  bool isSigned() {
    return signStatus == SignStatus.signed;
  }

  bool isFillsign() {
    return signStatus == SignStatus.fillsign;
  }

  bool isSame() {
    return dateStatus == DateStatus.same;
  }

  bool isBefore() {
    return dateStatus == DateStatus.before;
  }

  bool isAfter() {
    return dateStatus == DateStatus.after;
  }

  bool isToday() {
    return ymd == FormatUtil.formatLineYMD(FormatUtil.getTHNowTime());
  }

  bool isYesterday() {
    return DateUtil.isYesterday(DateTime.parse(ymd), FormatUtil.getTHNowTime());
  }

  Color getBgColor() {
    if (isUnsign()) {
      if (isSame()) {
        return IConstant.main_color;
      } else {
        if (clickEnable) {
          return IConstant.red_bg_color;
        } else {
          return IConstant.grey_bg_color;
        }
      }
    } else if (isFillsign()){
      return IConstant.main_color;
    }  else {
      return IConstant.main_color;
    }
  }

  Color getTexColor() {
    if (isUnsign()) {
      if (isSame()) {
        return IConstant.white_color;
      } else if (isBefore()) {
        if (clickEnable) {
          return IConstant.main_color;
        } else {
          return IConstant.grey_color;
        }
      } else {
        return IConstant.red_bg_color2;
      }
    } else if (isFillsign()){
      return IConstant.white_color;
    } else {
      return IConstant.white_color;
    }
  }

}

enum DateStatus { before, same, after }

enum SignStatus { unsign, signed, fillsign }
