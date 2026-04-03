import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/HomeEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/grow/SignPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/LoadImageView.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/AppUtils.dart';
import '../cart/CartBadge.dart';
import '../cart/CartPage.dart';
import '../event/CartEvent.dart';
import '../event/OpenMenuEvent.dart';
import '../event/UserInfoEvent.dart';
import '../message/MessageCenterPage.dart';
import '../product/ProductAdvertise.dart';
import '../search/SearchDelegateBar.dart';
import '../utils/EventBusUtil.dart';
import '../widget/GenAvatar.dart';

class GrowHeaderBar extends StatefulWidget {

  GrowHeaderBar();

  @override
  State<GrowHeaderBar> createState() => _GrowHeaderBarState();

}

class _GrowHeaderBarState extends BaseKeepAliveState<GrowHeaderBar> {

  dynamic userInfo;

  bool isLogin = false;

  List<dynamic> advertiseList = [];

  dynamic userInfoEvent;

  dynamic homeEvent;

  dynamic cartEvent;

  int cartNumber = 0;

  @override
  void initState() {
    super.initState();
    userInfoEvent = EventBusUtil.getInstance().on<UserInfoEvent>((event) {
      if (event.userInfoStatus == UserInfoStatus.complete) {
        loadContentDatas();
      }
    });
    homeEvent = EventBusUtil.getInstance().on<HomeEvent>((event) {
      if (event.homeType == HomeType.complete) {
        loadContentDatas();
      }
    });
    cartEvent = EventBusUtil.getInstance().on<CartEvent>((event) {
      if (event.cartType == CartType.complete) {
        loadContentDatas();
      }
    });
    loadContentDatas();
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(userInfoEvent);
    EventBusUtil.getInstance().off(homeEvent);
    EventBusUtil.getInstance().off(cartEvent);
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    bool loginState = await AppUtils.isLogined();
    if (loginState) {
      dynamic data = await AppUtils.getUserInfo();
      List<dynamic> cartList = await AppUtils.getCartData();
      setState(() {
        userInfo = data;
        isLogin = loginState;
        cartNumber = cartList.length;
      });
    } else {
      setState(() {
        userInfo = null;
        isLogin = false;
        cartNumber = 0;
      });
    }
    dynamic data = await AppUtils.getHomeData();
    setState(() {
      advertiseList = BaseModel.getDynamic(data, "advertiseList");
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SliverAppBar(
      backgroundColor: IConstant.white_color,
      elevation: 0.w,
      leading: Container(),
      actions: [
        InkWell(
          onTap: () {
            showPop(0.6 * Adapt.getWindowHeight(), SignPage());
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
            child: Image.asset("assets/icons/calendar.png"),
          ),
        ),
      ],
      pinned: true,
      //固定标题栏
      expandedHeight: 270.w - statusBarHeight,
      //显示的高度
      flexibleSpace: FlexibleSpaceBar(
        background: ProductAdvertise(advertiseList: advertiseList),
      ),
    );
  }

  Widget buildLeading() {
    return InkWell(
        onTap: () {
          EventBusUtil.getInstance().emit(OpenMenuEvent());
        },
        child: Container(margin: EdgeInsets.all(2.w), child: buildAvatar()));
  }

  Widget buildCart() {
    return InkWell(
        onTap: () {
          goCartIsLogin();
        },
        child: Center(
          child: Container(
            width: 40.w,
            height: 40.w,
            margin: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
                color: IConstant.grey_bg_color,
                borderRadius: BorderRadius.all(Radius.circular(40.w))),
            child: CartBadge(cartNumber: cartNumber),
          )),
        );
  }

  goCartIsLogin() async {
    bool isLogin = await AppUtils.isLogined();
    if (isLogin) {
      openCart();
    } else {
      toLogin((ctx) => {
        setState(() {
          finishContext(ctx);
          openCart();
        })
      });
    }
  }

  void openCart(){
    showPop(0.9 * Adapt.getWindowHeight(), CartPage(fromDetail: true));
  }

  String getDisplayName() {
    String nickname = BaseModel.getString(userInfo, "nickname");
    String username = BaseModel.getString(userInfo, "username");
    String phoneCode = BaseModel.getString(userInfo, "phoneCode");
    String phone = BaseModel.getString(userInfo, "phone");
    return TextUtils.isNotEmpty(nickname) ? nickname: "$phoneCode $phone";
  }

  Widget buildAvatar() {
    if (isLogin && userInfo != null) {
      String avatar = BaseModel.getString(userInfo, "icon");
      if (TextUtils.isNotEmpty(avatar)) {
        return ClipOval(
            child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: GenAvatar(avatar)));
      } else {
        String displayName = getDisplayName();
        return ClipOval(
            child: Container(
                width: double.infinity,
                height: double.infinity,
                color: IConstant.white_translucent_color4,
                child: Center(
                    child: Text(TextUtils.isNotEmpty(displayName) ? displayName.substring(0, 1) : "",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20.sp, color: IConstant.text_color)))));
      }
    } else {
      return ClipOval(
          child: Container(
              width: double.infinity,
              height: double.infinity,
              color: IConstant.white_translucent_color4,
              child: Center(
                  child: Icon(Icons.menu,
                      size: 25.w,
                      color: IConstant.text_color))));
    }
  }
}
