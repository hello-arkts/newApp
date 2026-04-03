
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/SmallTextButton.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';


import '../ui/shop/widget/OutlineTextButton.dart';

class ViewUtils {
  //显示提示信息
  static displayToast(String str) {
    if (TextUtils.isEmpty(str)) return;
    EasyLoading.showToast(str);
  }

  //显示提示信息
  static showToastShort(String str) {
    if (TextUtils.isEmpty(str)) return;
    EasyLoading.showToast(str, duration: const Duration(seconds: 3));
  }

  //显示提示信息
  static showToastLong(String str) {
    if (TextUtils.isEmpty(str)) return;
    EasyLoading.showToast(str, duration: const Duration(seconds: 5));
  }

  static show() {
    EasyLoading.show(
      dismissOnTap: false,
      maskType: EasyLoadingMaskType.none,
      indicator: Container(
        width: 50.w,
        height: 50.w,
        color: Colors.transparent,
        child: SpinKitFadingCircle(color: IConstant.main_color, size: 50.w,),
      )
    );
  }

  static dismiss() {
    EasyLoading.dismiss();
  }

  //创建询问弹窗
  static showConfirmDialog(BuildContext context, String title,
      Function(BuildContext context, bool bl) callBack) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(child: Container(
            color: Colors.white,
            width: 300.w,
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 40.w,
                ),
                Padding(padding: EdgeInsets.only(left: 16.w, right: 16.w),
                    child: Text(title, style: TextStyle(color:IConstant.text_color, fontSize: 14.sp),
                ),),
                SizedBox(
                  height: 40.w,
                ),
                Container(
                  height: 1.w,
                  color: IConstant.line_color,
                ),
                SizedBox(
                  height: 50.w,
                  child: Row(
                    children: [
                      Expanded(
                          child: InkWell(
                        child: Center(
                          child: Text(
                            LanguageConfig.get(
                                LanguageConfigKeys.ViewUtils_cancel),
                            style: TextStyle(
                                color: IConstant.title_color, fontSize: 14.sp),
                          ),
                        ),
                        onTap: () {
                          callBack(context, false);
                        },
                      )),
                      Container(
                        width: 1.w,
                        color: IConstant.line_color,
                      ),
                      Expanded(
                          child: InkWell(
                        child: Container(
                          color: IConstant.main_color,
                          child: Center(
                            child: Text(
                              LanguageConfig.get(
                                  LanguageConfigKeys.ViewUtils_confirm),
                              style: TextStyle(
                                  color: IConstant.white_color, fontSize: 14.sp),
                            ),
                          ),
                        ),
                        onTap: () {
                          callBack(context, true);
                        },
                      ))
                    ],
                  ),
                )
              ],
            ),
          ));
        });
  }

  //创建提示弹窗
  static showRemindDialog(BuildContext context, String title, String content, String remindText,
      Function(BuildContext context) callBack, {bool barrierDismissible = false}) {
    showDialog(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (BuildContext context) {
          return Dialog(child: Container(
            color: Colors.white,
            width: 300.w,
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 300.w,
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
                      child: Text(title, style: TextStyle(color:IConstant.text_color, fontSize: 15.sp),
                      ),
                    ),
                    Positioned(top: 10.w, right: 10.w, child: InkWell(
                      onTap: () {
                        callBack(context);
                      },
                      child: Icon(Icons.close, size: 22.w, color: IConstant.sub_text_color,),
                    ))
                  ],
                ),
                // Container(
                //   height: 1.w,
                //   color: IConstant.line_color,
                // ),
                SizedBox(
                  height: 40.w,
                ),
                Padding(padding: EdgeInsets.only(left: 16.w, right: 16.w),
                  child: Text(content, style: TextStyle(color:IConstant.text_color, fontSize: 14.sp),
                  ),),
                SizedBox(
                  height: 40.w,
                ),
                // Container(
                //   height: 1.w,
                //   color: IConstant.line_color,
                // ),
                Container(
                  width: 150.w,
                  margin: EdgeInsets.fromLTRB(16.w, 14.w, 16.w, 14.w),
                  child: OutlineTextButton(text: remindText, fontSize: 15.sp, onTap: () {
                    callBack(context);
                  }),
                )
              ],
            ),
          ));
        });
  }

  //创建提示弹窗
  static showCustomDialog(BuildContext context,
      String title,
      Widget content,
      String remindText,
      Function(BuildContext context, DialogEvent dialogEvent) callBack) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(child: Container(
            color: Colors.white,
            width: 300.w,
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 300.w,
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
                      child: Text(title, style: TextStyle(color:IConstant.text_color, fontSize: 15.sp),
                      ),
                    ),
                    Positioned(top: 10.w, right: 10.w, child: InkWell(
                      onTap: () {
                        callBack(context, DialogEvent.close);
                      },
                      child: Icon(Icons.close, size: 22.w, color: IConstant.sub_text_color,),
                    ))
                  ],
                ),
                // Container(
                //   height: 1.w,
                //   color: IConstant.line_color,
                // ),
                SizedBox(
                  height: 40.w,
                ),
                Padding(padding: EdgeInsets.only(left: 16.w, right: 16.w),
                  child: content),
                SizedBox(
                  height: 40.w,
                ),
                // Container(
                //   height: 1.w,
                //   color: IConstant.line_color,
                // ),
                Container(
                  width: 150.w,
                  margin: EdgeInsets.fromLTRB(16.w, 14.w, 16.w, 14.w),
                  child: OutlineTextButton(text: remindText, bgColor: IConstant.red_bg_color3, fontSize: 15.sp, onTap: () {
                    callBack(context, DialogEvent.confirm);
                  }),
                )
              ],
            ),
          ));
        });
  }

  //创建提示弹窗
  static showRemindDialog2(
      BuildContext context,
      String title,
      String content,
      String cancel,
      String confirm,
      Function(BuildContext context, DialogEvent dialogEvent) callBack) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(child: Container(
            color: Colors.white,
            width: 300.w,
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 300.w,
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(25.w, 10.w, 25.w, 10.w),
                      child: Text(title, style: TextStyle(color:IConstant.text_color, fontWeight: FontWeight.bold, fontSize: 15.sp),
                      ),
                    ),
                    Positioned(top: 10.w, right: 10.w, child: InkWell(
                      onTap: () {
                        callBack(context, DialogEvent.close);
                      },
                      child: Icon(Icons.close, size: 22.w, color: IConstant.sub_text_color,),
                    ))
                  ],
                ),
                // Container(
                //   height: 1.w,
                //   color: IConstant.line_color,
                // ),
                SizedBox(
                  height: 40.w,
                ),
                Padding(padding: EdgeInsets.only(left: 16.w, right: 16.w),
                  child: Text(content, textAlign: TextAlign.center, style: TextStyle(color:IConstant.text_color, fontSize: 14.sp),
                  ),),
                SizedBox(
                  height: 40.w,
                ),
                // Container(
                //   height: 1.w,
                //   color: IConstant.line_color,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 110.w,
                      margin: EdgeInsets.fromLTRB(16.w, 14.w, 16.w, 14.w),
                      child: OutlineTextButton(text: cancel, fontSize: 15.sp, onTap: () {
                        callBack(context, DialogEvent.cancel);
                      }),
                    ),
                    Container(
                      width: 110.w,
                      margin: EdgeInsets.fromLTRB(0.w, 14.w, 16.w, 14.w),
                      child: SmallTextButton(text: confirm, fontSize: 15.sp, onTap: () {
                        callBack(context, DialogEvent.confirm);
                      }),
                    )
                  ],
                )
              ],
            ),
          ));
        });
  }

  //创建提示弹窗
  static showCustomDialog2(
      BuildContext context,
      String title, Widget content,
      String cancel, String confirm,
      Function(BuildContext context, DialogEvent dialogEvent) callBack) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(child: Container(
            color: Colors.white,
            width: 300.w,
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 300.w,
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
                      child: Text(title, style: TextStyle(color:IConstant.text_color, fontSize: 15.sp),
                      ),
                    ),
                    Positioned(top: 10.w, right: 10.w, child: InkWell(
                      onTap: () {
                        callBack(context, DialogEvent.close);
                      },
                      child: Icon(Icons.close, size: 22.w, color: IConstant.sub_text_color,),
                    ))
                  ],
                ),
                // Container(
                //   height: 1.w,
                //   color: IConstant.line_color,
                // ),
                SizedBox(
                  height: 40.w,
                ),
                Padding(padding: EdgeInsets.only(left: 16.w, right: 16.w),
                  child: content),
                SizedBox(
                  height: 40.w,
                ),
                // Container(
                //   height: 1.w,
                //   color: IConstant.line_color,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 110.w,
                      margin: EdgeInsets.fromLTRB(16.w, 14.w, 16.w, 14.w),
                      child: OutlineTextButton(text: cancel, fontSize: 15.sp, onTap: () {
                        callBack(context, DialogEvent.cancel);
                      }),
                    ),
                    Container(
                      width: 110.w,
                      margin: EdgeInsets.fromLTRB(0.w, 14.w, 16.w, 14.w),
                      child: SmallTextButton(text: confirm, fontSize: 15.sp, onTap: () {
                        callBack(context, DialogEvent.confirm);
                      }),
                    )
                  ],
                )
              ],
            ),
          ));
        });
  }

  //创建扩张区域
  static buildExpande() {
    return const Expanded(
      child: SizedBox(),
    );
  }

  //没有数据
  static buildNoData() {
    return Center(
        child: Text(LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_data),
            style: TextStyle(color: Color(0xff999999), fontSize: 14.sp)));
  }

  //没有更多
  static buildNoMore() {
    return Center(
      child: Text(LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_more),
        style: TextStyle(fontSize: 12.sp, color: Color(0xff333333)),
      ),
    );
  }

  //加载更多
  static buildLoadMore() {
    return buildLoading();
  }

  //正在加载
  static buildLoading() {
    return Center(
      child: SizedBox(
        width: 50.w,
        height: 50.w,
        child: SpinKitFadingCircle(color: IConstant.main_color, size: 50.w,),
      ),
    );
  }

  //重试
  static buildRetry(callBack) {
    return ElevatedButton(
      child: Text(
        LanguageConfig.get(LanguageConfigKeys.ViewUtils_retry),
        style: TextStyle(fontSize: 16.sp, color: Color(0xffff0000)),
      ),
      onPressed: () {
        callBack();
      },
    );
  }

  static _buildBackBtn(callBack, Widget icon) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: callBack,
      child: Center(
        child: icon,
      ),
    );
  }

  //返回按钮
  static buildBackBtn(callBack) {
    return _buildBackBtn(callBack,
        Icon(Icons.arrow_back, size: 24.w, color: IConstant.text_color));
  }

  static buildBackLightBtn(callBack) {
    return _buildBackBtn(
        callBack,
        Icon(Icons.arrow_back_ios_new,
            size: 24.w, color: IConstant.text_color));
  }

  static buildTextEditingController(String str, { Function(String text)? listener }){
    TextEditingController controller = TextEditingController.fromValue(TextEditingValue(
        text: str,
        selection: TextSelection.fromPosition(TextPosition(offset: str.length))));
    if (listener != null) {
      controller.addListener(() {
        listener(controller.text.trimLeft());
      });
    }
    return controller;
  }

}

enum DialogEvent{ close, cancel, confirm }