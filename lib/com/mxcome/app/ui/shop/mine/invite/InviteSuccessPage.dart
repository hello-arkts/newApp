import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/ClipboardUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/Util.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/BigTextButton.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/SmallTextButton.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';

class InviteSuccessPage extends StatefulWidget {

  String nickName;

  InviteSuccessPage(this.nickName);

  @override
  State<InviteSuccessPage> createState() => _InviteSuccessPageState();
}

class _InviteSuccessPageState extends BaseKeepAliveState<InviteSuccessPage> {

  String allAmount = "";

  @override
  void initState() {
    super.initState();
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    //await InviteUtils.clearUserData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      body: Stack(
        children: [
          Positioned(left: 0.w, top: 0.w, right: 0.w, bottom: 0.w, child:  Column(
            children: [
              SizedBox(height: 60.w),
              Image.asset("assets/icons/invite_success.png", width: 50.w,),
              SizedBox(height: 25.w),
              Container(
                margin: EdgeInsets.only(left: 16.w, right: 16.w),
                child: Text(LanguageConfig.get(LanguageConfigKeys.Login_link_create_success),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.w, fontWeight: FontWeight.bold, color: IConstant.text_color)),
              ),
              SizedBox(height: 25.w),
              Container(
                margin: EdgeInsets.only(left: 16.w, right: 16.w),
                padding: EdgeInsets.fromLTRB(10.w, 4.w, 10.w, 4.w),
                decoration: BoxDecoration(
                  color: IConstant.line_color,
                  borderRadius: BorderRadius.all(Radius.circular(30.w)),
                ),
                child: Text(LanguageConfig.get(LanguageConfigKeys.Login_copy_link), textAlign: TextAlign.center, style: TextStyle(fontSize: 15.sp, color: IConstant.title_color))
              ),
              SizedBox(height: 50.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("mxcome.com/kol/${widget.nickName}", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.title_color)),
                  SizedBox(width: 6.w,),
                  InkWell(
                    onTap: () {
                      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_copy_success),);
                      copy();
                    },
                    child: Image.asset("assets/icons/kol_copy.png", width: 30.w,),
                  )
                ],
              )
            ]
          )),
        ],
      ),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Future<void> copy() async {
    String newUrl = Util.getShareKolURL(widget.nickName);
    ClipboardUtil.setDataToast(newUrl);
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      elevation: 0.w,
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 20.w),
        height: 50.w,
        alignment: Alignment.center,
        child: SizedBox(
          width: 180.w,
          child: SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_activity_lottery_complete), onTap: () {
            Navigator.of(context).pop();
          }),
        ),
      ),
    );
  }
}
