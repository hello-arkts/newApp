import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/model/BaseRsp.dart';
import 'package:mxcome/com/mxcome/app/model/ShopFeaturedServer.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';

import '../widget/LoadImageView.dart';
import '../widget/PriceText.dart';
import '../detail/ProductDetailPage.dart';

class ShopFeaturedProductsTab extends StatefulWidget {
  final int shopId;
  final int pageSize;

  const ShopFeaturedProductsTab({
    super.key,
    required this.shopId,
    this.pageSize = 10,
  });

  @override
  State<ShopFeaturedProductsTab> createState() =>
      _ShopFeaturedProductsTabState();
}

class _ShopFeaturedProductsTabState extends State<ShopFeaturedProductsTab> {
  int _pageNum = 1;
  int _total = 0;
  bool _loading = false;
  String? _errorText;
  List<dynamic> _items = [];

  @override
  void initState() {
    super.initState();
    _load(refresh: true);
  }

  Future<void> _load({required bool refresh}) async {
    if (_loading) return;
    if (widget.shopId <= 0) {
      setState(() {
        _errorText = '店铺不存在';
        _total = 0;
      });
      return;
    }

    setState(() {
      _loading = true;
      _errorText = null;
      if (refresh) {
        _pageNum = 1;
      }
    });

    try {
      final BaseRsp rsp = await ShopFeaturedServer.productByShopidUrl({
        'shopId': widget.shopId.toString(),
        'pageNum': _pageNum.toString(),
        'pageSize': widget.pageSize.toString(),
      });
      if (!mounted) return;

      if (rsp.retCode == RspRetCode.SUCCESS) {
        final data = rsp.data;
        final list = data is List ? data : [];
        final int currentCount = list.length;
        final bool hasMore = currentCount >= widget.pageSize;

        setState(() {
          if (refresh) {
            _items = list;
          } else {
            _items = [..._items, ...list];
          }
          // 如果本次返回的条数少于 pageSize，说明没有更多了
          _total = hasMore ? _items.length + 1 : _items.length;
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
          _errorText = rsp.msg;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorText = e.toString();
      });
    }
  }

  IndicatorResult _onRefresh() {
    _load(refresh: true);
    return IndicatorResult.success;
  }

  IndicatorResult _onLoadMore() {
    if (_loading) return IndicatorResult.success;
    if (_items.isEmpty) return IndicatorResult.noMore;
    if (_total > 0 && _items.length >= _total) return IndicatorResult.noMore;
    _pageNum += 1;
    _load(refresh: false);
    return IndicatorResult.success;
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _errorText ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: IConstant.grey_color),
          ),
          SizedBox(height: 12.w),
          ViewUtils.buildRetry(() => _load(refresh: true)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget empty = Center(
      child: Text(
        '暂无商品',
        style: TextStyle(fontSize: 14.sp, color: IConstant.grey_color),
      ),
    );

    final Widget body;
    if (_errorText != null && _items.isEmpty) {
      body = _buildError();
    } else if (_items.isEmpty && _loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_items.isEmpty) {
      body = empty;
    } else {
      body = CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 16.w),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    _ShopFeaturedProductCard(item: _items[index]),
                childCount: _items.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.w,
                crossAxisSpacing: 12.w,
                childAspectRatio: 0.6,
              ),
            ),
          ),
        ],
      );
    }

    return EasyRefresh(
      header: MaterialHeader(color: IConstant.main_color),
      footer: CupertinoFooter(
        emptyWidget: Container(
          padding: EdgeInsets.all(10.w),
          child: Text(
            '没有更多了',
            style: TextStyle(fontSize: 14.sp, color: IConstant.text_color),
          ),
        ),
      ),
      onRefresh: () async => _onRefresh(),
      onLoad: () async => _onLoadMore(),
      child: body,
    );
  }
}

class _ShopFeaturedProductCard extends StatelessWidget {
  final dynamic item;

  const _ShopFeaturedProductCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final String name = BaseModel.getString(item, 'name');
    final String pic = BaseModel.getString(item, 'pic');
    final double price = BaseModel.getDouble(item, 'price'); // 真实价格，红色
    final double originalPrice =
        BaseModel.getDouble(item, 'originalPrice'); // 原价，灰色
    final String productId = BaseModel.getString(item, 'id'); // 商品ID

    return GestureDetector(
      onTap: () {
        if (productId.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(productId),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: LoadImageView(double.infinity, double.infinity, pic),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: IConstant.title_color,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: PriceText(
                                        price,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFFF4D4F),
                                      ),
                                    ),
                                  ),
                                  if (originalPrice > 0 &&
                                      originalPrice != price)
                                    Flexible(
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 2.w),
                                        child: Text(
                                          '฿${originalPrice.toStringAsFixed(0)}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: IConstant.grey_color,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
