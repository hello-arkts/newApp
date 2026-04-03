import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';

typedef OnTap = Function();

class ExpandedOutlineText extends StatefulWidget {

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
  int flex = 1;

  ExpandedOutlineText(
      {
        required this.text,
        required this.onTap,
        this.fontSize = 13,
        this.bgColor = IConstant.red_bg_color,
        this.borderColor = IConstant.main_color,
        this.textColor = IConstant.main_color,
        this.left = 12,
        this.right = 12,
        this.top = 2,
        this.bottom = 2,
        this.flex = 1,
        super.key
      });

  @override
  State<StatefulWidget> createState() {
    return ExpandedOutlineTextState();
  }
}

class ExpandedOutlineTextState extends State<ExpandedOutlineText> {

  @override
  Widget build(BuildContext context) {
    return Expanded(flex: widget.flex, child: InkWell(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        height: 40.w,
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(6.w, 4.w, 6.w, 4.w),
        padding: EdgeInsets.fromLTRB(widget.left, widget.top, widget.right, widget.bottom),
        decoration: BoxDecoration(
            color: widget.bgColor,
            border: Border.all(width: 1, color: widget.borderColor),
            borderRadius: BorderRadius.circular(30.w)),
        child: Text(
          widget.text,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: widget.fontSize, color: widget.textColor),
        ),
      ),
    ));
  }
}
