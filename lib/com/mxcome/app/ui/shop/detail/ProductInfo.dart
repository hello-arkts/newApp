
import 'package:card_swiper/card_swiper.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/Logger.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/ProductDetailEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../BaseKeepAliveState.dart';
import '../../../IURLConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../event/ReceiveTaskEvent.dart';
import '../utils/EventBusUtil.dart';
import '../utils/FormatUtil.dart';
import '../widget/LoadImageView.dart';
import 'GetCouponPage.dart';
import 'ReceiveTaskPage.dart';
import 'VideoPlayerWidget.dart';

class ProductInfo extends StatefulWidget {

  dynamic product;

  String activityId;

  bool showParameter = false;

  ProductInfo(this.product, { this.activityId = "", this.showParameter = false});

  @override
  State<ProductInfo> createState() => ProductInfoState();

}

class ProductInfoState extends BaseKeepAliveState<ProductInfo>
    with SingleTickerProviderStateMixin {

  List albumPics = [];
  String description = "";
  List<dynamic> pocketList = [];
  dynamic taskReceiveEvent;
  Map<String, String> promiseList = {};
  List<dynamic> skuStockList = [];
  List<String> serviceIds = [];
  String _videoUrl = "";
  List<dynamic> _couponList = [];

  @override
  void initState() {
    super.initState();
    String pics = BaseModel.getString(widget.product, "albumPics");
    skuStockList = BaseModel.getDynamic(widget.product, "skuStockList");
    String servId = BaseModel.getString(widget.product, "serviceIds");
    if(TextUtils.isEmpty(servId)) {
      servId = "1,2,5,8";
    }
    serviceIds = servId.split(",");
    promiseList.putIfAbsent("1", () => LanguageConfig.get(LanguageConfigKeys.Shop_order_service1));
    promiseList.putIfAbsent("2", () => LanguageConfig.get(LanguageConfigKeys.Shop_order_service2));
    promiseList.putIfAbsent("3", () => LanguageConfig.get(LanguageConfigKeys.Shop_order_service3));
    // promiseList.putIfAbsent("4", () => LanguageConfig.get(LanguageConfigKeys.Shop_order_service4));
    promiseList.putIfAbsent("5", () => LanguageConfig.get(LanguageConfigKeys.Shop_order_service5));
    promiseList.putIfAbsent("6", () => LanguageConfig.get(LanguageConfigKeys.Shop_order_service6));
    promiseList.putIfAbsent("7", () => LanguageConfig.get(LanguageConfigKeys.Shop_order_service7));
    promiseList.putIfAbsent("8", () => LanguageConfig.get(LanguageConfigKeys.Shop_order_service8));
    String videoUrl = BaseModel.getString(widget.product, "videoUrl");
    _videoUrl = videoUrl;
    if (TextUtils.isEmpty(pics)) {
      if(videoUrl.isNotEmpty) {
        albumPics.add(videoUrl);
      }
      albumPics.add(widget.product["pic"]);
    } else {
      if(videoUrl.isNotEmpty) {
        albumPics.add(videoUrl);
      }
      List<String> tempList = pics.split(",").toList();
      for (String element in tempList) {
        if (!TextUtils.isEmpty(element)) {
          albumPics.add(element);
        }
      }
    }
    description = widget.product["subTitle"];
    taskReceiveEvent = EventBusUtil.getInstance().on<ReceiveTaskEvent>((event) {
      showPop(0.8 * Adapt.getWindowHeight(), ReceiveTaskPage(event.product, pocketList));
    });
    loadContentDatas();
    loadShopCoupon();
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(taskReceiveEvent);
    super.dispose();
  }

  Future<void> loadShopCoupon() async {
    String productId = BaseModel.getString(widget.product, "id");
    String url = "${IURLConstant.MALL_LIST_BY_PRODUCT_SHOP}$productId";
    BaseRsp rsp = await HttpUtils.post(url, {
      "productId": productId,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        _couponList =  rsp.data;
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  @override
  Future<void> loadContentDatas() async {
    String productId = BaseModel.getString(widget.product, "id");
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_PRODUCT_POCKET_LIST, {
      "productId": productId
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<dynamic> tempList = [];
      List<dynamic> dataList = rsp.data;
      for (var item in dataList) {
        int type = BaseModel.getInt(item, "type"); //只添加普通任务
        if (type == 0) {
          tempList.add(item);
        }
      }
      if (tempList.isNotEmpty) {
        EventBusUtil.getInstance().emit(ProductDetailEvent(OptionStatus.isTaskProd));
        setState(() {
          pocketList = tempList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                Swiper(
                  key: UniqueKey(),
                  itemBuilder: (BuildContext context, int index) {
                    if(_videoUrl.isNotEmpty && index == 0) {
                      return VideoPlayerWidget(videoUrl: _videoUrl, volume: 0.5);
                    }else {
                      return LoadImageView(0.w, 0.w, albumPics[index]);
                    }
                  },
                  itemCount: albumPics.length,
                  loop: albumPics.length == 1 ? false : true,
                  autoplay: _videoUrl.isEmpty ? true : false,
                  pagination: const SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                        color: IConstant.grey_bg_color,
                        activeColor: IConstant.main_color,
                  )),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 10.w),
            child: buildBaseInfo(),
          ),
          Container(
            padding: EdgeInsets.only(left: 16.w, right: 16.w),
            child: buildDeliveryInfo(),
          )
        ],
      ),
    );
  }

  double getRateDouble() {
    return BaseModel.getDouble(widget.product, "buyPercentage");
  }

  String? getRateString() {
    double rate = getRateDouble();
    String value = (rate * 100).toString();
    return NumUtil.getDoubleByValueStr(value)?.toStringAsFixed(1);
  }

  Widget buildBaseInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildProductInfo(),
          Text(BaseModel.getString(widget.product, "subTitle"),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16.sp, color: IConstant.title_color),
          ),
          // buildGetCoupon(),
    ]);
  }

  Widget buildDeliveryInfo() {
    int property = BaseModel.getInt(widget.product, "property");
    int virtualGoodsType = BaseModel.getInt(widget.product, "virtualGoodsType");
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      widget.showParameter ? InkWell(onTap: () {
        EventBusUtil.getInstance().emit(ProductDetailEvent(OptionStatus.param));
      }, child: Padding(
          padding: EdgeInsets.only(top: 6.w, bottom: 6.w),
          child:  Row(
            children: [
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_product_parameter),
                  style: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color)),
              SizedBox(width: 20.w),
              Expanded(
                  child: Text(
                      LanguageConfig.get(LanguageConfigKeys.Shop_product_see),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontSize: 14.sp, color: IConstant.sub_text_color))),
              Icon(Icons.chevron_right, size: 24.w, color: IConstant.sub_text_color),
            ],
          ),),) : Container(),
      property == 2 ? Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 18.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 5.w),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.w, color: IConstant.main_color),
                  borderRadius: BorderRadius.circular(13.r),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    LanguageConfig.get(LanguageConfigKeys.Shop_order_detail_address_nav_tip),
                    style: TextStyle(
                      color: IConstant.text_color,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          virtualGoodsType == 1 ? Container(
            margin: EdgeInsets.only(bottom: 18.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LanguageConfig.get(LanguageConfigKeys.Shop_order_detail_address_nav),
                  style: TextStyle(
                    color: IConstant.text_color,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 8.w,),
                InkWell(
                  onTap: () {
                    _launchMaps(BaseModel.getString(widget.product, "latitude"), BaseModel.getString(widget.product, "longitude"));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(constraints: BoxConstraints(maxWidth: 272.w), child: Text(getProductSite(), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color), maxLines: 2, overflow: TextOverflow.ellipsis,)),
                      Image.asset("assets/icons/ic_goods_detail_nav.png", width: 42.w),
                    ],
                  ),
                )
              ],
            ),
          ): Container()
        ],
      ) : Column(
        children: [
          Row(
            children: [
              Image.asset("assets/icons/logistics.png", width: 20.w),
              SizedBox(width: 10.w),
              Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_product_now_pay_tip),
                  maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14.sp, color: IConstant.text_color))),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30.w, 6.w, 0.w, 6.w),
            child: Row(
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_product_nation_branding), style: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color)),
                SizedBox(width: 4.w),
                Text(getProductAddress(), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color),)
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30.w, 0.w, 0.w, 6.w),
            child: Row(
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_product_producer), style: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color)),
                SizedBox(width: 4.w),
                Text(getProducer(), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color))
              ],
            ),
          ),
        ],
      ),
      serviceIds.contains("4") ? Container(
        padding: EdgeInsets.fromLTRB(30.w, 6.w, 0.w, 6.w),
        decoration: BoxDecoration(color: IConstant.grey_bg_color, borderRadius: BorderRadius.circular(18.w)),
        child: Row(
          children: [
            Text("${LanguageConfig.get(LanguageConfigKeys.Shop_order_service4)} ", style: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color)),
            SizedBox(width: 10.w),
            Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_product_free_charge_overtime_tip), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color), maxLines: 2,))
          ],
        ),
      ) : Container(),
      SizedBox(height: 10.w),
      Container(
        decoration: BoxDecoration(
            color: IConstant.blue_bg_color2,
            borderRadius: BorderRadius.circular(15.w)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(14.w, 10.w, 0.w, 0.w),
              child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_brand_commitment),
                  style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
            ),
            buildServiceId()
          ],
        ),
      ),
      SizedBox(height: 10.w),
      Text(BaseModel.getString(widget.product, "description"),
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 14.w, color: IConstant.text_color),
      )
    ]);
  }

  void _launchMaps(String lat, String lng) async {
    String url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  String getProductSite() {
    String useAddress = BaseModel.getString(widget.product, "useAddress");
    return useAddress;
  }

  String getProductAddress() {
    String productAddress = BaseModel.getString(widget.product, "productAddress");
    if (TextUtils.isEmpty(productAddress)) {
      productAddress = LanguageConfig.get(LanguageConfigKeys.Login_country_th);
    }
    return productAddress;
  }

  String getProducer() {
    int placeOriginType = BaseModel.getInt(widget.product, "placeOriginType"); //1：国内、2：进口
    if (placeOriginType == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Login_country_th);
    } else {
      return BaseModel.getString(widget.product, "placeOrigin");
    }
  }

  // 以逗号分割的产品服务
  Widget buildServiceId() {
    List<String> selectList = [];
    for (String item in serviceIds) {
      if (promiseList.containsKey(item)) {
        String promiseItem = "${promiseList[item]}";
        if (!selectList.contains(promiseItem)) {
          selectList.add(promiseItem);
        }
      }
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(10.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisExtent: 28.w,
        mainAxisSpacing: 10.w, //item上下间隔
        crossAxisSpacing: 4.w, //item左右间隔
      ),
      itemCount: selectList.length,
      itemBuilder: (BuildContext context, int index) {
        return buildPromiseItem(selectList[index]);
      },
    );
  }

  Widget buildPromiseItem(String name) {
    return Row(
      children: [
        Image.asset("assets/icons/star.png", width: 18.w, height: 18.w),
        SizedBox(width: 2.w),
        Expanded(child: Text(name,
            maxLines: 2,
            overflow: TextOverflow.clip,
            style: TextStyle(
                fontSize: 11.sp,
                color: IConstant.sub_text_color))),
      ],
    );
  }

  Widget buildProductInfo() {
    int profitStatus = BaseModel.getInt(widget.product, "profitStatus");
    if (profitStatus == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  PriceText(BaseModel.getDouble(widget.product, "price"), fontWeight: FontWeight.bold, fontSize: 20.sp),
                  SizedBox(width: 2.w),
                  buildStart(),
                  SizedBox(width: 8.w),
                  buildProfit(widget.product),
                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10.w),
            width: double.infinity,
            height: 2.w,
            color: IConstant.line_color,
          ),
          SizedBox(height: 6.w),
          Row(
            children: [
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_task_stock),
                  style: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color)),
              SizedBox(width: 4.w),
              Text(getTaskStock(),
                  style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
              expandeSpace,
              Image.asset("assets/icons/small_heart.png", width: 12.w, height: 12.w),
              SizedBox(width: 4.w),
              Text(BaseModel.getString(widget.product, "collectionNum"),
                  style: TextStyle(fontSize: 12.sp, color: IConstant.grey_color)),
            ],
          ),
          SizedBox(height: 16.w),
        ],
      );
    } else {
     return Column(children: [
       Row(
         children: [
           PriceText(BaseModel.getDouble(widget.product, "price"), fontWeight: FontWeight.bold, fontSize: 20.sp,),
           SizedBox(width: 2.w),
           buildStart(),
           expandeSpace,
           Row(
             children: [
               Image.asset("assets/icons/small_heart.png", width: 12.w, height: 12.w),
               SizedBox(width: 4.w),
               Text("${widget.product["collectionNum"]}",
                   style: TextStyle(fontSize: 12.sp, color: IConstant.grey_color)),
             ],
           )
         ],
       ),
       SizedBox(height: 5.w),
     ]);
    }
  }

  Widget buildStart() {
    String startText = "";
    Set<double> skuSet = {};
    for (var item in skuStockList) {
      skuSet.add(BaseModel.getDouble(item, "price"));
    }
    if (skuSet.length > 1) {
      startText = LanguageConfig.get(LanguageConfigKeys.Shop_product_rise);
    }
    return Text(startText, style: TextStyle(fontSize: 14.sp, color: IConstant.main_color));
  }

  Widget buildProfit(dynamic item) {
    return Container(
      margin: EdgeInsets.only(top: 2.w),
      padding: EdgeInsets.fromLTRB(10.w, 2.w, 10.w, 2.w),
      decoration: BoxDecoration(color: IConstant.red_bg_color, borderRadius: BorderRadius.circular(18.w)),
      child: Row(
          children: [
            Image.asset("assets/icons/profit.png", width: 10.w, height: 10.w),
            SizedBox(width: 2.w),
            Text(getProfitText(item),
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11.sp, color: IConstant.main_color))
          ]
      ),
    );
  }

  String getProfitText(dynamic item) {
    double minProfit = BaseModel.getDouble(item, "minProfit");
    double maxProfit = BaseModel.getDouble(item, "maxProfit");
    return FormatUtil.profitAmount(maxProfit, maxPrice: maxProfit);
  }

  // Widget buildGetCoupon() {
  //   List<dynamic> showItemList = _couponList.length > 3 ? _couponList.sublist(0, 3) : _couponList;
  //   return Column(
  //     children: [
  //       Container(
  //         alignment: Alignment.center,
  //         padding: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 0.w),
  //         child: Row(
  //           children: [
  //             Expanded(child: _couponList.isEmpty ? Text(LanguageConfig.get(LanguageConfigKeys.Base_product_none_coupon), style: TextStyle(fontSize: 14.w, color: IConstant.sub_text_color),)
  //                 : Wrap(spacing: 16.w, runSpacing: 4.w, children: getCouponWidget(showItemList)),),
  //             InkWell(
  //                 onTap: () {
  //                   showPop(0.9 * Adapt.getWindowHeight(), GetCouponPage(widget.product, _couponList));
  //                 },
  //                 child: Container(
  //                   decoration: BoxDecoration(
  //                     color: IConstant.main_color,
  //                     borderRadius: BorderRadius.all(Radius.circular(20.w)),
  //                   ),
  //                   alignment: Alignment.center,
  //                   padding: EdgeInsets.fromLTRB(16.w, 6.w, 16.w, 6.w),
  //                   child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_product_get_coupon),
  //                     textAlign: TextAlign.center, style: TextStyle(fontSize: 13.sp, color: IConstant.white_color),
  //                   ),
  //                 )
  //             )
  //           ],
  //         ),
  //       ),
  //       SizedBox(height: 16.w),
  //       Container(
  //         margin: EdgeInsets.only(left: 16.w, right: 16.w),
  //         height: 1.w,
  //         color: IConstant.line_color,
  //       ),
  //       SizedBox(height: 16.w),
  //     ],
  //   );
  // }
  //
  // List<Widget> getCouponWidget(List<dynamic> showItemList) {
  //   List<Widget> showWidget = [];
  //   for (var item in showItemList) {
  //     showWidget.add(Chip(
  //         padding: EdgeInsets.fromLTRB(10.w, 8.w, 10.w, 8.w),
  //         label: Text(getCouponText(item),
  //             style: TextStyle(
  //                 fontSize: 11.sp,
  //                 color: IConstant.main_color)),
  //         shape: RoundedRectangleBorder(
  //             side: BorderSide(
  //                 color: IConstant.red_bg_color6,
  //                 width: 0.5.w),
  //             borderRadius: BorderRadius.all(Radius.circular(20.w))),
  //         backgroundColor: IConstant.red_bg_color6
  //     ));
  //   }
  //   return showWidget;
  // }
  //
  // String getCouponText(dynamic item) {
  //   double minPoint = BaseModel.getDouble(item, "minPoint");
  //   double amount = BaseModel.getDouble(item, "amount");
  //   if (minPoint > 0) {
  //     return sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_order_full_reduction), [ FormatUtil.price2String(minPoint), FormatUtil.price2String(amount)]);
  //   } else {
  //     return sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_order_direct_reduction), [ FormatUtil.price2String(amount)]);
  //   }
  // }

  String getTaskStock() {
    int pocketStock = BaseModel.getInt(widget.product, "pocketStock");
    return "$pocketStock ${LanguageConfig.get(LanguageConfigKeys.Shop_pocket_piece)}";
    // int total = 0;
    // for (var item in skuStockList) {
    //   int stock = BaseModel.getInt(item, "pocketStock");
    //   total += stock;
    // }
    // return "$total ${LanguageConfig.get(LanguageConfigKeys.Shop_pocket_piece)}";
  }


}
