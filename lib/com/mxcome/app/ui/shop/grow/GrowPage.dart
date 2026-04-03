import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/grow/GrowHeaderBar.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/promotion/RedStagePage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/SmallTextButton.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import '../../../model/BaseModel.dart';
import '../../../utils/AppUtils.dart';
import '../event/UserInfoEvent.dart';
import '../mine/promotion/PromotionPage.dart';
import '../utils/EventBusUtil.dart';

class GrowPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GrowPageState();
  }
}

class GrowPageState extends BaseKeepAliveState<GrowPage> {
  dynamic userInfo;

  bool isLogin = false;

  dynamic userInfoEvent;

  int redPower = 0;	//是否有红包闯关资格：0->否, 1->是，-1->永久失效

  @override
  void initState() {
    super.initState();
    userInfoEvent = EventBusUtil.getInstance().on<UserInfoEvent>((event) {
      if (event.userInfoStatus == UserInfoStatus.complete) {
        loadContentDatas();
      }
    });
    loadContentDatas();
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(userInfoEvent);
    super.dispose();
  }

  Future<void> _onRefresh() async {
    EventBusUtil.getInstance().emit(UserInfoEvent());
    await Future.delayed(const Duration(milliseconds: 800), () {});
  }

  @override
  Future<void> loadContentDatas() async {
    bool loginState = await AppUtils.isLogined();
    if (loginState) {
      dynamic data = await AppUtils.getUserInfo();
      setState(() {
        userInfo = data;
        redPower = BaseModel.getInt(data, "redPower");
        isLogin = loginState;

      });
    } else {
      setState(() {
        userInfo = null;
        redPower = 0;
        isLogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return EasyRefresh(
        header: const MaterialHeader(color: IConstant.main_color),
        onRefresh: () => _onRefresh(),
        child: MyCustomScrollView());
  }

  CustomScrollView MyCustomScrollView() {
    return CustomScrollView(
      slivers: <Widget>[
        GrowHeaderBar(),
        SliverList(delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return buildRedPocket();
        }, childCount: 1)),
      ],
    );
  }

  Widget buildRedPocket() {
    return Container(
      margin: EdgeInsets.fromLTRB(0.w, 10.w, 0.w, 10.w),
      padding: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 0.w),
      decoration: BoxDecoration(
          color: IConstant.white_color,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.w))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("有奖推广",
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: IConstant.text_color)),
          Container(
            margin: EdgeInsets.fromLTRB(0.w, 10.w, 0.w, 0.w),
            decoration: BoxDecoration(
              color: IConstant.red_bg_color3,
              borderRadius: BorderRadius.circular(10.w),
            ),
            padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
            child: Row(
              children: [
                Expanded(child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset("assets/icons/mxcome_icon.png", width: 30.w),
                        SizedBox(width: 10.w),
                        Text("红包闯关",
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.text_color)),
                        SizedBox(width: 10.w),
                        Image.asset("assets/icons/hot.png", width: 15.w),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(38.w, 0.w, 10.w, 0.w),
                      child: Text("已有0人获得฿111,000巨额红包奖励资格", maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                    )
                  ],
                )),
                SmallTextButton(text: "Go", onTap: () {
                  if (redPower == 1) {
                    nextPage(RedStagePage(), false);
                  } else {
                    ViewUtils.displayToast("未获得红包闯关资格");
                  }
                })
              ],
            ),
          )
        ],
      ),
    );
  }
}
