
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../config/LanguageConfig.dart';

class ProfitStudyPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return ProfitStudyPageState();
  }

}

class ProfitStudyPageState extends BaseKeepAliveState<ProfitStudyPage> {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.5.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_profit_study),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: Center(child: Text(LanguageConfig.get(LanguageConfigKeys.Base_coming_soon))),
    );
  }

}
