
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';

import '../../../BaseKeepAliveState.dart';
import 'SmallTextButton.dart';


class CommResultPage extends StatefulWidget {

  String title;
  Widget message;
  String btnText = "";

  Function(BuildContext ctx) callBack;

  CommResultPage({
    required this.title,
    required this.message,
    required this.callBack, this.btnText = ""});

  @override
  State<StatefulWidget> createState() {
    return CommResultPageState();
  }

}

class CommResultPageState extends BaseKeepAliveState<CommResultPage> {

  bool isSure = false;
  String btnText = "";

  @override
  void initState() {
    super.initState();
    if (TextUtils.isEmpty(widget.btnText)) {
      btnText = LanguageConfig.get(LanguageConfigKeys.ViewUtils_confirm);
    } else  {
      btnText = widget.btnText;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      body: Column(
        children: [
          SizedBox(height: 10.w),
          Text(widget.title,
              style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
          Expanded(child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Center(child: widget.message),
          ))
        ],
      ),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 100.w,
      elevation: 0.w,
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
        alignment: Alignment.center,
        child: SizedBox(
          width: 180.w,
          child: SmallTextButton(text: btnText, onTap: () {
            widget.callBack(context);
          }),
        ),
      ),
    );
  }

}
