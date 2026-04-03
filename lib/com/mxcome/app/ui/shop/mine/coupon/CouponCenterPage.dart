
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/coupon/MineCouponPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/SmallTextButton.dart';
import 'package:sprintf/sprintf.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IURLConstant.dart';
import '../../../../config/LanguageConfig.dart';
import '../../../../model/BaseModel.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/HttpUtils.dart';
import '../../../../utils/ViewUtils.dart';
import '../../utils/FormatUtil.dart';
import '../../widget/LoadImageView.dart';
import 'UseCouponPage.dart';

class CouponCenterPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return CouponCenterPageState();
  }

}

class CouponCenterPageState extends BaseKeepAliveState<CouponCenterPage> {

  @override
  void initState() {
    super.initState();
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    isLoading = true;
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_COUPON_CENTER_LIST, {
      "pageNum": "$page",
      "pageSize": "10",
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<dynamic> list = BaseModel.isNotEmpty(rsp.data, "list") ? BaseModel.getDynamic(rsp.data, "list") : [];
      setState(() {
        count = rsp.data["total"];
        if (page == 1) {
          datas = list;
        } else {
          datas.addAll(list);
        }
      });
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
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_voucher_center),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: datas.isEmpty ? buildHeader() : EasyRefresh(
        header: const MaterialHeader(color: IConstant.main_color),
        footer: CupertinoFooter(emptyWidget: Container(
            padding: EdgeInsets.all(10.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_more), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
          )),
        onRefresh: ()=> onRefresh(),
        onLoad: ()=> onLoadMore(), child: ListView.separated(
              itemBuilder: (ctx, idx) => buildItem(datas[idx]),
              itemCount: datas.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(height: 1.w);
              })),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildItem(dynamic item) {
    return InkWell(onTap: () {

    }, child: Container(
      margin: EdgeInsets.fromLTRB(12.w, 10.w, 12.w, 10.w),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: IConstant.line_color),
          borderRadius: BorderRadius.circular(10.w)),
      child: Row(
        children: [
          Expanded(flex: 5, child: buildLeft(item)),
          Expanded(flex: 2, child: buildRight(item))
        ],
      )
    ));
  }

  Widget buildLeft(dynamic item) {
    dynamic shop = BaseModel.getDynamic(item, "shop");
    int type = BaseModel.getInt(item, "type");
    int shopId = BaseModel.getInt(shop, "id");
    String shopIcon = BaseModel.getString(shop, "logo");
    String shopName = BaseModel.getString(shop, "name");
    if (shopId == 0) {
      shopName = LanguageConfig.get(LanguageConfigKeys.app_name);
    }
    if (type == 0) {
      return Padding(
        padding: EdgeInsets.only(left: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_voucher), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.text_color)),
            SizedBox(height: 6.w),
            Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_all_platforms), style: TextStyle(fontSize: 13.sp, color: IConstant.sub_text_color)),
            SizedBox(height: 6.w),
            Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_valid_to), [ BaseModel.getString(item, "endTime") ]), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(left: 10.w),
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
                    maxWidth: 60.w,
                  ),
                  child: Text(shopName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13.sp, color: IConstant.title_color)),
                ),
                SizedBox(width: 2.w),
                Image.asset("assets/icons/ip_icon.png", width: 20.w),
                SizedBox(width: 6.w),
                Container(
                  padding: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
                  constraints: BoxConstraints(
                      maxWidth: 85.w
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.w, color: IConstant.main_color),
                      borderRadius: BorderRadius.circular(10.w)),
                  child: Text(getType(shopId), style: TextStyle(fontSize: 12.sp, color: IConstant.main_color)),
                )
              ],
            ),
            SizedBox(height: 2.w),
            Text(BaseModel.getString(item, "name"), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.text_color)),
            SizedBox(height: 6.w),
            Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_valid_to), [ BaseModel.getString(item, "endTime") ]), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))
          ],
        ),
      );
    }
  }

  Widget buildRight(dynamic item) {
    dynamic shop = BaseModel.getDynamic(item, "shop");
    int type = BaseModel.getInt(item, "type");
    return Container(
      decoration: BoxDecoration(
          color: type == 0 ? IConstant.gold_color : IConstant.red_bg_color3,
          borderRadius: BorderRadius.horizontal(right: Radius.circular(10.w))),
      child: Column(
        children: [
          SizedBox(height: 4.w),
          PriceText(BaseModel.getDouble(item, "amount"), fontSize: 20.sp),
          SizedBox(height: 6.w),
          Text(getUseType(BaseModel.getInt(item, "useType"), BaseModel.getDouble(item, "minPoint")),
              textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
          SizedBox(height: 6.w),
          SmallTextButton(text: getIsHold(BaseModel.getInt(item, "isHold")), onTap: () {
            int isHold = BaseModel.getInt(item, "isHold");
            if (isHold == 1) {
              nextPage(UseCouponPage(shop, item), false);
            } else {
              couponGet(item);
            }
          })
        ],
      ),
    );
  }

  String getIsHold(int isHold) {
    if (isHold == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_to_use);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_get_now);
    }
  }

  String getUseType(int type, double minPoint) {
    if (minPoint > 0) {
      return sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_full_available), [ FormatUtil.price2String(minPoint) ]);
    } else {
      if (type == 0) {
        return LanguageConfig.get(LanguageConfigKeys.Shop_mine_all_platforms);
      } else if (type == 1) {
        return LanguageConfig.get(LanguageConfigKeys.Shop_mine_category_available);
      } else {
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

  Future<void> couponGet(dynamic item) async {
    ViewUtils.show();
    String id = BaseModel.getString(item, "id");
    String url = "${IURLConstant.MALL_COUPON_ADD}$id";
    BaseRsp rsp = await HttpUtils.post(url, {
      "id": id
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_mine_received_successfully));
      loadContentDatas();
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      elevation: 10.w,
      child: InkWell(
        onTap: () {
          finish();
          nextPage(MineCouponPage(), false);
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/icons/coupon.png", width: 18.w),
              SizedBox(width: 6.w),
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_my_coupon), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
            ],
          ),
        ),
      ),
    );
  }

}
