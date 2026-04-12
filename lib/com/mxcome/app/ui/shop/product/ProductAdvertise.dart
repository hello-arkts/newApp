import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IURLConstant.dart';
import 'package:mxcome/com/mxcome/app/model/BaseRsp.dart';
import 'package:mxcome/com/mxcome/app/ui/LanguagePage.dart';
import 'package:mxcome/com/mxcome/app/ui/WebPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/category/CategoryPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/rebate/ConsumptionRebatePage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/LoadImageView.dart';
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:mxcome/com/mxcome/app/ui/shop/product/JumpPage.dart';
import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseModel.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/AppUtils.dart';
import '../../../config/StaticDataConfig.dart';
import '../../../utils/ViewUtils.dart';
import '../../web3/WalletCreatePage.dart';
import '../../web3/WalletManagerPage.dart';
import 'MonthlyBenefitsPage.dart';
import 'SuperWednesdayPage.dart';

class ProductAdvertise extends StatefulWidget {
  dynamic advertiseList;

  dynamic categoryList;

  ProductAdvertise({this.advertiseList, this.categoryList});

  @override
  State<StatefulWidget> createState() {
    return ProductAdvertiseState();
  }
}

class ProductAdvertiseState extends BaseKeepAliveState<ProductAdvertise> {
  List<dynamic> advertiseList = [];

