
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/BigTextButton.dart';
import 'package:open_store/open_store.dart';

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

class VersionPage extends StatefulWidget {

  String updateTime;
  String versionInfo;

  VersionPage(this.updateTime, this.versionInfo);

  @override
  State<StatefulWidget> createState() {
    return VersionPageState();
  }

}

class VersionPageState extends BaseKeepAliveState<VersionPage> {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        leading: Container(),
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_setting_update_new_version),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(20.w, 10.w, 20.w, 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${LanguageConfig.get(LanguageConfigKeys.Shop_setting_update_time)} ${widget.updateTime}", style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
            SizedBox(height: 16.w),
            Expanded(child: Text(widget.versionInfo, style: TextStyle(fontSize: 14.sp, color: IConstant.text_color))),
            Center(
              child: Image.asset("assets/icons/update_icon.png", height: 40.w),
            )
          ],
        ),
      ),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      elevation: 0.w,
      child: Container(
        margin: EdgeInsets.fromLTRB(70.w, 20.w, 70.w, 20.w),
        child: BigTextButton(
            text: LanguageConfig.get(LanguageConfigKeys.Shop_setting_now_update),
            bgColor: IConstant.dark_green_color,
            textColor: IConstant.white_color, onTap: () {
              if (Platform.isAndroid) {
                OpenStore.instance.open(
                  androidAppBundleId: 'com.mxcome.app.mxcome', // Android app bundle package name
                );
              } else {
                OpenStore.instance.open(
                  appStoreId: '6446675692', // AppStore id of your app for iOS
                );
              }
        }),
      ),
    );
  }

}
