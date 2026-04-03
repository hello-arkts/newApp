
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/IURLConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/model/BaseRsp.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/coupon/UseCouponPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/SmallTextButton.dart';
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import 'package:sprintf/sprintf.dart';

class CouponReceivedPage extends StatefulWidget {
  CouponReceivedPage({super.key});

  @override
  State<CouponReceivedPage> createState() => _CouponReceivedPageState();
}

class _CouponReceivedPageState extends BaseKeepAliveState<CouponReceivedPage> {

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
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        leading: Container(),
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.shop_mine_receive_discount),
            style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: IConstant.text_color)),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 10.w, bottom: 20.w),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 22.w),
            height: 163.w,
            child: Image.asset("assets/icons/ic_coupon_adv.png", width: double.infinity, height: double.infinity),
            // child: Swiper(
            //   loop: advertiseList.length > 1 ? true : false,
            //   autoplay: advertiseList.length > 1 ? true : false,
            //   itemBuilder: (BuildContext context, int index) {
            //     return InkWell(
            //       onTap: () {
            //       },
            //       child: LoadImageView(double.infinity, double.infinity, BaseModel.getString(advertiseList[index], "pic"), fit: BoxFit.cover),
            //     );
            //   },
            //   itemCount: advertiseList.length,
            //   // pagination: SwiperPagination(),
            // ),
          ),
          Container(
            padding: EdgeInsets.only(left: 18.w, right: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset("assets/icons/ip_icon.png", width: 26.w, height: 26.w),
                    SizedBox(width: 6.w,),
                    Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.shop_mine_platform_coupon_tips), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: IConstant.text_color))),
                  ],
                ),
                SizedBox(height: 18.w,),
                datas.isEmpty ? Padding(padding: EdgeInsets.only(top: 120.w), child: buildHeader(),) : ListView.separated(
                itemBuilder: (ctx, idx) => buildItem(datas[idx]),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: datas.length,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 20.w);
                }),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildItem(dynamic item) {
    return InkWell(onTap: () {

    }, child: Container(
        //padding: EdgeInsets.fromLTRB(0.w, 10.w, 0.w, 10.w),
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
            Expanded(flex: 1, child: buildRight(item))
          ],
        )
    ));
  }

  Widget buildLeft(dynamic item) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, top: 8.w, bottom: 8.w),
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
          SizedBox(height: 2.w),
          Text(BaseModel.getString(item, "name"), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: IConstant.text_color), maxLines: 1, overflow: TextOverflow.ellipsis),
          SizedBox(height: 2.w),
          Text(getUseType(BaseModel.getInt(item, "useType")), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: IConstant.text_color)),
          SizedBox(height: 6.w),
          Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_valid_to), [FormatUtil.formatYMDHM(DateTime.parse(BaseModel.getString(item, "endTime")))]), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color.withOpacity(0.55)))
        ],
      ),
    );
  }

  Widget buildRight(dynamic item) {
    dynamic shop = BaseModel.getDynamic(item, "shop");
    int type = BaseModel.getInt(item, "type");
    return Container(
      padding: EdgeInsets.only(top: 12.w, bottom: 12.w),
      decoration: BoxDecoration(
          color: IConstant.red_bg_color3,
          borderRadius: BorderRadius.horizontal(right: Radius.circular(10.w))),
      child: Column(
        children: [
          SizedBox(height: 4.w),
          PriceText(BaseModel.getDouble(item, "amount"), fontSize: 20.sp, color: IConstant.main_color),
          SizedBox(height: 8.w),
          Text(getUseLimitType(BaseModel.getDouble(item, "minPoint")),
              textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
          SizedBox(height: 16.w),
          SizedBox(
            height: 25.w,
            child: SmallTextButton(fontSize: 12.w, text: getIsHold(BaseModel.getInt(item, "isHold")), onTap: () {
              int isHold = BaseModel.getInt(item, "isHold");
              if (isHold == 1) {
                nextPage(UseCouponPage(shop, item), false);
              } else {
                couponGet(item);
              }
            }),
          )
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

  String getUseLimitType(double minPoint) {
    if (minPoint > 0) {
      return sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_full_available), [ minPoint.toStringAsFixed(2) ]);
    } else {
      return sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_full_available), [ 0.toStringAsFixed(2) ]);
    }
  }

  String getUseType(int type) {
    if (type == 0) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_all_platforms);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_specific_product_available);
    }
  }

  // String getUseType(int type, double minPoint) {
  //   if (minPoint > 0) {
  //     return sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_full_available), [ FormatUtil.price2String(minPoint) ]);
  //   } else {
  //     if (type == 0) {
  //       return LanguageConfig.get(LanguageConfigKeys.Shop_mine_all_platforms);
  //     } else {
  //       return LanguageConfig.get(LanguageConfigKeys.Shop_mine_specific_product_available);
  //     }
  //   }
  // }

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
}
