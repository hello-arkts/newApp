import 'package:flutter/material.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/LanguageEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/utils/AppUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguagePage extends StatefulWidget {

  static String language = IConstant.DEFAULT_LANGUAGE;

  @override
  State<StatefulWidget> createState() => LanguagePageState();
}

class LanguagePageState extends BaseKeepAliveState<LanguagePage> {

  List<String> langueges = [
    LanguageType.EN,
    LanguageType.TH,
    LanguageType.ZH,
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
          elevation: 0.w,
          titleSpacing: 0,
          title: Text(
            LanguageConfig.get(LanguageConfigKeys.language),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color),
          )),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            child: Text(
                LanguageConfig.get(LanguageConfigKeys.language_tip),
                style: TextStyle(fontSize: 15.w, color: IConstant.text_color)),
          ),
          Expanded(child: ListView.separated(
             itemBuilder: (ctx, idx) => buildItem(idx),
             itemCount: langueges.length,
             separatorBuilder: (BuildContext context, int index) {
               return Divider(height: 1.w);
             }))
        ],
      ),
    );
  }

  buildItem(idx) {
    String item = langueges[idx];
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: <Widget>[
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(getLanguage(item),
                //   style: TextStyle(color: item == LanguagePage.language ? IConstant.main_color: IConstant.title_color, fontSize: 17.sp),
                //   maxLines: 1,
                // ),
                Text(getLanguageText(item),
                  style: TextStyle(color: item == LanguagePage.language ? IConstant.main_color: IConstant.title_color, fontSize: 17.sp),
                  maxLines: 1,
                )
              ],
            )),
            item == LanguagePage.language
                ? Icon(Icons.check, size: 20.w, color: IConstant.main_color,)
                : SizedBox(width: 20.w, height: 20),
          ],
        ),
      ),
      onTap: () async {
        LanguagePage.language = item;
        await AppUtils.setLanguage(item);
        EventBusUtil.getInstance().emit(LanguageEvent());
        finish();
      },
    );
  }

  String getLanguage(String lang){
    String title;
    switch (lang) {
      case "ZH":
        title = LanguageConfig.get(LanguageConfigKeys.Login_country_zh);
        break;
      case "TH":
        title = LanguageConfig.get(LanguageConfigKeys.Login_country_th);
        break;
      default:
        title = LanguageConfig.get(LanguageConfigKeys.Login_country_en);
        break;
    }
    return title;
  }

  String getLanguageText(String lang){
    String title;
    switch (lang) {
      case "ZH":
        title = "简体中文";
        break;
      case "TH":
        title = "ไทย";
        break;
      default:
        title = "English";
        break;
    }
    return title;
  }


}
