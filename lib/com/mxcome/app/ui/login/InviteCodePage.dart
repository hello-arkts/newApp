
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../BaseKeepAliveState.dart';
import '../../IConstant.dart';
import '../../config/LanguageConfig.dart';


class InviteCodePage extends StatefulWidget {

  InviteCodePage();

  @override
  State<InviteCodePage> createState() => _InviteCodePageState();
}

class _InviteCodePageState extends BaseKeepAliveState<InviteCodePage> {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        leading: Container(),
        title: Text(LanguageConfig.get(LanguageConfigKeys.Login_input_invite_code_title),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(10.w, 0.w, 10.w, 20.w),
        child: Text(LanguageConfig.get(LanguageConfigKeys.Login_input_invite_code_content),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.w, color: IConstant.text_color)),
      ),
    );
  }

}
