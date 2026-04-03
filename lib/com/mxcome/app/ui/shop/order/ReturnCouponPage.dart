
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/coupon/UseCouponPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/OutlineTextButton.dart';
import 'package:sprintf/sprintf.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseModel.dart';
import '../utils/FormatUtil.dart';
import '../widget/LoadImageView.dart';
import '../widget/PriceText.dart';
import '../widget/SmallTextButton.dart';


class ReturnCouponPage extends StatefulWidget {

  List<dynamic> couponList;

  Function(BuildContext ctx) callBack;

  ReturnCouponPage(this.couponList, this.callBack);

  @override
  State<StatefulWidget> createState() {
    return ReturnCouponPageState();
  }

}

class ReturnCouponPageState extends BaseKeepAliveState<ReturnCouponPage> {

  List<dynamic> _couponList = [];

  @override
  void initState() {
    super.initState();
    _couponList = widget.couponList;
    loadContentDatas();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_return_coupon),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: ListView.separated(
          scrollDirection: Axis.vertical,
          itemCount: _couponList.length,
          itemBuilder: (context, idx) {
            return buildCouponItem(idx);
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 16.w);
          }),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildCouponItem(int index) {
    dynamic item = _couponList[index];
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 4.w, 16.w, 4.w),
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
          Expanded(flex: 2, child: buildLeft(item)),
          Expanded(flex: 4, child: buildRight(item)),
        ],
      ),
    );
  }

  Widget buildLeft(dynamic item) {
    dynamic coupon = BaseModel.getDynamic(item, "coupon");
    int type = BaseModel.getInt(coupon, "type");
    int status = BaseModel.getInt(item, "status");
    if(type == 0) {
      String btnText;
      if (status == 0) {
        btnText = LanguageConfig.get(LanguageConfigKeys.Shop_mine_to_use);
      } else if (status == 1) {
        btnText = LanguageConfig.get(LanguageConfigKeys.Shop_mine_used);
      } else {
        btnText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_expired);
      }
      return Container(
        padding: EdgeInsets.fromLTRB(0.w, 16.w, 0.w, 40.w),
        decoration: BoxDecoration(
            color: IConstant.gold_color,
            borderRadius: BorderRadius.all(Radius.circular(10.w))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PriceText(BaseModel.getDouble(coupon, "amount"), fontSize: 20.sp,
                color: status != 0 ? IConstant.white_color : IConstant.main_color),
            SizedBox(height: 5.w),
            Text(getUseLimitType(BaseModel.getDouble(coupon, "minPoint")),
                textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp,
                    color: status != 0 ? IConstant.white_color : IConstant.text_color)),
          ],
        ),
      );
    }else {
      return Container(
        padding: EdgeInsets.fromLTRB(0.w, 16.w, 0.w, 40.w),
        decoration: BoxDecoration(
            color: type == 0 ? IConstant.gold_color : IConstant.red_bg_color3,
            borderRadius: BorderRadius.all(Radius.circular(10.w))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            PriceText(BaseModel.getDouble(coupon, "amount"), fontSize: 20.sp),
            SizedBox(height: 12.w,),
            Text(getUseLimitType(BaseModel.getDouble(coupon, "minPoint")), textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
          ],
        ),
      );
    }
  }

  Widget buildRight(dynamic item) {
    dynamic coupon = BaseModel.getDynamic(item, "coupon");
    dynamic shop = BaseModel.getDynamic(item, "shop");
    int shopId = BaseModel.getInt(shop, "id");
    String shopIcon = BaseModel.getString(shop, "logo");
    String shopName = BaseModel.getString(shop, "name");
    int type = BaseModel.getInt(coupon, "type");
    int isAllProducts = BaseModel.getInt(coupon, "isAllProducts");
    if (shopId == 0) {
      shopName = LanguageConfig.get(LanguageConfigKeys.app_name);
    }
    if(type == 0) {
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
            SizedBox(height: 5.w),
            Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_all_platforms), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
            SizedBox(height: 10.w),
            Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_valid_to), [ FormatUtil.formatYMDHM(DateTime.parse(BaseModel.getString(coupon, "endTime"))) ]), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color.withOpacity(0.55)))
          ],
        ),
      );
    }else {
      return Padding(
        padding: EdgeInsets.only(left: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(child: shopId == 0 ? Image.asset("assets/icons/official_icon.png", width: 32.w, height: 32.w)
                    : LoadImageView(32.w, 32.w, shopIcon)),
                SizedBox(width: 4.w),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 80.w,
                  ),
                  child: Text(shopName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14.sp, color: IConstant.title_color)),
                ),
                SizedBox(width: 6.w),
                Container(
                  padding: EdgeInsets.fromLTRB(6.w, 3.w, 6.w, 3.w),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.w, color: IConstant.main_color),
                      borderRadius: BorderRadius.circular(10.w)),
                  child: Text(getType(shopId), style: TextStyle(fontSize: 12.sp, color: IConstant.main_color)),
                )
              ],
            ),
            SizedBox(height: 2.w),
            Text(BaseModel.getString(coupon, "name"), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: IConstant.text_color), maxLines: 1, overflow: TextOverflow.ellipsis),
            SizedBox(height: 2.w),
            Text(getUseType(BaseModel.getInt(coupon, "useType"), shopId, isAllProducts),
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: IConstant.text_color)),
            SizedBox(height: 6.w),
            Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_valid_to), [ FormatUtil.formatYMDHM(DateTime.parse(BaseModel.getString(coupon, "endTime"))) ]), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color.withOpacity(0.55)))
          ],
        ),
      );
    }
  }

  String getIsHold(int isHold) {
    if (isHold == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_to_use);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_get_now);
    }
  }

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

  String getType(int shopId) {
    if (shopId == 0) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_platform_voucher);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_merchant_voucher);
    }
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      elevation: 0.w,
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
        height: 90.w,
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_return_coupon_tip),
                style: TextStyle(fontSize: 15.sp, color: IConstant.text_color)),
            SizedBox(height: 16.w),
            SizedBox(
              width: 180.w,
              child: SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.ViewUtils_confirm), onTap: () {
                widget.callBack(context);
              }),
            )
          ],
        ),
      ),
    );
  }

}
