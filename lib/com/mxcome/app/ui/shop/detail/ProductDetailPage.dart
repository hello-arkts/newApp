import 'dart:collection';
import 'dart:convert';

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/brand/BrandShopPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/cart/CartPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CouponDrawerComponents.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/detail/ProductProtocolPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/CartEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/HomeEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/ReceiveTaskEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/CartItem.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/ReadCount.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/order/OrderConfirmPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/search/SearchDelegateBar.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/BigTextButton.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/LoadImageView.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/OutlineTextButton.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/SmallTextButton.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import '../../../BaseKeepAliveState.dart';
import '../../../IURLConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseModel.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/HttpUtils.dart';
import '../cart/CartBadge.dart';
import '../event/CollectEvent.dart';
import '../event/ProductDetailEvent.dart';
import '../model/SkuModel.dart';
import '../model/SpecModel.dart';
import '../utils/EventBusUtil.dart';
import '../widget/CartNumberView.dart';
import '../widget/PriceText.dart';
import 'ProductHtml.dart';
import 'ProductInfo.dart';
import 'ProductParamPage.dart';

class ProductDetailPage extends StatefulWidget {
  String productId;

  String pocketCode;

  String activityId;

  bool isLottery;

  ProductDetailPage(this.productId,
      {this.pocketCode = "", this.activityId = "", this.isLottery = false});

  @override
  State<StatefulWidget> createState() {
    return ProductDetailPageState();
  }
}

