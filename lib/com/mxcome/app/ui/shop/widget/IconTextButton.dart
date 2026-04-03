import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';

typedef OnTap = Function();

class IconTextButton extends StatefulWidget {

  Widget icon;
  String text = "";
  OnTap onTap;
  double fontSize;
  final Color bgColor;
  final Color textColor;
  double left;
  double right;
  double top;
  double bottom;

  IconTextButton(
      {
        required this.icon,
        required this.text,
        required this.onTap,
        this.fontSize = 12,
        this.bgColor = IConstant.main_color,
        this.textColor = IConstant.white_color,
        this.left = 12,
        this.right = 12,
        this.top = 0,
        this.bottom = 0,
        super.key
      });

  @override
  State<StatefulWidget> createState() {
    return IconTextButtonState();
  }
}

class IconTextButtonState extends State<IconTextButton> {

  MaterialStateProperty<Color> createTextButtonColor() {
    return MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.pressed)) {
        return widget.bgColor;
      } else if (states.contains(MaterialState.disabled)) {
        return widget.bgColor;
      }
      return widget.bgColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.text == LanguageConfig.get(LanguageConfigKeys.Shop_activity_completed_game)) {
      widget.left = 40;
      widget.right = 40;
    }
    return TextButton.icon(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(widget.left.w, widget.top.w, widget.right.w, widget.bottom.w)),
        backgroundColor: createTextButtonColor(),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w))),
      ),
      onPressed: () {
        widget.onTap();
      },
      icon: widget.text == LanguageConfig.get(LanguageConfigKeys.Shop_activity_completed_game) ? Container() : widget.icon,
      label: Text(
        widget.text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: widget.fontSize, color: widget.textColor),
      ),
    );
  }
}