  dynamic userInfo;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    dynamic data = await AppUtils.getUserInfo();
    List<dynamic> tempList = [];
    if (widget.advertiseList != null) {
      for (dynamic item in widget.advertiseList) {
        tempList.add(item);
      }
    }
    setState(() {
      userInfo = data;
      advertiseList = tempList;
    });
  }

  @override
  void didUpdateWidget(covariant ProductAdvertise oldWidget) {
    super.didUpdateWidget(oldWidget);
    initData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
            transform: Matrix4.translationValues(0.0, -70.w, 0.0),
            height: 400.w,
            child: Swiper(
              loop: advertiseList.length > 1 ? true : false,
              autoplay: advertiseList.length > 1 ? true : false,
              autoplayDelay: 5000,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    gotoWhere(index);
                  },
                  child: LoadImageView(double.infinity, double.infinity,
                      BaseModel.getString(advertiseList[index], "pic"),
                      fit: BoxFit.cover),
                );
              },
              itemCount: advertiseList.length,
              // pagination: SwiperPagination(),
            )),
        // SizedBox(
        //   height: 100.w,
        //   child: ListView.separated(
        //       scrollDirection: Axis.horizontal,
        //       itemCount: widget.categoryList.length,
        //       physics: const ClampingScrollPhysics(),
        //       padding: EdgeInsets.symmetric(horizontal: 10.w),
        //       itemBuilder: (context, index) {
        //         return buildListItem(index);
        //       },
        //       separatorBuilder: (BuildContext context, int index) {
        //         return SizedBox(width: 15.w);
        //       }),
        // ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.w), // 增加底部的外边距，为阴影腾出空间
          padding: EdgeInsets.fromLTRB(10.w, 15.w, 10.w, 10.w),
          decoration: BoxDecoration(
            color: Colors.white, // 背景色
            borderRadius: BorderRadius.circular(16.r), // 圆角16
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06), // 浅灰色的阴影
                blurRadius: 8, // 阴影模糊半径
                spreadRadius: 1, // 阴影扩散范围
                offset: const Offset(0, 0.4), // 向下偏移
              ),
            ],
          ),
          child: buildNewGridMenu(),
        ),
      ],
    );
  }

  Widget buildListItem(int index) {
    if (index == 0) {
      // web钱包
      return InkWell(
        onTap: () {
          web3Wallet();
        },
        child: Container(
          width: 146.w,
          height: 100.w,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: Image.asset(web3WalletBg()).image),
              borderRadius: BorderRadius.all(Radius.circular(10.r))),
        ),
      );
    } else if (index == 1) {
      // 品牌店铺
      return InkWell(
        onTap: () {
          nextPage(CategoryPage(getId(index)), false);
        },
        child: Container(
          width: 146.w,
          height: 100.w,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: Image.asset(getIPBg()).image),
              borderRadius: BorderRadius.all(Radius.circular(10.r))),
        ),
      );
    } else {
      // 消费返点
      return InkWell(
        onTap: () {
          nextPage(ConsumptionRebatePage(), false);
        },
        child: Container(
          width: 146.w,
          height: 100.w,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: Image.asset(getRebaseBg()).image),
              borderRadius: BorderRadius.all(Radius.circular(10.r))),
        ),
      );
    }
  }

  // 新版六宫格菜单
  Widget buildNewGridMenu() {
    // 如果有接口数据，优先使用接口数据
    final List<Map<String, String>> menus =
        StaticDataConfig.productAdvertiseMenus;

    double itemHeight = 85.w;
    double gridHeight = itemHeight * 2 + 10.w;

    return SizedBox(
        height: gridHeight,
        child: GridView.builder(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal, // 改为横向滚动
          physics: const ClampingScrollPhysics(), // 允许内部滚动
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 横向滚动时，crossAxisCount 表示行数（2行）
            mainAxisSpacing: 0, // 由于是横向，mainAxisSpacing 变成了列与列之间的间距
            crossAxisSpacing: 10.w, // crossAxisSpacing 变成了行与行之间的间距
            childAspectRatio: itemHeight /
                (MediaQuery.of(context).size.width /
                    3.5), // 调整横向滚动时的宽高比，以保证每列宽度合适
          ),
          itemCount: menus.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                // 点击跳转逻辑
                if (index == 0) {
                  // 入境申请 (快速通关) -> 跳往自定义的中转页
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JumpPage(
                        note: 'https://tdac.immigration.go.th/',
                        applyUrl: 'https://tdac.immigration.go.th/',
                        selfApplyStatus: true,
                      ),
                    ),
                  );
                } else if (index == 3) {
                  nextPage(CategoryPage(getId(index)), false);
                } else if (index == 5) {
                  nextPage(ConsumptionRebatePage(), false);
                } else {
                  // web3Wallet() 或其他
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    menus[index]["icon"]!,
                    width: 32.w,
                    height: 32.w,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 8.w),
                  Text(
                    menus[index]["title"]!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 4.w),
                  Text(
                    menus[index]["subtitle"]!,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: menus[index].containsKey("subtitleColor") &&
                              menus[index]["subtitleColor"] == "red"
                          ? Colors.red
                          : const Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }

  web3WalletBg() {
    switch (LanguagePage.language) {
      case 'TH':
        return 'assets/icons/web3_bg_th.png';
      case 'ZH':
        return 'assets/icons/web3_bg_zh.png';
      case 'EN':
        return 'assets/icons/web3_bg_en.png';
      default:
        return 'assets/icons/web3_bg_th.png';
    }
  }

  getIPBg() {
    switch (LanguagePage.language) {
      case 'TH':
        return 'assets/icons/ip_bg_th.png';
      case 'ZH':
        return 'assets/icons/ip_bg_zh.png';
      case 'EN':
        return 'assets/icons/ip_bg_en.png';
      default:
        return 'assets/icons/ip_bg_th.png';
    }
  }

  getRebaseBg() {
    switch (LanguagePage.language) {
      case 'TH':
        return 'assets/icons/rebase_bg_th.png';
      case 'ZH':
        return 'assets/icons/rebase_bg_zh.png';
      case 'EN':
        return 'assets/icons/rebase_bg_en.png';
      default:
        return 'assets/icons/rebase_bg_th.png';
    }
  }

  goSuperWednesdayPageIsLogin() async {
    bool isLogin = await AppUtils.isLogined();
    if (isLogin) {
      nextPage(SuperWednesdayPage(), false);
    } else {
      toLogin((ctx) => {
            setState(() {
              finishContext(ctx);
              nextPage(SuperWednesdayPage(), false);
            })
          });
    }
  }

  web3Wallet() async {
    bool isLogin = await AppUtils.isLogined();
    if (isLogin) {
      if (BaseModel.isEmpty(userInfo, "email")) {
        showPop(0.5 * Adapt.getWindowHeight(), WalletCreatePage(),
            topColor: IConstant.web3_create_bg_color);
      } else {
        nextPage(WalletManagerPage(), false);
      }
    } else {
      toLogin((ctx) => {
            setState(() {
              finishContext(ctx);
              if (BaseModel.isEmpty(userInfo, "email")) {
                showPop(0.5 * Adapt.getWindowHeight(), WalletCreatePage(),
                    topColor: IConstant.web3_create_bg_color);
              } else {
                nextPage(WalletManagerPage(), false);
              }
            })
          });
    }
  }

  goWeeklyBenefitsPageIsLogin() async {
    bool isLogin = await AppUtils.isLogined();
    if (isLogin) {
      ViewUtils.show();
      BaseRsp rsp =
          await HttpUtils.post(IURLConstant.MALL_GET_SYSTEM_SETTINGS, {});
      String headDevelopmentOpen =
          BaseModel.getString(rsp.data, "headDevelopmentOpen");
      if (rsp.retCode == RspRetCode.SUCCESS) {
        bool isOpenRebate = (headDevelopmentOpen == "1");
        if (isOpenRebate) {
          nextPage(ConsumptionRebatePage(), false);
        } else {
          ViewUtils.displayToast(LanguageConfig.get(
              LanguageConfigKeys.shop_home_rebate_close_tip));
        }
      } else {
        ViewUtils.displayToast(rsp.msg);
      }
      ViewUtils.dismiss();
    } else {
      toLogin((ctx) => {
            setState(() {
              finishContext(ctx);
            })
          });
    }
  }

  goMonthlyBenefitsPageIsLogin() async {
    nextPage(MonthlyBenefitsPage(), false);
  }

  String getName(int index) {
    if (widget.categoryList.length > index) {
      if (LanguagePage.language == "ZH") {
        return BaseModel.getString(widget.categoryList[index], "chName");
      } else if (LanguagePage.language == "EN") {
        return BaseModel.getString(widget.categoryList[index], "enName");
      } else {
        return BaseModel.getString(widget.categoryList[index], "name");
      }
    } else {
      return "";
    }
  }

  String getId(int index) {
    if (widget.categoryList.length > index) {
      return BaseModel.getString(widget.categoryList[index], "id");
    } else {
      return "";
    }
  }

  String getCategoryBg(int index) {
    return "assets/icons/category_bg$index.png";
  }

  String getCategoryIcon(int index) {
    return "assets/icons/category_icon$index.png";
  }

  gotoWhere(int index) async {
    dynamic item = advertiseList[index];
    int relationType = BaseModel.getInt(item, "relationType");
    String url = BaseModel.getString(item, "url");
    url = index == 0 ? "mxcome://app/lottery" : url;
    if (relationType == 1) {
      //活动广告
      int relationId = BaseModel.getInt(item, "relationId");
      List<dynamic> dataList = await AppUtils.getActivityData();
      dynamic activityModel;
      for (dynamic activity in dataList) {
        int activityId = BaseModel.getInt(activity, "id");
        if (relationId == activityId) {
          activityModel = activity;
          break;
        }
      }
      if (activityModel != null) {
        activityIsLogin(activityModel);
      } else {
        ViewUtils.displayToast(
            LanguageConfig.get(LanguageConfigKeys.Shop_activity_not_exist));
      }
    } else if (url.startsWith("mxcome://app/")) {
      //普通广告
      launchUrlString(url);
    } else {
      //普通广告
      nextPage(WebPage(BaseModel.getString(item, "url")), false);
    }
  }

  activityIsLogin(dynamic activity) async {
    if (await AppUtils.isLogined()) {
      activityStart(activity, false);
    } else {
      toLogin((ctx) => {
            setState(() {
              finishContext(ctx);
              activityStart(activity, false);
            })
          });
    }
  }
}
