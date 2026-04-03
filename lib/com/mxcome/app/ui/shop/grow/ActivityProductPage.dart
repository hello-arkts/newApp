import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/detail/ProductDetailPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/CollectEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CountDownView.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IURLConstant.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../detail/TimePromptPage.dart';
import '../event/MainTabEvent.dart';
import '../event/PocketEvent.dart';
import '../model/ActivityProductModel.dart';
import '../pocket/ActivityDetailPage.dart';
import '../pocket/GetPrizeActivityPage.dart';
import '../utils/EventBusUtil.dart';
import '../utils/FormatUtil.dart';
import '../widget/CommResultPage.dart';
import '../widget/LoadImageView.dart';
import '../widget/SmallTextButton.dart';

class ActivityProductPage extends StatefulWidget {

  dynamic activityDetail;

  dynamic activityMember;

  ActivityProductPage(this.activityDetail, {this.activityMember});

  @override
  State<StatefulWidget> createState() => ActivityProductPageState();
}

class ActivityProductPageState extends BaseKeepAliveState<ActivityProductPage> {

  dynamic _activityDetail;

  dynamic _activityMember;

  List<dynamic> levelGiftList = [];
  List<ActivityProductModel> productList = [];
  List<dynamic> giftConfigList = [];

  bool isReloadCollect = false;

  int _currentLevel = 1;

  int _levelNum = 0;

  dynamic pocketEvent;

  @override
  void initState() {
    super.initState();
    _activityDetail = widget.activityDetail;
    _activityMember = widget.activityMember;
    pocketEvent = EventBusUtil.getInstance().on<PocketEvent>((event) async {
      if (event.pocketType == PocketType.complete) {
        String activityId = BaseModel.getString(_activityDetail, "id");
        dynamic activityMember = await AppUtils.getActivityMember(activityId);
        setState(() {
          _activityMember = activityMember;
        });
      }
    });
    loadContentDatas();
  }

  @override
  void dispose() {
    if (isReloadCollect) {
      EventBusUtil.getInstance().emit(CollectEvent());
    }
    EventBusUtil.getInstance().off(pocketEvent);
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    List<ActivityProductModel> dataList = [];
    List<String> collectionList = [];
    List<dynamic> localCollectionList = await AppUtils.getCollectData();
    for (var item in localCollectionList) {
      collectionList.add(BaseModel.getString(item, "productId"));
    }
    int tempLevel = BaseModel.getInt(_activityMember, "level");
    if (tempLevel <= 0) {
      tempLevel = 1;
    }
    int tempLevelNum = BaseModel.getInt(_activityDetail, "levelNum");
    List<dynamic> tmpProductList = BaseModel.getDynamic(_activityDetail, "productList");
    for (var item in tmpProductList) {
      String productId = BaseModel.getString(item, "productId");
      int level = BaseModel.getInt(item, "level");
      if (level == tempLevel) {
        dataList.add(ActivityProductModel.fromJson(item, collectionList.contains(productId)));
      }
    }
    setState(() {
      productList = dataList;
      levelGiftList = BaseModel.getDynamic(_activityDetail, "levelGiftList");
      giftConfigList = BaseModel.getDynamic(_activityDetail, "giftConfigList");
      _currentLevel = tempLevel;
      _levelNum = tempLevelNum;
    });
  }

