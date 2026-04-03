import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
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
import '../utils/EventBusUtil.dart';
import '../widget/GenAvatar.dart';
import 'SearchDelegateBar.dart';

class SearchBar extends AppBar {

  @override
  State<SearchBar> createState() => _SearchBarState();

}

class _SearchBarState extends BaseKeepAliveState<SearchBar> {

  bool isLogin = false;

  dynamic userInfoEvent;

  dynamic cartEvent;

  int cartNumber = 0;

  String? _avatar;

  @override
  void initState() {
    super.initState();
    userInfoEvent = EventBusUtil.getInstance().on<UserInfoEvent>((event) {
      if (event.userInfoStatus == UserInfoStatus.complete) {
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
        _avatar = BaseModel.getString(data, "icon");
        isLogin = loginState;
        cartNumber = cartList.length;
      });
    } else {
      setState(() {
        _avatar = null;
        isLogin = false;
        cartNumber = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppBar(
      elevation: 0.w,
      leading: buildLeading(),
      title: Image.asset("assets/icons/pocket_title.jpg"),
      actions: <Widget>[
        InkWell(
          onTap: () {
            showSearch(context: context, delegate: SearchDelegateBar());
          },
          child: Center(
            child: Container(
                width: 40.w,
                height: 40.w,
                margin: EdgeInsets.all(5.w),
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                    color: IConstant.white_bg_color,
                    borderRadius: BorderRadius.all(Radius.circular(40.w))),
                child: Image.asset("assets/icons/search.png",
                    width: 22.w, height: 22.w, color: IConstant.text_color)),
          ),
        ),
        buildCart()
      ],
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

  Widget buildAvatar() {
    if (isLogin && TextUtils.isNotEmpty(_avatar)) {
      return ClipOval(
          child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: GenAvatar(_avatar!)));
    } else {
      return ClipOval(
          child: Container(
              width: double.infinity,
              height: double.infinity,
              color: IConstant.white_bg_color,
              child: Center(
                  child: Icon(Icons.menu,
                      size: 25.w,
                      color: IConstant.text_color))));
    }
  }
}
