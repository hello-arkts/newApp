import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';

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
class PromotionHighlight extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        // color: Colors.white,
      ),
      padding: EdgeInsets.all(2.w),
      child: mode == 'row' ? _buildRowMode() : _buildGridMode(),
    );
  }

  /// 构建单行滚动模式
  Widget _buildRowMode() {
    return SizedBox(
      height: cardHeight.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.only(right: 12.w),
            child: _buildCategoryItem(index),
          );
        },
      ),
    );
  }

  /// 构建九宫格模式
  Widget _buildGridMode() {
    return GridView.builder(
      padding: EdgeInsets.zero, // 移除默认内边距
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnsCount,
        mainAxisExtent: cardHeight.h,
        mainAxisSpacing: 12.w,
        crossAxisSpacing: 12.w,
      ),
      itemCount: categories.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildCategoryItem(index);
      },
    );
  }

  /// 构建分类项
  Widget _buildCategoryItem(int index) {
    if (index >= categories.length) {
      return const SizedBox.shrink();
    }

    final category = categories[index];
    final String icon = _getCategoryIcon(index);
    final String name = _getCategoryName(category, index);

    return GestureDetector(
      onTap: () {
        if (onCategoryTap != null) {
          onCategoryTap!(category);
        }
      },
      child: Container(
        padding: mode == 'row'
            ? EdgeInsets.symmetric(horizontal: 14.w)
            : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: _getCategoryBgColor(index),
          borderRadius: BorderRadius.circular(20.r),
          border: index == activeIndex
              ? Border.all(
                  color: IConstant.main_color.withOpacity(0.3), width: 1.w)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: mode == 'row' ? MainAxisSize.min : MainAxisSize.max,
          children: [
            // 分类图标
            _buildCategoryIcon(icon, index),
            SizedBox(width: 6.w),
            // 分类名称
            mode == 'row'
                ? Text(
                    name,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: index == activeIndex
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: index == activeIndex
                          ? IConstant.main_color
                          : IConstant.title_color,
                    ),
                  )
                : Flexible(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: index == activeIndex
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: index == activeIndex
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
        // 如果图片加载失败，使用默认图标
        return Icon(
          _getDefaultIcon(index),
          size: 20.w,
          color: index == 0 ? IConstant.main_color : IConstant.text_color,
        );
      },
    );
  }

  /// 获取分类图标路径
  String _getCategoryIcon(int index) {
    const icons = [
      'assets/icons/category_restaurant.png',
      'assets/icons/category_hotel.png',
      'assets/icons/category_car.png',
      'assets/icons/category_ticket.png',
      'assets/icons/category_popular.png',
      'assets/icons/category_leisure.png',
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
    const names = [
      '网红餐厅',
      '酒店住宿',
      '租车接机',
      '景点门票',
      '热门泰货',
      '休闲娱乐',
    ];

    // 如果有传入的 category 数据，优先使用
    try {
      String? i18nKey = category['i18nKey'];
      if (i18nKey != null && i18nKey.isNotEmpty) {
        return LanguageConfig.get(i18nKey);
      }
      String? chName = category['chName'];
      if (chName != null && chName.isNotEmpty) {
        return chName;
      }
    } catch (e) {
      // 忽略错误
    }

    return index < names.length ? names[index] : '分类';
  }

  /// 获取分类背景颜色
  Color _getCategoryBgColor(int index) {
    // 如果是选中的分类，使用主色调背景
    if (index == activeIndex) {
      return IConstant.main_color.withOpacity(0.1);
    }

    const colors = [
      Color(0xFFFFF0F0), // 网红餐厅 - 浅红色
      Color(0xFFF0F8FF), // 酒店住宿 - 浅蓝色
      Color(0xFFFFF8F0), // 租车接机 - 浅橙色
      Color(0xFFF0F8F0), // 景点门票 - 浅绿色
      Color(0xFFFFF0F8), // 热门泰货 - 浅粉色
      Color(0xFFF8F0FF), // 休闲娱乐 - 浅紫色
    ];
    return index < colors.length ? colors[index] : const Color(0xFFF5F5F5);
  }
}
