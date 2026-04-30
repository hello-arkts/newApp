import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/LanguageEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';

const List<Map<String, String>> featuredPromotionCategories = [
  {
    "id": "1",
    "i18nKey": LanguageConfigKeys.Featured_promotion_category_restaurant,
  },
  {
    "id": "2",
    "i18nKey": LanguageConfigKeys.Featured_promotion_category_hotel,
  },
  {
    "id": "3",
    "i18nKey": LanguageConfigKeys.Featured_promotion_category_car,
  },
  {
    "id": "4",
    "i18nKey": LanguageConfigKeys.Featured_promotion_category_ticket,
  },
  {
    "id": "5",
    "i18nKey": LanguageConfigKeys.Featured_promotion_category_popular_thai,
  },
  {
    "id": "6",
    "i18nKey": LanguageConfigKeys.Featured_promotion_category_leisure,
  },
];

/// 精选优惠 - 分类高亮组件
/// 对应红色标记区域 1：展示优惠重点信息（分类导航）
/// 独立可复用，具有清晰的接口和样式隔离
class PromotionHighlight extends StatefulWidget {
  /// 分类数据列表
  /// 每个分类应包含：id, name, icon, chName, enName
  final List<dynamic> categories;

  /// 点击分类的回调
  final Function(dynamic)? onCategoryTap;

  /// 当前选中的分类索引（用于高亮显示）
  final int activeIndex;

  /// 显示模式：grid-九宫格，row-单行滚动
  final String mode;

  /// 每行显示的分类数量（仅在 grid 模式下有效）
  final int columnsCount;

  /// 分类卡片的高度
  final double cardHeight;

  const PromotionHighlight({
    super.key,
    required this.categories,
    this.onCategoryTap,
    this.activeIndex = 0,
    this.mode = 'grid',
    this.columnsCount = 3,
    this.cardHeight = 30,
  });

  @override
  State<PromotionHighlight> createState() => _PromotionHighlightState();
}

class _PromotionHighlightState extends State<PromotionHighlight> {
  dynamic _languageEvent;

