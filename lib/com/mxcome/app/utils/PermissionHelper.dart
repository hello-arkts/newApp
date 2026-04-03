import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {

  static VoidCallback defaultCall = () {};

  ///检查权限
  static void check(Permission permission, {
         VoidCallback? onSuccess,
         VoidCallback? onFailed,
         VoidCallback? onOpenSetting}) async {
    PermissionStatus status = await permission.status;
    if (status.isGranted) {
      onSuccess != null ? onSuccess() : defaultCall();
    } else if (status.isDenied) {
      onFailed != null ? onFailed() : defaultCall();
    } else if (status.isPermanentlyDenied) {
      onOpenSetting != null ? onOpenSetting() : defaultCall();
    } else if (status.isRestricted) {
      //IOS单独处理
      onOpenSetting != null ? onOpenSetting() : defaultCall();
    } else if (status.isLimited) {
      //IOS单独处理
      onOpenSetting != null ? onOpenSetting() : defaultCall();
    }
  }

  //申请权限
  static void requestPermission(Permission permission, {
    VoidCallback? onSuccess,
    VoidCallback? onFailed,
    VoidCallback? onOpenSetting}) async {
    PermissionStatus status = await permission.request();
    if (status.isGranted) {
      onSuccess != null ? onSuccess() : defaultCall();
    } else if (status.isDenied) {
      onFailed != null ? onFailed() : defaultCall();
    } else if (status.isPermanentlyDenied) {
      onOpenSetting != null ? onOpenSetting() : defaultCall();
    } else if (status.isRestricted) {
      //IOS单独处理
      onOpenSetting != null ? onOpenSetting() : defaultCall();
    } else if (status.isLimited) {
      //IOS单独处理
      onOpenSetting != null ? onOpenSetting() : defaultCall();
    }
  }

}