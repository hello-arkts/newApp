
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/setting/VersionPage.dart';
import 'package:mxcome/com/mxcome/app/utils/Adapt.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IURLConstant.dart';
import '../../../../config/LanguageConfig.dart';
import '../../../../model/BaseModel.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/AppUtils.dart';
import '../../../../utils/HttpUtils.dart';
import '../../../../utils/ViewUtils.dart';
import '../../../WebPage.dart';
import '../../model/ReadCount.dart';
import '../../utils/FormatUtil.dart';
import 'package:badges/badges.dart' as badges;

import '../../utils/Util.dart';

class AboutPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return AboutPageState();
  }

}

class AboutPageState extends BaseKeepAliveState<AboutPage> {

  bool isLogin = false;

  ReadCount _versionCount = ReadCount(IConstant.version_count, 0, 0);

  String localVersion = "";

  dynamic versionInfo;

  String serviceVersion = "";

  @override
  void initState() {
    super.initState();
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    localVersion = await Util.getVersion();
    ReadCount versionCount = await AppUtils.getReadCount(IConstant.version_count);
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_VERSION_INFO, {});
    setState(() {
      versionInfo = rsp.data;
      _versionCount = versionCount;
      serviceVersion = BaseModel.getString(rsp.data, "version");
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.5.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_setting_about),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Divider(height: 1.w),
          InkWell(onTap: () {
            checkVersion();
          }, child: ListTile(
            title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_setting_about_version), style: TextStyle(fontSize: 16.sp, color: IConstant.text_color)),
            subtitle: buildVersion(),
            // trailing: Icon(Icons.chevron_right, size: 20.w),
          )),
          Divider(height: 1.w),
          InkWell(onTap: () {
            nextPage(WebPage(FormatUtil.getProtocol()), false);
          }, child: ListTile(
            title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_setting_user_agreement), style: TextStyle(fontSize: 16.sp, color: IConstant.text_color)),
            subtitle: Text(LanguageConfig.get(LanguageConfigKeys.Shop_setting_user_agreement_detail), style: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color)),
            // trailing: Icon(Icons.chevron_right, size: 20.w),
          )),
          Divider(height: 1.w),
        ],
      ),
    );
  }

  Widget buildVersion() {
    return Row(
      children: [
        Text("Ver.$localVersion", style: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color)),
        SizedBox(width: 16.w),
        serviceVersion != localVersion ? badges.Badge(
            showBadge: true,
            badgeContent: Text("", style: TextStyle(fontSize: 12.sp, color: Colors.white)),
            position: badges.BadgePosition.topEnd(top: -10.w, end: -10.w),
            child: buildVersionIcon()) : Container(),
      ],
    );
  }

  Widget buildVersionIcon() {
    if(Platform.isAndroid) {
      return Image.asset("assets/icons/scb_google_play.png", height: 25.w);
    } else {
      return Image.asset("assets/icons/scb_app_store.png", height: 25.w);
    }
  }

  void checkVersion() async {
    if (serviceVersion != localVersion) {
      String updateTime = BaseModel.getString(versionInfo, "updateTime");
      String info = BaseModel.getString(versionInfo, "versionInfo");
      showUpdateDialog(updateTime, info);
    } else {
      _versionCount.value = 0;
      _versionCount.read = 0;
      await AppUtils.setReadCount(IConstant.version_count, _versionCount);
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_setting_last_version));
    }
  }

  void showUpdateDialog(String updateTime, String versionInfo) {
    showPop(0.6 * Adapt.getWindowHeight(), VersionPage(updateTime, versionInfo));
  }

}