class ProductDetailPageState extends BaseKeepAliveState<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  String loading = LanguageConfig.get(LanguageConfigKeys.Loading);

  final titles = [
    LanguageConfig.get(LanguageConfigKeys.Shop_product_goods),
    LanguageConfig.get(LanguageConfigKeys.Shop_product_detail),
    LanguageConfig.get(LanguageConfigKeys.Shop_product_shop),
  ];

  late TabController tabController;

  final childScrollController = ScrollController();

  final GlobalKey productInfoKey = GlobalKey();

  var productInfoHeight = 0.0;

  double toolbarOpacity = 1.0;

  String productId = "";

  dynamic _product;

  dynamic _shopDetail;

  int _isNeedAgree = 0;

  List<dynamic> _productAttributeList = [];

  List<dynamic> _productAttributeValueList = [];

  List<dynamic> _skuStockList = [];

  List<SkuModel> skuList = [];

  int _number = 1;

  SkuModel? _skuModel;

  String _choiceValues = "";

  Map<String, String> _choiceMap = HashMap();

  int cartNumber = 0;

  dynamic productDetailEvent;

  dynamic cartEvent;

  bool isTaskProd = false;

  bool isCollection = false;

  bool isReloadCollect = false;

  ReadCount detailReadCount = ReadCount(IConstant.activity_detail_count, 0, 1);

  bool isShowToolbar = true;

  @override
  void initState() {
    super.initState();
    productId = widget.productId;
    tabController = TabController(vsync: this, length: titles.length);
    childScrollController.addListener(() {
      // double t = childScrollController.offset / 100;
      // if(t > 1.0 && !isShowToolbar) {
      //   isShowToolbar = true;
      //   toolbarOpacity = 1.0;
      //   setState(() {});
      // }else if(t < 1.0 && isShowToolbar){
      //   isShowToolbar = false;
      //   toolbarOpacity = 0.0;
      //   setState(() {});
      // }
      if (childScrollController.position.userScrollDirection ==
              ScrollDirection.forward &&
          !isShowToolbar) {
        isShowToolbar = true;
        toolbarOpacity = 1.0;
        setState(() {});
      } else if (childScrollController.position.userScrollDirection ==
              ScrollDirection.reverse &&
          isShowToolbar) {
        isShowToolbar = false;
        toolbarOpacity = 0.0;
        setState(() {});
      }
      if (childScrollController.offset >= productInfoHeight) {
        tabController.animateTo(1);
      } else {
        tabController.animateTo(0);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final size = productInfoKey.currentContext!.size ?? Size.zero;
      productInfoHeight = size.height;
    });
    productDetailEvent =
        EventBusUtil.getInstance().on<ProductDetailEvent>((event) {
      if (event.optionStatus == OptionStatus.spec) {
        openBottomSheet(context, 0);
      } else if (event.optionStatus == OptionStatus.param) {
        showPop(
            0.7 * Adapt.getWindowHeight(),
            ProductParamPage(
                _productAttributeList, _productAttributeValueList));
      } else if (event.optionStatus == OptionStatus.isTaskProd) {
        setState(() {
          isTaskProd = true;
        });
      }
    });
    cartEvent = EventBusUtil.getInstance().on<CartEvent>((event) {
      if (event.cartType == CartType.complete) {
        loadCartNum();
      }
    });
    loadVipProtocol();
    loadContentDatas();
    loadCollectList();
  }

  Future<void> loadVipProtocol() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_SELECT_AGREE, {
      "productId": productId,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      _isNeedAgree = BaseModel.getInt(rsp.data, "isAgree");
    }
  }

  @override
  void dispose() {
    if (isReloadCollect) {
      EventBusUtil.getInstance().emit(HomeEvent());
      EventBusUtil.getInstance().emit(CollectEvent());
    }
    EventBusUtil.getInstance().off(productDetailEvent);
    EventBusUtil.getInstance().off(cartEvent);
    super.dispose();
    childScrollController.dispose();
    tabController.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    BaseRsp rsp = await HttpUtils.post(
        "${IURLConstant.MALL_PRODUCT_DETAIL}$productId", {"id": productId});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        _product = rsp.data;
        _skuStockList = BaseModel.getDynamic(rsp.data, "skuStockList");
        _productAttributeList =
            BaseModel.isNotEmpty(rsp.data, "productAttributeList")
                ? BaseModel.getDynamic(rsp.data, "productAttributeList")
                : [];
        _productAttributeValueList =
            BaseModel.isNotEmpty(rsp.data, "productAttributeValueList")
                ? BaseModel.getDynamic(rsp.data, "productAttributeValueList")
                : [];
      });
      final int shopId = BaseModel.getInt(_product ?? {}, 'shopId');
      if (shopId > 0) {
        await _loadShopDetail(shopId);
      }
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    loadCartNum();
    detailReadCount =
        await AppUtils.getReadCount(IConstant.activity_detail_count);
  }

  Future<void> _loadShopDetail(int shopId) async {
    try {
      final rsp = await HttpUtils.post(IURLConstant.MALL_PRODUCT_BY_SHOPID, {'shopId': shopId});
      if (rsp.retCode == RspRetCode.SUCCESS && rsp.data != null) {
        setState(() {
          _shopDetail = rsp.data;
        });
      }
    } catch (e) {
      // ignore error, shop details will not be shown
    }
  }

  Future<void> loadCartNum() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_CART_LIST, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<dynamic> tempList = rsp.data;
      await AppUtils.setCartData(tempList);
      setState(() {
        cartNumber = tempList.length;
      });
    }
  }

  Future<void> loadCollectList() async {
    bool isExist = false;
    List<dynamic> dataList = await AppUtils.getCollectData();
    for (var item in dataList) {
      if (productId == BaseModel.getString(item, "productId")) {
        isExist = true;
        break;
      }
    }
    setState(() {
      isCollection = isExist;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // 解析店铺相关数据，商品详情接口返回的是 shop 对象
    final dynamic shopData =
        _product != null ? BaseModel.getDynamic(_product, 'shop') ?? {} : {};

    // 店铺名称和Logo从商品接口的shop对象获取
    final String shopName = BaseModel.getString(shopData, 'name').isNotEmpty
        ? BaseModel.getString(shopData, 'name')
        : '';

    final String shopLogo = BaseModel.getString(shopData, 'logo');

    // 地址和电话从店铺详情API获取，使用优惠券API的字段名
    final String shopAddress = _shopDetail != null
        ? (BaseModel.getString(_shopDetail, 'addressZh').isNotEmpty
            ? BaseModel.getString(_shopDetail, 'addressZh')
            : (BaseModel.getString(_shopDetail, 'addressTh').isNotEmpty
                ? BaseModel.getString(_shopDetail, 'addressTh')
                : BaseModel.getString(_shopDetail, 'addressEn')))
        : BaseModel.getString(shopData, 'address');

    final String shopPhone = _shopDetail != null
        ? BaseModel.getString(_shopDetail, 'addressPhone') ?? ''
        : BaseModel.getString(shopData, 'phone');

    // 使用外层 product 的 shopId 或 shop.id
    final int shopId = BaseModel.getInt(_product ?? {}, 'shopId') > 0
        ? BaseModel.getInt(_product ?? {}, 'shopId')
        : BaseModel.getInt(shopData, 'id');

    // 构造 shopList 数据用于抽屉地图选择器
    // 优先使用店铺详情API的数据，如果没有则使用商品接口的shop数据
    List<dynamic> shopList;
    if (_shopDetail != null) {
      shopList = [_shopDetail];
    } else if (_product != null && shopData.isNotEmpty) {
      // 将商品接口的shop数据转换为适配格式，确保字段名一致
      final Map<String, dynamic> adaptedShop = {
        'id': shopId,
        'name': shopName,
        'logoUrl': shopLogo,
        'addressZh': BaseModel.getString(shopData, 'address'),
        'addressPhone': BaseModel.getString(shopData, 'phone'),
      };
      shopList = [adaptedShop];
    } else {
      shopList = [];
    }

    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: buildAppBar(),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              // 店铺头部信息组件固定在顶部，不随内容滚动
              if (_product != null && shopId > 0)
                Container(
                  color: IConstant.white_color, // 保持白色背景
                  padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
                  child: CouponShopTabHeaderSection(
                    logoUrl: shopLogo,
                    name: shopName,
                    address: shopAddress,
                    phone: shopPhone,
                    shopId: shopId,
                    shopName: shopName,
                    onNavigateTap: () async {
                      if (shopList.isEmpty) {
                        ViewUtils.displayToast(LanguageConfig.get(
                            LanguageConfigKeys.ViewUtils_no_data));
                        return;
                      }

                      // 弹出一个包含 CouponStorePickerActionSection 的底部抽屉，跟 CouponDetailDrawer 一致
                      await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (BuildContext context) {
                          return DraggableScrollableSheet(
                            initialChildSize: 0.5,
                            minChildSize: 0.3,
                            maxChildSize: 0.9,
                            builder: (_, controller) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16.w)),
                                ),
                                padding:
                                    EdgeInsets.fromLTRB(16.w, 0, 16.w, 32.w),
                                child: StatefulBuilder(
                                  builder: (context, setModalState) {
                                    final store = shopList[0];
                                    // 支持两种数据结构：店铺详情API的addressZh和商品接口的address
                                    final String address =
                                        BaseModel.getString(store, 'addressZh').isNotEmpty
                                            ? BaseModel.getString(store, 'addressZh')
                                            : (BaseModel.getString(store, 'addressTh').isNotEmpty
                                                ? BaseModel.getString(store, 'addressTh')
                                                : (BaseModel.getString(store, 'addressEn').isNotEmpty
                                                    ? BaseModel.getString(store, 'addressEn')
                                                    : BaseModel.getString(store, 'address')));

                                    return SingleChildScrollView(
                                      controller: controller,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Center(
                                            child: GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () =>
                                                  Navigator.pop(context),
                                              child: Container(
                                                width: double.infinity,
                                                alignment: Alignment.center,
                                                child:
                                                    const CouponDrawerHandle(),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 6.w),
                                          CouponStorePickerActionSection(
                                            addressText: address,
                                            shopList: shopList,
                                            selectedIndex: 0,
                                            shopName: shopName,
                                            onSelectIndex: (int index) {
                                              // 详情页通常只有一家店，不做切换处理
                                            },
                                            onNoDataTap: () {
                                              ViewUtils.displayToast(
                                                  LanguageConfig.get(
                                                      LanguageConfigKeys
                                                          .ViewUtils_no_data));
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    couponList: const [],
                    activeCouponIdListenable: ValueNotifier(''),
                    onSelectCouponId: (_) {},
                    shopList: shopList,
                    selectedStoreIndex: 0,
                    onStoreSelected: (index) {},
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  controller: childScrollController,
                  child: Column(
                    children: [
                      Container(
                        key: productInfoKey,
                        child: _product == null
                            ? SizedBox(
                                height:
                                    MediaQuery.of(context).size.height - 200,
                                child: ViewUtils.buildLoading())
                            : ProductInfo(
                                _product,
                                activityId: widget.activityId,
                                showParameter: _productAttributeList.isNotEmpty,
                              ),
                      ),
                      Container(
                          key: UniqueKey(),
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: _product == null
                              ? const SizedBox()
                              : ProductHtml(_product)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: (_product != null && shopId > 0)
                ? 70.w
                : 5.w, // 店铺栏高度大约 64w + 上下内边距，所以大概设 70w
            child: Opacity(
              opacity: toolbarOpacity,
              child: Container(
                width: 220.w,
                height: 36.w,
                color: Colors.transparent,
                child: buildPreferredSize(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: InkWell(
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
                  width: 18.w, height: 18.w, color: IConstant.sub_text_color),
              Expanded(
                  child: Padding(
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
              //         margin: EdgeInsets.only(left: 5.w, right: 10.w),
              //         child: Image.asset("assets/icons/camera.png",
              //             width: 18.w, height: 18.w, color: IConstant.sub_text_color),)),
              // ),
            ]),
          ),
        ),
      ),
      actions: <Widget>[
        InkWell(
            onTap: () {
              goCartIsLogin();
            },
            child: Container(
              margin: EdgeInsets.only(left: 5.w, right: 5.w),
              child: CartBadge(cartNumber: cartNumber),
            )),
        // buildShareAction()
      ],
    );
  }

  Widget buildPreferredSize() {
    return Material(
      color: const Color(0xCCF0F0F0),
      borderRadius: BorderRadius.all(Radius.circular(20.r)),
      child: TabBar(
        dividerColor: Colors.transparent,
        controller: tabController,
        tabs: titles.map((item) => getTab(item)).toList(),
        padding: EdgeInsets.all(3.w),
        labelPadding: EdgeInsets.zero,
        labelColor: IConstant.text_color,
        unselectedLabelColor: IConstant.text_color,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(18.w),
          color: Colors.white,
        ),
        onTap: (index) {
          if (tabController.indexIsChanging) {
            switch (index) {
              case 0:
                childScrollController.jumpTo(0);
                tabController.animateTo(0);
                break;
              case 1:
                childScrollController.jumpTo(productInfoHeight);
                tabController.animateTo(1);
                break;
              case 2:
                childScrollController.jumpTo(productInfoHeight);
                tabController.animateTo(1);
                if (isReloadCollect) {
                  EventBusUtil.getInstance().emit(HomeEvent());
                  EventBusUtil.getInstance().emit(CollectEvent());
                }
                nextPage(BrandShopPage(BaseModel.getString(_product, "shopId")),
                    false);
                break;
            }
          }
        },
      ),
    );
  }

  Tab getTab(dynamic item) {
    return Tab(
        child: Container(
      width: 65.w,
      height: 36.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.w),
        color: Colors.transparent,
      ),
      child: Center(
        child: Text(item,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 12.sp)),
      ),
    ));
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 70.w,
      child: Container(
        margin: EdgeInsets.only(right: 10.w),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: buildHeart(),
            ),
            // Expanded(
            //     flex: 2,
            //     child: IconButton(icon: Image.asset("assets/icons/chat.png", width: 24.w, height: 24.w), onPressed: (){
            //       ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_coming_soon));
            //     },),
            // ),
            Expanded(
              flex: 2,
              child: IconButton(
                icon: Image.asset("assets/icons/add_cart.png",
                    width: 24.w, height: 24.w),
                onPressed: () {
                  openBottomSheet(context, 1);
                },
              ),
            ),
            Expanded(flex: isTaskProd ? 2 : 4, child: const SizedBox()),
            Expanded(
              flex: 4,
              child: OutlineTextButton(
                  text: LanguageConfig.get(
                      LanguageConfigKeys.Shop_product_now_buy),
                  top: 8.w,
                  bottom: 8.w,
                  onTap: () => openBottomSheet(context, 2)),
            ),
            SizedBox(width: 10.w),
            isTaskProd ? buildBadge() : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget buildBadge() {
    return badges.Badge(
      showBadge: detailReadCount.isUnread(),
      position: badges.BadgePosition.topEnd(top: -8, end: 0),
      badgeContent:
          Text("", style: TextStyle(fontSize: 10.sp, color: Colors.white)),
      child: SmallTextButton(
          text: LanguageConfig.get(LanguageConfigKeys.Shop_product_mxget),
          top: 8.w,
          bottom: 8.w,
          left: 20.w,
          right: 20.w,
          onTap: () => gotoMXGet()),
    );
  }

  Widget buildHeart() {
    return IconButton(
      icon: Image.asset(
          isCollection
              ? "assets/icons/heart_red.png"
              : "assets/icons/heart_grey.png",
          width: 24.w,
          height: 24.w),
      onPressed: () {
        isCollection ? delete() : add();
      },
    );
  }

  Future<void> add() async {
    bool isLogin = await AppUtils.isLogined();
    if (isLogin) {
      doAdd();
    } else {
      toLogin((ctx) => {
            setState(() {
              finishContext(ctx);
              doAdd();
            })
          });
    }
  }

  Future<void> doAdd() async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.postJSON(IURLConstant.MALL_COLLECTION_ADD, {
      "productId": BaseModel.getString(_product, "id"),
      "productName": BaseModel.getString(_product, "name"),
      "productPic": BaseModel.getString(_product, "pic"),
      "productPrice": BaseModel.getString(_product, "price"),
      "productSubTitle": BaseModel.getString(_product, "subTitle"),
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        isCollection = true;
      });
      loadContentDatas();
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    isReloadCollect = true;
    ViewUtils.dismiss();
  }

  Future<void> delete() async {
    bool isLogin = await AppUtils.isLogined();
    if (isLogin) {
      doDelete();
    } else {
      toLogin((ctx) => {
            setState(() {
              finishContext(ctx);
              doDelete();
            })
          });
    }
  }

  Future<void> doDelete() async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_COLLECTION_DELETE,
        {"productId": BaseModel.getString(_product, "id")});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        isCollection = false;
      });
      loadContentDatas();
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    isReloadCollect = true;
    ViewUtils.dismiss();
  }

  Future<void> gotoMXGet() async {
    EventBusUtil.getInstance().emit(ReceiveTaskEvent(_product));
    isReloadCollect = true;
    setState(() {
      detailReadCount.read = 0;
    });
    await AppUtils.setReadCount(
        IConstant.activity_detail_count, detailReadCount);
  }

  openBottomSheet(BuildContext context, int type) {
    if (_product == null) {
      ViewUtils.displayToast(loading);
      return;
    }
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isDismissible: false,
        isScrollControlled: true,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              List<Widget> widgetList = loadSkuData(setState);
              return Container(
                height: 0.8 * Adapt.getWindowHeight(),
                decoration: BoxDecoration(
                    color: IConstant.white_color,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12.w))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 50.w,
                        height: 8.w,
                        margin: EdgeInsets.only(top: 4.w, bottom: 2.w),
                        decoration: BoxDecoration(
                            color: IConstant.line_color,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.w))),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 10.w),
                        child: Center(
                            child: Text(
                                LanguageConfig.get(LanguageConfigKeys
                                    .Shop_product_select_spec),
                                style: TextStyle(
                                    fontSize: 17.sp,
                                    color: IConstant.text_color)))),
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.all(16.w),
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                          color: IConstant.white_color,
                          borderRadius: BorderRadius.all(Radius.circular(12.w)),
                          border: Border.all(
                              width: 1.w, color: IConstant.grey_bg_color)),
                      child: Row(
                        children: [
                          LoadImageView(80.w, 80.w, getProductPic()),
                          SizedBox(width: 10.w),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              PriceText(getChoicePrice()),
                              SizedBox(height: 4.w),
                              Text(
                                _choiceValues,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: IConstant.text_color),
                              )
                            ],
                          ))
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ListView.builder(
                        itemCount: widgetList.length,
                        itemBuilder: (context, index) {
                          return widgetList[index];
                        },
                      ),
                    ),
                    Container(
                        height: 60,
                        padding: EdgeInsets.only(left: 16.w),
                        child: Row(
                          children: [
                            Text(
                                LanguageConfig.get(
                                    LanguageConfigKeys.Shop_product_quantity),
                                style: TextStyle(
                                    fontSize: 17.sp,
                                    color: IConstant.text_color)),
                            SizedBox(width: 80.w),
                            CartNumberView(
                              _number,
                              (number) {
                                setState(() {
                                  _number = number;
                                });
                              },
                              limitNum: BaseModel.getInt(
                                  _product, 'productQuantityLimit'),
                            ),
                          ],
                        )),
                    Divider(height: 1.w),
                    Container(
                      height: 70.w,
                      margin: EdgeInsets.fromLTRB(40.w, 0.w, 40.w, 20.w),
                      child: Row(children: getButtons(type)),
                    )
                  ],
                ),
              );
            }));
  }

  String getProductPic() {
    if (_skuModel != null && TextUtils.isNotEmpty(_skuModel?.pic)) {
      return "${_skuModel?.pic}";
    } else {
      String pic = "";
      String pics = BaseModel.getString(_product, "albumPics");
      if (TextUtils.isEmpty(pics)) {
        pic = BaseModel.getString(_product, "pic");
      } else {
        pic = pics.split(",")[0];
      }
      return pic;
    }
  }

  double getChoicePrice() {
    if (_skuModel != null) {
      return _skuModel!.price;
    } else {
      return BaseModel.getDouble(_product, "price");
    }
  }

  List<Widget> getButtons(int type) {
    List<Widget> tempList = [];
    if (type == 1) {
      tempList.add(Expanded(
          flex: 1,
          child: BigTextButton(
              text:
                  LanguageConfig.get(LanguageConfigKeys.Shop_product_join_cart),
              top: 8.w,
              bottom: 8.w,
              onTap: () {
                addCartIsLogin();
              })));
    } else if (type == 2) {
      tempList.add(Expanded(
          flex: 1,
          child: BigTextButton(
              text: LanguageConfig.get(LanguageConfigKeys.Shop_product_now_buy),
              top: 8.w,
              bottom: 8.w,
              onTap: () {
                buyIsLogin();
              })));
    } else {
      tempList.add(Expanded(
          flex: 1,
          child: BigTextButton(
              text:
                  LanguageConfig.get(LanguageConfigKeys.Shop_product_join_cart),
              top: 8.w,
              bottom: 8.w,
              onTap: () {
                addCartIsLogin();
              })));
      tempList.add(SizedBox(width: 20.w));
      tempList.add(Expanded(
          flex: 1,
          child: BigTextButton(
              text: LanguageConfig.get(LanguageConfigKeys.Shop_product_now_buy),
              top: 8.w,
              bottom: 8.w,
              onTap: () {
                buyIsLogin();
              })));
    }
    return tempList;
  }

  List<Widget> loadSkuData(setState) {
    List<Widget> widgetDatas = [];
    LinkedHashMap<String, SpecModel> spDatas = LinkedHashMap();
    bool defaultSelect = true; //默认选择
    for (dynamic sku in _skuStockList) {
      skuList.add(SkuModel.fromJson(sku));
      List<dynamic> spDataList = jsonDecode(sku["spData"]);
      for (var spData in spDataList) {
        String key = spData["key"].toString();
        String value = spData["value"].toString();
        Set<String> valueSet = {};
        if (spDatas.containsKey(key)) {
          SpecModel? specModel = spDatas[key];
          if (specModel != null) {
            valueSet = specModel.valueSet;
          }
        }
        valueSet.add(value);
        SpecModel specModel = SpecModel(valueSet);
        spDatas.putIfAbsent(key, () => specModel);
        if (valueSet.length > 1) {
          defaultSelect = false;
        }
      }
    }
    if (defaultSelect) {
      spDatas.forEach((key, specModel) {
        _choiceMap.putIfAbsent(key, () => specModel.valueSet.elementAt(0));
      });
      Set<String> values = {};
      _choiceMap.forEach((key, value) {
        values.add(value);
      });
      updateChoiceValues(values, setState);
    }
    spDatas.forEach((key, specModel) {
      widgetDatas.add(Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(key,
                style: TextStyle(fontSize: 15.sp, color: IConstant.text_color)),
            SizedBox(height: 4.w),
            Wrap(spacing: 20, children: getSpecWidget(key, specModel, setState))
          ],
        ),
      ));
    });
    return widgetDatas;
  }

  List<Widget> getSpecWidget(String key, SpecModel specModel, setState) {
    List<Widget> specWidget = [];
    for (var value in specModel.valueSet) {
      specWidget.add(ChoiceChip(
        padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 8.w),
        label: Text(value,
            style: TextStyle(
                fontSize: 15.sp,
                color: _choiceMap.containsValue(value)
                    ? IConstant.white_color
                    : IConstant.text_color)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.w))),
        backgroundColor: IConstant.grey_bg_color,
        selectedColor: IConstant.main_color,
        selected: _choiceMap.containsValue(value),
        onSelected: (isSelect) => {
          if (isSelect) {updateChoiceMap(key, value, setState)}
        },
      ));
    }
    return specWidget;
  }

  updateChoiceMap(String key, String value, setState) {
    LinkedHashMap<String, String> choiceMap = LinkedHashMap();
    choiceMap.addAll(_choiceMap);
    choiceMap.remove(key);
    choiceMap.putIfAbsent(key, () => value);
    Set<String> values = {};
    choiceMap.forEach((key, value) {
      values.add(value);
    });
    setState(() {
      _choiceMap = choiceMap;
    });
    updateChoiceValues(values, setState);
  }

  updateChoiceValues(Set<String> values, setState) {
    String choiceValues = "";
    for (var element in skuList) {
      if (values.containsAll(element.valueSet)) {
        _skuModel = element;
        for (var item in element.valueSet) {
          choiceValues += "$item,";
        }
        break;
      }
    }
    if (TextUtils.isNotEmpty(choiceValues)) {
      choiceValues = choiceValues.substring(0, choiceValues.length - 1);
    }
    setState(() {
      _choiceValues = choiceValues;
    });
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

  void openCart() {
    showPop(0.9 * Adapt.getWindowHeight(), CartPage(fromDetail: true));
  }

  addCartIsLogin() async {
    bool isLogin = await AppUtils.isLogined();
    if (isLogin) {
      addCart();
    } else {
      toLogin((ctx) => {
            setState(() {
              finishContext(ctx);
              addCart();
            })
          });
    }
  }

  buyIsLogin() async {
    bool isLogin = await AppUtils.isLogined();
    if (isLogin) {
      buy();
    } else {
      toLogin((ctx) => {
            setState(() {
              finishContext(ctx);
              buy();
            })
          });
    }
  }

  void buy() {
    if (_skuModel == null) {
      ViewUtils.displayToast(
          LanguageConfig.get(LanguageConfigKeys.Shop_product_select_spec));
      return;
    }
    if (_isNeedAgree == 0) {
      showPop(
          0.9 * Adapt.getWindowHeight(),
          ProductProtocolPage(productId, (sure) {
            if (sure) {
              finish();
              goOrderConfirm();
            }
          }));
    } else {
      goOrderConfirm();
    }
  }

  void goOrderConfirm() {
    _isNeedAgree = 1;
    List<CartItem> selectCartList = [];
    CartItem cartItem = CartItem.fromProductToCartItem(
        _product, _skuModel!, _number, widget.pocketCode);
    selectCartList.add(cartItem);
    finishContext(context);
    EventBusUtil.getInstance().emit(CartEvent());
    nextPage(
        OrderConfirmPage(selectCartList, false, [],
            productId: productId, isLottery: widget.isLottery),
        false);
  }

  addCart() async {
    if (_skuModel == null) {
      ViewUtils.displayToast(
          LanguageConfig.get(LanguageConfigKeys.Shop_product_select_spec));
      return;
    }
    String productId = _skuModel!.productId;
    String brandName = _product["brandName"].toString();
    String productName = _product["name"].toString();
    String productPic = _product["pic"].toString();
    String price = "${_skuModel!.price}";
    String productCategoryId = _product["productCategoryId"].toString();
    String productAttr = _skuModel!.spData.toString();
    String productSkuId = _skuModel!.id;
    String productSkuCode = _skuModel!.skuCode;
    String quantity = _number.toString();
    String productSn = _product["productSn"].toString();
    String subTitle = _product["subTitle"].toString();
    BaseRsp rsp = await HttpUtils.postJSON(IURLConstant.MALL_CART_ADD, {
      "price": price,
      "productAttr": productAttr,
      "productBrand": brandName,
      "productCategoryId": productCategoryId,
      "productId": productId,
      "productName": productName,
      "productPic": productPic,
      "productSkuCode": productSkuCode,
      "productSkuId": productSkuId,
      "productSn": productSn,
      "productSubTitle": subTitle,
      "quantity": quantity,
      "pocketCode": widget.pocketCode
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        ViewUtils.displayToast(LanguageConfig.get(
            LanguageConfigKeys.Shop_product_cart_add_success));
        finishContext(context);
        EventBusUtil.getInstance().emit(CartEvent());
        loadCartNum();
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }
}
