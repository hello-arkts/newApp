
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';

import 'KeyboardItem.dart';

class PasswordKeyboard extends StatefulWidget {


  Function(BuildContext context, String item) callBack;

  PasswordKeyboard(this.callBack);

  @override
  State<StatefulWidget> createState() {
    return PasswordKeyboardState();
  }
}

class PasswordKeyboardState extends State<PasswordKeyboard> {
  
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var backMethod;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _scaffoldKey,
      width: double.infinity,
      height: 210.w,
      color: IConstant.line_color,
      margin: EdgeInsets.only(bottom: 16.w),
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  KeyboardItem(text: '1', onTap: () => {
                    widget.callBack(context, "1")
                  }),
                  KeyboardItem(text: '2', onTap: () => {
                    widget.callBack(context, "2")
                  }),
                  KeyboardItem(text: '3', onTap: () => {
                    widget.callBack(context, "3")
                  }),
                ],
              ),
              Row(
                children: <Widget>[
                  KeyboardItem(text: '4', onTap: () => {
                    widget.callBack(context, "4")
                  }),
                  KeyboardItem(text: '5', onTap: () => {
                    widget.callBack(context, "5")
                  }),
                  KeyboardItem(text: '6', onTap: () => {
                    widget..callBack(context, "6")
                  }),
                ],
              ),
              Row(
                children: <Widget>[
                  KeyboardItem(text: '7', onTap: () => {
                    widget.callBack(context, "7")
                  }),
                  KeyboardItem(text: '8', onTap: () => {
                    widget.callBack(context, "8")
                  }),
                  KeyboardItem(text: '9', onTap: () => {
                    widget.callBack(context, "9")
                  }),
                ],
              ),
              Row(
                children: <Widget>[
                  KeyboardItem(text: "⌫", onTap: () => {
                    widget.callBack(context, "del")
                  }),
                  KeyboardItem(text: '0', onTap: () => {
                    widget.callBack(context, "0")
                  }),
                  Expanded(child: Container())
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
