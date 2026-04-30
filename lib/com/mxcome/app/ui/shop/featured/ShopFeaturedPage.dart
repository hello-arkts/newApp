import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';

import 'ShopFeaturedProductsTab.dart';
import 'ShopFeaturedBrandTab.dart';

class ShopFeaturedModule extends StatefulWidget {
  final int shopId;
  final int pageSize;
  final Map<String, dynamic>? shopData;

  const ShopFeaturedModule({
    super.key,
    required this.shopId,
    this.pageSize = 10,
    this.shopData,
  });

  @override
  State<ShopFeaturedModule> createState() => _ShopFeaturedModuleState();
}

class _ShopFeaturedModuleState extends State<ShopFeaturedModule> {
  int _tabIndex = 0; // 0: 店铺精选, 1: 关于品牌

  Widget _buildHeaderTabs() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (_tabIndex != 0) {
                setState(() => _tabIndex = 0);
              }
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    LanguageConfig.get(LanguageConfigKeys.Shop_featured_tab_products),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight:
                          _tabIndex == 0 ? FontWeight.bold : FontWeight.normal,
                      color: _tabIndex == 0
                          ? IConstant.title_color
                          : IConstant.grey_color,
                    ),
                  ),
                  SizedBox(height: 6.w),
                  Container(
                    width: 24.w,
                    height: 4.w,
                    decoration: BoxDecoration(
                      color: _tabIndex == 0
                          ? const Color(0xFFFF4D4F)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 24.w),
          GestureDetector(
            onTap: () {
              if (_tabIndex != 1) {
                setState(() => _tabIndex = 1);
              }
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    LanguageConfig.get(LanguageConfigKeys.Shop_featured_tab_brand),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight:
                          _tabIndex == 1 ? FontWeight.bold : FontWeight.normal,
                      color: _tabIndex == 1
                          ? IConstant.title_color
                          : IConstant.grey_color,
                    ),
                  ),
                  SizedBox(height: 6.w),
                  Container(
                    width: 24.w,
                    height: 4.w,
                    decoration: BoxDecoration(
                      color: _tabIndex == 1
                          ? const Color(0xFFFF4D4F)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (_tabIndex == 0) {
      content = ShopFeaturedProductsTab(
        shopId: widget.shopId,
        pageSize: widget.pageSize,
      );
    } else {
      content = ShopFeaturedBrandTab(
        shopId: widget.shopId,
        shopData: widget.shopData,
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderTabs(),
          Expanded(child: content),
        ],
      ),
    );
  }
}
