import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/LanguagePage.dart';

class ShopFeaturedBrandTab extends StatefulWidget {
  final int shopId;
  final Map<String, dynamic>? shopData;

  const ShopFeaturedBrandTab({
    super.key,
    required this.shopId,
    this.shopData,
  });

  @override
  State<ShopFeaturedBrandTab> createState() => _ShopFeaturedBrandTabState();
}

class _ShopFeaturedBrandTabState extends State<ShopFeaturedBrandTab> {
  Map<String, dynamic>? _brandData;

  @override
  void initState() {
    super.initState();
    _initFromShopData();
  }

  void _initFromShopData() {
    final shop = widget.shopData!;
    String name = shop['brandName']?.toString() ?? '';
    String intro = '';
    if (LanguagePage.language == LanguageType.ZH) {
      name = shop['brandNameZh']?.toString() ?? name;
      intro = shop['introZh']?.toString() ?? '';
    } else if (LanguagePage.language == LanguageType.TH) {
      name = shop['brandNameTh']?.toString() ?? name;
      intro = shop['introTh']?.toString() ?? '';
    } else {
      name = shop['brandNameEn']?.toString() ?? name;
      intro = shop['introEn']?.toString() ?? '';
    }

    setState(() {
      _brandData = {
        'logo': shop['logoUrl'] ?? '',
        'name': name,
        'authMark': intro,
        'provoPhoto': '',
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_brandData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24.h),
          // 头部区域
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              if (_brandData!['logo'] != null &&
                  _brandData!['logo'].toString().isNotEmpty)
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: _brandData!['logo'].toString().trim(),
                    width: 72.w,
                    height: 72.w,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        _buildPlaceholderLogo(),
                  ),
                )
              else
                _buildPlaceholderLogo(),

              SizedBox(width: 8.w),

              // 品牌信息
              Expanded(
                child: SizedBox(
                  height: 72.w, // 与Logo高度一致，从而保证内容在这个高度内均匀分布
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        _brandData!['name']?.toString() ?? '',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      // Slogan / 副标题
                      Text(
                        _brandData!['email']?.toString().isNotEmpty == true
                            ? _brandData!['email'].toString()
                            : 'Think different',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // 品牌介绍文本
          Text(
            _brandData!['authMark']?.toString().isNotEmpty == true
                ? _brandData!['authMark'].toString()
                : 'Apple was founded as Apple Computer Company on April 1, 1976, by Steve Wozniak, Steve Jobs (1955–2011) and Ronald Wayne to develop and sell Wozniak\'s Apple I personal computer. It was incorporated by Jobs and Wozniak as Apple Computer, Inc. in 1977. The company\'s second computer, the Apple II, became a best seller and one of the first mass-produced microcomputers. Apple went public in 1980 to instant financial success.',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF333333),
              height: 1.6,
            ),
          ),

          SizedBox(height: 24.h),

          // 宣传图 + 播放按钮
          _buildMediaElement(_brandData!['provoPhoto']?.toString() ?? ''),

          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildMediaElement(String url) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: url.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: url.trim(),
                      width: double.infinity,
                      height: 200.h,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          _buildPlaceholderPhoto(),
                    )
                  : _buildPlaceholderPhoto(),
            ),
            // Play button overlay
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5.w),
              ),
              child: Center(
                child: Icon(Icons.play_arrow, color: Colors.white, size: 36.w),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        // 指示器
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFFF4D4F),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(width: 6.w),
            Container(
              width: 4.w,
              height: 4.w,
              decoration: const BoxDecoration(
                color: Color(0xFFFF4D4F),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlaceholderLogo() {
    return Container(
      width: 72.w,
      height: 72.w,
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(Icons.store, size: 32.w, color: const Color(0xFFCCCCCC)),
      ),
    );
  }

  Widget _buildPlaceholderPhoto() {
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Icon(Icons.image, size: 48.w, color: const Color(0xFFCCCCCC)),
      ),
    );
  }
}
