import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';

import 'PromotionHighlight.dart';
import 'PromotionAction.dart';
import 'FeaturedOfferDetails.dart';

/// 精选优惠主组件
/// 作为 PromotionHighlight 和 PromotionAction 的容器
/// 提供响应式布局和统一的样式规范
class FeaturedPromotion extends StatefulWidget {
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
  State<FeaturedPromotion> createState() => _FeaturedPromotionState();
}

class _FeaturedPromotionState extends State<FeaturedPromotion> {
  /// 当前选中的分类索引
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    // 初始化时选中第一个分类
    if (widget.categories.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onCategorySelected(widget.categories[0], 0);
      });
    }
  }

  /// 处理分类选中事件
  void _onCategorySelected(dynamic category, int index) {
    setState(() {
      _activeIndex = index;
    });
    // 调用父组件的回调获取数据
    if (widget.onCategoryTap != null) {
      widget.onCategoryTap!(category);
    }
  }

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
            categories: widget.categories,
            activeIndex: _activeIndex,
            onCategoryTap: (category) {
              int index = widget.categories.indexOf(category);
              _onCategorySelected(category, index);
            },
          ),
          SizedBox(height: 8.h),
          // 优惠商品列表 (PromotionAction)
          PromotionAction(
            promotionItems: widget.promotionItems,
            onPromotionTap: widget.onPromotionTap,
            maxItems: null,
            scrollable: true,
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FeaturedOfferDetails(),
              ),
            );
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero, // 移除默认内边距
          ),
          child: Row(
            children: [
              Text(
                LanguageConfig.get(
                    LanguageConfigKeys.Featured_promotion_view_all),
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
