import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mxcome/com/mxcome/app/model/BaseRsp.dart';
import 'package:mxcome/com/mxcome/app/model/ShopFeaturedServer.dart';

// 精选店铺组件
class ShopFeaturedScroller extends StatefulWidget {
  const ShopFeaturedScroller({super.key});

  @override
  State<ShopFeaturedScroller> createState() => _ShopFeaturedScrollerState();
}

class _ShopFeaturedScrollerState extends State<ShopFeaturedScroller> {
  List<dynamic> _shopList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchShopList();
  }

  Future<void> _fetchShopList() async {
    try {
      final BaseRsp rsp = await ShopFeaturedServer.shopListUrl();
      if (mounted && rsp.retCode == RspRetCode.SUCCESS && rsp.data != null) {
        final Map<String, dynamic> data = rsp.data as Map<String, dynamic>;
        final List<Map<String, String>> parsedList = [];

        int i = 1;
        while (true) {
          final logoKey = 'shopLogo$i';
          final nameKey = 'shopName$i';
          final urlKey = 'url$i';

          if (data.containsKey(logoKey)) {
            parsedList.add({
              'logo':
                  data[logoKey]?.toString().trim().replaceAll('`', '') ?? '',
              'name': data[nameKey]?.toString() ?? '',
              'url': data[urlKey]?.toString().trim().replaceAll('`', '') ?? '',
            });
            i++;
          } else {
            break;
          }
        }

        setState(() {
          _shopList = parsedList;
          _isLoading = false;
        });
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 80.w,
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_shopList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _shopList.length <= 3
          // ≤3个：均匀分布，每个卡片等宽
          ? Row(
              children: List.generate(_shopList.length, (index) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: _buildShopCard(_shopList[index]),
                  ),
                );
              }),
            )
          // >3个：水平滚动
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: List.generate(_shopList.length, (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 0 : 8.w,
                    ),
                    child: SizedBox(
                      width: 100.w,
                      child: _buildShopCard(_shopList[index]),
                    ),
                  );
                }),
              ),
            ),
    );
  }

  Widget _buildShopCard(dynamic shop) {
    final logoUrl = shop['logo']?.toString() ?? '';
    final url = shop['url']?.toString() ?? '';

    return GestureDetector(
      onTap: () async {
        if (url.isNotEmpty) {
          final Uri uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      },
      child: Container(
        height: 56.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.w),
          border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.w),
          child: logoUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: logoUrl,
                  fit: BoxFit.contain,
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.store, color: Colors.grey),
                )
              : const Icon(Icons.store, color: Colors.grey),
        ),
      ),
    );
  }
}
