import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CouponDetailDrawer.dart';

import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:sprintf/sprintf.dart';

/// 精选优惠 - 优惠操作组件
/// 对应红色标记区域 2：展示优惠操作按钮或交互元素
/// 独立可复用，具有清晰的接口和样式隔离
class PromotionAction extends StatefulWidget {
  /// 优惠商品数据列表
  /// 每个商品应包含：id, name, pic, minPrice, maxPrice, promotionAmount
  final List<dynamic> promotionItems;

  /// 点击优惠商品的回调
  final Function(dynamic)? onPromotionTap;

  final Function(dynamic)? onUseTap;

  /// 每行显示的商品数量
  final int columnsCount;

  /// 商品卡片的高度
  final double cardHeight;

  /// 最多显示多少个商品；为 null 时显示全部
  final int? maxItems;

  /// 是否允许组件内部滚动
  final bool scrollable;

  const PromotionAction({
    Key? key,
    required this.promotionItems,
    this.onPromotionTap,
    this.onUseTap,
    this.columnsCount = 2,
    this.cardHeight = 220,
    this.maxItems = 4,
    this.scrollable = false,
  }) : super(key: key);

  @override
  State<PromotionAction> createState() => _PromotionActionState();
}

class _PromotionActionState extends State<PromotionAction> {
  @override
  Widget build(BuildContext context) {
    if (widget.promotionItems.isEmpty) {
      return _buildEmptyState();
    }

    final int itemCount = widget.maxItems == null
        ? widget.promotionItems.length
        : math.min(widget.promotionItems.length, widget.maxItems!);

    final EdgeInsets containerPadding =
        widget.scrollable ? EdgeInsets.zero : EdgeInsets.all(6.w);
    final EdgeInsets gridPadding = widget.scrollable
        ? EdgeInsets.fromLTRB(6.w, 10.h, 6.w, 10.h)
        : EdgeInsets.zero;

    final Widget gridView = GridView.builder(
      padding: gridPadding,
      primary: false,
      shrinkWrap: true, // 强制让 GridView 计算内容高度
      physics:
          const NeverScrollableScrollPhysics(), // 禁用内部滚动，让外层的 CustomScrollView 接管滑动事件
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.columnsCount,
        mainAxisExtent: 125.h,
        mainAxisSpacing: 12.w,
        crossAxisSpacing: 12.w,
      ),
      itemCount: itemCount,
      itemBuilder: (BuildContext context, int index) {
        return _buildPromotionItem(index);
      },
    );

    return Container(
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: containerPadding,
      child: gridView,
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
              LanguageConfig.get(LanguageConfigKeys.Featured_promotion_empty),
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
    if (index >= widget.promotionItems.length) {
      return const SizedBox.shrink();
    }

    final item = widget.promotionItems[index];
    final String name = BaseModel.getString(item, "name");
    final String logo = BaseModel.getString(item['shop'], "logo");
    final String promotionAmount = _getPromotionAmount(item);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (widget.onUseTap != null) {
            widget.onUseTap!(item);
            return;
          }
          final dynamic coupon = BaseModel.getDynamic(item, 'coupon');
          final String couponId = BaseModel.getString(item, 'id').isNotEmpty
              ? BaseModel.getString(item, 'id')
              : (BaseModel.getString(item, 'couponId').isNotEmpty
                  ? BaseModel.getString(item, 'couponId')
                  : BaseModel.getString(coupon, 'id'));
          if (couponId.isEmpty) {
            if (widget.onPromotionTap != null) {
              widget.onPromotionTap!(item);
            }
            return;
          }
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) {
              return CouponDetailDrawer(
                initialCouponId: couponId,
                initialItem: item,
              );
            },
          );
        },
        borderRadius: BorderRadius.circular(22.r),
        child: Container(
          height: 125.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 72.w,
                height: 72.w,
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
                        size: 34.w,
                        color: IConstant.grey_color,
                      )
                    : null,
              ),
              SizedBox(height: 6.h),
              SizedBox(
                height: 14.h,
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: IConstant.title_color,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                promotionAmount,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: IConstant.main_color,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
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
        return sprintf(
            LanguageConfig.get(
                LanguageConfigKeys.Featured_promotion_discount_full),
            [minPoint.toInt(), amount.toInt()]);
      } else {
        return sprintf(
            LanguageConfig.get(LanguageConfigKeys.Featured_promotion_voucher),
            [amount.toInt()]);
      }
    } catch (e) {
      return LanguageConfig.get(LanguageConfigKeys.Featured_promotion_discount);
    }
  }

  /// 构建立即使用按钮
  // Widget _buildActionButton(dynamic item) {
  //   return Material(
  //     color: Colors.transparent,
  //     child: InkWell(
  //       onTap: () {
  //         if (widget.onUseTap != null) {
  //           widget.onUseTap!(item);
  //           return;
  //         }
  //         final dynamic coupon = BaseModel.getDynamic(item, 'coupon');
  //         final String couponId = BaseModel.getString(item, 'id').isNotEmpty
  //             ? BaseModel.getString(item, 'id')
  //             : (BaseModel.getString(item, 'couponId').isNotEmpty
  //                 ? BaseModel.getString(item, 'couponId')
  //                 : BaseModel.getString(coupon, 'id'));
  //         if (couponId.isEmpty) {
  //           if (widget.onPromotionTap != null) {
  //             widget.onPromotionTap!(item);
  //           }
  //           return;
  //         }
  //         showModalBottomSheet(
  //           context: context,
  //           isScrollControlled: true,
  //           backgroundColor: Colors.transparent,
  //           builder: (_) {
  //             return CouponDetailDrawer(
  //               initialCouponId: couponId,
  //               initialItem: item,
  //             );
  //           },
  //         );
  //       },
  //       borderRadius: BorderRadius.circular(20.r),
  //       splashColor: IConstant.main_color.withOpacity(0.2),
  //       highlightColor: IConstant.main_color.withOpacity(0.1),
  //       child: Container(
  //         padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(20.r),
  //           border: Border.all(
  //             color: Colors.grey.shade400,
  //             width: 1.w,
  //           ),
  //         ),
  //         child: Text(
  //           LanguageConfig.get(LanguageConfigKeys.Featured_promotion_use_now),
  //           style: TextStyle(
  //             fontSize: 10.sp,
  //             color: IConstant.title_color,
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
