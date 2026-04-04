import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';

class GovRecommendBar extends StatelessWidget {
  const GovRecommendBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 59.h, // 严格固定高度
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    LanguageConfig.get(LanguageConfigKeys.Gov_recommend_title),
                    style: TextStyle(
                      fontSize: 13.sp, // 稍微缩小字体适应固定高度
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    LanguageConfig.get(LanguageConfigKeys.Gov_recommend_subtitle),
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF999999),
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildGovIcon('assets/icons/gov_icon_1.png', 0),
                  SizedBox(width: 6.w),
                  _buildGovIcon('assets/icons/gov_icon_2.png', 1),
                  SizedBox(width: 6.w),
                  _buildGovIcon('assets/icons/gov_icon_3.png', 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGovIcon(String assetPath, int index) {
    final double size = 32.r; // 图标略缩小，适配 59.h
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFF5F5F5),
        border: Border.all(
          color: const Color(0xFFE8E8E8),
          width: 1,
        ),
      ),
      child: ClipOval(
        child: Image.asset(
          assetPath,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return SizedBox(
              width: size,
              height: size,
              child: ColoredBox(
                color: const Color(0xFFE8E8E8),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFF999999),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}