import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/model/BaseRsp.dart';
import 'package:mxcome/com/mxcome/app/model/ShopFeaturedServer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ShopFeaturedBrandTab extends StatefulWidget {
  final int shopId;

  const ShopFeaturedBrandTab({
    super.key,
    required this.shopId,
  });

  @override
  State<ShopFeaturedBrandTab> createState() => _ShopFeaturedBrandTabState();
}

class _ShopFeaturedBrandTabState extends State<ShopFeaturedBrandTab> {
  bool _isLoading = true;
  bool _hasError = false;
  Map<String, dynamic>? _brandData;

  @override
  void initState() {
    super.initState();
    _fetchBrandData();
  }

  Future<void> _fetchBrandData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final BaseRsp rsp = await ShopFeaturedServer.shopBrandByShopidUrl({
        'shopId': widget.shopId.toString(),
      });

      if (!mounted) return;

      if (rsp.retCode == RspRetCode.SUCCESS && rsp.data != null) {
        setState(() {
          _brandData = rsp.data as Map<String, dynamic>;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      print('Brand Error: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError || _brandData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('加载品牌数据失败',
                style: TextStyle(color: IConstant.grey_color, fontSize: 14.sp)),
            SizedBox(height: 10.h),
            ElevatedButton(
              onPressed: _fetchBrandData,
              child: const Text('点击重试'),
            )
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          // Logo
          if (_brandData!['logo'] != null &&
              _brandData!['logo'].toString().isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CachedNetworkImage(
                imageUrl: _brandData!['logo'].toString().trim(),
                width: 80.w,
                height: 80.w,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => _buildPlaceholderLogo(),
              ),
            )
          else
            _buildPlaceholderLogo(),

          SizedBox(height: 16.h),
          // 品牌名称
          Text(
            _brandData!['name']?.toString() ?? '',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF333333),
            ),
          ),

          SizedBox(height: 8.h),
          // 联系人/邮箱
          if (_brandData!['contactName']?.toString().isNotEmpty == true ||
              _brandData!['email']?.toString().isNotEmpty == true)
            Text(
              [
                if (_brandData!['contactName']?.toString().isNotEmpty == true)
                  'Contact: ${_brandData!['contactName']}',
                if (_brandData!['email']?.toString().isNotEmpty == true)
                  _brandData!['email'].toString(),
              ].join(' | '),
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF999999),
              ),
            ),

          SizedBox(height: 24.h),
          // 官网按钮
          if (_brandData!['officialWebsite']?.toString().isNotEmpty == true)
            OutlinedButton.icon(
              onPressed: () {
                // 点击跳转官网逻辑
              },
              icon: Icon(Icons.language,
                  size: 16.w, color: const Color(0xFF333333)),
              label: Text(
                '官网',
                style:
                    TextStyle(fontSize: 14.sp, color: const Color(0xFF333333)),
              ),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                side: const BorderSide(color: Color(0xFFDDDDDD)),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              ),
            ),

          SizedBox(height: 32.h),
          // 品牌介绍/认证标识 (使用 authMark 或默认文案)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              _brandData!['authMark']?.toString().isNotEmpty == true
                  ? _brandData!['authMark'].toString()
                  : 'Welcome to ${_brandData!['name']?.toString() ?? 'our brand'}. We are dedicated to providing the best products and services to our customers.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF666666),
                height: 1.5,
              ),
            ),
          ),

          SizedBox(height: 40.h),
          // 宣传图片
          if (_brandData!['provoPhoto']?.toString().isNotEmpty == true)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: CachedNetworkImage(
                  imageUrl: _brandData!['provoPhoto'].toString().trim(),
                  width: double.infinity,
                  height: 200.h,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) =>
                      _buildPlaceholderPhoto(),
                ),
              ),
            )
          else
            _buildPlaceholderPhoto(),

          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildPlaceholderLogo() {
    return Container(
      width: 80.w,
      height: 80.w,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Icon(Icons.store, size: 40.w, color: const Color(0xFFCCCCCC)),
      ),
    );
  }

  Widget _buildPlaceholderPhoto() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        height: 200.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Icon(Icons.image, size: 48.w, color: const Color(0xFFCCCCCC)),
        ),
      ),
    );
  }
}
