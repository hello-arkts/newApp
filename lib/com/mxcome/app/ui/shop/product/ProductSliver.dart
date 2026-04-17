import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IURLConstant.dart';
import 'package:mxcome/com/mxcome/app/Logger.dart';
import 'package:mxcome/com/mxcome/app/PageConstant.dart';
import 'package:mxcome/com/mxcome/app/model/BaseRsp.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/detail/ProductDetailPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/BalanceEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/HomeEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/QRCodeEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/UserInfoEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/rebate/BindSuperiorPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/product/HotActivityPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CountDownView.dart';
import 'package:mxcome/com/mxcome/app/utils/Adapt.dart';
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import 'package:share_plus/share_plus.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseModel.dart';
import '../../../utils/AppUtils.dart';
import '../brand/BrandShopPage.dart';
import '../event/ActivityEvent.dart';
import '../mine/invite/MineLinkPage.dart';
import '../utils/EventBusUtil.dart';
import '../utils/Util.dart';
import '../widget/LoadImageView.dart';
import '../widget/FeaturedPromotion.dart';
import '../widget/PromotionHighlight.dart';
import 'ProductHeaderBar.dart';
import 'ProductTask.dart';
import '../event/ScrollEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/featured/ShopFeaturedScroller.dart';

class ProductSliver extends StatefulWidget {
  const ProductSliver({super.key});

  @override
  State<StatefulWidget> createState() => ProductSliverState();
}

class ProductSliverState extends BaseKeepAliveState<ProductSliver> {
  List<dynamic> activityList = [];

  List<String> activityMemberIds = [];

  dynamic activityEvent;

  dynamic qrcodeEvent;

  dynamic userInfoEvent;

  bool isLogin = false;
  dynamic userInfo;

  late ScrollController _scrollController;
  double _lastScrollOffset = 0;
  bool _isAtBottom = false;
  bool _isBouncing = false; // 回弹锁：防止回弹过程中误触发

  // 精选优惠相关数据
  List<dynamic> promotionCategories = []; // 分类列表
  List<dynamic> promotionItems = []; // 优惠券列表
  int _selectedCategoryIndex = 0; // 当前选中的分类索引
  int _promotionPageNum = 1;
  int _promotionPageSize = 10;
  bool _promotionHasMore = true;
  bool _promotionIsLoading = false;
  dynamic _currentPromotionCategory;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final pos = _scrollController.position;
      double currentOffset = pos.pixels;
      double maxExtent = pos.maxScrollExtent;

      // 回弹保护：到达底部附近后进入回弹锁定状态
      // 只有当用户明确往上滑离底部一定距离后才解锁
      if (currentOffset >= maxExtent) {
        // 触底了，进入回弹锁定
        _isBouncing = true;
        _lastScrollOffset = currentOffset;
        return;
      }

      if (_isBouncing) {
        // 正在回弹中，判断是否是真正的用户下滑还是物理回弹
        // 回弹后 offset 会回到 maxExtent 附近，只有用户继续往下拉才解锁
        if (currentOffset < maxExtent - 5) {
          // 已经离开底部区域，但需要判断方向
          // 如果 offset 在减小（回弹或用户下滑），先更新 _lastScrollOffset 但不触发事件
          _isBouncing = false;
          _lastScrollOffset = currentOffset;
          // 不触发任何事件，等下一次滚动再正常判断
          return;
        } else {
          // 还在底部附近晃动，继续锁定
          _lastScrollOffset = currentOffset;
          return;
        }
      }

      // 忽略顶部弹性越界
      if (pos.pixels < pos.minScrollExtent) return;

      if (currentOffset > _lastScrollOffset && currentOffset > 50) {
        // 上滑（内容往上移动）→ 隐藏广告
        if (!_isAtBottom) {
          _isAtBottom = true;
          EventBusUtil.getInstance().emit(ScrollEvent(ScrollDirection.down));
        }
      } else if (currentOffset < _lastScrollOffset) {
        // 下滑（内容往下移动）→ 显示广告
        if (_isAtBottom) {
          _isAtBottom = false;
          EventBusUtil.getInstance().emit(ScrollEvent(ScrollDirection.up));
        }
      }

