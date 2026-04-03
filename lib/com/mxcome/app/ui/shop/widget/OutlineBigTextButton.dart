import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';

typedef OnTap = Function();

class OutlineBigTextButton extends StatefulWidget {

  String text = "";
  OnTap onTap;
  double fontSize;
  final Color bgColor;
  final Color borderColor;
  final Color textColor;
  double left;
  double right;
  double top;
  double bottom;
  bool enable;

  OutlineBigTextButton(
      {
        required this.text,
        required this.onTap,
        this.fontSize = 16,
        this.bgColor = IConstant.main_color,
        this.borderColor = IConstant.main_color,
        this.textColor = IConstant.white_color,
        this.left = 16,
        this.right = 16,
        this.top = 10,
        this.bottom = 10,
        this.enable = true
      });

  @override
  State<StatefulWidget> createState() {
    return OutlineBigTextButtonState();
  }
}

class OutlineBigTextButtonState extends State<OutlineBigTextButton> {
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
    return OutlinedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(widget.left.w, widget.top.w, widget.right.w, widget.bottom.w)),
        backgroundColor: createTextButtonColor(),
        side: MaterialStateBorderSide.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return BorderSide(color: widget.enable ? widget.borderColor : IConstant.grey_bg_color, width: 1.w);
          } else if (states.contains(MaterialState.disabled)) {
            return BorderSide(color: widget.enable ? widget.borderColor : IConstant.grey_bg_color, width: 1.w);
          }
          return BorderSide(color: widget.enable ? widget.borderColor : IConstant.grey_bg_color, width: 1.w);
        }),
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
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: widget.fontSize, color: widget.enable ? widget.textColor: IConstant.sub_text_color),
      ),
    );
  }
}
