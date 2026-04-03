
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/OutlineTextButton.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../widget/SmallTextButton.dart';
import 'IDCardVerifiedPage.dart';

class IDCardVerifyingPage extends StatefulWidget {

  bool verifying;

  IDCardVerifyingPage({this.verifying = true});

  @override
  State<StatefulWidget> createState() {
    return IDCardVerifyingPageState();
  }

}

class IDCardVerifyingPageState extends BaseKeepAliveState<IDCardVerifyingPage> {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.5.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_verify_status),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.verifying ? Color(0xFFC3E5FF) : Color(0xFFFDEAEA),
                Color(0xFFFFFFFF),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.verifying ? LanguageConfig.get(LanguageConfigKeys.Shop_mine_verifying) :
              LanguageConfig.get(LanguageConfigKeys.Shop_mine_verify_failed),
                style: TextStyle(fontSize: 25.sp, color: IConstant.text_color)),
            SizedBox(height: 6.w),
            widget.verifying ? Card(
              elevation: 5.w,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(12.w),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
                child: Row(
                  children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_verify_status_tip1),
                            style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
                        Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_verify_status_tip2),
                            style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
                      ],
                    )),
                    Icon(Icons.check_circle, color: const Color(0xFFC3E5FF), size: 20.w),
                  ],
                ),
              ),
            ) :
            Card(
              elevation: 5.w,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(12.w),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_verify_failed_status_tip1),
                        style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
                    Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_verify_failed_status_tip2),
                        style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.w),
            Container(
              alignment: Alignment.center,
              child: widget.verifying ? Image.asset("assets/icons/verifying.png",
                  width: 320.w,
                  height: 320.w) : Image.asset("assets/icons/verify_failed.png",
                  width: 320.w,
                  height: 320.w),
            )
          ],
        ),
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
          child: buildButton(),
        ),
      ),
    );
  }

  Widget buildButton() {
    return widget.verifying ? OutlineTextButton(text: LanguageConfig.get(LanguageConfigKeys.ViewUtils_confirm), onTap: () {
      backHome();
    }) : OutlineTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_mine_verify_reapply), onTap: () {
      finishContext(context);
      nextPage(IDCardVerifiedPage(), false);
    });
  }

}
