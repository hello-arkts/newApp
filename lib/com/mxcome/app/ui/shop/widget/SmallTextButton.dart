import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';

typedef OnTap = Function();

class SmallTextButton extends StatefulWidget {

  String text = "";
  OnTap onTap;
  double fontSize;
  final Color bgColor;
  final Color textColor;
  double left;
  double right;
  double top;
  double bottom;
  bool enable;

  SmallTextButton(
      {
        required this.text,
        required this.onTap,
        this.fontSize = 13,
        this.bgColor = IConstant.main_color,
        this.textColor = IConstant.white_color,
        this.left = 14,
        this.right = 14,
        this.top = 0,
        this.bottom = 0,
        this.enable = true
      });

  @override
  State<StatefulWidget> createState() {
    return SmallTextButtonState();
  }
}

class SmallTextButtonState extends State<SmallTextButton> {
  MaterialStateProperty<Color> createTextButtonColor() {
    return MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.pressed)) {
        return widget.enable ? widget.bgColor : IConstant.grey_bg_color;
      } else if (states.contains(MaterialState.disabled)) {
        return widget.enable ? widget.bgColor : IConstant.grey_bg_color;
      }
      return widget.enable ? widget.bgColor : IConstant.grey_bg_color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(widget.left.w, widget.top.w, widget.right.w, widget.bottom.w)),
        backgroundColor: createTextButtonColor(),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w))),
      ),
      onPressed: () {
        if (widget.enable) {
          widget.onTap();
        }
      },
      child: Text(
        widget.text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: widget.fontSize, color: widget.enable ? widget.textColor: IConstant.sub_text_color),
      ),
    );
  }
}
