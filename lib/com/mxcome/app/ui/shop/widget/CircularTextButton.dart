import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';

typedef OnTap = Function();

class CircularTextButton extends StatefulWidget {

  String text = "";
  OnTap onTap;
  double fontSize;
  final Color bgColor;
  final Color textColor;

  CircularTextButton(
      {
        required this.text,
        required this.onTap,
        this.fontSize = 14,
        this.bgColor = IConstant.main_color,
        this.textColor = IConstant.white_color,
        super.key
      });

  @override
  State<StatefulWidget> createState() {
    return CircularTextButtonState();
  }
}

class CircularTextButtonState extends State<CircularTextButton> {
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
    return TextButton(
      style: ButtonStyle(
        backgroundColor: createTextButtonColor(),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.w))),
      ),
      onPressed: () {
        widget.onTap();
      },
      child: Text(
        widget.text,
        maxLines: 2,
        style: TextStyle(fontSize: widget.fontSize, color: widget.textColor),
      ),
    );
  }
}
