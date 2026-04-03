import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../widget/SmallTextButton.dart';


class VerifiedResultPage extends StatefulWidget {

  VerifiedResultPage();

  @override
  State<StatefulWidget> createState() {
    return VerifiedResultPageState();
  }

}

class VerifiedResultPageState extends BaseKeepAliveState<VerifiedResultPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      body: Column(
        children: [
          SizedBox(height: 10.w),
          Text(LanguageConfig.get(LanguageConfigKeys.Base_submit_success),
              style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
          Container(
            margin: EdgeInsets.fromLTRB(16.w, 20.w, 16.w, 6.w),
            child: Expanded(child: Center(child: buildWaitTime())),
          )
        ],
      ),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildWaitTime() {
    String joinMXGet = LanguageConfig.get(LanguageConfigKeys.Shop_mine_verify_wait_time);
    var golds = joinMXGet.split("|");
    return RichText(
        text: TextSpan(
            children: [
              TextSpan(
                text: golds[0],
                style: TextStyle(fontSize: 14.sp, color: IConstant.text_color),
              ),
              TextSpan(
                text: "1",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.main_color),
              ),
              TextSpan(
                text: golds[1],
                style: TextStyle(fontSize: 14.sp, color: IConstant.text_color),
              ),
            ]));
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      elevation: 0.w,
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
        height: 50.w,
        alignment: Alignment.center,
        child: SizedBox(
          width: 180.w,
          child: SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.ViewUtils_confirm), onTap: () {
            backHome();
          }),
        ),
      ),
    );
  }

}