  @override
  void initState() {
    super.initState();
    _languageEvent = EventBusUtil.getInstance().on<LanguageEvent>((event) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(_languageEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(2.w),
      child: widget.mode == 'row' ? _buildRowMode() : _buildGridMode(),
    );
  }

  /// 构建单行滚动模式
  Widget _buildRowMode() {
    return _RowModeWithArrows(
      categories: widget.categories,
      activeIndex: widget.activeIndex,
      cardHeight: widget.cardHeight,
      onCategoryTap: widget.onCategoryTap,
    );
  }

  /// 构建九宫格模式
  Widget _buildGridMode() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.columnsCount,
        mainAxisExtent: widget.cardHeight.h,
        mainAxisSpacing: 12.w,
        crossAxisSpacing: 12.w,
      ),
      itemCount: widget.categories.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildCategoryItem(index);
      },
    );
  }

  /// 构建分类项
  Widget _buildCategoryItem(int index) {
    if (index >= widget.categories.length) {
      return const SizedBox.shrink();
    }

    final category = widget.categories[index];
    final String icon = _getCategoryIcon(index);
    final String name = _getCategoryName(category, index);

    return GestureDetector(
      onTap: () {
        if (widget.onCategoryTap != null) {
          widget.onCategoryTap!(category);
        }
      },
      child: Container(
        padding: widget.mode == 'row'
            ? EdgeInsets.symmetric(horizontal: 14.w)
            : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          border: index == widget.activeIndex
              ? Border.all(color: IConstant.main_color, width: 1.w)
              : Border.all(color: Colors.transparent, width: 1.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: widget.mode == 'row' ? MainAxisSize.min : MainAxisSize.max,
          children: [
            // 分类图标
            _buildCategoryIcon(icon, index),
            SizedBox(width: 6.w),
            // 分类名称
            widget.mode == 'row'
                ? Text(
                    name,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: index == widget.activeIndex
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: index == widget.activeIndex
                          ? IConstant.main_color
                          : IConstant.title_color,
                    ),
                  )
                : Flexible(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: index == widget.activeIndex
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: index == widget.activeIndex
                            ? IConstant.main_color
                            : IConstant.title_color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  /// 构建分类图标
  Widget _buildCategoryIcon(String icon, int index) {
    return Image.asset(
      icon,
      width: 20.w,
      height: 20.w,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          _getDefaultIcon(index),
          size: 20.w,
          color: index == widget.activeIndex
              ? IConstant.main_color
              : IConstant.text_color,
        );
      },
    );
  }

  /// 获取分类图标路径
  String _getCategoryIcon(int index) {
    const icons = [
      'assets/icons/category_restaurant1.png',
      'assets/icons/category_hotel1.png',
      'assets/icons/category_car1.png',
      'assets/icons/category_ticket1.png',
      'assets/icons/category_popular1.png',
      'assets/icons/category_leisure1.png',
    ];
    return index < icons.length
        ? icons[index]
        : 'assets/icons/category_default.png';
  }

  /// 获取默认图标
  IconData _getDefaultIcon(int index) {
    const icons = [
      Icons.restaurant,
      Icons.hotel,
      Icons.directions_car,
      Icons.confirmation_number,
      Icons.local_fire_department,
      Icons.beach_access,
    ];
    return index < icons.length ? icons[index] : Icons.store;
  }

  /// 获取分类名称
  String _getCategoryName(dynamic category, int index) {
    const keys = [
      LanguageConfigKeys.Featured_promotion_category_restaurant,
      LanguageConfigKeys.Featured_promotion_category_hotel,
      LanguageConfigKeys.Featured_promotion_category_car,
      LanguageConfigKeys.Featured_promotion_category_ticket,
      LanguageConfigKeys.Featured_promotion_category_popular_thai,
      LanguageConfigKeys.Featured_promotion_category_leisure,
    ];

    // 如果有传入的 category 数据，优先使用
    try {
      String? i18nKey = category['i18nKey'];
      if (i18nKey != null && i18nKey.isNotEmpty) {
        return LanguageConfig.get(i18nKey);
      }
      String? chName = category['chName'];
      if (chName != null && chName.isNotEmpty) {
        return chName; // Here we might want to still use chName if it's from backend, but normally i18nKey is provided
      }
    } catch (e) {
      // 忽略错误
    }

    return index < keys.length
        ? LanguageConfig.get(keys[index])
        : LanguageConfig.get(
            LanguageConfigKeys.Promotion_highlight_category_fallback);
  }
}

class _ScrollIndicatorArrow extends StatefulWidget {
  final bool isLeft;

  const _ScrollIndicatorArrow({required this.isLeft});

  @override
  State<_ScrollIndicatorArrow> createState() => _ScrollIndicatorArrowState();
}

class _ScrollIndicatorArrowState extends State<_ScrollIndicatorArrow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: widget.isLeft ? Alignment.centerRight : Alignment.centerLeft,
          end: widget.isLeft ? Alignment.centerLeft : Alignment.centerRight,
          colors: [
            Colors.white,
            Colors.white.withOpacity(0.0),
          ],
        ),
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              widget.isLeft
                  ? -8.0 * _animation.value
                  : 8.0 * _animation.value,
              0,
            ),
            child: Icon(
              widget.isLeft ? Icons.chevron_left : Icons.chevron_right,
              size: 28.w,
              color: IConstant.main_color,
            ),
          );
        },
      ),
    );
  }
}

class _RowModeWithArrows extends StatefulWidget {
  final List<dynamic> categories;
  final int activeIndex;
  final double cardHeight;
  final Function(dynamic)? onCategoryTap;

  const _RowModeWithArrows({
    required this.categories,
    required this.activeIndex,
    required this.cardHeight,
    this.onCategoryTap,
  });

  @override
  State<_RowModeWithArrows> createState() => _RowModeWithArrowsState();
}

