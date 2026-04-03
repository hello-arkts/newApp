import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/BigTextButton.dart';
import 'package:mxcome/com/mxcome/app/utils/AppUtils.dart';

import '../../BaseKeepAliveState.dart';
import '../../config/LanguageConfig.dart';
import '../shop/event/LoginSuccessEvent.dart';
import '../shop/utils/EventBusUtil.dart';

class GuidePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return GuidePageState();
  }
}

class GuidePageState extends BaseKeepAliveState<GuidePage> {

  dynamic loginSuccessEvent;

  List<String> imageList = [
    "assets/back/banner_1.png",
    "assets/back/banner_2.png",
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  @override
  void initState() {
    super.initState();
    loginSuccessEvent = EventBusUtil.getInstance().on<LoginSuccessEvent>((event) async {
      await AppUtils.setToken(event.token);
      nextMainPage();
    });
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(loginSuccessEvent);
    super.dispose();
  }

  Widget buildBody() {
    return Stack(
      children: [
        Swiper(
          loop: true,
          autoplay: true,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.fromLTRB(16.w, 70.w, 16.w, 0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/icons/loading_top.png", width: 250.w),
                  Expanded(
                      child: Center(
                    child: Image.asset("assets/icons/loading_$index.png",
                        width: 300.w, height: 300.w),
                  )),
                  SizedBox(height: 70.w)
                ],
              ),
            );
          },
          itemCount: imageList.length,
          pagination: const SwiperPagination(
              builder: DotSwiperPaginationBuilder(
                color: IConstant.translucent_color,
                activeColor: IConstant.main_color,
              )),
          // pagination: SwiperPagination(
          //   margin: EdgeInsets.all(16.w),
          //   alignment: Alignment.bottomCenter,
          //   builder: FractionPaginationBuilder(
          //       color: IConstant.translucent_color,
          //       activeColor: IConstant.main_color,
          //       fontSize: 18.sp,
          //       activeFontSize: 25.sp),
          // ),
        ),
        Positioned(
            top: 70.w,
            right: 16.w,
            child: InkWell(
              onTap: () {
                onSuccess();
                nextMainPage();
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(12.w, 4.w, 12.w, 4.w),
                decoration: BoxDecoration(
                    color: IConstant.translucent_color,
                    border:
                        Border.all(color: IConstant.white_color, width: 1.w),
                    borderRadius: BorderRadius.all(Radius.circular(20.w))),
                child: Text(LanguageConfig.get(LanguageConfigKeys.Login_skip),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.sp, color: IConstant.white_color)),
              ),
            ))
      ],
    );
  }

  Widget buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 20.w),
        child: Row(
          children: [
            // Expanded(
            //     flex: 2,
            //     child: BigTextButton(
            //         onTap: () async {
            //           toRegister((ctx) => onSuccess());
            //         },
            //         text: LanguageConfig.get(
            //             LanguageConfigKeys.Login_register_new),
            //         bgColor: IConstant.red_bg_color3,
            //         textColor: IConstant.main_color)),
            // SizedBox(width: 16.w),
            Expanded(
                flex: 1,
                child: BigTextButton(
                    onTap: () {
                      toLogin((ctx) => onSuccess());
                    },
                    text: LanguageConfig.get(LanguageConfigKeys.Login_login))),
          ],
        ),
      ),
    );
  }

  Future<void> onSuccess() async {
    await AppUtils.setLoadGuide(true);
  }
}
