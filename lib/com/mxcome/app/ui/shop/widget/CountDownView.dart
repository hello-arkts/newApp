
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';

import '../utils/Util.dart';

class CountDownView extends StatefulWidget {

  final String startTime;
  final String endTime;
  final double fontSize;
  final Color prefixColor;
  final Color textColor;
  final TextAlign textAlign;
  final String prefix;
  final String stop;
  final int timeType;
  Function? callBack;

  CountDownView({
    required this.startTime,
    required this.endTime,
    this.fontSize = 14,
    this.prefixColor = IConstant.text_color,
    this.textColor = IConstant.text_color,
    this.textAlign = TextAlign.left,
    this.prefix = "",
    this.stop = "",
    this.timeType = 0,
    this.callBack,
  });

  @override
  State<StatefulWidget> createState() {
    return _CountDownViewState();
  }
}

class _CountDownViewState extends State<CountDownView> {
  // 用来在布局中显示相应的剩余时间
  String remainTime = '';
  Timer? _timer;
  int diffTime = 0;

  @override
  void initState() {
    super.initState();
    if (TextUtils.isNotEmpty(widget.startTime) && TextUtils.isNotEmpty(widget.endTime)) {
      // 初始化的时候开启倒计时
      startCountDown(widget.startTime, widget.endTime);
    }
  }

  @override
  void dispose() {
    super.dispose();
    // 在页面回收或滑动复用回收的时候一定要把 timer 清除
    if (_timer != null) {
      if (_timer!.isActive) {
        _timer!.cancel();
        _timer = null;
      }
    }
  }

  @override
  void didUpdateWidget(CountDownView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 外部重新请求接口后重新进行倒计时，这个方法是用来监控外部setState的
    if (TextUtils.isNotEmpty(widget.startTime) && TextUtils.isNotEmpty(widget.endTime)) {
      startCountDown(widget.startTime, widget.endTime);
    }
  }

  void startCountDown(String startTime, String endTime) {
    bool timeout = isTimeout(startTime, endTime);
    //超时回调
    if (timeout) {
      setState(() {
        remainTime = widget.stop;
      });
      if (widget.callBack != null) {
        widget.callBack?.call();
      }
      return;
    }
    // 重新计时的时候要把之前的清除掉
    if (_timer != null) {
      if (_timer!.isActive) {
        _timer!.cancel();
        _timer = null;
      }
    }

    const repeatPeriod = Duration(milliseconds: 1000);
    var createTime = DateTime.parse(startTime);
    var finishTime = DateTime.parse(endTime);
    diffTime = finishTime.difference(createTime).inSeconds;
    calculateTime(createTime, createTime.add(Duration(seconds: diffTime)));

    _timer = Timer.periodic(repeatPeriod, (timer) {
      if (diffTime < 1) {
        //取消定时器，避免无限回调
        timer.cancel();
        //超时回调
        setState(() {
          remainTime = widget.stop;
        });
        if (widget.callBack != null) {
          widget.callBack?.call();
        }
        return;
      }
      diffTime --;
      calculateTime(createTime, createTime.add(Duration(seconds: diffTime)));
    });
  }

  isTimeout(String startTime, String endTime) {
    var createTime = DateTime.parse(startTime);
    var finishTime = DateTime.parse(endTime);
    diffTime = finishTime.difference(createTime).inSeconds;
    return diffTime < 1;
  }

  /// 计算天数、小时、分钟、秒
  void calculateTime(startTime, endTime) {
    var surplus = endTime.difference(startTime);
    int day = (surplus.inSeconds ~/ 3600) ~/ 24;
    int hour = (surplus.inSeconds ~/ 3600) % 24;
    int minute = surplus.inSeconds % 3600 ~/ 60;
    int second = surplus.inSeconds % 60;

    var str = '';
    if (day > 0) {
      str = '$day${LanguageConfig.get(LanguageConfigKeys.Shop_pocket_days)}';
    }
    if (hour > 0 || (day > 0 && hour == 0)) {
      if (hour < 10) {
        str = "${str}0";
      }
      str = "$str$hour:";
    }
    if (minute < 10) {
      str = "${str}0";
    }
    str = "$str$minute:";
    if (second < 10) {
      str = "${str}0";
    }
    str = "$str$second";
    setState(() {
      remainTime = str;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RichText(maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: widget.textAlign, text: TextSpan(children: [
      TextSpan(text: getPrefixText(), style: TextStyle(fontSize: widget.fontSize, color: widget.prefixColor)),
      TextSpan(text: remainTime, style: TextStyle(fontSize: widget.fontSize, color: widget.textColor)),
    ]));
  }

  bool isShop() {
    return remainTime == widget.stop;
  }

  String getPrefixText() {
    if (remainTime == widget.stop) {
      return "";
    } else {
      return "${widget.prefix} ";
    }
  }

}

