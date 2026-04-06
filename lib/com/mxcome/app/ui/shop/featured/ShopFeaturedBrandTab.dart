import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';

class ShopFeaturedBrandTab extends StatelessWidget {
  final int shopId;

  const ShopFeaturedBrandTab({
    super.key,
    required this.shopId,
  });

  @override
  Widget build(BuildContext context) {
    // 待后续补充关于品牌接口及具体内容
    return Center(
      child: Text(
        '关于品牌暂无内容',
        style: TextStyle(fontSize: 14.sp, color: IConstant.grey_color),
      ),
    );
  }
}
