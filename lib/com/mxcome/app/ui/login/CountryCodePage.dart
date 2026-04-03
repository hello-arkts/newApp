import 'package:flutter/material.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/CountryCodeEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/CountryCodeModel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../shop/utils/EventBusUtil.dart';

class CountryCodePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => CountryCodePageState();
}

class CountryCodePageState extends BaseKeepAliveState<CountryCodePage> {

  List<CountryCodeModel> countryCodeList = [
    CountryCodeModel.fromLanguage(LanguageType.EN),
    CountryCodeModel.fromLanguage(LanguageType.TH),
    CountryCodeModel.fromLanguage(LanguageType.ZH),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
          elevation: 0.5.w,
          titleSpacing: 0,
          centerTitle: true,
          title: Text(LanguageConfig.get(LanguageConfigKeys.Login_select_country),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color),
          )),
      body: ListView.separated(
          itemBuilder: (ctx, idx) => buildItem(idx),
          itemCount: countryCodeList.length,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(height: 1.w);
          }),
    );
  }

  buildItem(idx) {
    CountryCodeModel item = countryCodeList[idx];
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Expanded(child: Text("${item.title} ${item.code}",
              style: TextStyle(color: IConstant.title_color, fontSize: 17.sp),
            )),
            Image.asset(item.icon,
              width: 18.w,
              height: 18.w,
            )
          ],
        ),
      ),
      onTap: () {
        EventBusUtil.getInstance().emit(CountryCodeEvent(item));
        finish();
      },
    );
  }

}
