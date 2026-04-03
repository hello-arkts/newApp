import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/Logger.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/CartEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/HomeEvent.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/AppUtils.dart';
import '../cart/CartBadge.dart';
import '../cart/CartPage.dart';
import '../event/OpenMenuEvent.dart';
import '../event/UserInfoEvent.dart';
import '../message/MessageCenterPage.dart';
import '../product/ProductAdvertise.dart';
import '../search/SearchDelegateBar.dart';
import '../utils/EventBusUtil.dart';
import '../widget/GenAvatar.dart';

class ProductHeaderBar extends StatefulWidget {

  bool innerBoxIsScrolled = false;

  ProductHeaderBar(this.innerBoxIsScrolled, {super.key});

  @override
  State<ProductHeaderBar> createState() => _ProductHeaderBarState();

}

class _ProductHeaderBarState extends BaseKeepAliveState<ProductHeaderBar> {

  bool isLogin = false;

  List<dynamic> advertiseList = [];

  dynamic userInfoEvent;

  dynamic homeEvent;

  dynamic cartEvent;

  bool _innerBoxIsScrolled = false;

  int cartNumber = 0;

  List<dynamic> categoryList = [];

  String? _avatar;

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

  void initData() {
    setState(() {
      _innerBoxIsScrolled = widget.innerBoxIsScrolled;
    });
  }

  @override
  void didUpdateWidget(covariant ProductHeaderBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    initData();
  }

  @override
  Future<void> loadContentDatas() async {
    bool loginState = await AppUtils.isLogined();
    if (loginState) {
      dynamic data = await AppUtils.getUserInfo();
      List<dynamic> cartList = await AppUtils.getCartData();
      Logger.info("------来来吗？");
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
    dynamic data = await AppUtils.getHomeData();
    setState(() {
      advertiseList = BaseModel.isNotEmpty(data, "advertiseList") ? BaseModel.getDynamic(data, "advertiseList") : [];
      categoryList = BaseModel.isNotEmpty(data, "productCategoriesList") ? BaseModel.getDynamic(data, "productCategoriesList") : [];
      categoryList.insert(0, {'name': 'Web3 wallet'});
      categoryList.insert(2, {'name': 'Monthly benefits'});
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SliverAppBar(
      backgroundColor: IConstant.white_color,
      elevation: 0.w,
      leading: buildLeading(),
      // title: buildTitle(),
      actions: buildActions(),
      pinned: true,
      //固定标题栏
      expandedHeight: 400.w - statusBarHeight,
      //显示的高度
      flexibleSpace: FlexibleSpaceBar(
        background: ProductAdvertise(advertiseList: advertiseList, categoryList: categoryList),
      ),
    );
  }

  Widget buildTitle() {
    if (_innerBoxIsScrolled) {
      return InkWell(
        onTap: () {
          showSearch(context: context, delegate: SearchDelegateBar());
        },
        child: Container(
          decoration: BoxDecoration(
              color: IConstant.grey_bg_color,
              borderRadius: BorderRadius.all(Radius.circular(40.w))),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 7.h, 0, 7.h),
            child: Row(children: [
              Image.asset("assets/icons/search.png",
                width: 18.w, height: 18.w, color: IConstant.text_color),
              Expanded(child: Padding(
                padding: EdgeInsets.only(left: 7.w),
                child: Text(
                  LanguageConfig.get(LanguageConfigKeys.Shop_product_search),
                  style: TextStyle(
                      fontSize: 15.w, color: IConstant.sub_text_color),
                ),
              )),
              // InkWell(
              //   onTap: () {
              //     showScanDialog();
              //   },
              //   child: Center(
              //       child: Container(
              //           margin: EdgeInsets.only(left: 5.w, right: 10.w),
              //           child: Image.asset("assets/icons/camera.png",
              //               width: 18.w, height: 18.w, color: IConstant.text_color),)),
              // ),
            ]),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  List<Widget> buildActions() {
    if(_innerBoxIsScrolled) {
      return [
        InkWell(
          onTap: () {
            //showSearch(context: context, delegate: SearchDelegateBar());
            if(isLogin) {
              showScanDialog();
            }else {
              toLogin((ctx1) => {
                setState(() {
                  finishContext(ctx1);
                })
              });
            }
          },
          child: Container(
              margin: EdgeInsets.fromLTRB(5.w, 10.w, 16.w, 10.w),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.w),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: IConstant.white_bg_color, width: 1.w),
                  borderRadius: BorderRadius.all(Radius.circular(17.w))),
              child: Image.asset("assets/icons/ic_home_scan.png",
                  width: 22.w, height: 22.w,)),
        )
      ];
    } else {
      return [
        buildCart()
      ];
    }
  }

  Widget buildMessage() {
    return InkWell(
      onTap: () {
        nextPage(MessageCenterPage(), false);
      },
      child: Center(
          child: Container(
              margin: EdgeInsets.only(left: 5.w, right: 5.w),
              child: ClipOval(
                  child: Container(
                      width: 40.w,
                      height: 40.w,
                      color: IConstant.grey_bg_color,
                      child: Center(
                          child: Image.asset("assets/icons/bell.png",
                              width: 22.w, height: 22.w, color: IConstant.text_color)))))),
    );
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

  Widget buildLeading() {
    return InkWell(
        onTap: () {
          EventBusUtil.getInstance().emit(OpenMenuEvent());
        },
        child: Container(margin: EdgeInsets.all(2.w), child: buildAvatar()));
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
              color: _innerBoxIsScrolled ? IConstant.white_bg_color : IConstant.white_translucent_color4,
              child: Center(
                  child: Icon(Icons.menu,
                      size: 25.w,
                      color: IConstant.text_color))));
    }
  }

}
