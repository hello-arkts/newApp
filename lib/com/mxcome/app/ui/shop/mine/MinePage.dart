import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/CollectEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/OrderEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/UserInfoEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/promotion/RedStagePage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/setting/AboutPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/setting/SettingPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/wallet/WalletPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:mxcome/com/mxcome/app/utils/Adapt.dart';
import 'package:mxcome/com/mxcome/app/utils/AppUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:share_plus/share_plus.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IURLConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/HttpUtils.dart';
import '../detail/ProductDetailPage.dart';
import '../event/MainTabEvent.dart';
import '../model/ReadCount.dart';
import '../order/AfterSalesPage.dart';
import '../order/OrderPage.dart';
import '../utils/Util.dart';
import '../widget/GenAvatar.dart';
import 'address/AddressListPage.dart';
import 'collect/CollectionPage.dart';
import '../utils/EventBusUtil.dart';
import '../utils/FormatUtil.dart';
import '../widget/LoadImageView.dart';
import 'coupon/MineCouponPage.dart';
import 'invite/MineLinkPage.dart';
import 'member/MemberInfoPage.dart';
import 'rebate/ConsumptionRebatePage.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MinePageState();
  }
}

class MinePageState extends BaseKeepAliveState<MinePage> {

  dynamic userInfo;
  int idCardStatus = -1;

  bool isLogin = false;

  dynamic userInfoEvent;

  dynamic orderEvent;

  dynamic collectEvent;

  ReadCount _orderCount0 = ReadCount(IConstant.order_count_0, 0, 0);
  ReadCount _orderCount1 = ReadCount(IConstant.order_count_1, 0, 0);
  ReadCount _orderCount2 = ReadCount(IConstant.order_count_2, 0, 0);
  ReadCount _orderCount3 = ReadCount(IConstant.order_count_3, 0, 0);
  ReadCount _versionCount = ReadCount(IConstant.version_count, 0, 0);

  List<dynamic> incomeList = [];

  List<dynamic> collectionList = [];

  String localVersion = "";

  String serviceVersion = "";

  int redPower = 1;

  bool isOpenRebate = false;

