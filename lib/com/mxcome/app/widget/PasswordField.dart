import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {

  String text;

  PasswordField(this.text);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PasswordCustom(text),
    );
  }
}

class PasswordCustom extends CustomPainter {

  String text;

  PasswordCustom(this.text);

  @override
  void paint(Canvas canvas, Size size) {
    // 密码画笔
    Paint mPwdPaint;
    Paint mRectPaint;

    // 初始化密码画笔
    mPwdPaint = Paint();
    mPwdPaint.color = Colors.black;

    // 初始化密码框
    mRectPaint = Paint();
    mRectPaint.color = const Color(0xff707070);

    ///  圆角矩形的绘制
    RRect r = RRect.fromLTRBR(
        0.0, 0.0, size.width, size.height, Radius.circular(size.height / 12));

    ///  画笔的风格
    mRectPaint.style = PaintingStyle.stroke;
    canvas.drawRRect(r, mRectPaint);

    ///  将其分成六个 格子（六位支付密码）
    var per = size.width / 6.0;
    var offsetX = per;
    while (offsetX < size.width) {
      canvas.drawLine(
          Offset(offsetX, 0.0), Offset(offsetX, size.height), mRectPaint);
      offsetX += per;
    }

    ///  画实心圆
    var half = per / 2;
    var radio = per / 8;
    mPwdPaint.style = PaintingStyle.fill;

    ///  当前有几位密码，画几个实心圆
    for (int i = 0; i < text.length && i < 6; i++) {
      canvas.drawArc(Rect.fromLTRB(i * per + half - radio, size.height / 2 - radio,
              i * per + half + radio, size.height / 2 + radio),
          0.0,
          2 * pi,
          true,
          mPwdPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
