import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/LanguagePage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/CollectEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/SortView.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IURLConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseModel.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/TextUtils.dart';
import '../cart/CartBadge.dart';
import '../cart/CartPage.dart';
import '../model/LabelModel.dart';
import 'SelectWherePage.dart';
import '../detail/ProductDetailPage.dart';
import '../model/SelectModel.dart';
import '../search/SearchDelegateBar.dart';
import '../utils/FormatUtil.dart';
import '../widget/LoadImageView.dart';

class BrandShopPage extends StatefulWidget {

  String shopId;

  bool isPop;

  BrandShopPage(this.shopId, {this.isPop = false});

  @override
  State<StatefulWidget> createState() => BrandShopPageState();

}

class BrandShopPageState extends BaseKeepAliveState<BrandShopPage> {

  dynamic shop;

  List<dynamic> categoryList3 = [];

  List<dynamic> categoryList4 = [];

  int category3Index = 0;

  int category4Index = 0;

  final String all = LanguageConfig.get(LanguageConfigKeys.Shop_order_all);

  List<SelectModel> optionalList = [];

  List<SelectModel> priceList = [];

  List<SelectModel> profitList = [];

  List<LabelModel> labelList = [];

  int cartNumber = 0;

  bool isExpand = false;

  String category3Name = '';

  String category4Name = '';

  bool showCondition = false;

  SortState priceState = SortState.INIT;

  SortState profitState = SortState.INIT;

  SortState saleState = SortState.INIT;

  dynamic collectEvent;

  @override
  void initState() {
    super.initState();
    collectEvent = EventBusUtil.getInstance().on<CollectEvent>((event) {
      if (event.collectType == CollectType.query) {
        loadProductLabel();
      }
    });
    loadContentDatas();
    loadCartNum();
  }

  @override
  void dispose() {
    super.dispose();
    EventBusUtil.getInstance().off(collectEvent);
  }

