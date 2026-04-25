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

  /// 外部传入的选中索引（可选）
  final int? externalActiveIndex;

  /// 外部索引变化回调（可选）
  final Function(int)? onExternalIndexChanged;

  const FeaturedPromotion({
    Key? key,
    required this.categories,
    required this.promotionItems,
    this.onCategoryTap,
    this.onPromotionTap,
    this.externalActiveIndex,
    this.onExternalIndexChanged,
  }) : super(key: key);

  @override
  State<FeaturedPromotion> createState() => _FeaturedPromotionState();

  static SliverPersistentHeaderDelegate buildPersistentHeader({
    required List<dynamic> categories,
    required int activeIndex,
    required Function(dynamic) onCategoryTap,
  }) {
    return _FeaturedPromotionHeaderDelegate(
      categories: categories,
      activeIndex: activeIndex,
      onCategoryTap: onCategoryTap,
    );
  }
}

class _FeaturedPromotionState extends State<FeaturedPromotion> {
  /// 当前选中的分类索引
  int get _activeIndex => widget.externalActiveIndex ?? _internalActiveIndex;
  int _internalActiveIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.externalActiveIndex == null && widget.categories.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onCategorySelected(widget.categories[0], 0);
      });
    }
  }

  @override
  void didUpdateWidget(FeaturedPromotion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.externalActiveIndex != oldWidget.externalActiveIndex &&
        widget.externalActiveIndex != null) {
      _internalActiveIndex = widget.externalActiveIndex!;
    }
  }

  /// 处理分类选中事件
  void _onCategorySelected(dynamic category, int index) {
    _internalActiveIndex = index;
    if (widget.onExternalIndexChanged != null) {
      widget.onExternalIndexChanged!(index);
    }
    setState(() {});
    if (widget.onCategoryTap != null) {
      widget.onCategoryTap!(category);
    }
  }

  Widget buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        SizedBox(height: 2.h),
        PromotionHighlight(
          categories: widget.categories,
          activeIndex: _activeIndex,
          onCategoryTap: (category) {
            int index = widget.categories.indexOf(category);
            _onCategorySelected(category, index);
          },
        ),
        SizedBox(height: 8.h),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeader(),
          // 优惠商品列表 (PromotionAction)
          PromotionAction(
            promotionItems: widget.promotionItems,
            onPromotionTap: widget.onPromotionTap,
            maxItems: null,
            scrollable: false,
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

class _FeaturedPromotionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final List<dynamic> categories;
  final int activeIndex;
  final Function(dynamic) onCategoryTap;

  _FeaturedPromotionHeaderDelegate({
    required this.categories,
    required this.activeIndex,
    required this.onCategoryTap,
  });

  @override
  double get minExtent => 90.h;

  @override
  double get maxExtent => 90.h;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                  padding: EdgeInsets.zero,
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
                    Icon(
                      Icons.chevron_right,
                      size: 18.w,
                      color: IConstant.text_color,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 32.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isActive = index == activeIndex;
                return GestureDetector(
                  onTap: () => onCategoryTap(category),
                  child: Container(
                    margin: EdgeInsets.only(right: 12.w),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: isActive ? const Color(0xFFFF4D4D) : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      category['name'] ?? '',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: isActive ? Colors.white : IConstant.text_color,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _FeaturedPromotionHeaderDelegate oldDelegate) {
    return activeIndex != oldDelegate.activeIndex ||
        categories != oldDelegate.categories;
  }
}
