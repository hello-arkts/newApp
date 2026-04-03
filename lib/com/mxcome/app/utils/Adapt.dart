import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:ui';

class Adapt {
  static double getWindowHeight() {
    MediaQueryData _mediaQuery = MediaQueryData.fromWindow(window);
    return _mediaQuery.size.height;
  }

  static double getWindowWidth() {
    MediaQueryData _mediaQuery = MediaQueryData.fromWindow(window);
    return _mediaQuery.size.width;
  }



  static double getWidgetHeight(ctx) {
    Size size = MediaQuery.of(ctx).size;
    return size.height;
  }

  static double getWidgetWidth(ctx) {
    Size size = MediaQuery.of(ctx).size;
    return size.width;
  }

  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double getAppBarHeight() {
    return AppBar().preferredSize.height;
  }

  static px(number) {
    MediaQueryData _mediaQuery = MediaQueryData.fromWindow(window);
    double _pixelRatio = _mediaQuery.devicePixelRatio;
    return (number / _pixelRatio) * (Platform.isAndroid || (Platform.isIOS && _pixelRatio.toInt() >= 3) ? 1 : .8);
  }

  static double getRatio() {
    MediaQueryData _mediaQuery = MediaQueryData.fromWindow(window);
    double _pixelRatio = _mediaQuery.devicePixelRatio;
    return _pixelRatio;
  }

  static sp(number) {
    MediaQueryData _mediaQuery = MediaQueryData.fromWindow(window);
    double _textScaleFactor = _mediaQuery.textScaleFactor;
    return number / _textScaleFactor;
  }
}