      _lastScrollOffset = currentOffset;
    });
    // 加载精选优惠数据
    loadPromotionCategories();
    qrcodeEvent = EventBusUtil.getInstance().on<QRCodeEvent>((event) {
      if (TextUtils.isNotEmpty(event.content)) {
        if (event.content.startsWith(PageConstant.MXCOME_WEB_URI)) {
          parserWebScanResult(Uri.parse(event.content));
        } else {
          parserAppScanResult(Uri.parse(event.content));
        }
      }
    });
    activityEvent = EventBusUtil.getInstance().on<ActivityEvent>((event) {
      if (event.activityType == ActivityType.complete) {
        refreshServiceTime();
        loadContentDatas();
      }
    });
    userInfoEvent = EventBusUtil.getInstance().on<UserInfoEvent>((event) async {
      bool loginState = await AppUtils.isLogined();
      if (loginState) {
        dynamic data = await AppUtils.getUserInfo();
        setState(() {
          userInfo = data;
          isLogin = loginState;
        });
      } else {
        setState(() {
          userInfo = null;
          isLogin = false;
        });
      }
    });
    loadContentDatas();
  }

  parserWebScanResult(Uri? uri) {
    try {
      if (uri == null) return;
      Map<String, dynamic> params = uri.queryParameters;
      if (params.isNotEmpty && params.keys.contains("pageName")) {
        String pageName = params["pageName"] ?? '';
        if (pageName.isNotEmpty && pageName == "ProductDetail") {
          String productId = params["productId"] ?? '';
          nextPageState(ProductDetailPage(productId), false);
        }
      } else {
        params = {};
      }
      TextUtils.println(params);
    } catch (e) {
      TextUtils.println(e);
    }
  }

  parserAppScanResult(Uri? uri) {
    try {
      if (uri == null) return;
      String path = uri.path;
      if (path.isNotEmpty && path.contains("bind")) {
        List<String> segments = uri.pathSegments;
        String superiorId = segments.last;
        showPop(
            0.54 * Adapt.getWindowHeight(),
            BindSuperiorPage(
              superiorId: superiorId,
            ));
      }
    } catch (e) {
      TextUtils.println(e);
    }
  }

  refreshServiceTime() async {
    BaseRsp res = await HttpUtils.post(IURLConstant.MALL_GET_SERVICE_TIME, {});
    Logger.info(res);
    setState(() {
      serviceTime = res.data;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    refreshServiceTime();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    EventBusUtil.getInstance().off(activityEvent);
    EventBusUtil.getInstance().off(qrcodeEvent);
    EventBusUtil.getInstance().off(userInfoEvent);
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    bool loginState = await AppUtils.isLogined();
    if (loginState) {
      dynamic data = await AppUtils.getUserInfo();
      setState(() {
        userInfo = data;
        isLogin = loginState;
      });
    } else {
      setState(() {
        userInfo = null;
        isLogin = false;
      });
    }
    isLoading = true;
    List<String> activityIds = await AppUtils.getActivityMemberIds();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_ACTIVITY_LIST,
        {"isReceive": "0", "pageNum": "1", "pageSize": "6"});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        activityMemberIds = activityIds;
        List<dynamic> list = BaseModel.isNotEmpty(rsp.data, "list")
            ? BaseModel.getDynamic(rsp.data, "list")
            : [];
        datas = list;
      });
    }
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return EasyRefresh(
        triggerAxis: Axis.vertical,
        header: const MaterialHeader(color: IConstant.main_color),
        footer: CupertinoFooter(
            emptyWidget: Container(
          padding: EdgeInsets.all(10.w),
          child: Text(LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_more),
              style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
        )),
        onLoad: () => _onLoadMore(),
        onRefresh: () => _onRefresh(),
        child: myCustomScrollView());
  }

  Future<void> _onRefresh() async {
    isLoading = false;
    page = 1;
    count = 0;

    // 刷新精选优惠数据
    if (_currentPromotionCategory != null) {
      await loadPromotionItems(_currentPromotionCategory, isLoadMore: false);
    } else {
      await loadPromotionCategories();
    }

    EventBusUtil.getInstance().emit(ActivityEvent());
    EventBusUtil.getInstance().emit(HomeEvent());
    EventBusUtil.getInstance().emit(BalanceEvent());
    await Future.delayed(const Duration(milliseconds: 800), () {});
  }

  Future<IndicatorResult> _onLoadMore() async {
    if (_currentPromotionCategory != null && _promotionHasMore) {
      await loadPromotionItems(_currentPromotionCategory, isLoadMore: true);
      if (!_promotionHasMore) {
        return IndicatorResult.noMore;
      }
      return IndicatorResult.success;
    }
    return IndicatorResult.noMore;
  }

  CustomScrollView myCustomScrollView() {
    return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        slivers: <Widget>[
          ProductHeaderBar(true), // 任务头
          // 任务列表
          SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
            return ProductTask();
          }, childCount: 1)),
          // 横向店铺列表
          SliverToBoxAdapter(
            child: _buildShopFeaturedScroller(),
          ),
          // 当活动为空时隐藏活动列表
          if (datas.isNotEmpty) ...[
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return buildActivity();
              }, childCount: 1),
            ),
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return buildActivityItem(index);
              }, childCount: datas.length),
            ),
            SliverToBoxAdapter(
              child: InkWell(
                onTap: () {
                  nextPage(HotActivityPage(), false);
                },
                child: Container(
                  width: 340.w,
                  padding: EdgeInsets.symmetric(vertical: 6.w),
                  margin:
                      EdgeInsets.only(bottom: 15.w, left: 18.w, right: 18.w),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          width: 1.w, color: const Color(0x8C292929)),
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: Text(
                    LanguageConfig.get(LanguageConfigKeys.shop_home_load_more),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: IConstant.text_color,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
          // 精选优惠组件
          SliverToBoxAdapter(
            child: _buildFeaturedPromotion(),
          ),
          // KOL 分享
          SliverToBoxAdapter(
            child: buildKOLShare(),
          ),
        ]);
  }

  Widget buildActivity() {
    return GestureDetector(
      onTap: () {
        nextPage(HotActivityPage(), false);
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 10.w),
          padding: EdgeInsets.fromLTRB(12.w, 10.w, 12.w, 10.w),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Image.asset("assets/icons/hot.png", width: 18.w, height: 18.w),
            SizedBox(width: 6.w),
            Text(
              LanguageConfig.get(LanguageConfigKeys.Shop_product_hot_activity),
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: IConstant.title_color),
            ),
            Icon(Icons.chevron_right, size: 22.w),
          ])),
    );
  }

  Widget buildActivityItem(int index) {
    dynamic activity = datas[index];
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10, //阴影范围
            spreadRadius: 0.1, //阴影浓度
            color: Colors.grey.withOpacity(0.3), //阴影颜色
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.w)),
            child: InkWell(
              onTap: () async {
                //activityStart(activity, false);
                gotoActivity(activity);
              },
              child: LoadImageView(
                  double.infinity, 92.w, BaseModel.getString(activity, "img"),
                  alignment: Alignment.topCenter),
            ),
          ),
          SizedBox(
            height: 4.w,
          ),
          // LinearProgressIndicator(
          //   value: getTimeDouble(activity),
          //   backgroundColor: IConstant.white_color,
          //   valueColor: const AlwaysStoppedAnimation<Color>(IConstant.main_color),
          // ),
          Row(
            children: [
              Expanded(
                  flex: 4,
                  child: InkWell(
                    onTap: () {
                      nextPage(
                          BrandShopPage(
                              BaseModel.getString(activity, "shopId")),
                          false);
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipOval(
                              child: LoadImageView(30.w, 30.w,
                                  BaseModel.getString(activity, "shopIcon"))),
                          SizedBox(width: 6.w),
                          Expanded(
                              child: Text(
                                  BaseModel.getString(activity, "shopName"),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: IConstant.title_color)))
                        ],
                      ),
                    ),
                  )),
              Expanded(flex: 5, child: buildStopTime(activity)),
              Expanded(
                  flex: 4,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(16.w, 6.w, 8.w, 8.w),
                    child: buildRightItem(activity),
                  ))
            ],
          )
        ],
      ),
    );
  }

  gotoActivity(dynamic activity) async {
    if (!await AppUtils.isLogined()) {
      toLogin((ctx) => {
            setState(() {
              finishContext(ctx);
            })
          });
    } else {
      ViewUtils.show();
      BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_ACTIVITY_MEMBER_INFO,
          {"activityId": BaseModel.getString(activity, "id")});
      if (rsp.retCode == RspRetCode.SUCCESS) {
        gotoPage(activity, rsp.data, false);
      } else {
        ViewUtils.dismiss();
        ViewUtils.displayToast(rsp.msg);
      }
    }
  }

  double getTimeDouble(dynamic item) {
    DateTime createTime =
        DateTime.parse(BaseModel.getString(item, "createTime"));
    DateTime endTime = DateTime.parse(BaseModel.getString(item, "endTime"));
    int spaceTime =
        endTime.millisecondsSinceEpoch - createTime.millisecondsSinceEpoch;
    int currentSpaceTime =
        endTime.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
    return (currentSpaceTime / spaceTime);
  }

  Widget buildRightItem(dynamic activity) {
    if (activityMemberIds.contains(BaseModel.getString(activity, "id"))) {
      return InkWell(
          onTap: () {
            //activityStart(activity, true);
            gotoActivity(activity);
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(8.w, 6.w, 10.w, 6.w),
            decoration: BoxDecoration(
                color: IConstant.red_bg_color3,
                borderRadius: BorderRadius.circular(20.w)),
            child: Text(
                LanguageConfig.get(LanguageConfigKeys.Shop_pocket_participated),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11.sp, color: IConstant.main_color)),
          ));
    } else {
      return InkWell(
          onTap: () {
            gotoActivity(activity);
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(10.w, 6.w, 10.w, 6.w),
            decoration: BoxDecoration(
                color: IConstant.main_color,
                borderRadius: BorderRadius.circular(20.w)),
            child: Text(
                LanguageConfig.get(LanguageConfigKeys.Shop_pocket_join_now),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
          ));
    }
  }

  Widget buildStopTime(dynamic item) {
    String endTime = BaseModel.getString(item, "endTime");
    return CountDownView(
        startTime: serviceTime,
        endTime: endTime,
        fontSize: 11.w,
        textColor: IConstant.main_color,
        prefix: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_remain),
        stop: LanguageConfig.get(LanguageConfigKeys.Shop_activity_closed));
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
      margin: EdgeInsets.all(10.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.w, color: IConstant.text_color),
          borderRadius: BorderRadius.circular(12.r),
        ),
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
              Container(
                  constraints: BoxConstraints(maxWidth: 180.w),
                  child: Text(
                      LanguageConfig.get(
                          LanguageConfigKeys.Login_input_kol_share),
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: IConstant.text_color,
                          fontWeight: FontWeight.bold))),
            ],
          ),
          InkWell(
            onTap: () {
              if (isLogin) {
                showPop(0.7 * Adapt.getWindowHeight(), MineLinkPage());
              } else {
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
                        ).image))),
          )
        ],
      ),
    );
  }

  Widget buildKolShareWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
      margin: EdgeInsets.all(10.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.w, color: IConstant.sub_title_color),
          borderRadius: BorderRadius.circular(12.r),
        ),
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
              Container(
                  constraints: BoxConstraints(maxWidth: 180.w),
                  child: Text(
                      LanguageConfig.get(
                          LanguageConfigKeys.Login_input_kol_recommend),
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: IConstant.text_color,
                          fontWeight: FontWeight.bold))),
            ],
          ),
          InkWell(
            onTap: () {
              if (isLogin) {
                shareWeb();
              } else {
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
                        ).image))),
          )
        ],
      ),
    );
  }

  Future<void> shareWeb() async {
    String kolName = BaseModel.getString(userInfo, "kolName");
    String shareUrl = Util.getShareKolURL(kolName);
    Share.share(shareUrl);
  }

  /// 加载精选优惠分类数据
  Future<void> loadPromotionCategories() async {
    // 这里使用硬编码的分类数据，实际应该从接口获取
    setState(() {
      promotionCategories = featuredPromotionCategories;
    });
    // 加载第一个分类的优惠券
    if (promotionCategories.isNotEmpty) {
      loadPromotionItems(promotionCategories[0]);
    }
  }

  /// 加载指定分类的优惠券数据
  Future<void> loadPromotionItems(dynamic category,
      {bool isLoadMore = false}) async {
    if (_promotionIsLoading) return;

    if (!isLoadMore) {
      _promotionPageNum = 1;
      _promotionHasMore = true;
      _currentPromotionCategory = category;
      setState(() {
        promotionItems = [];
      });
    }

    if (!_promotionHasMore) return;

    _promotionIsLoading = true;
    try {
      String categoryId = BaseModel.getString(category, 'id');
      var rsp = await HttpUtils.post(IURLConstant.MALL_COUPON_LIST, {
        'type': categoryId,
        'pageNum': _promotionPageNum.toString(),
        'pageSize': _promotionPageSize.toString(),
      });
      if (rsp.retCode == 200) {
        List<dynamic> newItems =
            BaseModel.getDynamicList(rsp.data, 'list') ?? [];

        setState(() {
          if (isLoadMore) {
            promotionItems.addAll(newItems);
          } else {
            promotionItems = newItems;
          }

          if (newItems.length < _promotionPageSize) {
            _promotionHasMore = false;
          } else {
            _promotionPageNum++;
          }
        });
      }
    } catch (e) {
      print('加载优惠券失败: $e');
    } finally {
      _promotionIsLoading = false;
    }
  }

  /// 构建精选优惠组件
  Widget _buildFeaturedPromotion() {
    return FeaturedPromotion(
      categories: promotionCategories,
      promotionItems: promotionItems,
      onCategoryTap: (category) {
        // 处理分类点击，加载对应分类的优惠券
        loadPromotionItems(category);
      },
      onPromotionTap: (item) {
        // 处理商品点击
        print('点击商品：${item}');
      },
    );
  }

  // 精选店铺组件
  Widget _buildShopFeaturedScroller() {
    return const ShopFeaturedScroller();
  }
}
