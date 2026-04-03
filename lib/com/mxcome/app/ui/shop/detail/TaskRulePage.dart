
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/LanguagePage.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';

class TaskRulePage extends StatefulWidget {

  TaskRulePage();

  @override
  State<TaskRulePage> createState() => _TaskRulePageState();
}

class _TaskRulePageState extends BaseKeepAliveState<TaskRulePage> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_rule_title),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color,fontWeight: FontWeight.bold),),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 0.w),
        child: ListView(
          children: [
            SizedBox(height: 15.w,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(text: TextSpan(text: "1. ", style: TextStyle(fontSize: 15.sp, color: IConstant.title_color),
                  children: [
                    TextSpan(text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_rule_tip1), style: TextStyle(fontSize: 15.sp,
                        fontWeight: FontWeight.bold, color: IConstant.title_color)),
                    WidgetSpan(child: SizedBox(width: 10.w)),
                    TextSpan(text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_rule_value_tip1), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
                  ]
                )),
                SizedBox(height: 10.w,),
                Container(
                  width: 120.w,
                  height: 1.w,
                  margin: EdgeInsets.only(left: 16.w),
                  color: const Color(0xFFD9D9D9),
                )
              ],
            ),
            SizedBox(height: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(text: TextSpan(text: "2. ", style: TextStyle(fontSize: 15.sp, color: IConstant.title_color),
                    children: [
                      TextSpan(text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_rule_tip2), style: TextStyle(fontSize: 15.sp,
                          fontWeight: FontWeight.bold, color: IConstant.title_color)),
                      WidgetSpan(child: SizedBox(width: 10.w)),
                      TextSpan(text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_rule_value_tip2), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
                    ]
                )),
                SizedBox(height: 10.w,),
                Container(
                  width: 135.w,
                  height: 1.w,
                  margin: EdgeInsets.only(left: 16.w),
                  color: const Color(0xFFD9D9D9),
                )
              ],
            ),
            SizedBox(height: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(text: TextSpan(text: "3. ", style: TextStyle(fontSize: 15.sp, color: IConstant.title_color),
                    children: [
                      TextSpan(text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_rule_tip3), style: TextStyle(fontSize: 15.sp,
                          fontWeight: FontWeight.bold, color: IConstant.title_color)),
                      WidgetSpan(child: SizedBox(width: 10.w)),
                      TextSpan(text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_rule_value_tip3), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
                    ]
                )),
                SizedBox(height: 10.w,),
                Container(
                  width: 135.w,
                  height: 1.w,
                  margin: EdgeInsets.only(left: 16.w),
                  color: const Color(0xFFD9D9D9),
                )
              ],
            ),
            SizedBox(height: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(text: TextSpan(text: "4. ", style: TextStyle(fontSize: 15.sp, color: IConstant.title_color),
                    children: [
                      TextSpan(text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_rule_tip4), style: TextStyle(fontSize: 15.sp,
                          fontWeight: FontWeight.bold, color: IConstant.title_color)),
                      WidgetSpan(child: SizedBox(width: 10.w)),
                      TextSpan(text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_rule_value_tip4), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
                    ]
                )),
                SizedBox(height: 10.w,),
                Container(
                  width: 90.w,
                  height: 1.w,
                  margin: EdgeInsets.only(left: 16.w),
                  color: const Color(0xFFD9D9D9),
                )
              ],
            ),
            SizedBox(height: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(text: TextSpan(text: "5. ", style: TextStyle(fontSize: 15.sp, color: IConstant.title_color),
                    children: [
                      TextSpan(text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_rule_tip5), style: TextStyle(fontSize: 15.sp,
                          fontWeight: FontWeight.bold, color: IConstant.title_color)),
                      WidgetSpan(child: SizedBox(width: 10.w)),
                      TextSpan(text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_rule_value_tip5), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
                    ]
                )),
                SizedBox(height: 10.w,),
                Container(
                  width: 60.w,
                  height: 1.w,
                  margin: EdgeInsets.only(left: 16.w),
                  color: const Color(0xFFD9D9D9),
                )
              ],
            ),
            SizedBox(height: 10.w),
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 RichText(text: TextSpan(text: "6. ", style: TextStyle(fontSize: 15.sp, color: IConstant.title_color),
                    children: [
                      TextSpan(text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_rule_tip6), style: TextStyle(fontSize: 15.sp,
                          fontWeight: FontWeight.bold, color: IConstant.title_color)),
                      WidgetSpan(child: SizedBox(width: 10.w)),
                      TextSpan(text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_rule_value_tip6), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
                    ])),
                 SizedBox(height: 10.w,),
                 Container(
                   width: 225.w,
                   height: 1.w,
                   margin: EdgeInsets.only(left: 16.w),
                   color: const Color(0xFFD9D9D9),
                 )
               ],
             ),
            SizedBox(height: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(text: TextSpan(text: "7. ", style: TextStyle(fontSize: 15.sp, color: IConstant.title_color),
                    children: [
                      TextSpan(text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_rule_tip7), style: TextStyle(fontSize: 15.sp,
                          fontWeight: FontWeight.bold, color: IConstant.title_color)),
                      WidgetSpan(child: SizedBox(width: 10.w)),
                      TextSpan(text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_rule_value_tip7), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
                    ]
                )),
                SizedBox(height: 10.w),
                Container(
                  width: 135.w,
                  height: 1.w,
                  margin: EdgeInsets.only(left: 16.w),
                  color: const Color(0xFFD9D9D9),
                )
              ],
            ),
            SizedBox(height: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(text: TextSpan(text: "8. ", style: TextStyle(fontSize: 15.sp, color: IConstant.title_color),
                    children: [
                      TextSpan(text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_rule_tip8), style: TextStyle(fontSize: 15.sp,
                          fontWeight: FontWeight.bold, color: IConstant.title_color)),
                      WidgetSpan(child: SizedBox(width: 10.w)),
                      TextSpan(text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_rule_value_tip8), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
                    ]
                )),
                SizedBox(height: 10.w),
                Container(
                  width: 60.w,
                  height: 1.w,
                  margin: EdgeInsets.only(left: 16.w),
                  color: const Color(0xFFD9D9D9),
                )
              ],
            ),
            SizedBox(height: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(text: TextSpan(text: "9. ", style: TextStyle(fontSize: 15.sp, color: IConstant.title_color),
                    children: [
                      TextSpan(text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_rule_tip9), style: TextStyle(fontSize: 15.sp,
                          fontWeight: FontWeight.bold, color: IConstant.title_color)),
                      WidgetSpan(child: SizedBox(width: 10.w)),
                      TextSpan(text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_rule_value_tip9), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
                    ]
                )),
                SizedBox(height: 10.w),
                Container(
                  width: 90.w,
                  height: 1.w,
                  margin: EdgeInsets.only(left: 16.w),
                  color: const Color(0xFFD9D9D9),
                )
              ],
            ),
            SizedBox(height: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(text: TextSpan(text: "10. ", style: TextStyle(fontSize: 15.sp, color: IConstant.title_color),
                    children: [
                      TextSpan(text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_rule_tip10), style: TextStyle(fontSize: 15.sp,
                          fontWeight: FontWeight.bold, color: IConstant.title_color)),
                      WidgetSpan(child: SizedBox(width: 10.w)),
                      TextSpan(text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_rule_value_tip10), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
                    ]
                )),
                SizedBox(height: 10.w),
                Container(
                  width: 190.w,
                  height: 1.w,
                  margin: EdgeInsets.only(left: 16.w),
                  color: const Color(0xFFD9D9D9),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

}
