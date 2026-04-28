import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/LanguagePage.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/LoadImageView.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/detail/VideoPlayerWidget.dart';

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
    String subtitle = '';
    if (LanguagePage.language == LanguageType.ZH) {
      name = shop['brandNameZh']?.toString() ?? name;
      intro = shop['introZh']?.toString() ?? '';
      subtitle = shop['brandNameZh2']?.toString() ?? '';
    } else if (LanguagePage.language == LanguageType.TH) {
      name = shop['brandNameTh']?.toString() ?? name;
      intro = shop['introTh']?.toString() ?? '';
      subtitle = shop['brandNameTh2']?.toString() ?? '';
    } else {
      name = shop['brandNameEn']?.toString() ?? name;
      intro = shop['introEn']?.toString() ?? '';
      subtitle = shop['brandNameEn2']?.toString() ?? '';
    }

    setState(() {
      _brandData = {
        'logo': shop['logoUrl'] ?? '',
        'name': name,
        'subtitle': subtitle,
        'authMark': intro,
        'videoUrls': shop['videoUrls'] ?? '',
      };
    });
  }

  bool _isBrandDataEmpty() {
    if (_brandData == null) return true;
    final logo = _brandData!['logo']?.toString() ?? '';
    final name = _brandData!['name']?.toString() ?? '';
    final subtitle = _brandData!['subtitle']?.toString() ?? '';
    final authMark = _brandData!['authMark']?.toString() ?? '';
    final videoUrls = _brandData!['videoUrls']?.toString() ?? '';
    return logo.isEmpty && name.isEmpty && subtitle.isEmpty && authMark.isEmpty && videoUrls.isEmpty;
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store_outlined,
            size: 80.w,
            color: IConstant.grey_color,
          ),
          SizedBox(height: 16.w),
          Text(
            LanguageConfig.get(LanguageConfigKeys.Shop_featured_products_empty),
            style: TextStyle(fontSize: 16.sp, color: IConstant.grey_color),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_brandData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_isBrandDataEmpty()) {
      return _buildEmpty();
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
                        _brandData!['subtitle']?.toString() ?? '',
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
            _brandData!['authMark']?.toString() ?? '',
            textAlign: TextAlign.left,
            softWrap: true,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF333333),
              height: 1.6,
            ),
          ),

          SizedBox(height: 24.h),

          // 宣传图 + 播放按钮
          _buildMediaElement(_brandData!['videoUrls']?.toString() ?? ''),

          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildMediaElement(String urls) {
    if (urls.isEmpty) {
      return _buildPlaceholderPhoto();
    }

    List<String> urlList = urls.split(',').where((url) => url.trim().isNotEmpty).toList();
    if (urlList.isEmpty) {
      return _buildPlaceholderPhoto();
    }

    return SizedBox(
      height: 200.h,
      child: Swiper(
        key: UniqueKey(),
        itemBuilder: (BuildContext context, int index) {
          String mediaUrl = urlList[index].trim();
          if (_isVideoUrl(mediaUrl)) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: VideoPlayerWidget(videoUrl: mediaUrl, volume: 0.5),
            );
          } else {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: LoadImageView(1.sw, 200.h, mediaUrl),
            );
          }
        },
        itemCount: urlList.length,
        loop: urlList.length == 1 ? false : true,
        pagination: SwiperPagination(
          builder: DotSwiperPaginationBuilder(
            color: IConstant.grey_bg_color,
            activeColor: IConstant.main_color,
          ),
        ),
      ),
    );
  }

  bool _isVideoUrl(String url) {
    String lowerUrl = url.toLowerCase();
    return lowerUrl.endsWith('.mp4') ||
        lowerUrl.endsWith('.mov') ||
        lowerUrl.endsWith('.avi') ||
        lowerUrl.endsWith('.mkv') ||
        lowerUrl.endsWith('.webm');
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
