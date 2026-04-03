import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/BigTextButton.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';

import '../../BaseKeepAliveState.dart';
import '../../config/LanguageConfig.dart';

class BetaCheckPage extends StatefulWidget {

  Function(BuildContext context) callBack;
  
  BetaCheckPage(this.callBack);

  @override
  State<StatefulWidget> createState() {
    return BetaCheckPageState();
  }
}

class BetaCheckPageState extends BaseKeepAliveState<BetaCheckPage> {

  String pwdText = '';

  bool clickEnable = false;

  // bool _onEditing = false;
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(20.w, 30.w, 20.w, 30.w),
          child: Text(LanguageConfig.get(LanguageConfigKeys.Login_input_invite_code),
               style: TextStyle(fontSize: 15.w, color: IConstant.text_color)),
        ),
        VerificationCode(
          margin: EdgeInsets.all(6.w),
          textStyle: TextStyle(fontSize: 20.w, color: IConstant.text_color),
          keyboardType: TextInputType.number,
          length: 4,
          fullBorder: true,
          fillColor: IConstant.white_bg_color,
          cursorColor: IConstant.blue_color,
          autofocus: true,
          onCompleted: (String value) {
            setState(() {
              pwdText = value;
              clickEnable = true;
            });
          },
          onEditing: (bool value) {
            setState(() {
              clickEnable = false;
            });
          },
        ),
        Container(
          margin: EdgeInsets.only(top: 30.w),
          width: 200.w,
          child: BigTextButton(text: LanguageConfig.get(LanguageConfigKeys.ViewUtils_confirm), enable: clickEnable, onTap: () async {
              if (pwdText == "9158") {
                widget.callBack(context);
              } else {
                ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Login_invite_code_error));
              }
          }),
        ),
        expandeSpace,
      ],
    );
  }

}
 