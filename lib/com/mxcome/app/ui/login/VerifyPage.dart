import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';
import 'package:mxcome/com/mxcome/app/utils/Adapt.dart';
import 'package:mxcome/com/mxcome/app/widget/SafeVerify.dart';

import '../../BaseKeepAliveState.dart';
import '../../utils/ViewUtils.dart';

class VerifyPage extends StatefulWidget {

  final Function lister;

  VerifyPage({required this.lister});

  @override
  _VerifyPageState createState() => _VerifyPageState();

}

class _VerifyPageState extends BaseKeepAliveState<VerifyPage> {

  final GlobalKey safeVerifyKey = GlobalKey();

  bool success = false;

  int randomX1 = 0;
  int randomY1 = 0;
  int randomX2 = 0;
  int randomY2 = 0;

  bool safeVerifyEnable = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final size = safeVerifyKey.currentContext!.size ?? Size.zero;
      double radius = 32.0;
      int maxX1 = FormatUtil.num2int(size.width - radius * 2.2);
      int maxY1 = 30;
      int maxX2 = FormatUtil.num2int(size.width - radius * 2.6);
      int maxY2 = FormatUtil.num2int(size.height * 0.3);
      getRandomXy(maxX1, maxY1, maxX2, maxY2);
    });
  }

  Future<void> getRandomXy(int maxX1, int maxY1, int maxX2, int maxY2) async {
    randomX1 = Random().nextInt(maxX1);
    randomY1 = Random().nextInt(maxY1);
    randomX2 = Random().nextInt(maxX2);
    randomY2 = Random().nextInt(maxY2);
    setState(() {
      safeVerifyEnable = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    /// 禁用侧滑
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.all(16.w),
          child: Column(
            children: [
              SizedBox(height: Adapt.getAppBarHeight() + 20.w),
              Text(LanguageConfig.get(LanguageConfigKeys.Verify_safe_verify),
                  style:
                      TextStyle(fontSize: 28.sp, color: IConstant.text_color)),
              SizedBox(height: 20.w),
              Text(LanguageConfig.get(LanguageConfigKeys.Verify_safe_verify_tip1),
                  style:
                      TextStyle(fontSize: 15.sp, color: IConstant.text_color)),
              SizedBox(height: 10.w),
              Text(LanguageConfig.get(LanguageConfigKeys.Verify_safe_verify_tip2),
                  style:
                      TextStyle(fontSize: 15.sp, color: IConstant.text_color)),
              SizedBox(height: 30.w),
              Expanded(
                key: safeVerifyKey,
                child: safeVerifyEnable
                    ? SafeVerity(randomX1, randomY1, randomX2, randomY2,
                        lister: (state) {
                          if (state) {
                            finishContext(context);
                            widget.lister(randomX1, randomY1, randomX2, randomY2);
                          }
                        })
                    : ViewUtils.buildLoading(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
