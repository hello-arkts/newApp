import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';

import 'PromotionHighlight.dart';
import 'PromotionAction.dart';

/// 精选优惠主组件
/// 作为 PromotionHighlight 和 PromotionAction 的容器
/// 提供响应式布局和统一的样式规范
class FeaturedPromotion extends StatelessWidget {
  /// 分类数据列表
  final List<dynamic> categories;
  
  /// 优惠商品数据列表
  final List<dynamic> promotionItems;
  
  /// 点击分类的回调
  final Function(dynamic)? onCategoryTap;
  
  /// 点击优惠商品的回调
  final Function(dynamic)? onPromotionTap;

  const FeaturedPromotion({
    Key? key,
    required this.categories,
    required this.promotionItems,
    this.onCategoryTap,
    this.onPromotionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题栏
          _buildHeader(),
          SizedBox(height: 2.h),
          // 分类导航区域 (PromotionHighlight)
          PromotionHighlight(
            categories: categories,
            onCategoryTap: onCategoryTap,
          ),
          SizedBox(height: 16.h),
          // 优惠商品列表 (PromotionAction)
          PromotionAction(
            promotionItems: promotionItems,
            onPromotionTap: onPromotionTap,
          ),
        ],
      ),
    );
  }

  /// 构建标题栏
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              LanguageConfig.get(LanguageConfigKeys.Featured_promotion_title),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: IConstant.title_color,
              ),
            ),
          ],
        ),
        // 查看所有按钮
        TextButton(
          onPressed: () {
            // TODO: 跳转到精选优惠详情页
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero, // 移除默认内边距
          ),
          child: Row(
            children: [
              Text(
                LanguageConfig.get(LanguageConfigKeys.Featured_promotion_view_all),
                style: TextStyle(
                  fontSize: 13.sp,
                  color: IConstant.text_color,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.chevron_right,
                size: 18.w,
                color: IConstant.text_color,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
