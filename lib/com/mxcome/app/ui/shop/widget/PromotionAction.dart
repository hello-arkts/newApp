import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import '../utils/FormatUtil.dart';

/// 精选优惠 - 优惠操作组件
/// 对应红色标记区域 2：展示优惠操作按钮或交互元素
/// 独立可复用，具有清晰的接口和样式隔离
class PromotionAction extends StatelessWidget {
  /// 优惠商品数据列表
  /// 每个商品应包含：id, name, pic, minPrice, maxPrice, promotionAmount
  final List<dynamic> promotionItems;
  
  /// 点击优惠商品的回调
  final Function(dynamic)? onPromotionTap;
  
  /// 每行显示的商品数量
  final int columnsCount;
  
  /// 商品卡片的高度
  final double cardHeight;

  const PromotionAction({
    Key? key,
    required this.promotionItems,
    this.onPromotionTap,
    this.columnsCount = 2,
    this.cardHeight = 220,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (promotionItems.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(6.w),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        primary: false,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnsCount,
          mainAxisExtent: 160.h, // 增加高度以适应图片
          mainAxisSpacing: 12.w,
          crossAxisSpacing: 12.w,
        ),
        itemCount: promotionItems.length > 4 ? 4 : promotionItems.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildPromotionItem(index);
        },
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState() {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_offer_outlined,
              size: 60.w,
              color: IConstant.grey_color.withOpacity(0.3),
            ),
            SizedBox(height: 12.h),
            Text(
              '暂无精选优惠',
              style: TextStyle(
                fontSize: 14.sp,
                color: IConstant.grey_color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建优惠商品项
  Widget _buildPromotionItem(int index) {
    if (index >= promotionItems.length) {
      return const SizedBox.shrink();
    }

    final item = promotionItems[index];
    final String name = BaseModel.getString(item, "name");
    final String logo = BaseModel.getString(item['shop'], "logo");
    final String pic = BaseModel.getString(item, "pic");
    final String promotionAmount = _getPromotionAmount(item);

    return GestureDetector(
      onTap: () {
        if (onPromotionTap != null) {
          onPromotionTap!(item);
        }
      },
      child: Container(
        height: 160.h,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo 圆形头像
            Container(
              width: 35.w,
              height: 35.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: IConstant.grey_color.withOpacity(0.1),
                image: logo.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(logo),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: logo.isEmpty
                  ? Icon(
                      Icons.store,
                      size: 20.w,
                      color: IConstant.grey_color,
                    )
                  : null,
            ),
            SizedBox(height: 6.h),
            // 店铺名称
            SizedBox(
              width: 84.w,
              height: 12.h,
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: IConstant.title_color,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 4.h),
            // 优惠金额（满减信息）
            Text(
              promotionAmount,
              style: TextStyle(
                fontSize: 12.sp,
                color: IConstant.main_color,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 6.h),
            // 立即使用按钮
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: IConstant.main_color,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '立即使用',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 获取优惠金额文本（满减信息）
  String _getPromotionAmount(dynamic item) {
    try {
      double minPoint = BaseModel.getDouble(item, "minPoint");
      double amount = BaseModel.getDouble(item, "amount");

      // 显示满减信息
      if (minPoint > 0) {
        return '满 ฿${minPoint.toInt()} 减 ฿${amount.toInt()}';
      } else {
        return '฿${amount.toInt()} 代金券';
      }
    } catch (e) {
      return '优惠';
    }
  }
}
