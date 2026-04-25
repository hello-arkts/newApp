import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';

import 'PromotionHighlight.dart';
import 'PromotionAction.dart';
import 'FeaturedOfferDetails.dart';

/// 精选优惠 Sliver 版本（用于 CustomScrollView）
class FeaturedPromotionSliver extends StatefulWidget {
  final List<dynamic> categories;
  final List<dynamic>? promotionItems;
  final Function(dynamic)? onCategoryTap;
  final Function(dynamic)? onPromotionTap;
  final int? externalActiveIndex;
  final Function(int)? onExternalIndexChanged;

  const FeaturedPromotionSliver({
    Key? key,
    required this.categories,
    this.promotionItems,
    this.onCategoryTap,
    this.onPromotionTap,
    this.externalActiveIndex,
    this.onExternalIndexChanged,
  }) : super(key: key);

  @override
  State<FeaturedPromotionSliver> createState() => _FeaturedPromotionSliverState();
}

class _FeaturedPromotionSliverState extends State<FeaturedPromotionSliver> {
  int get _activeIndex => widget.externalActiveIndex ?? _internalActiveIndex;
  int _internalActiveIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.externalActiveIndex == null && widget.categories.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _internalActiveIndex = 0;
      });
    }
  }

  void _onCategoryTap(dynamic category) {
    final index = widget.categories.indexOf(category);
    if (widget.onExternalIndexChanged != null) {
      widget.onExternalIndexChanged!(index);
    }
    if (widget.onCategoryTap != null) {
      widget.onCategoryTap!(category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _FeaturedPromotionHeaderDelegate(
        categories: widget.categories,
        activeIndex: _activeIndex,
        onCategoryTap: _onCategoryTap,
      ),
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
  double get minExtent => 120.h;

  @override
  double get maxExtent => 120.h;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      child: FeaturedPromotionContent.buildHeaderContent(
        context: context,
        categories: categories,
        activeIndex: activeIndex,
        onCategoryTap: onCategoryTap,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _FeaturedPromotionHeaderDelegate oldDelegate) {
    return activeIndex != oldDelegate.activeIndex ||
        categories != oldDelegate.categories;
  }
}

/// 精选优惠内容组件（无头部，用于 SliverToBoxAdapter 或普通布局）
class FeaturedPromotionContent extends StatefulWidget {
  final List<dynamic> categories;
  final List<dynamic> promotionItems;
  final Function(dynamic)? onCategoryTap;
  final Function(dynamic)? onPromotionTap;
  final int? externalActiveIndex;
  final Function(int)? onExternalIndexChanged;

  const FeaturedPromotionContent({
    Key? key,
    required this.categories,
    required this.promotionItems,
    this.onCategoryTap,
    this.onPromotionTap,
    this.externalActiveIndex,
    this.onExternalIndexChanged,
  }) : super(key: key);

  @override
  State<FeaturedPromotionContent> createState() => _FeaturedPromotionContentState();

  static Widget buildHeaderContent({
    required BuildContext context,
    required List<dynamic> categories,
    required int activeIndex,
    required Function(dynamic) onCategoryTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderWidgetStatic(context, categories),
        SizedBox(height: 2.h),
        PromotionHighlight(
          categories: categories,
          activeIndex: activeIndex,
          onCategoryTap: onCategoryTap,
        ),
      ],
    );
  }

  static Widget _buildHeaderWidgetStatic(BuildContext context, List<dynamic> categories) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            LanguageConfig.get(LanguageConfigKeys.Featured_promotion_title),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: IConstant.title_color,
            ),
          ),
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
            mainAxisSize: MainAxisSize.min,
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

class _FeaturedPromotionContentState extends State<FeaturedPromotionContent> {
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
  void didUpdateWidget(FeaturedPromotionContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.externalActiveIndex != oldWidget.externalActiveIndex &&
        widget.externalActiveIndex != null) {
      _internalActiveIndex = widget.externalActiveIndex!;
    }
  }

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
    return FeaturedPromotionContent.buildHeaderContent(
      context: context,
      categories: widget.categories,
      activeIndex: _activeIndex,
      onCategoryTap: (category) {
        int index = widget.categories.indexOf(category);
        _onCategorySelected(category, index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
}
