
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/ClockComponent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CountDownView.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/SmallTextButton.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../widget/BigTextButton.dart';

class TimePromptPage extends StatefulWidget {

  String endTime;

  int type = 1; //1：任务，2：活动

  Function(BuildContext context, bool yes) callBack;

  TimePromptPage(this.endTime, this.callBack, {this.type = 1});

  @override
  State<TimePromptPage> createState() => _TimePromptPageState();
}

class _TimePromptPageState extends BaseKeepAliveState<TimePromptPage> {

  String _endTime = "";

  @override
  void initState() {
    super.initState();
    _endTime = widget.endTime;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        leading: Container(),
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_tip),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10.w, 4.w, 10.w, 4.w),
              decoration: BoxDecoration(
                  color: IConstant.red_bg_color3,
                  borderRadius: BorderRadius.circular(20.w)),
              child: CountDownView(startTime: serviceTime, endTime: _endTime, fontSize: 15.sp, textColor: IConstant.main_color, timeType: 1, stop: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_task_over)),
            ),
            SizedBox(height: 30.w),
            widget.type == 1 ?
            Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_48_hours),
                textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)) :
            Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_48_hours),
                textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
            SizedBox(height: 10.w),
            widget.type == 1 ?
            Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_task_soon_timeout),
                textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)) :
            Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_soon_timeout),
                textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp, color: IConstant.text_color))
          ],
        ),
      ),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getServiceTime();
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      child: SizedBox(
        height: 60.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100.w,
              child: SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.ViewUtils_cancel),
                  bgColor: IConstant.grey_bg_color,
                  textColor: IConstant.text_color,
                  onTap: () {
                    widget.callBack(context, false);
                  }),
            ),
            SizedBox(width: 20.w),
            SizedBox(
              width: 100.w,
              child: SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.ViewUtils_confirm), onTap: () {
                widget.callBack(context, true);
              }),
            ),
          ],
        ),
      ),
    );
  }

}
