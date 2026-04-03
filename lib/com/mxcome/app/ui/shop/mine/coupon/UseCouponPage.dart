import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/OutlineTextButton.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import 'package:sprintf/sprintf.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IURLConstant.dart';
import '../../../../config/LanguageConfig.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/HttpUtils.dart';
import '../../detail/ProductDetailPage.dart';
import '../../utils/FormatUtil.dart';
import '../../widget/LoadImageView.dart';
import '../../widget/SortView.dart';


class UseCouponPage extends StatefulWidget {

  dynamic shop;
  dynamic coupon;

  UseCouponPage(this.shop, this.coupon);

  @override
  State<StatefulWidget> createState() => UseCouponPageState();
}

class UseCouponPageState extends BaseKeepAliveState<UseCouponPage> {

  dynamic _shop;
  dynamic _coupon;
  SortState priceState = SortState.INIT;

  @override
  void initState() {
    super.initState();
    _shop = widget.shop;
    _coupon = widget.coupon;
    loadContentDatas();
  }

  @override
  void didUpdateWidget(covariant UseCouponPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _coupon = widget.coupon;
  }

  @override
  Future<void> loadContentDatas() async {
    isLoading = true;
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_PRODUCT_COUPON_LIST, {
      "couponId": BaseModel.getString(_coupon, "id"),
      "pageNum": "$page",
      "pageSize": "10",
      "sort": getSort(),
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        List<dynamic> list = BaseModel.isNotEmpty(rsp.data, "list") ? BaseModel.getDynamic(rsp.data, "list") : [];
        count = rsp.data["total"];
        if(page == 1) {
          datas = list;
        } else {
          datas.addAll(list);
        }
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_applicable_range),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Container(
      margin: EdgeInsets.only(top: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _coupon != null ? buildCoupon() : Container(),
          Container(
            margin: EdgeInsets.fromLTRB(16.w, 20.w, 16.w, 0.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_products_applicable_coupon),
                style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 4.w),
            child: Row(
              children: [
                OutlineTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_all), onTap: () {}),
                expandeSpace,
                SortView(LanguageConfig.get(LanguageConfigKeys.Shop_brand_price), priceState, (state)  {
                  setState(() {
                    priceState = state;
                  });
                  page = 1;
                  datas = [];
                  loadContentDatas();
                }),
              ],
            ),
          ),
          Expanded(child: datas.isEmpty ? buildHeader() : EasyRefresh(
              footer: CupertinoFooter(emptyWidget: Container(
            padding: EdgeInsets.all(10.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_more), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
          )),
              onLoad: ()=> onLoadMore(),
              child:
              CustomScrollView(
                slivers: <Widget>[
                  SliverPadding(
                    padding: EdgeInsets.all(10.w),
                    sliver: SliverGrid(
                      delegate:
                      SliverChildBuilderDelegate((BuildContext context, int index) {
                        return buildGridItem(index);
                      }, childCount: datas.length),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 250.w,
                        mainAxisSpacing: 10.w, //item上下间隔
                        crossAxisSpacing: 10.w, //item左右间隔
                      ),
                    ),
                  ),
                ],
              )
          )),
        ],
      ),
    );
  }

  Widget buildCoupon() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 0.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
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
      child: Row(
        children: [
          Expanded(flex: 4, child: buildLeft()),
          Expanded(flex: 2, child: buildRight()),
        ],
      ),
    );
  }

  Widget buildLeft() {
    int type = BaseModel.getInt(_coupon, "type");
    int shopId = BaseModel.getInt(_shop, "id");
    String shopIcon = BaseModel.getString(_shop, "logo");
    String shopName = BaseModel.getString(_shop, "name");
    int isAllProducts = BaseModel.getInt(_coupon, "isAllProducts");
    if (shopId == 0) {
      shopName = LanguageConfig.get(LanguageConfigKeys.app_name);
    }
    if (type == 0) {
      return Padding(
        padding: EdgeInsets.only(left: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(child: Image.asset("assets/icons/official_icon.png", width: 34.w, height: 34.w)),
                SizedBox(width: 4.w),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 70.w,
                  ),
                  child: Text(LanguageConfig.get(LanguageConfigKeys.app_name),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13.sp, color: IConstant.title_color)),
                ),
              ],
            ),
            SizedBox(height: 6.w),
            Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_all_platforms), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
            SizedBox(height: 6.w),
            Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_valid_to), [ FormatUtil.formatYMDHM(DateTime.parse(BaseModel.getString(_coupon, "endTime"))) ]), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color.withOpacity(0.55)))
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(child: shopId == 0 ? Image.asset("assets/icons/official_icon.png", width: 45.w, height: 45.w)
                    : LoadImageView(45.w, 45.w, shopIcon)),
                SizedBox(width: 4.w),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 70.w,
                  ),
                  child: Text(shopName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13.sp, color: IConstant.title_color)),
                ),
                // SizedBox(width: 2.w),
                // Image.asset("assets/icons/ip_icon.png", width: 20.w),
                SizedBox(width: 6.w),
                Container(
                  padding: EdgeInsets.fromLTRB(6.w, 3.w, 6.w, 3.w),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.w, color: IConstant.main_color),
                      borderRadius: BorderRadius.circular(10.r)),
                  child: Text(getType(_shop), style: TextStyle(fontSize: 12.sp, color: IConstant.main_color)),
                )
              ],
            ),
            SizedBox(height: 2.w),
            Text(BaseModel.getString(_coupon, "name"), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: IConstant.text_color), maxLines: 1, overflow: TextOverflow.ellipsis),
            SizedBox(height: 2.w),
            // Text(BaseModel.getString(_coupon, "name"), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.text_color)),
            Text(getUseType(BaseModel.getInt(_coupon, "useType"), shopId, isAllProducts), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: IConstant.text_color)),
            SizedBox(height: 6.w),
            Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_valid_to), [ FormatUtil.formatYMDHM(DateTime.parse(BaseModel.getString(_coupon, "endTime"))) ]), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color.withOpacity(0.55)))
          ],
        ),
      );
    }
  }

  Widget buildRight() {
    int type = BaseModel.getInt(_coupon, "type");
    return Container(
      padding: EdgeInsets.fromLTRB(0.w, 20.w, 0.w, 60.w),
      decoration: BoxDecoration(
          color: type == 0 ? IConstant.gold_color : IConstant.red_bg_color3,
          borderRadius: BorderRadius.horizontal(right: Radius.circular(10.w))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PriceText(BaseModel.getDouble(_coupon, "amount"), fontSize: 20.sp),
          SizedBox(height: 10.w,),
          Text(getUseLimitType(BaseModel.getDouble(_coupon, "minPoint")),
              textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
        ],
      ),
    );
  }

  Widget buildGridItem(int index) {
    return InkWell(
      onTap: () {
        nextPageState(ProductDetailPage(BaseModel.getString(datas[index], "id")), false);
      },
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: IConstant.line_color, width: 1.w),
            borderRadius: BorderRadius.all( Radius.circular(10.w)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.vertical(top:  Radius.circular(10.w)),
                      child: LoadImageView(double.infinity, 180.w, BaseModel.getString(datas[index], "pic"))),
                  buildProfit(datas[index])
                ],
              ),
              SizedBox(height: 2.w),
              Expanded(flex: 5, child:  Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: Text(BaseModel.getString(datas[index], "name"),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 13.sp, color: IConstant.text_color)))),
              Container(
                height: 30.w,
                padding: EdgeInsets.only(left: 6.w, right: 6.w),
                child: buildPrice(index),
              ),
            ],
          )
      ),
    );
  }

  Widget buildProfit(dynamic item) {
    int profitStatus = BaseModel.getInt(item, "profitStatus");
    double minProfit = BaseModel.getDouble(item, "minProfit");
    return profitStatus == 1 && minProfit > 0 ? Container(
      decoration: BoxDecoration(
          color: IConstant.red_bg_color3,
          borderRadius: BorderRadius.circular(10.w)),
      padding: EdgeInsets.fromLTRB(6.w, 2.w, 6.w, 2.w),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset("assets/icons/profit.png", width: 10.w, height: 10.w),
        SizedBox(width: 2.w),
        Text(getProfitText(item),
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

  // String getUseType(int type, double minPoint) {
  //   if (minPoint > 0) {
  //     return sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_full_available), [ FormatUtil.price2String(minPoint) ]);
  //   } else {
  //     if (type == 0) {
  //       return LanguageConfig.get(LanguageConfigKeys.Shop_mine_all_platforms);
  //     } else if (type == 1) {
  //       return LanguageConfig.get(LanguageConfigKeys.Shop_mine_category_available);
  //     } else {
  //       return LanguageConfig.get(LanguageConfigKeys.Shop_mine_specific_product_available);
  //     }
  //   }
  // }

  String getUseLimitType(double minPoint) {
    if (minPoint > 0) {
      return sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_full_available), [ minPoint.toStringAsFixed(2) ]);
    } else {
      return sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_full_available), [ 0.toStringAsFixed(2) ]);
    }
  }

  String getUseType(int type, int shopId, int isAllProducts) {
    if(shopId == 0) {
      if (type == 0) {
        return LanguageConfig.get(LanguageConfigKeys.Shop_mine_all_platforms);
      } else {
        return LanguageConfig.get(LanguageConfigKeys.Shop_mine_specific_product_available);
      }
    }else {
      if(isAllProducts == 1) {
        return LanguageConfig.get(LanguageConfigKeys.Shop_mine_all_shops);
      }else {
        return LanguageConfig.get(LanguageConfigKeys.Shop_mine_specific_product_available);
      }
    }
  }

  String getType(dynamic shop) {
    if (BaseModel.getInt(shop, "id") == 0) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_platform_voucher);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_merchant_voucher);
    }
  }

  Widget buildPrice(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PriceText(BaseModel.getDouble(datas[index], "price"),
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: IConstant.title_color),
        SizedBox(width: 8.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icons/small_heart.png",
                width: 12.w, height: 12.w),
            SizedBox(width: 4.w),
            Text(BaseModel.getString(datas[index], "collectionNum"),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.sp, color: IConstant.grey_color)),
          ],
        )
      ],
    );
  }

  String getSort() {
    if(priceState == SortState.UP) {
      return "1";
    } else if(priceState == SortState.DOWN) {
      return "2";
    } else {
      return "";
    }
  }

}
