import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/IURLConstant.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/model/BaseRsp.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/coupon/CouponCenterPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/coupon/VoucherItemPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:mxcome/com/mxcome/app/utils/Adapt.dart';
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../config/LanguageConfig.dart';
import 'CouponItemPage.dart';
import 'CouponReceivedPage.dart';

class MineCouponPage extends StatefulWidget {

  MineCouponPage();

  @override
  State<MineCouponPage> createState() => MineCouponPageState();
}

class MineCouponPageState extends BaseKeepAliveState<MineCouponPage>
    with SingleTickerProviderStateMixin {

  late TabController tabController;

  int currentIndex = 0;

  final titles = [
    LanguageConfig.get(LanguageConfigKeys.Shop_mine_coupon),
    LanguageConfig.get(LanguageConfigKeys.Shop_mine_voucher),
  ];
  
  final pages = [CouponItemPage(), VoucherItemPage()];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: titles.length, vsync: this);
    loadContentDatas();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Future<void> loadContentDatas() async{
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
        datas = datas.length > 3 ? datas.sublist(0, 3) : datas;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.w + appBarHeight),
        child: AppBar(
            elevation: 0.w,
            centerTitle: true,
            title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_my_coupon),
                style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)
            ),
          flexibleSpace: Container(
            margin: EdgeInsets.fromLTRB(18.w, appBarHeight + statusBarHeight + 10.w, 18.w, 60.w),
            padding: EdgeInsets.fromLTRB(15.w, 13.w, 15.w, 11.w),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset("assets/icons/ic_mx_logo.png", width: 34.w),
                    SizedBox(width: 8.w,),
                    Text("MXCOME", style: TextStyle(fontSize: 14.sp, color: IConstant.text_color, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8.w,),
                    Container(
                      padding: EdgeInsets.fromLTRB(6.w, 3.w, 6.w, 3.w),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.w, color: IConstant.main_color),
                          borderRadius: BorderRadius.circular(10.w)),
                      child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_platform_voucher), style: TextStyle(fontSize: 12.sp, color: IConstant.main_color)),
                    )
                  ],
                ),
                SizedBox(height: 10.w,),
                Text(LanguageConfig.get(LanguageConfigKeys.shop_mine_platform_coupon_hint), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color, fontWeight: FontWeight.w500)),
                SizedBox(height: 5.w,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                        spacing: 10.w,
                        children: datas.map((item) => buildLabelItem(item)).toList()),
                    InkWell(
                      onTap: () {
                        showPop(0.85 * Adapt.getWindowHeight(), CouponReceivedPage());
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: IConstant.main_color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              LanguageConfig.get(LanguageConfigKeys.Shop_mine_get_now),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          bottom: buildTabBar(),
        ),
      ),
        body: titles.isEmpty ? Container(color: IConstant.white_color) : TabBarView(
          controller: tabController,
          children: pages.map((item)=>item).toList(),
        ),
    );
  }

  Widget buildLabelItem(dynamic item) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.w),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: IConstant.red_bg_color4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      child: PriceText(BaseModel.getDouble(item, "amount"),
          fontSize: 12.sp, color: IConstant.main_color)
    );
  }

  TabBar buildTabBar() {
    return TabBar(
      dividerColor: Colors.transparent,
      controller: tabController,
      tabs: titles.map((item)=>Tab(child: Text(item))).toList(),
      isScrollable: false,
      indicatorColor: IConstant.main_color,
      labelColor: IConstant.text_color,
      unselectedLabelColor: IConstant.text_color,
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
      indicatorWeight: 3,
    );
  }
}