  @override
  void initState() {
    super.initState();
    userInfoEvent = EventBusUtil.getInstance().on<UserInfoEvent>((event) {
      if (event.userInfoStatus == UserInfoStatus.complete) {
        loadContentDatas();
      }
    });
    orderEvent = EventBusUtil.getInstance().on<OrderEvent>((event) {
      if (event.orderType == OrderType.complete) {
        loadContentDatas();
      }
    });
    collectEvent = EventBusUtil.getInstance().on<CollectEvent>((event) {
      if (event.collectType == CollectType.complete) {
        loadContentDatas();
      }
    });
    loadContentDatas();
    EventBusUtil.getInstance().emit(UserInfoEvent());
    EventBusUtil.getInstance().emit(CollectEvent());
    EventBusUtil.getInstance().emit(OrderEvent());
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(userInfoEvent);
    EventBusUtil.getInstance().off(orderEvent);
    EventBusUtil.getInstance().off(collectEvent);
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    // await launchUrlString("mxcome://app/payResult/711", mode: LaunchMode.externalApplication);
    bool loginState = await AppUtils.isLogined();
    localVersion = await Util.getVersion();
    if (loginState) {
      dynamic data = await AppUtils.getUserInfo();
      setState(() {
        isLogin = loginState;
        userInfo = data;
      });
      BaseRsp res = await HttpUtils.post(IURLConstant.MALL_GET_SYSTEM_SETTINGS, {});
      setState(() {
        idCardStatus = BaseModel.getInt(userInfo, "idCardStatus");
        redPower = BaseModel.getInt(userInfo, "redPower");
        String headDevelopmentOpen = BaseModel.getString(res.data, "headDevelopmentOpen");
        isOpenRebate = (headDevelopmentOpen == "1");
      });
      ReadCount orderCount0 = await AppUtils.getReadCount(IConstant.order_count_0);
      ReadCount orderCount1 = await AppUtils.getReadCount(IConstant.order_count_1);
      ReadCount orderCount2 = await AppUtils.getReadCount(IConstant.order_count_2);
      ReadCount orderCount3 = await AppUtils.getReadCount(IConstant.order_count_3);
      ReadCount versionCount = await AppUtils.getReadCount(IConstant.version_count);
      List<dynamic> pocketData = await AppUtils.getCollectData();
      setState(() {
        _orderCount0 = orderCount0;
        _orderCount1 = orderCount1;
        _orderCount2 = orderCount2;
        _orderCount3 = orderCount3;
        _versionCount = versionCount;
        collectionList = pocketData;
      });
      loadIncomeInfo();
    } else {
      setState(() {
        isLogin = loginState;
        collectionList = [];
      });
    }
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_VERSION_INFO, {});
    setState(() {
      serviceVersion = BaseModel.getString(rsp.data, "version");
    });
  }

  Future<void> loadIncomeInfo() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_INCOME_INFO, {
      "pageNum": "$page", "pageSize": "20"
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        incomeList = BaseModel.isNotEmpty(rsp.data, "list") ? BaseModel.getDynamic(rsp.data, "list") : [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      width: Adapt.getWindowWidth() * 0.9,
      child: Scaffold(
        backgroundColor: IConstant.white_color,
        body: ListView(
          children: [
            menuIcon(),
            menuHeader(),
            //menuMember(),
            menuWallet(),
            menuOrder(),
            buildCollect(),
          ],
        ),
        bottomNavigationBar: menuBottomBar(),
      ),
    );
  }

  Widget menuIcon() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0.w),
      padding: EdgeInsets.only(bottom: 8.w),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              finish();
            },
            child: Image.asset(
              "assets/icons/menu.png",
              width: 22.w,
            ),
          ),
          SizedBox(width: 10.w),
          Image.asset(
            "assets/icons/mxcome.png",
            width: 90.w,
          ),
          SizedBox(width: 10.w),
          Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_adv),
              style: TextStyle(fontSize: 17.sp, color: IConstant.main_color)),
          expandeSpace,
          Row(
            children: [
              InkWell(
                  onTap: () {
                    nextPageIsLogin(MineCouponPage());
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Image.asset(
                      "assets/icons/coupon_center.png",
                      width: 28.w,
                      height: 28.w,
                    ),
                  ),),
              SizedBox(width: 18.w,),
              InkWell(
                  onTap: () {
                    nextPage(SettingPage(), false);
                  },
                  child: Image.asset(
                    "assets/icons/setting.png",
                    width: 24.w,
                    height: 24.w,
                    color: IConstant.text_color,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget menuHeader() {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x1E000000),
            blurRadius: 9,
            offset: Offset(0, 2),
            spreadRadius: 0,
          )
        ],
      ),
      margin: EdgeInsets.fromLTRB(10.w, 5.w, 16.w, 2.w),
      child: Column(
        children: [
          buildMember(),
          SizedBox(height: 6.w,),
          // buildKOLShare(),
        ],
      ),
    );
  }

  Widget buildMember() {
    if (isLogin) {
      return buildUserInfo();
    } else {
      return InkWell(onTap: () {
        goLogin();
      }, child: ListTile(
        title: Text(
            LanguageConfig.get(LanguageConfigKeys.Shop_mine_not_login)),
        trailing: Icon(Icons.chevron_right, size: 20.w),
      ));
    }
  }

  Widget buildUserInfo() {
    return Container(
      padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              nextPage(MemberInfoPage(), false);
            },
            child: Row(
                children: [
                  ClipOval(child: buildAvatar()),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(constraints: BoxConstraints(maxWidth: 100.w),child: Text(getDisplayName(), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color), maxLines: 3,)),
                          SizedBox(width: 4.w),
                          idCardStatus == 2 ? Image.asset("assets/icons/flower.png", width: 18.w, height: 18.w) : Container()
                        ],
                      ),
                      Text("@${BaseModel.getString(userInfo, "generatorId")}", style: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color))
                    ],
                  )
                ]
            ),
          ),
          isOpenRebate ? InkWell(
            onTap: () {
              nextPage(ConsumptionRebatePage(), false);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.w),
              margin: EdgeInsets.only(top: 10.w),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: IConstant.red_bg_color3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/icons/ic_consumption_rebate.png", width: 20.w, height: 20.w),
                  SizedBox(width: 5.w),
                  Text(
                    LanguageConfig.get(LanguageConfigKeys.Shop_wallet_rebate),
                    style: TextStyle(
                      color: IConstant.text_color,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
          ): Container()
        ],
      ),
    );
  }

  String getDisplayName() {
    String nickname = BaseModel.getString(userInfo, "nickname");
    String username = BaseModel.getString(userInfo, "username");
    String phoneCode = BaseModel.getString(userInfo, "phoneCode");
    String phone = BaseModel.getString(userInfo, "phone");
    return TextUtils.isNotEmpty(nickname) ? nickname: "$phoneCode $phone";
  }

  Widget buildAvatar() {
    String avatar = BaseModel.getString(userInfo, "icon");
    if (TextUtils.isNotEmpty(avatar)) {
      return SizedBox(
        width: 60.w,
        height: 60.w,
        child: GenAvatar(avatar),
      );
    } else {
      String displayName = getDisplayName();
      return Container(
          width: 60.w,
          height: 60.w,
          color: IConstant.red_translucent_color,
          child: Center(
              child: Text(TextUtils.isNotEmpty(displayName) ? displayName.substring(0, 1) : "",
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 20.sp, color: IConstant.white_color))));
    }
  }

  Widget menuMember() {
    return Row(
      children: [
        Expanded(
          child: InkWell(onTap: ()=> nextPageIsLogin(MineCouponPage()), child: Container(
            margin: EdgeInsets.fromLTRB(16.w, 10.w, 0.w, 0.w),
            padding: EdgeInsets.fromLTRB(12.w, 10.w, 12.w, 10.w),
            decoration: BoxDecoration(border: Border.all(color: IConstant.line_color, width: 1.w), borderRadius: BorderRadius.circular(10.w)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/icons/coupon_center.png",
                  width: 26.w,
                  height: 26.w,
                ),
                SizedBox(height: 10.w),
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_get_center),
                    maxLines: 2,
                    style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
              ],
            ),
          )),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: InkWell(onTap: () {
            // if(redPower == 0) {
            //   ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_not_red_level));
            // }else {
            //   nextPageIsLogin(RedStagePage());
            // }
            nextPageIsLogin(RedStagePage());
          }, child: Container(
            margin: EdgeInsets.fromLTRB(0.w, 10.w, 16.w, 0.w),
            padding: EdgeInsets.fromLTRB(12.w, 10.w, 12.w, 10.w),
            decoration: BoxDecoration(border: Border.all(color: IConstant.line_color, width: 1.w), borderRadius: BorderRadius.circular(10.w)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/icons/promotion_center.png",
                  width: 26.w,
                  height: 26.w,
                ),
                SizedBox(height: 10.w),
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_promotion_rewards),
                    maxLines: 2,
                    style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
              ],
            ),
          )),
        ),
        // SizedBox(width: 10.w),
        // Expanded(
        //   child: InkWell(onTap: ()=> nextPageIsLogin(MerchantManagePage()), child: Container(
        //     margin: EdgeInsets.fromLTRB(0.w, 10.w, 16.w, 0.w),
        //     padding: EdgeInsets.fromLTRB(12.w, 10.w, 12.w, 10.w),
        //     decoration: BoxDecoration(border: Border.all(color: IConstant.line_color, width: 1.w), borderRadius: BorderRadius.circular(10.w)),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Image.asset(
        //           "assets/icons/shop_center.png",
        //           width: 26.w,
        //           height: 26.w,
        //         ),
        //         SizedBox(height: 10.w),
        //         Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_shop_service),
        //             maxLines: 2,
        //             style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
        //       ],
        //     ),
        //   )),
        // ),
      ],
    );
  }

  Widget buildKOLShare() {
    String kolName = BaseModel.getString(userInfo, "kolName");
    if (TextUtils.isEmpty(kolName)) {
      return buildKolAddWidget();
    } else {
      return buildKolShareWidget();
    }
  }

  Widget buildKolAddWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
      decoration: BoxDecoration(
          border: Border.all(width: 1.w, color: IConstant.line_color)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/icons/ic_kol_link.png",
                width: 20.w,
                height: 20.w,
              ),
              SizedBox(width: 4.w),
              Container(constraints: BoxConstraints(maxWidth: 180.w), child: Text(LanguageConfig.get(LanguageConfigKeys.Login_input_kol_share), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))),
            ],
          ),
          InkWell(
            onTap: () {
              if(isLogin) {
                showPop(0.7 * Adapt.getWindowHeight(), MineLinkPage());
              }else {
                toLogin((ctx) => {
                  setState(() {
                    finishContext(ctx);
                  })
                });
              }
            },
            child: Container(
                width: 73.w,
                height: 30.w,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: Image.asset(
                          "assets/icons/ic_kol_add.png",
                        ).image)
                )
            ),
          )],
      ),
    );
  }

  Widget buildKolShareWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
      decoration: BoxDecoration(
          border: Border.all(width: 1.w, color: IConstant.line_color)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/icons/ic_kol_link.png",
                width: 20.w,
                height: 20.w,
              ),
              SizedBox(width: 4.w),
              Container(constraints: BoxConstraints(maxWidth: 180.w), child: Text(LanguageConfig.get(LanguageConfigKeys.Login_input_kol_recommend), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))),
            ],
          ),
          InkWell(
            onTap: () {
              if(isLogin) {
                shareWeb();
              }else {
                toLogin((ctx) => {
                  setState(() {
                    finishContext(ctx);
                  })
                });
              }
            },
            child: Container(
                width: 73.w,
                height: 30.w,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: Image.asset(
                          "assets/icons/ic_kol_share.png",
                        ).image)
                )
            ),
          )],
      ),
    );
  }

  Widget menuWallet() {
    double withdrawalBalance = BaseModel.getDouble(userInfo, "withdrawalBalance");
    return InkWell(
      onTap: () {
        nextPageIsLogin(WalletPage());
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 0.w),
        padding: EdgeInsets.fromLTRB(12.w, 16.w, 12, 16.w),
        decoration: BoxDecoration(border: Border.all(color: IConstant.line_color, width: 1.w), borderRadius: BorderRadius.circular(10.w)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 12.w),
              child: Row(
                children: [
                  Image.asset("assets/icons/mine_asset.png",
                      fit: BoxFit.fill,
                      width: 18.w,
                      height: 18.w),
                  SizedBox(width: 4.w),
                  Text(
                      LanguageConfig.get(LanguageConfigKeys.Shop_mine_wallet),
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: IConstant.title_color))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0.w, 0.w, 0.w, 10.w),
              padding: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
              decoration: BoxDecoration(
                color: IConstant.green_bg_color,
                borderRadius: BorderRadius.all(Radius.circular(8.w)),
              ),
              child: Row(
                children: [
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_wallet_mxget_income),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 12.sp, color: IConstant.text_color)),
                  SizedBox(width: 8.w),
                  PriceText(isLogin ? withdrawalBalance : 0,
                      fontSize: 12.sp, fontWeight: FontWeight.bold, color: withdrawalBalance < 0 ? IConstant.main_color : IConstant.green_color),
                  expandeSpace,
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_wallet_last_income),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 12.sp, color: IConstant.text_color)),
                  SizedBox(width: 8.w),
                  SizedBox(
                    width: 70.w,
                    child: incomeList.isNotEmpty && isLogin ? buildIncomeDetail() : Text(FormatUtil.price2String(0),
                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.green_color),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 1, child: Container(margin: EdgeInsets.only(left: 16.w), height: 50.w, child: InkWell(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          LanguageConfig.get(LanguageConfigKeys.Shop_mine_gold_coin),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 13.sp, color: IConstant.sub_text_color)),
                      expandeSpace,
                      PriceText(isLogin ? BaseModel.getDouble(userInfo, "goldCoin") : 0, fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.title_color, isFormat: false),
                    ],
                  ),
                ))),
                Container(
                  color: IConstant.line_color,
                  width: 1.w,
                  height: 50.w,
                ),
                Expanded(flex: 1, child: Container(margin: EdgeInsets.only(left: 16.w), height: 50.w, child: InkWell(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          LanguageConfig.get(LanguageConfigKeys.Shop_mine_account_balance),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 13.sp, color: IConstant.sub_text_color)),
                      expandeSpace,
                      PriceText(isLogin ? BaseModel.getDouble(userInfo, "balance") : 0, fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.title_color),
                    ],
                  ),
                ))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIncomeDetail() {
    dynamic selectModel;
    for (var item in incomeList) {
      int status = BaseModel.getInt(item, "status"); //动态收益：0 1  转入余额：-1  退单：-2
      if (status == 0 || status == 0 ||status == -2 ) {
        selectModel = item;
        break;
      }
    }
    if (selectModel != null) {
      int status = BaseModel.getInt(selectModel, "status"); //动态收益：0 1  转入余额：-1  退单：-2
      if (status == 0 || status == 1) {
        return Container(
          padding: EdgeInsets.fromLTRB(4.w, 2.w, 4.w, 2.w),
          child: Text("+${FormatUtil.price2String(BaseModel.getDouble(selectModel, "balance"))}",
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.green_color)),
        );
      } else {
        return Container(
          padding: EdgeInsets.fromLTRB(4.w, 2.w, 4.w, 2.w),
          child: Text("-${FormatUtil.price2String(BaseModel.getDouble(selectModel, "balance"))}",
              style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.bold, color: IConstant.main_color)),
        );
      }
    } else {
      return Text(FormatUtil.price2String(0),
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.green_color));
    }
  }

  Widget menuOrder() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 0.w),
      padding: EdgeInsets.fromLTRB(12.w, 16.w, 12, 16.w),
      decoration: BoxDecoration(border: Border.all(color: IConstant.line_color, width: 1.w), borderRadius: BorderRadius.circular(10.w)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 16.w),
            child: Row(
              children: [
                Image.asset("assets/icons/mine_order.png",
                    fit: BoxFit.fill,
                    width: 18.w,
                    height: 18.w),
                SizedBox(width: 4.w),
                Text(
                    LanguageConfig.get(LanguageConfigKeys.Shop_mine_order),
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: IConstant.title_color))
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: InkWell(
                onTap: () {
                  nextPageIsLogin(OrderPage("0"));
                },
                child: Column(
                  children: [
                    badges.Badge(
                      showBadge: isLogin && _orderCount0.isUnread() && _orderCount0.getNumber() > 0,
                      position: badges.BadgePosition.topEnd(top: -10.w, end: -12.w),
                      badgeContent: Text("${_orderCount0.value}", style: TextStyle(fontSize: 10.sp, color: Colors.white)),
                      child: Image.asset("assets/icons/round_dollar.png",
                          fit: BoxFit.fill, width: 22, height: 22),
                    ),
                    SizedBox(height: 10.w),
                    Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_wait_pay),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13.sp, color: IConstant.text_color))
                  ],
                ),
              )),
              // Expanded(child: InkWell(
              //   onTap: () {
              //     nextPageIsLogin(OrderPage("1"));
              //   },
              //   child: Column(
              //     children: [
              //       badges.Badge(
              //         showBadge: isLogin && _orderCount1.isUnread() && _orderCount1.getNumber() > 0,
              //         position: badges.BadgePosition.topEnd(top: -10.w, end: -12.w),
              //         badgeContent: Text("${_orderCount1.value}", style: TextStyle(fontSize: 10.sp, color: Colors.white)),
              //         child: Image.asset("assets/icons/clock.png",
              //             fit: BoxFit.fill, width: 22, height: 22),
              //       ),
              //       SizedBox(height: 10.w),
              //       Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_wait_deliver),
              //           maxLines: 2,
              //           overflow: TextOverflow.ellipsis,
              //           textAlign: TextAlign.center,
              //           style: TextStyle(
              //               fontSize: 13.sp, color: IConstant.text_color))
              //     ],
              //   ),
              // )),
              Expanded(child: InkWell(
                onTap: () {
                  nextPageIsLogin(OrderPage("2"));
                },
                child: Column(
                  children: [
                    badges.Badge(
                      showBadge: isLogin && _orderCount2.isUnread() && _orderCount2.getNumber() > 0,
                      position: badges.BadgePosition.topEnd(top: -10.w, end: -12.w),
                      badgeContent: Text("${_orderCount2.value}", style: TextStyle(fontSize: 10.sp, color: Colors.white)),
                      child: Image.asset("assets/icons/order_lock.png",
                          fit: BoxFit.fill, width: 22, height: 22),
                    ),
                    SizedBox(height: 10.w),
                    Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_wait_receipt),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13.sp, color: IConstant.text_color))
                  ],
                ),
              )),
              Expanded(child: InkWell(
                onTap: () {
                  nextPageIsLogin(AfterSalesPage("-1"));
                },
                child: Column(
                  children: [
                    badges.Badge(
                      showBadge: false,
                      position: badges.BadgePosition.topEnd(top: -10.w, end: -12.w),
                      //badgeContent: Text("${_orderCount3.value}", style: TextStyle(fontSize: 10.sp, color: Colors.white)),
                      child: Image.asset("assets/icons/basket_update.png",
                          fit: BoxFit.fill, width: 22, height: 22),
                    ),
                    SizedBox(height: 10.w),
                    Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_after_sales),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13.sp, color: IConstant.text_color))
                  ],
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCollect() {
    return collectionList.isNotEmpty ? Container(
      margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 0.w),
      padding: EdgeInsets.fromLTRB(12.w, 16.w, 0.w, 16.w),
      decoration: BoxDecoration(border: Border.all(color: IConstant.line_color, width: 1.w), borderRadius: BorderRadius.circular(10.w)),
      child: InkWell(onTap: () {
        nextPage(CollectionPage(), false);
      } ,child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                children: [
                  Image.asset("assets/icons/mine_collection.png",
                      fit: BoxFit.fill,
                      width: 18.w,
                      height: 18.w),
                  SizedBox(width: 4.w),
                  Text(
                      LanguageConfig.get(LanguageConfigKeys.Shop_pocket_like),
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: IConstant.title_color)),
                ],
              ),
              expandeSpace,
              Image.asset("assets/icons/heart_grey.png",
                  fit: BoxFit.fill,
                  width: 12.w,
                  height: 12.w),
              SizedBox(width: 4.w),
              Text("${collectionList.length}",
                  style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
              SizedBox(width: 12.w)
            ],
          ),
          SizedBox(height: 10.w),
          Row(
            children: [
              Expanded(flex: 1, child: buildImages()),
              Container(
                alignment: Alignment.centerRight,
                child: Icon(Icons.chevron_right, size: 24.w, color: IConstant.sub_text_color),
              )
            ],
          )
        ],
      ))
    ) : Container(
        margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 0.w),
        padding: EdgeInsets.fromLTRB(12.w, 16.w, 12, 16.w),
        decoration: BoxDecoration(border: Border.all(color: IConstant.line_color, width: 1.w), borderRadius: BorderRadius.circular(10.w)),
        child:  Column(
          children: [
            Row(
              children: [
                Row(
                  children: [
                    Image.asset("assets/icons/mine_collection.png",
                        fit: BoxFit.fill,
                        width: 18.w,
                        height: 18.w),
                    SizedBox(width: 4.w),
                    Text(
                        LanguageConfig.get(LanguageConfigKeys.Shop_pocket_like),
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: IConstant.title_color))
                  ],
                ),
                expandeSpace,
                Image.asset("assets/icons/heart_grey.png",
                    fit: BoxFit.fill,
                    width: 12.w,
                    height: 12.w),
                SizedBox(width: 4.w),
                Text("${collectionList.length}",
                    style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color))
              ],
            ),
            SizedBox(height: 10.w),
            Column(
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_like_empty_tip),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                InkWell(
                  onTap: () {
                    backHome();
                    EventBusUtil.getInstance().emit(MainTabEvent(pageType: PageType.main));
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 8.w),
                    padding: EdgeInsets.fromLTRB(10.w, 2.w, 10.w, 2.w),
                    decoration: BoxDecoration(
                        border: Border.all(color: IConstant.main_color, width: 0.5.w),
                        borderRadius: BorderRadius.circular(10.w)),
                    child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_go_stroll),
                        style: TextStyle(fontSize: 13.sp, color: IConstant.main_color)),
                  ),
                )
              ],
            )
          ],
        )
    );
  }

  Widget menuBottomBar() {
    return BottomAppBar(
      height: 110.w,
      elevation: 0.w,
      padding: EdgeInsets.fromLTRB(20.w, 16.w, 20.w, 16.w),
      child: Row(
        children: [
          Expanded(flex: 2, child: InkWell(
                onTap: () {
                  nextPageIsLogin(AddressListPage());
                },
                child: Row(
                  children: [
                    badges.Badge(
                      showBadge: false,
                      position: badges.BadgePosition.topEnd(top: -10.w, end: -12.w),
                      badgeContent: Text("", style: TextStyle(fontSize: 10.sp, color: Colors.white)),
                      child: Image.asset(
                          "assets/icons/property_location.png",
                          fit: BoxFit.fill,
                          width: 20.w,
                          height: 20.w),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(child:  Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_address_manage),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 13.sp, color: IConstant.text_color)))
                  ],
                )),
          ),
          SizedBox(width: 10.w),
          // Expanded(flex: 1, child: InkWell(
          //     onTap: () {
          //       nextPage(HelpPage(), false);
          //     },
          //     child: Row(
          //       children: [
          //         badges.Badge(
          //           showBadge: false,
          //           position: badges.BadgePosition.topEnd(top: -10.w, end: -12.w),
          //           badgeContent: Text("", style: TextStyle(fontSize: 10.sp, color: Colors.white)),
          //           child: Image.asset("assets/icons/help.png",
          //               fit: BoxFit.fill,
          //               width: 20.w,
          //               height: 20.w),
          //         ),
          //         SizedBox(width: 8.w),
          //         Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_help),
          //             maxLines: 2,
          //             overflow: TextOverflow.ellipsis,
          //             style: TextStyle(
          //                 fontSize: 13.sp, color: IConstant.text_color)))
          //       ],
          //     ),
          //   ),
          // ),
          Expanded(flex: 2, child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              badges.Badge(
                  showBadge: localVersion != serviceVersion,
                  badgeContent: Text("", style: TextStyle(fontSize: 12.sp, color: Colors.white)),
                  position: badges.BadgePosition.topEnd(top: -10.w, end: -2.w),
                  child: InkWell(
                    onTap: () {
                      nextPage(AboutPage(), false);
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
                      decoration: BoxDecoration(
                          border: Border.all(color: IConstant.line_color, width: 1.w),
                          borderRadius: BorderRadius.circular(10.w)),
                      child: Text(getLocalVersion(), textAlign: TextAlign.right, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                    ),
                  ))
            ],
          )),
        ],
      ),
    );
  }

  String getLocalVersion(){
    if (IConstant.IS_DEBUG) {
      return "Ver.$localVersion.test";
    } else {
      return "Ver.$localVersion";
    }
  }

  nextPageIsLogin(Widget widget) {
    if (isLogin) {
      nextPage(widget, false);
    } else {
      toLogin((ctx) {
        finishContext(ctx);
        nextPage(widget, false);
      });
    }
  }

  void goLogin() {
    toLogin((ctx) {
      finishContext(ctx);
      loadContentDatas();
    });
  }

  Widget buildImages() {
    List<dynamic> showItemList = collectionList.length > 4 ? collectionList.sublist(0, 4) : collectionList;
    return Row(
      children: showItemList.map((item) => buildImageItem(item)).toList(),
    );
  }

  Widget buildImageItem(dynamic item) {
    return InkWell(
        onTap: () {
          nextPageState(ProductDetailPage(BaseModel.getString(item, "productId")), false);
        },
        child: Row(
          children: [
            ClipOval(
              child: LoadImageView(56.w, 56.w, BaseModel.getString(item, "productPic")),
            ),
            SizedBox(width: 10.w)
          ],
        ));
  }

  Future<void> shareWeb() async {
    String kolName = BaseModel.getString(userInfo, "kolName");
    String shareUrl = Util.getShareKolURL(kolName);
    Share.share(shareUrl);
  }
}
