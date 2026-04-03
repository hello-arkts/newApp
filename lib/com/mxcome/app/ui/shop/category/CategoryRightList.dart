
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/brand/BrandShopPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/CategoryEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/CollectEvent.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../IURLConstant.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/HttpUtils.dart';
import '../../LanguagePage.dart';
import '../detail/ProductDetailPage.dart';
import '../utils/EventBusUtil.dart';
import '../utils/FormatUtil.dart';
import '../widget/LoadImageView.dart';
import '../widget/PriceText.dart';

class CategoryRightList extends StatefulWidget {

  @override
  State<CategoryRightList> createState() => _CategoryRightListState();

}

class _CategoryRightListState extends BaseKeepAliveState<CategoryRightList> {

  dynamic selectCategory;

  List<dynamic> categoryList2 = [];

  List<dynamic> categoryList3 = [];

  int category2Index = 0;

  int category3Index = 0;

  final String all = LanguageConfig.get(LanguageConfigKeys.Shop_order_all);

  dynamic categoryEvent;

  dynamic collectEvent;

  List<dynamic> hotCategoryList = [];

  List<dynamic> hotProductList = [];

  List<dynamic> brandList = [];

  bool isExpand = false;

  String category2Name = '';

  String category3Name = '';

  @override
  void initState() {
    super.initState();
    categoryEvent = EventBusUtil.getInstance().on<CategoryEvent>((event) {
      selectCategory = event.category;
      loadContentDatas();
      categoryList2 = [];
      categoryList2.add(all);
      setState(() {
        isExpand = false;
        category2Index = 0;
        category3Index = 0;
        category2Name = all;
        category3Name = '';
        dynamic secondCategoryList = BaseModel.getDynamic(selectCategory, "children");
        if (secondCategoryList.isNotEmpty) {
          categoryList2.addAll(secondCategoryList);
          autoLoadProduct();
          categoryList3 = [];
          if(categoryList2[0] == all) {
            categoryList3 = [];
          }else {
            categoryList3 = BaseModel.getDynamic(categoryList2[1], "children");
          }
          autoLoadShop();
        }
      });
    });

    collectEvent = EventBusUtil.getInstance().on<CollectEvent>((event) {
      if (event.collectType == CollectType.query) {
        autoLoadProduct();
      }
    });

    loadContentDatas();
  }

  String getName(dynamic item){
    if (LanguagePage.language == "ZH") {
      return BaseModel.getString(item, "chName");
    } else if (LanguagePage.language == "EN") {
      return BaseModel.getString(item, "enName");
    } else {
      return BaseModel.getString(item, "name");
    }
  }

