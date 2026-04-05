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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(12.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnsCount,
          mainAxisExtent: cardHeight.h,
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
    final String pic = BaseModel.getString(item, "pic");
    final double price = BaseModel.getDouble(item, "price");
    final String promotionAmount = _getPromotionAmount(item);

    return GestureDetector(
      onTap: () {
        if (onPromotionTap != null) {
          onPromotionTap!(item);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: IConstant.white_bg_color, width: 1.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 商品图片
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              child: Stack(
                children: [
                  Image.network(
                    pic,
                    width: double.infinity,
                    height: 120.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 120.h,
                        color: IConstant.grey_color.withOpacity(0.1),
                        child: Icon(
                          Icons.image,
                          size: 40.w,
                          color: IConstant.grey_color.withOpacity(0.3),
                        ),
                      );
                    },
                  ),
                  // 优惠标签
                  Positioned(
                    top: 6.h,
                    left: 6.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: IConstant.main_color.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        '特惠',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 商品信息
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(8.w, 6.w, 8.w, 0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 商品名称
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: IConstant.title_color,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    // 优惠金额
                    Text(
                      promotionAmount,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: IConstant.main_color,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    // 价格和使用按钮
                    _buildPriceAndButton(price),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建价格和使用按钮
  Widget _buildPriceAndButton(double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 价格
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '¥',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: IConstant.title_color,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: price.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: IConstant.title_color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // 使用按钮
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: IConstant.main_color,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            '立即使用',
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  /// 获取优惠金额文本
  String _getPromotionAmount(dynamic item) {
    try {
      double minProfit = BaseModel.getDouble(item, "minProfit");
      double maxProfit = BaseModel.getDouble(item, "maxProfit");
      return FormatUtil.profitAmount(maxProfit, maxPrice: maxProfit);
    } catch (e) {
      return '优惠详情';
    }
  }
}
