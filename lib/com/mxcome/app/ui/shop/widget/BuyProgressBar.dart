import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/Logger.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';

class BuyProgressBar extends StatefulWidget {

  int progress = 0;
  Color color;

  BuyProgressBar({required this.progress, required this.color});

  @override
  State<StatefulWidget> createState() {
    return BuyProgressBarState();
  }
}

class BuyProgressBarState extends State<BuyProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.circle, size: 8.w, color: getLevelColor(0)),
        Icon(Icons.circle, size: 8.w, color: getLevelColor(1)),
        Icon(Icons.circle, size: 8.w, color: getLevelColor(2)),
        Icon(Icons.circle, size: 8.w, color: getLevelColor(3)),
        Icon(Icons.circle, size: 8.w, color: getLevelColor(4)),
        Icon(Icons.circle, size: 8.w, color: getLevelColor(5)),
        Icon(Icons.circle, size: 8.w, color: getLevelColor(6)),
        Icon(Icons.circle, size: 8.w, color: getLevelColor(7)),
        Icon(Icons.circle, size: 8.w, color: getLevelColor(8)),
        Icon(Icons.circle, size: 8.w, color: getLevelColor(9)),
      ],
    );
  }

  Color getLevelColor(int index) {
    if (index < widget.progress) {
      return widget.color;
    } else {
      return IConstant.line_color;
    }
  }
}