  @override
  void didUpdateWidget(covariant ActivityProductPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    loadContentDatas();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getServiceTime();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            if (_activityMember != null) {
              backHome();
              EventBusUtil.getInstance().emit(MainTabEvent(pageType: PageType.pocketActivity));
            } else {
              finishContext(context);
            }
          },
          child: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_quick_understand),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
        actions: [
          _popupMenuButton(context)
        ],
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  PopupMenuButton _popupMenuButton(BuildContext context){
    return _activityMember != null ? PopupMenuButton(
      icon: Icon(Icons.more_vert, size: 25.w),
      itemBuilder: (BuildContext context){
        return [
          PopupMenuItem(value: "1",child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_abandoning), style: TextStyle(
              fontSize: 13.sp, color: IConstant.text_color)),),
          PopupMenuItem(value: "2",child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_rules), style: TextStyle(
              fontSize: 13.sp, color: IConstant.text_color)),),
        ];
      },
      onSelected: (dynamic value) {
        if ("1" == "$value") {
          giveUpDialog();
        } else if("2" == "$value") {
          showRuleDialog();
        }
      },
    ) : PopupMenuButton(
        icon: Icon(Icons.more_vert, size: 25.w),
        itemBuilder: (BuildContext context){
          return [
            PopupMenuItem(value: "2",child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_rules), style: TextStyle(
                fontSize: 13.sp, color: IConstant.text_color)),),
          ];
        },
        onSelected: (dynamic value) {
          showRuleDialog();
        },
      );
  }

  Widget buildBody() {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.fromLTRB(40.w, 16.w, 40.w, 0.w),
            child: buildLevel()),
        Container(
          margin: EdgeInsets.fromLTRB(20.w, 10.w, 20.w, 16.w),
          decoration: BoxDecoration(
            color: IConstant.red_bg_color,
            border: Border.all(color: IConstant.main_color, width: 1.w),
            borderRadius: BorderRadius.all(Radius.circular(40.w)),
          ),
          child: Row(
              children: [
                Expanded(child: InkWell(
                  onTap: () {
                    showPop(0.9 * Adapt.getWindowHeight(), GetPrizeActivityPage(_activityDetail, _activityMember, selectIndex: 1));
                  },
                  child: Row(
                    children: [
                      SizedBox(width: 14.w),
                      Expanded(flex: 3, child: Text(
                          LanguageConfig.get(
                              LanguageConfigKeys.Shop_activity_top_prize),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 13.sp, color: IConstant.text_color))),
                      Expanded(flex: 7, child: getTopList())
                    ],
                  ),
                )),
                Container(
                  width: 1.w,
                  height: 16.w,
                  margin: EdgeInsets.only(top: 10.w, bottom: 10.w),
                  color: IConstant.default_select_color,
                ),
                Expanded(child: InkWell(
                  onTap: () {
                    showPop(0.9 * Adapt.getWindowHeight(), GetPrizeActivityPage(_activityDetail, _activityMember, selectIndex: 0));
                  },
                  child: Row(
                    children: [
                      SizedBox(width: 14.w),
                      Expanded(flex: 3, child: Text(
                          LanguageConfig.get(
                              LanguageConfigKeys.Shop_activity_level_prize),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 13.sp, color: IConstant.text_color))),
                      Expanded(flex: 7, child: getGiftList()),
                    ],
                  ),
                ))
              ],
            ),
        ),
        Expanded(flex: 1, child: buildProduct())
      ],
    );
  }

  Widget buildLevel() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icons/clock.png",
                width: 12.w, height: 12.w),
            SizedBox(
              width: 4.w,
            ),
            Text(
                LanguageConfig.get(LanguageConfigKeys.Shop_activity_count_down),
                style: TextStyle(fontSize: 13.sp, color: IConstant.sub_text_color)),
            SizedBox(
              width: 4.w,
            ),
            getStopTime(_activityDetail),
            SizedBox(
              width: 6.w,
            ),
            Container(
              width: 1.w,
              height: 16.w,
              margin: EdgeInsets.only(top: 10.w, bottom: 10.w),
              color: IConstant.default_select_color,
            ),
            SizedBox(
              width: 6.w,
            ),
            Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_level_count),
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: IConstant.text_color)),
            SizedBox(
              width: 4.w,
            ),
            Text(getMemberLevel(),
                style: TextStyle(fontSize: 13.sp, color: IConstant.main_color)),
          ],
        ),
        SizedBox(height: 6.w),
      ],
    );
  }

  String getMemberLevel(){
    return "$_currentLevel/$_levelNum";
  }

  Widget getStopTime(dynamic item) {
    String endTime = BaseModel.getString(item, "endTime");
    return CountDownView(startTime: serviceTime, endTime: endTime,
        fontSize: 12.w,
        textColor: IConstant.main_color,
        stop: LanguageConfig.get(LanguageConfigKeys.Shop_activity_closed));
  }

  Widget getTopList() {
    List showItemList =
    giftConfigList.length > 3 ? giftConfigList.sublist(0, 3) : giftConfigList;
    return Row(children: showItemList.map((e) => getGiftImage(e)).toList());
  }

  Widget getGiftList() {
    List showItemList =
        levelGiftList.length > 3 ? levelGiftList.sublist(0, 3) : levelGiftList;
    return Row(children: showItemList.map((e) => getGiftImage(e)).toList());
  }

  Widget getGiftImage(dynamic item) {
    return Card(
      margin: EdgeInsets.fromLTRB(2.w, 6.w, 2.w, 6.w),
      elevation: 0.w,
      child: LoadImageView(
          30.w, 30.w, BaseModel.getString(item, "productGiftPic")),
    );
  }

  Widget buildProduct() {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 260.w,
        mainAxisSpacing: 10.w, //item上下间隔
        crossAxisSpacing: 10.w, //item左右间隔
      ),
      itemCount: productList.length + 1,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            ActivityProductModel product = productList[index];
            goDetail(product);
          },
          child: buildProductItem(index),
        );
      },
    );
  }

  Future<void> goDetail(ActivityProductModel product) async {
    String productId = product.productId;
    showPop(0.9 * Adapt.getWindowHeight(), ProductDetailPage(productId));
  }

  Widget buildProductItem(int index) {
    if (index >= productList.length) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.w)),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.asset(
                  "assets/icons/activity_bg.png",
                ).image)
        ),
        child: Column(
          children: [
            SizedBox(height: 40.w),
            Image.asset("assets/icons/activity_prize.png",
                 width: 60.w, height: 60.w),
            SizedBox(height: 30.w),
            Image.asset("assets/icons/activity_product_icon.png",
                width: 30.w, height: 30.w),
            Container(
              margin: EdgeInsets.fromLTRB(10.w, 30.w, 10.w, 0),
              child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_complete_level_lock_new_level),
                  style: TextStyle(fontSize: 11.sp, color: IConstant.text_color),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ),
         ],
        ),
      );
    } else {
      ActivityProductModel product = productList[index];
      return Stack(
        children: [
          Column(
            children: [
              Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(8.w)),
                  clipBehavior: Clip.antiAlias,
                  elevation: 1,
                  child: LoadImageView(150.w, 150.w, product.productPic)),
              Expanded(child: Text(product.productName,
                  style: TextStyle(fontSize: 13.sp, color: IConstant.text_color),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis)),
              Padding(
                  padding: EdgeInsets.only(left: 5.w, top: 2.w, right: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PriceText(product.price, fontSize: 13.sp, color: IConstant.text_color),
                      Row(
                        children: [
                          Image.asset("assets/icons/small_heart.png",
                              width: 12.w, height: 12.w),
                          SizedBox(width: 4.w),
                          Text("${product.collectionNum}",
                              style: TextStyle(
                                  fontSize: 12.sp, color: IConstant.grey_color)),
                        ],
                      )
                    ],
                  )
              ),
              buildProfit(product)
            ],
          ),
          // Positioned(
          //   top: 10.w,
          //   right: 10.w,
          //   child: buildHeart(product)),
        ],
      );
    }
  }

  Widget buildProfit(ActivityProductModel model) {
    return Container(
      margin: EdgeInsets.fromLTRB(4.w, 8.w, 4.w, 8.w),
      padding: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
      decoration: BoxDecoration(
        color: IConstant.red_bg_color,
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset("assets/icons/profit.png", width: 10.w, height: 10.w),
          SizedBox(width: 2.w),
          Text(getProfitText(model),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11.sp, color: IConstant.main_color)),
        ],
      ),
    );
  }

  String getProfitText(ActivityProductModel model) {
    double minProfit = model.minProfit;
    double maxProfit = model.maxProfit;
    return FormatUtil.profitAmount(maxProfit, maxPrice: maxProfit);
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      elevation: 0.w,
      child: SizedBox(
        height: 90.w,
        child: Stack(
          children: [
            Positioned(left: 0.w, right: 0.w, bottom: 50.w, child: Container(
              color: IConstant.line_color,
              height: 2.w,
            )),
            Positioned(left: 0.w, right: 0.w, bottom: 0.w, child: Container(
              height: 40.w,
              margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 6.w),
              child: Row(
                children: [
                  buildTopInfo(),
                  SizedBox(width: 20.w),
                  SmallTextButton(text: getJoinText(), onTap: () {
                    if (_activityMember != null) {
                      startActivityDetail();
                    } else {
                      if (check()) {
                        activityJoin();
                      }
                    }
                  })
                ],
              ),
            )),
            Positioned(top: 0.w, right: 16.w, child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(10.w),
                      topEnd: Radius.circular(10.w),
                      bottomStart: Radius.circular(10.w),
                  )),
              clipBehavior: Clip.antiAlias,
              elevation: 4.w,
              child: Container(
                height: 30.w,
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(10.w, 0.w, 10.w, 0.w),
                child: _activityMember != null ? Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_challenge_failed_profit), style: TextStyle(fontSize: 11.sp, color: IConstant.main_color))
                : Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_click_challenge), style: TextStyle(fontSize: 11.sp, color: IConstant.main_color)),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget buildTopInfo() {
    if (_activityMember != null) {
      return Expanded(child: Row(
        children: [
          Text(
              LanguageConfig.get(
                  LanguageConfigKeys.Shop_activity_current_top),
              style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
          SizedBox(
            width: 4.w,
          ),
          Text(getRank(),
              style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
        ],
      ));
    } else {
      return Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_ranking_information),
          maxLines: 2, overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)));
    }
  }

  String getJoinText() {
    if (_activityMember != null) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_activity_continue_break_barrier);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_activity_now_break_barrier);
    }
  }

  String getRank() {
    String rank = BaseModel.getString(_activityMember, "rank");
    if (TextUtils.isEmpty(rank)) {
      rank = LanguageConfig.get(LanguageConfigKeys.Shop_activity_not_listed);
    }
    return rank;
  }

  Widget buildRanking() {
    if (giftConfigList.isNotEmpty) {
      return LoadImageView(
          35.w,
          35.w,
          BaseModel.getString(
              giftConfigList[giftConfigList.length - 1], "productGiftPic"));
    } else {
      return Container();
    }
  }

    bool check() {
      String endTime = BaseModel.getString(_activityDetail, "endTime");
      DateTime endDT = DateTime.parse(endTime);
      DateTime newDT = DateTime.parse(serviceTime);
      if (endDT.difference(newDT).inMilliseconds < 48 * 60 * 60 * 1000) {
        showPop(0.4 * Adapt.getWindowHeight(), TimePromptPage(endTime, (ctx, yes) => {
          setState(() {
            finishContext(ctx);
            if (yes) {
              activityJoin();
            }
          })
        }, type: 2));
        return false;
      }
      return true;
    }

  void activityJoin() async {
    BaseRsp rsp = await HttpUtils.postJSON(IURLConstant.MALL_ACTIVITY_SAVE, {
      "activityId": BaseModel.getString(_activityDetail, "id"),
      "level": "1"
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      EventBusUtil.getInstance().emit(PocketEvent());
      showSuccessJoinDialog();
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  void showSuccessJoinDialog() {
    showPop(0.35 * Adapt.getWindowHeight(), CommResultPage(
        title: LanguageConfig.get(LanguageConfigKeys.Shop_activity_success_participated),
        message: Padding(padding: EdgeInsets.fromLTRB(20.w, 16.w, 20.w, 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_success_participated_tip1),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
              SizedBox(height: 12.w),
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_success_participated_tip2),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
            ],
          ),
        ),
        callBack: (BuildContext ctx) {
          finishContext(ctx);
          startActivityDetail();
        })
    );
  }

  void startActivityDetail() async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_ACTIVITY_MEMBER_INFO, {
      "activityId": BaseModel.getString(_activityDetail, "id")
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      nextPage(ActivityDetailPage(rsp.data), false);
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  void showRuleDialog() {
    showPop(0.5 * Adapt.getWindowHeight(), CommResultPage(
        title: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_activity_rules),
        btnText: LanguageConfig.get(LanguageConfigKeys.Shop_order_got_it),
        message: Padding(padding: EdgeInsets.fromLTRB(20.w, 16.w, 20.w, 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_rule_tip1),
                  style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
              SizedBox(height: 12.w),
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_rule_tip2),
                  style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
              SizedBox(height: 12.w),
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_rule_tip3),
                  style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
              SizedBox(height: 12.w),
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_rule_tip4),
                  style: TextStyle(fontSize: 13.sp, color: IConstant.text_color))
            ],
          ),
        ),
        callBack: (BuildContext ctx) {
          finishContext(ctx);
        })
    );
  }

  void giveUpDialog() {
    showPop(0.5 * Adapt.getWindowHeight(), CommResultPage(
        title: LanguageConfig.get(LanguageConfigKeys.Shop_activity_abandoning),
        btnText: LanguageConfig.get(LanguageConfigKeys.Shop_activity_confirm_abandonment),
        message: Padding(padding: EdgeInsets.fromLTRB(20.w, 16.w, 20.w, 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/icons/red_warn.png", width: double.infinity, height: 45.w),
              SizedBox(height: 30.w,),
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_abandoning_tip), textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
            ],
          ),
        ),
        callBack: (BuildContext ctx) {
          finishContext(ctx);
          giveUpActivity();
        })
    );
  }

  Future<void> giveUpActivity() async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_GIVE_UP_ACTIVITY, {
      "activityId": BaseModel.getString(_activityDetail, "id"),
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      backHome();
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

}
