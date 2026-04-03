import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';

typedef OnTap = Function();

class KeyboardItem extends StatefulWidget {

  final String text;
  final OnTap onTap;

  KeyboardItem(
      {
        required this.text,
        required this.onTap,
        super.key
      });

  @override
  State<StatefulWidget> createState() {
    return KeyboardItemState();
  }

}

class KeyboardItemState extends State<KeyboardItem> {
  MaterialStateProperty<Color> createTextButtonColor() {
    return MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.pressed)) {
        return IConstant.default_select_color;
      } else if (states.contains(MaterialState.disabled)) {
        return IConstant.white_color;
      }
      return IConstant.white_color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      margin: EdgeInsets.all(1.w),
      height: 50.w,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: createTextButtonColor(),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.w))),
        ),
        onPressed: () {
          widget.onTap();
        },
        child: Text(
          widget.text,
          style: TextStyle(fontSize: 18.sp, color: IConstant.text_color),
        ),
      ),
    ));
  }
}
