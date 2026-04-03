import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';

class LevelLayout extends StatefulWidget {

  int level = 0;

  LevelLayout(
      {
        required this.level
      });

  @override
  State<StatefulWidget> createState() {
    return LevelLayoutState();
  }
}

class LevelLayoutState extends State<LevelLayout> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("${LanguageConfig.get(LanguageConfigKeys.Shop_mine_member_level)}: Lv${widget.level}", style: TextStyle(fontSize: 12.sp, color: IConstant.text_color),),
        SizedBox(width: 4.w),
        Image.asset("assets/icons/level_1.png", width: 10.w,
            color: getLevelColor(0)),
        SizedBox(width: 2.w),
        Image.asset("assets/icons/level_2.png", width: 10.w,
            color: getLevelColor(1)),
        SizedBox(width: 2.w),
        Image.asset("assets/icons/level_3.png", width: 10.w,
            color: getLevelColor(2)),
        SizedBox(width: 2.w),
        Image.asset("assets/icons/level_4.png", width: 10.w,
            color: getLevelColor(3)),
        SizedBox(width: 2.w),
        Image.asset("assets/icons/level_5.png", width: 10.w,
            color: getLevelColor(4)),
        Expanded(child: Container()),
        Icon(Icons.chevron_right, size: 20.w, color: IConstant.sub_text_color)
      ],
    );
  }

  Color? getLevelColor(int index){
    if (index < widget.level) {
      return null;
    } else {
      return IConstant.line_color;
    }
  }
}