class _RowModeWithArrowsState extends State<_RowModeWithArrows> {
  final ScrollController _scrollController = ScrollController();
  bool _showLeftArrow = false;
  bool _showRightArrow = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkArrows());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    _checkArrows();
  }

  void _checkArrows() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final leftVisible = currentScroll > 0;
    final rightVisible = currentScroll < maxScroll;

    if (leftVisible != _showLeftArrow || rightVisible != _showRightArrow) {
      setState(() {
        _showLeftArrow = leftVisible;
        _showRightArrow = rightVisible;
      });
    }
  }

  void _scrollToSide(bool isLeft) {
    if (!_scrollController.hasClients) return;
    final offset = isLeft
        ? _scrollController.position.pixels - 100
        : _scrollController.position.pixels + 100;
    _scrollController.animateTo(
      offset.clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.cardHeight.h + 12.w,
      child: Stack(
        children: [
          ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(vertical: 6.w, horizontal: 2.w),
            scrollDirection: Axis.horizontal,
            itemCount: widget.categories.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(right: 12.w),
                child: _buildCategoryItem(index),
              );
            },
          ),
          if (_showLeftArrow)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () => _scrollToSide(true),
                child: _ScrollIndicatorArrow(isLeft: true),
              ),
            ),
          if (_showRightArrow)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () => _scrollToSide(false),
                child: _ScrollIndicatorArrow(isLeft: false),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(int index) {
    if (index >= widget.categories.length) {
      return const SizedBox.shrink();
    }

    final category = widget.categories[index];
    final String icon = _getCategoryIcon(index);
    final String name = _getCategoryName(category, index);

    return GestureDetector(
      onTap: () {
        if (widget.onCategoryTap != null) {
          widget.onCategoryTap!(category);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          border: index == widget.activeIndex
              ? Border.all(color: IConstant.main_color, width: 1.w)
              : Border.all(color: Colors.transparent, width: 1.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCategoryIcon(icon, index),
            SizedBox(width: 6.w),
            Text(
              name,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: index == widget.activeIndex
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: index == widget.activeIndex
                    ? IConstant.main_color
                    : IConstant.title_color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(String icon, int index) {
    return Image.asset(
      icon,
      width: 20.w,
      height: 20.w,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          _getDefaultIcon(index),
          size: 20.w,
          color: index == widget.activeIndex
              ? IConstant.main_color
              : IConstant.text_color,
        );
      },
    );
  }

  String _getCategoryIcon(int index) {
    const icons = [
      'assets/icons/category_restaurant1.png',
      'assets/icons/category_hotel1.png',
      'assets/icons/category_car1.png',
      'assets/icons/category_ticket1.png',
      'assets/icons/category_popular1.png',
      'assets/icons/category_leisure1.png',
    ];
    return index < icons.length
        ? icons[index]
        : 'assets/icons/category_default.png';
  }

  IconData _getDefaultIcon(int index) {
    const icons = [
      Icons.restaurant,
      Icons.hotel,
      Icons.directions_car,
      Icons.confirmation_number,
      Icons.local_fire_department,
      Icons.beach_access,
    ];
    return index < icons.length ? icons[index] : Icons.store;
  }

  String _getCategoryName(dynamic category, int index) {
    const keys = [
      LanguageConfigKeys.Featured_promotion_category_restaurant,
      LanguageConfigKeys.Featured_promotion_category_hotel,
      LanguageConfigKeys.Featured_promotion_category_car,
      LanguageConfigKeys.Featured_promotion_category_ticket,
      LanguageConfigKeys.Featured_promotion_category_popular_thai,
      LanguageConfigKeys.Featured_promotion_category_leisure,
    ];

    try {
      String? i18nKey = category['i18nKey'];
      if (i18nKey != null && i18nKey.isNotEmpty) {
        return LanguageConfig.get(i18nKey);
      }
      String? chName = category['chName'];
      if (chName != null && chName.isNotEmpty) {
        return chName;
      }
    } catch (e) {}

    return index < keys.length
        ? LanguageConfig.get(keys[index])
        : LanguageConfig.get(LanguageConfigKeys.Promotion_highlight_category_fallback);
  }
}