  @override
  Future<void> loadContentDatas() async {
    isLoading = true;
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_GET_SHOP_INFO, {
      "shopId": widget.shopId
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<LabelModel> tempList = [];
      List<dynamic> list = BaseModel.getDynamic(rsp.data, "labelList");
      for (var item in list) {
        tempList.add(LabelModel.fromJson(item, false));
      }
      setState(() {
        shop = rsp.data;
        labelList = tempList;
      });
    }
    rsp = await HttpUtils.post(IURLConstant.MALL_SHOP_CATEGORY_TREE, {
      "shopId": widget.shopId
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        category3Name = all;
        category4Name = '';
        categoryList3 = [];
        categoryList3 = rsp.data;
        categoryList3.insert(0, all);
        categoryList4 = [];
        // if(categoryList3[0] == all) {
        //   categoryList4 = [];
        // }else {
        //   categoryList4 = BaseModel.getDynamic(categoryList3[1], "children");
        // }
      });
    }
    isLoading = false;
    loadProductLabel();
  }

  void loadProductLabel() async {
    ViewUtils.show();
    String productCategoryId3 = getCategoryId3();
    String productCategoryId4 = getCategoryId4();
    String sort =getSort();
    // String profitSort = getProfitSort();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_GET_PRODUCT_LABEL, {
      "isReceive": getOptional("1"),
      "isProfitStatus": getOptional("2"),
      "isFamily": getOptional("3"),
      "isPeriod": getOptional("4"),
      "isFreePackage": getOptional("5"),
      "isOvertimeFree": getOptional("6"),
      "labelId": getLabel(),
      "pageNum": "$page",
      "pageSize": "10",
      "productCategoryId3": productCategoryId3,
      "productCategoryId4": productCategoryId4,
      "shopId": widget.shopId,
      "sort": sort,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        List<dynamic> list = BaseModel.isNotEmpty(rsp.data, "list") ? BaseModel.getDynamic(rsp.data, "list") : [];
        count = rsp.data["total"];
        if (page == 1) {
          datas = list;
        } else {
          datas.addAll(list);
        }
      });
    }
    ViewUtils.dismiss();
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: widget.isPop ? null : buildAppBar(),
      body: shop == null ? buildHeader() : buildBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFFFDBDB),
      elevation: 0.w,
      centerTitle: true,
      title: InkWell(
        onTap: () {
          showSearch(context: context, delegate: SearchDelegateBar());
        },
        child: Container(
          decoration: BoxDecoration(
              color: IConstant.white_translucent_color,
              borderRadius: BorderRadius.all(Radius.circular(40.w))),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 7.h, 0, 7.h),
            child: Row(children: [
              Image.asset("assets/icons/search.png",
                  width: 18.w, height: 18.w, color: IConstant.sub_text_color),
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
              //         margin: EdgeInsets.only(left: 5.w, right: 10.w),
              //         child: Image.asset("assets/icons/camera.png",
              //             width: 18.w, height: 18.w, color: IConstant.sub_text_color),)),
              // ),
            ]),
          ),
        ),
      ),
      actions: [
        InkWell(
            onTap: () {
              goCartIsLogin();
            },
            child: Container(
              margin: EdgeInsets.only(left: 5.w, right: 5.w),
              child: CartBadge(cartNumber: cartNumber),
            )),
      ],
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        widget.isPop ? buildPopShopHeader() : buildShopHeader(),
        Expanded(
          child: Stack(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isExpand = !isExpand;
                            });
                          },
                          child: Container(
                            height: 30.w,
                            padding: EdgeInsets.symmetric(horizontal: 14.w,),
                            margin: EdgeInsets.symmetric(horizontal: 19.w, vertical: 5.w),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1.w, color: isExpand ? const Color(0x8C292929) : IConstant.line_color),
                                borderRadius: BorderRadius.circular(17.r),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                category3Name == all ? Text(
                                  all,
                                  style: TextStyle(
                                    color: IConstant.text_color,
                                    fontSize: 13.sp,
                                  ),
                                ) : Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                        category3Name,
                                        style: TextStyle(
                                          color: IConstant.text_color,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.symmetric(horizontal: 5.w), child: Icon(Icons.arrow_forward_ios, size: 15.w, color: const Color(0xFFB5B5B5),),),
                                      Expanded(
                                        child: Text(
                                          category4Name,
                                          style: TextStyle(
                                            color: IConstant.text_color,
                                            fontSize: 13.sp,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(isExpand ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 24.w, color: IConstant.grey_color,),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      InkWell(
                          onTap: () {
                        // showPop(0.7 * Adapt.getWindowHeight(), SelectWherePage(optionalList, priceList, profitList, (ctx, args1, args2, args3){
                        //   finishContext(ctx);
                        //   optionalList = args1;
                        //   priceList = args2;
                        //   profitList = args3;
                        //   loadProductLabel();
                        // }));
                        setState(() {
                          showCondition = !showCondition;
                        });
                      }, child: Container(
                        padding: EdgeInsets.fromLTRB(16.w, 6.w, 16.w, 6.w),
                        decoration: BoxDecoration(
                          color: showCondition ? IConstant.red_bg_color3 : IConstant.line_color,
                          borderRadius: BorderRadius.circular(30.w),
                          border: Border.all(width: 1.w, color: showCondition ? IConstant.main_color : IConstant.white_color),
                        ),
                        child: Image.asset(
                          'assets/icons/shop_choose.png',
                          width: 15.w,
                          height: 15.w,
                        ),
                      )),
                      SizedBox(width: 16.w),
                    ],
                  ),
                  showCondition ? Container(
                    margin: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 0.w),
                    child: Row(
                      children: [
                        SortView(LanguageConfig.get(LanguageConfigKeys.Shop_brand_price), priceState, (state)  {
                          setState(() {
                            priceState = state;
                            profitState = SortState.INIT;
                            saleState = SortState.INIT;
                          });
                          page = 1;
                          datas = [];
                          loadProductLabel();
                        }),
                        SizedBox(width: 30.w),
                        SortView(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_share_profit), profitState, (state) {
                          setState(() {
                            priceState = SortState.INIT;
                            profitState = state;
                            saleState = SortState.INIT;
                          });
                          page = 1;
                          datas = [];
                          loadProductLabel();
                        }),
                        //SizedBox(width: 30.w),
                        // SortView(LanguageConfig.get(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_sale)), saleState, (state) {
                        //   setState(() {
                        //     priceState = SortState.INIT;
                        //     profitState = SortState.INIT;
                        //     saleState = state;
                        //   });
                        //   page = 1;
                        //   datas = [];
                        //   loadProductLabel();
                        // }),
                      ],
                    ),
                  ) : Container(),
                  labelList.isNotEmpty ? Container(
                    width: Adapt.getWindowWidth(),
                    margin: EdgeInsets.fromLTRB(16.w, 14.w, 16.w, 14.w),
                    child: Wrap(spacing: 8.w, children: labelList.map((item) => buildLabelItem(item)).toList()),
                  ) : Container(),
                  datas.isEmpty ? SizedBox(height: 400.w, child: ViewUtils.buildNoData(),) : Expanded(child: EasyRefresh(
                    footer: CupertinoFooter(emptyWidget: Container(
            padding: EdgeInsets.all(10.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_more), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
          )),
                    onLoad: ()=> onLoadMore(),
                    child: GridView.builder(
                      padding: EdgeInsets.all(16.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 190.w,
                    mainAxisSpacing: 16.w, //item上下间隔
                    crossAxisSpacing: 16.w, //item左右间隔
                      ),
                      itemCount: datas.length,
                      itemBuilder: (BuildContext context, int index) {
                    return buildListItem(index);
                      },
                    ),
                  ),
                  )
                ],
              ),
              Positioned(top: 50.w, child: isExpand ? buildCategoryListSelector() : Container()),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCategoryListSelector() {
    return Container(
      width: 255.w,
      height: 300.w,
      margin: EdgeInsets.only(left: 18.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x28000000),
            blurRadius: 12,
            offset: Offset(0, 2),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        children: [
          buildCategoryList3(),
          Container(color: IConstant.line_color, width: 1.w, margin: EdgeInsets.symmetric(vertical: 16.w),),
          buildCategoryList4()
        ],
      ),
    );
  }

  Widget buildCategoryList3() {
    return Expanded(flex: 2, child: ListView.separated(
        padding: EdgeInsets.only(top: 15.w, bottom: 15.w),
        scrollDirection: Axis.vertical,
        itemCount: categoryList3.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              setState(() {
                category3Index = index;
                refreshCategory4List();
              });
            },
            child: Padding(padding: EdgeInsets.fromLTRB(13.w, 8.w, 10.w, 8.w),
                child: Text(index == 0 ? all : BaseModel.getString(categoryList3[index], "categoryName"),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 14.sp,
                        fontWeight: index == category3Index ? FontWeight.bold : FontWeight.normal,
                        color: index == category3Index ? IConstant.text_color : IConstant.text_color.withOpacity(0.65)))
            ),);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(height: 6.w);
        }));
  }

  refreshCategory4List() {
    if(category3Index == 0) {
      setState(() {
        isExpand = false;
        categoryList4 = [];
      });
      autoLoadShopCategoryValue();
      loadProductLabel();
    }else {
      setState(() {
        categoryList4 = BaseModel.getDynamic(categoryList3[category3Index], "childrenList");
      });
    }
  }

  Widget buildCategoryList4() {
    return Expanded(flex: 3, child: ListView.separated(
        padding: EdgeInsets.only(left: 20.w, top: 15.w, bottom: 15.w),
        scrollDirection: Axis.vertical,
        itemCount: categoryList4.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              setState(() {
                category4Index = index;
                isExpand = false;
                loadProductLabel();
                autoLoadShopCategoryValue();
              });
            },
            child: Padding(padding: EdgeInsets.fromLTRB(10.w, 8.w, 10.w, 8.w),
                child: Text(getCategoryList4Name(categoryList4[index]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 14.sp,
                        fontWeight: index == category4Index ? FontWeight.bold : FontWeight.normal,
                        color: index == category4Index ? IConstant.text_color : IConstant.text_color.withOpacity(0.65)))
            ),);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(height: 6.w);
        }));
  }

  void autoLoadShopCategoryValue() async {
    if(category3Index == 0) {
      setState(() {
        category3Name = all;
        category4Name = '';
      });
    }else {
      setState(() {
        category3Name = BaseModel.getString(categoryList3[category3Index], "categoryName");
        category4Name = getCategoryList4Name(categoryList4[category4Index]);
      });
    }
  }

  String getCategoryId3() {
    String categoryId = "";
    if(category3Index == 0) {
      categoryId = "";
    }else {
      categoryId = BaseModel.getString(categoryList3[category3Index], "categoryId3");
    }
    return categoryId;
  }

  String getCategoryId4() {
    String categoryId = "";
    if(category3Index == 0) {
      categoryId = "";
    }else {
      categoryId = BaseModel.getString(categoryList4[category4Index], "id");
    }
    return categoryId;
  }

  getCategoryList4Name(var item) {
    switch(LanguagePage.language) {
      case 'TH':
        return BaseModel.getString(item, "name");
      case 'ZH':
        return BaseModel.getString(item, "chName");
      case 'EN':
        return BaseModel.getString(item, "enName");
      default:
        return BaseModel.getString(item, "name");
    }
  }

  Widget buildListItem(int index) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: IConstant.line_color, width: 1.w),
          borderRadius: BorderRadius.all( Radius.circular(10.w)),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () => {
                nextPage(ProductDetailPage(BaseModel.getString(datas[index], "id")), false)
              },
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.vertical(top:  Radius.circular(10.w)),
                      child: LoadImageView(double.infinity, 125.w, BaseModel.getString(datas[index], "pic"))),
                  buildProfit(index)
                ],
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.fromLTRB(10.w, 8.w, 10.w, 4.w),
              child: Text(BaseModel.getString(datas[index], "name"),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10.w, 4.w, 9.w, 8.w),
              child: buildPrice(index),
            ),
          ],
        )
    );
  }

  Widget buildPopShopHeader() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 10.w),
      child: Row(
        children: [
          ClipOval(
            child: LoadImageView(60.w, 60.w, BaseModel.getString(shop, "logo")),
          ),
          SizedBox(width: 8.w),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 180.w,
                    ),
                    child: Text(BaseModel.getString(shop, "name"),
                        style: TextStyle(
                            fontSize: 18.sp, color: IConstant.text_color)),
                  ),
                  SizedBox(width: 8.w),
                  Image.asset(
                    'assets/icons/ip_icon.png',
                    width: 24.w,
                    height: 24.w,
                  ),
                  // SizedBox(width: 8.w),
                  // Container(
                  //   padding: EdgeInsets.fromLTRB(6.w, 0.w, 6.w, 0.w),
                  //   decoration: BoxDecoration(
                  //       border: Border.all(width: 1.w, color: IConstant.text_color),
                  //       borderRadius: BorderRadius.circular(6.w)),
                  //   child: Text(LanguageConfig.get(LanguageConfigKeys.Login_country_th), style: TextStyle(
                  //       fontSize: 12.sp, color: IConstant.text_color)),
                  // ),
                  //expandeSpace,
                ],
              ),
              SizedBox(height: 6.w),
              Row(
                children: [
                  Expanded(child: Text(BaseModel.getString(shop, "introduction"),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12.sp, color: IConstant.text_color))),
                  SizedBox(width: 4.w),
                  InkWell(
                    onTap: () {
                      nextPage(BrandShopPage(BaseModel.getString(shop, "id")), false);
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(12.w, 2.w, 4.w, 2.w),
                      decoration: BoxDecoration(
                          color: IConstant.red_bg_color3,
                          borderRadius: BorderRadius.circular(30.w)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(LanguageConfig.get(LanguageConfigKeys.Shop_brand_goto_shop),
                              style: TextStyle(
                                  fontSize: 13.sp, color: IConstant.main_color)),
                          Icon(Icons.chevron_right,
                              size: 20.w, color: IConstant.main_color)
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          )),
          SizedBox(width: 8.w),
        ],
      ),
    );
  }

  Widget buildShopHeader() {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFDBDB),
              Color(0xFFFFFFFF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
      padding: EdgeInsets.only(top: 8.w, bottom: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 16.w),
          ClipOval(
            child: LoadImageView(90.w, 90.w, BaseModel.getString(shop, "logo")),
          ),
          SizedBox(width: 16.w),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 150.w,
                    ),
                    child: Text(BaseModel.getString(shop, "name"),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18.sp, color: IConstant.text_color)),
                  ),
                  SizedBox(width: 8.w),
                  Image.asset(
                    'assets/icons/ip_icon.png',
                    width: 24.w,
                    height: 24.w,
                  ),
                  // SizedBox(width: 8.w),
                  // Container(
                  //   padding: EdgeInsets.fromLTRB(6.w, 0.w, 6.w, 0.w),
                  //   decoration: BoxDecoration(
                  //       border: Border.all(width: 1.w, color: IConstant.text_color),
                  //       borderRadius: BorderRadius.circular(6.w)),
                  //   child: Text(LanguageConfig.get(LanguageConfigKeys.Login_country_th), style: TextStyle(
                  //       fontSize: 12.sp, color: IConstant.text_color)),
                  // ),
                  // expandeSpace,
                ],
              ),
              SizedBox(height: 4.w),
              Row(
                children: [
                  Expanded(child: Text(BaseModel.getString(shop, "introduction"),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12.sp, color: IConstant.text_color))),
                  // SizedBox(width: 10.w),
                  // InkWell(
                  //   onTap: () {
                  //
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.fromLTRB(14.w, 3.w, 14.w, 3.w),
                  //     decoration: BoxDecoration(
                  //         color: IConstant.white_color,
                  //         border: Border.all(width: 1.w, color: IConstant.main_color),
                  //         borderRadius: BorderRadius.circular(30.w)),
                  //     child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_brand_subscribe), style: TextStyle(fontSize: 14.sp, color: IConstant.main_color)),
                  //   ),
                  // ),
                  SizedBox(width: 16.w),
                ],
              ),
              SizedBox(height: 6.w),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
                    decoration: BoxDecoration(
                        color: IConstant.white_color,
                        borderRadius: BorderRadius.circular(30.w)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/rss_feed.png',
                          width: 15.w,
                          height: 15.w,
                        ),
                        SizedBox(width: 4.w),
                        Text("0", style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                        SizedBox(width: 8.w),
                        Container(width: 1.w, height: 10.w, color: IConstant.line_color),
                        SizedBox(width: 8.w),
                        Image.asset(
                          'assets/icons/pocket_hd.png',
                          width: 15.w,
                          height: 15.w,
                        ),
                        SizedBox(width: 4.w),
                        Text(BaseModel.getString(shop, "productNum"), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                      ],
                    ),
                  ),
                  expandeSpace,
                ],
              )
            ],
          )),
        ],
      ),
    );
  }

  Widget buildLabelItem(LabelModel model) {
    return ChoiceChip(
      padding: EdgeInsets.all(8.w),
      avatar: TextUtils.isEmpty(model.icon) ? null : LoadImageView(15.w, 15.w, model.icon),
      label: Text(model.name,
          style: TextStyle(
              fontSize: 12.sp,
              color: IConstant.text_color)),
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: model.isSelect
                  ? IConstant.main_color
                  : IConstant.white_bg_color,
              width: 0.5.w),
          borderRadius: BorderRadius.all(Radius.circular(20.w))),
      backgroundColor: IConstant.white_bg_color,
      selectedColor: IConstant.red_translucent_color,
      selected: model.isSelect,
      onSelected: (isSelect) => setSelectList(model),
    );
  }

  Widget buildPrice(int index){
    return Row(
      children: [
        PriceText(BaseModel.getDouble(datas[index], "price"), fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.title_color),
        SizedBox(width: 2.w,),
        buildStart(index),
        expandeSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icons/small_heart.png", width: 12.w, height: 12.w),
            SizedBox(width: 4.w),
            Text(BaseModel.getString(datas[index], "collectionNum"),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.sp, color: IConstant.grey_color)),
          ],
        ),
      ],
    );
  }

  Widget buildStart(int index) {
    List<dynamic> skuStockList = BaseModel.isNotEmpty(datas[index], "skuStockList") ? BaseModel.getDynamic(datas[index], "skuStockList") : [];
    String startText = "";
    Set<double> skuSet = {};
    for (var item in skuStockList) {
      skuSet.add(BaseModel.getDouble(item, "price"));
    }
    if (skuSet.length > 1) {
      startText = LanguageConfig.get(LanguageConfigKeys.Shop_product_rise);
    }
    return Text(startText, style: TextStyle(fontSize: 14.sp, color: IConstant.main_inactive_color));
  }

  Widget buildProfit(int index) {
    int profitStatus = BaseModel.getInt(datas[index], "profitStatus");
    double minProfit = BaseModel.getDouble(datas[index], "minProfit");
    return profitStatus == 1 ? Container(
      decoration: BoxDecoration(
          color: IConstant.white_color.withOpacity(0.85),
          borderRadius: BorderRadius.circular(0.w)),
      padding: EdgeInsets.fromLTRB(6.w, 2.w, 6.w, 2.w),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset("assets/icons/profit.png", width: 10.w, height: 10.w),
            SizedBox(width: 2.w),
            Text(getProfitText(datas[index]),
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11.sp, color: IConstant.main_color))
      ]),
    ) : Container();
  }

  String getProfitText(dynamic item) {
    double minProfit = BaseModel.getDouble(item, "minProfit");
    double maxProfit = BaseModel.getDouble(item, "maxProfit");
    return FormatUtil.profitAmount(maxProfit, maxPrice: maxProfit);
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

  setSelectList(LabelModel model) {
    for (LabelModel item in labelList) {
      item.isSelect = false;
    }
    setState(() {
      model.isSelect = !model.isSelect;
    });
    loadProductLabel();
  }

  String getPriceSort() {
    String sort = "0";
    for (SelectModel item in priceList) {
      if (item.isSelect) {
        sort = item.value;
        break;
      }
    }
    return sort;
  }

  String getSort() {
    if(priceState == SortState.DOWN) {
      return "1";
    } else if(priceState == SortState.UP) {
      return "2";
    } else if(profitState == SortState.UP) {
      return "3";
    } else if(profitState == SortState.DOWN) {
      return "4";
    } else if(saleState == SortState.DOWN) {
      return "5";
    } else if(saleState == SortState.UP) {
      return "6";
    } else {
      return "";
    }
  }

  // String getProfitSort() {
  //   String sort = "0";
  //   for (SelectModel item in profitList) {
  //     if(item.isSelect) {
  //       sort = item.value;
  //       break;
  //     }
  //   }
  //   return sort;
  // }

  String getOptional(String type) {
    String optional = "0";
    for (SelectModel item in optionalList) {
      if(item.isSelect && item.value == type) {
        optional = "1";
        break;
      }
    }
    return optional;
  }

  String getLabel() {
    String labelId = "";
    for (LabelModel item in labelList) {
      if(item.isSelect) {
        labelId = item.id;
        break;
      }
    }
    return labelId;
  }

}