  @override
  Future<void> loadContentDatas() async {
    if (selectCategory != null) {
      BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_HOT_CATEGORY, {
        "categoryId": BaseModel.getString(selectCategory, "id")
      });
      if (rsp.retCode == RspRetCode.SUCCESS) {
        setState(() {
          hotCategoryList = rsp.data;
        });
      }
    }
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(collectEvent);
    EventBusUtil.getInstance().off(categoryEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      body: categoryList2.isEmpty
          ? ViewUtils.buildNoData()
          : Stack(
            children: [
              ListView(
                  children: [
                    Card(shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(10.w)),
                        clipBehavior: Clip.antiAlias,
                        elevation: 2.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isExpand = !isExpand;
                                });
                              },
                              child: Container(
                                height: 30.w,
                                padding: EdgeInsets.symmetric(horizontal: 12.w,),
                                margin: EdgeInsets.symmetric(horizontal: 18.w, vertical: 5.w),
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
                                    category2Name == all ? Text(
                                      all,
                                      style: TextStyle(
                                        color: IConstant.text_color,
                                        fontSize: 13.sp,
                                      ),
                                    ) : Expanded(
                                      child: Row(
                                        children: [
                                          Text(
                                            category2Name,
                                            style: TextStyle(
                                              color: IConstant.text_color,
                                              fontSize: 13.sp,
                                            ),
                                          ),
                                          Padding(padding: EdgeInsets.symmetric(horizontal: 5.w), child: Icon(Icons.arrow_forward_ios, size: 15.w, color: const Color(0xFFB5B5B5),),),
                                          Expanded(
                                            child: Text(
                                              category3Name,
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
                            hotCategoryList.isNotEmpty ? Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(8.w, 10.w, 10.w, 0.w),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset("assets/icons/flame_hot.png", width: 17.w, height: 17.w),
                                      Text(LanguageConfig.get(LanguageConfigKeys.Shop_product_hot_category),
                                          style: TextStyle(
                                              fontSize: 13.sp, color: IConstant.text_color))
                                    ],
                                  ),
                                ),
                                buildHotCategory(),
                              ],
                            ) : SizedBox(
                              height: 10.w,
                            )
                          ],
                        )
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(16.w, 20.w, 16.w, 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(LanguageConfig.get(LanguageConfigKeys.Shop_product_hot_product),
                              style: TextStyle(
                                  fontSize: 13.sp, color: IConstant.text_color)),
                          SizedBox(height: 8.w),
                          buildHotProduct()
                        ],
                      ),
                    ),
                    brandList.isEmpty ? Container() : Container(
                      padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(LanguageConfig.get(LanguageConfigKeys.Shop_brand_shop),
                              style: TextStyle(
                                  fontSize: 13.sp, color: IConstant.text_color)),
                          SizedBox(height: 8.w),
                          buildBrand()
                        ],
                      ),
                    )
                  ],
                ),
              Positioned(top: 50.w, child: isExpand ? buildCategoryListSelector() : Container()),
            ],
          ),
    );
  }

  Widget buildCategoryListSelector() {
    return Container(
      width: 255.w,
      height: 300.w,
      margin: EdgeInsets.only(left: 15.w),
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
          buildCategoryList2(),
          Container(color: IConstant.line_color, width: 1.w, margin: EdgeInsets.symmetric(vertical: 16.w),),
          buildCategoryList3()
        ],
      ),
    );
  }

  Widget buildCategoryList2() {
    return Expanded(flex: 2, child: ListView.separated(
        padding: EdgeInsets.only(top: 15.w, bottom: 15.w),
        scrollDirection: Axis.vertical,
        itemCount: categoryList2.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              setState(() {
                category2Index = index;
                refreshCategory3List();
              });
            },
            child: Padding(padding: EdgeInsets.fromLTRB(13.w, 8.w, 13.w, 8.w),
                child: Text(index == 0 ? all : getName(categoryList2[index]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 14.sp,
                        fontWeight: index == category2Index ? FontWeight.bold : FontWeight.normal,
                        color: index == category2Index ? IConstant.text_color : IConstant.text_color.withOpacity(0.65)))
            ),);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(height: 6.w);
        }));
  }

  refreshCategory3List() {
    if(category2Index == 0) {
      autoLoadProduct();
      autoLoadCategoryValue();
      autoLoadShop();
      setState(() {
        isExpand = false;
        categoryList3 = [];
      });
      return;
    }else {
      categoryList3 = [];
      categoryList3 = BaseModel.getDynamic(categoryList2[category2Index], "children");
    }
  }

  Widget buildCategoryList3() {
    return Expanded(flex: 3, child: ListView.separated(
        padding: EdgeInsets.only(left: 20.w, top: 15.w, bottom: 15.w),
        scrollDirection: Axis.vertical,
        itemCount: categoryList3.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              setState(() {
                category3Index = index;
                isExpand = false;
                autoLoadCategoryValue();
                autoLoadProduct();
                autoLoadShop();
              });
            },
            child: Padding(padding: EdgeInsets.fromLTRB(13.w, 8.w, 13.w, 8.w),
                child: Text(getName(categoryList3[index]),
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

  void autoLoadCategoryValue() async {
    if(category2Index == 0) {
      setState(() {
        category2Name = all;
        category3Name = '';
      });
    }else {
      setState(() {
        category2Name = getName(categoryList2[category2Index]);
        category3Name = getName(categoryList3[category3Index]);
      });
    }
  }

  void autoLoadProduct() async {
    String categoryId = "";
    if(categoryList2[category2Index] != all) {
      categoryId = BaseModel.getString(categoryList2[category2Index], "id");
    }else {
      categoryId = BaseModel.getString(selectCategory, "id");
    }
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_HOT_PRODUCT_CATEGORY2, {"categoryId": categoryId});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        hotProductList = rsp.data;
      });
    }
  }

  void autoLoadShop() async {
    String categoryId = "";
    if(category2Index == 0) {
      categoryId = BaseModel.getString(selectCategory, "id");
    }else {
      categoryId = BaseModel.getString(categoryList3[category3Index], "id");
    }
    if (TextUtils.isNotEmpty(categoryId)) {
      BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_GET_SHOP_LIST_CATEGORY, {"categoryId": categoryId});
      if (rsp.retCode == RspRetCode.SUCCESS) {
        setState(() {
          brandList = rsp.data;
        });
      }
    } else {
      setState(() {
        brandList = [];
      });
    }
  }

  Widget buildHotCategory() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(12.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 26.w,
        mainAxisSpacing: 10.w, //item上下间隔
        crossAxisSpacing: 10.w, //item左右间隔
      ),
      itemCount: hotCategoryList.length,
      itemBuilder: (BuildContext context, int index) {
        return buildHotCategoryItem(hotCategoryList[index]);
      },
    );
  }

  Widget buildHotCategoryItem(dynamic item) {
    return InkWell(
      onTap: () {
        // nextPage(ProductGridPage(getName(item), parentCategoryId: BaseModel.getString(dynamic, "id")), false);
      },
      child: Container(
          padding: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
          decoration: BoxDecoration(
              color: IConstant.grey_bg_color,
              borderRadius: BorderRadius.circular(12.w)),
          child: Text(getName(item),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))),
    );
  }

  Widget buildHotProduct() {
    return Container(
        height: 180.w,
        color: Colors.white,
        child: hotProductList.isEmpty ? ViewUtils.buildNoData() : ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: hotProductList.length,
            itemBuilder: (context, index) {
              return buildHotProductItem(index);
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(width: 12.w);
            }));
  }

  Widget buildHotProductItem(int index) {
    return InkWell(
      onTap: () {
        nextPageState(ProductDetailPage(BaseModel.getString(hotProductList[index], "id")), false);
      },
      child: Container(
          width: 112.w,
          decoration: BoxDecoration(
            border: Border.all(color: IConstant.line_color, width: 1.w),
            borderRadius: BorderRadius.all(Radius.circular(10.w)),
          ),
          child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10.w)),
                      child: LoadImageView(111.w, 100.w,
                          BaseModel.getString(hotProductList[index], "pic"))),
                  buildProfit(index)
                ],
              ),
              Container(
                height: 30.w,
                padding: EdgeInsets.only(left: 6.w, right: 6.w),
                child: buildPrice(index),
              ),
              Container(
                height: 40.w,
                padding: EdgeInsets.only(left: 6.w, right: 6.w),
                child: buildName(index),
              ),
            ],
          )),
    );
  }

  Widget buildProfit(int index) {
    int profitStatus = BaseModel.getInt(hotProductList[index], "profitStatus");
    double minProfit = BaseModel.getDouble(hotProductList[index], "minProfit");
    return profitStatus == 1 && minProfit > 0 ? Container(
      width: 112.w,
      height: 20.w,
      color: IConstant.white_translucent_color3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/icons/profit.png", width: 10.w, height: 10.w),
          SizedBox(width: 2.w),
          Text(getProfitText(index),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11.sp, color: IConstant.main_color))
        ],
      ),
    ) : Container();
  }

  String getProfitText(int index) {
    double minProfit = BaseModel.getDouble(hotProductList[index], "minProfit");
    double maxProfit = BaseModel.getDouble(hotProductList[index], "maxProfit");
    return FormatUtil.profitAmount(maxProfit, maxPrice: maxProfit);
  }

  Widget buildName(int index) {
    return SizedBox(
      width: 100.w,
      child: Text(BaseModel.getString(hotProductList[index], "name"),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
    );
  }

  Widget buildPrice(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PriceText(BaseModel.getDouble(hotProductList[index], "price"),
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: IConstant.title_color),
        Expanded(child: SizedBox(width: 8.w)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icons/small_heart.png",
                width: 12.w, height: 12.w),
            SizedBox(width: 4.w),
            Text(BaseModel.getString(hotProductList[index], "collectionNum"),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.sp, color: IConstant.grey_color)),
          ],
        )
      ],
    );
  }

  Widget buildBrand() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 110.w,
        mainAxisSpacing: 10.w, //item上下间隔
        crossAxisSpacing: 10.w, //item左右间隔
      ),
      itemCount: brandList.length,
      itemBuilder: (BuildContext context, int index) {
        return buildBrandItem(brandList[index]);
      },
    );
  }

  Widget buildBrandItem(dynamic item) {
    return InkWell(
      onTap: () {
        showPop(0.9 * Adapt.getWindowHeight(), BrandShopPage(BaseModel.getString(item, "id"), isPop: true));
      },
      child: Container(
          padding: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
          decoration: BoxDecoration(
              border: Border.all(color: IConstant.line_color, width: 1.w),
              borderRadius: BorderRadius.circular(12.w)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ClipOval(child: LoadImageView(50.w, 50.w, BaseModel.getString(item, "logo"))),
              SizedBox(height: 6.w),
              Expanded(child: Text(BaseModel.getString(item, "name"),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))),
              SizedBox(height: 8.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/rss_feed.png',
                    width: 13.w,
                    height: 13.w,
                  ),
                  SizedBox(width: 2.w),
                  Text("0", style: TextStyle(fontSize: 11.sp, color: IConstant.text_color)),
                  expandeSpace,
                  Image.asset(
                    'assets/icons/pocket_hd.png',
                    width: 13.w,
                    height: 13.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(BaseModel.isNotEmpty(item, "productNum") ? BaseModel.getString(item, "productNum") : "0", style: TextStyle(fontSize: 11.sp, color: IConstant.text_color)),
                ],
              )
            ],
          )),
    );
  }

}
