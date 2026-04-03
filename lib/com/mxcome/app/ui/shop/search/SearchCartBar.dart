import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/CartEvent.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../utils/AppUtils.dart';
import '../event/OpenMenuEvent.dart';
import '../event/UserInfoEvent.dart';
import '../utils/EventBusUtil.dart';
import '../widget/GenAvatar.dart';
import 'SearchDelegateBar.dart';

class SearchCartBar extends AppBar {

  bool fromDetail = false;

  SearchCartBar({this.fromDetail = false});

  @override
  State<SearchCartBar> createState() => _SearchCartBarState();

}

class _SearchCartBarState extends BaseKeepAliveState<SearchCartBar> {

  dynamic userInfo;

  bool isLogin = false;

  dynamic userInfoEvent;

  @override
  void initState() {
    super.initState();
    userInfoEvent = EventBusUtil.getInstance().on<UserInfoEvent>((event) {
      if (event.userInfoStatus == UserInfoStatus.complete) {
        loadUserInfo();
      }
    });
    loadUserInfo();
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(userInfoEvent);
    super.dispose();
  }

  Future<void> loadUserInfo() async {
    bool loginState = await AppUtils.isLogined();
    if (loginState) {
      dynamic data = await AppUtils.getUserInfo();
      setState(() {
        userInfo = data;
        isLogin = loginState;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildAppBar();
  }

  Widget buildAppBar() {
    if(widget.fromDetail) {
      return AppBar(
        elevation: 0.w,
        leading: buildLeading(),
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_cart),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
        actions: <Widget>[
          InkWell(
            onTap: () {
              EventBusUtil.getInstance().emit(CartEvent(cartType: CartType.delete));
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
                  child: Icon(Icons.delete, size: 22.w, color: IConstant.text_color)),))
        ],
      );
    } else {
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
          InkWell(
            onTap: () {
              EventBusUtil.getInstance().emit(CartEvent(fromDetail: widget.fromDetail, cartType: CartType.delete));
            },
            child: Container(
                width: 40.w,
                height: 40.w,
                margin: EdgeInsets.all(5.w),
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                    color: IConstant.grey_bg_color,
                    borderRadius: BorderRadius.all(Radius.circular(40.w))),
                child: Icon(Icons.delete,size: 22.w, color: IConstant.text_color)),
          )
        ],
      );
    }
  }

  Widget? buildLeading() {
    if(widget.fromDetail) {
      return null;
    } else {
      return InkWell(
          onTap: () {
            EventBusUtil.getInstance().emit(OpenMenuEvent());
          },
          child: Container(margin: EdgeInsets.all(2.w), child: buildAvatar()));
    }
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
                color: IConstant.white_bg_color,
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
              color: IConstant.white_bg_color,
              child: Center(
                  child: Icon(Icons.menu,
                      size: 25.w,
                      color: IConstant.text_color))));
    }
  }
}
