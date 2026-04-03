import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/utils/Adapt.dart';
import 'package:open_store/open_store.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../config/LanguageConfig.dart';

class SCBDownloadPage extends StatefulWidget {

  SCBDownloadPage();

  @override
  State<StatefulWidget> createState() {
    return SCBDownloadPageState();
  }
}

class SCBDownloadPageState extends BaseKeepAliveState<SCBDownloadPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        title: Text(
            LanguageConfig.get(LanguageConfigKeys.Shop_order_install_scb),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Expanded(child: SizedBox(
          width: Adapt.getWindowWidth(),
          child: Image.asset("assets/icons/scb_bank_bg.png", fit: BoxFit.cover))
        ),
        Container(
          margin: EdgeInsets.fromLTRB(16.w, 20.w, 16.w, 0.w),
          child: Text(
              LanguageConfig.get(LanguageConfigKeys.Shop_order_download_tip),
              style: TextStyle(fontSize: 17.sp, color: IConstant.title_color)),
        ),
        InkWell(
          onTap: () {
            // nextPage(WebPage("https://play.google.com/store/apps/details?id=com.scb.phone&hl=th"), false);
            OpenStore.instance.open(
                androidAppBundleId: 'com.scb.phone&hl=th', // Android app bundle package name
            );
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(16.w, 20.w, 16.w, 0.w),
            child: Image.asset("assets/icons/scb_google_play.png", height: 60.w),
          ),
        ),
        InkWell(
          onTap: () {
            // nextPage(WebPage("https://apps.apple.com/tw/app/scb-easy/id568388474"), false);
            OpenStore.instance.open(
              appStoreId: '568388474', // AppStore id of your app for iOS
            );
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(16.w, 20.w, 16.w, 20.w),
            child: Image.asset("assets/icons/scb_app_store.png", height: 60.w),
          ),
        )
      ],
    );
  }
}
