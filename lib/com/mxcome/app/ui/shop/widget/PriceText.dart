import 'package:flutter/material.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';

class PriceText extends StatefulWidget {
  double price = 0.00;
  TextAlign textAlign;
  FontWeight fontWeight;
  final double fontSize;
  Color color;
  bool isFormat = true;
  int fixed;

  PriceText(this.price,
      {super.key,
      this.fontSize = 16,
      this.fontWeight = FontWeight.normal,
      this.color = IConstant.main_color,
      this.textAlign = TextAlign.start,
      this.isFormat = true,
      this.fixed = 2});

  @override
  State<StatefulWidget> createState() {
    return PriceTextState();
  }
}

class PriceTextState extends State<PriceText> {
  @override
  Widget build(BuildContext context) {

    return Text(
      widget.isFormat ? FormatUtil.price2String(widget.price, fixed: widget.fixed) : widget.price.toStringAsFixed(2),
      textAlign: widget.textAlign,
      style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
          color: widget.color),
    );
  }
}
