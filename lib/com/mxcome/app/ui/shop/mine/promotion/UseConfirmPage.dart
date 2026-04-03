import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../widget/SmallTextButton.dart';


class UseConfirmPage extends StatefulWidget {

  Function(BuildContext context) callBack;

  UseConfirmPage({required this.callBack});

  @override
  State<StatefulWidget> createState() {
    return UseConfirmPageState();
  }

}

class UseConfirmPageState extends BaseKeepAliveState<UseConfirmPage> {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      body: Column(
        children: [
          SizedBox(height: 10.w),
          Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_confirm_use),
              style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
          Expanded(child: Center(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_confirm_use_tip), style: TextStyle(fontSize: 14.w, color: IConstant.text_color))))
        ],
      ),
      bottomNavigationBar: buildBottomBar(),
    );
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
            widget.callBack(context);
          }),
        ),
      ),
    );
  }

}
