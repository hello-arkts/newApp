
import 'package:flutter/material.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/utils/AppUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';

import 'LanguagePage.dart';


class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexPageState();
}

class IndexPageState extends BaseKeepAliveState<IndexPage> {

  @override
  void initState() {
    super.initState();
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    // await AppUtils.setLoadGuide(false);
    LanguagePage.language = await AppUtils.getLanguage();
    // await installReferer();
    nextMainPage();
    // bool isLoadGuide = await AppUtils.isLoadGuide();
    // if (isLoadGuide) {
    //   nextMainPage();
    // } else {
    //   nextPage(GuidePage(), true);
    // }
  }

  // Future<void> installReferer() async {
  //   try {
  //     String str = await AppUtils.getInstallReferer();
  //     if (TextUtils.isNotEmpty(str)) return;
  //     ReferrerDetails referrerDetails = await AndroidPlayInstallReferrer.installReferrer;
  //     String installReferer = referrerDetails.installReferrer ?? 'referer_is_null';
  //     await AppUtils.setInstallReferer(installReferer);
  //   } catch (e) {
  //     TextUtils.println(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: Image.asset(
                  "assets/back/loading.jpg",
                ).image)),
        // child: ViewUtils.buildLoading(),
      ),
    );
  }

}
