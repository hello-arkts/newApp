import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/LanguageEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';

class GovRecommendBar extends StatefulWidget {
  const GovRecommendBar({
    Key? key,
  }) : super(key: key);

  @override
  State<GovRecommendBar> createState() => _GovRecommendBarState();
}

class _GovRecommendBarState extends State<GovRecommendBar> {
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
    return SizedBox(
      height: 59.w,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8.w,
              offset: Offset(0, 2.w),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      fontSize: 13.sp,
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
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildGovIcon('assets/icons/gov_iconLog_1.png', 0),
                SizedBox(width: 6.w),
                _buildGovIcon('assets/icons/gov_iconLog_2.png', 1),
                SizedBox(width: 6.w),
                _buildGovIcon('assets/icons/gov_iconLog_3.png', 2),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGovIcon(String assetPath, int index) {
    final double size = 32.r;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Image.asset(
          assetPath,
          width: size,
          height: size,
          fit: BoxFit.contain,
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