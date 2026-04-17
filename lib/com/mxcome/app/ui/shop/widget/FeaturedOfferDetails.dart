import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/IURLConstant.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PromotionAction.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PromotionHighlight.dart';
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';

class FeaturedOfferDetails extends StatefulWidget {
  const FeaturedOfferDetails({super.key});

  @override
  State<FeaturedOfferDetails> createState() => _FeaturedOfferDetailsState();
}

class _FeaturedOfferDetailsState extends State<FeaturedOfferDetails> {
  int _activeIndex = 0;

  // 模拟分类数据
  final List<dynamic> _categories = featuredPromotionCategories;

  List<dynamic> _filteredItems = [];
  int _pageNum = 1;
  int _pageSize = 10;
  bool _hasMore = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (_categories.isNotEmpty) {
      _loadPromotionItems(_categories[0]);
    }
  }

  Future<void> _loadPromotionItems(dynamic category,
      {bool isLoadMore = false}) async {
    if (_isLoading) return;

    if (!isLoadMore) {
      _pageNum = 1;
      _hasMore = true;
      setState(() {
        _filteredItems = [];
      });
    }

    if (!_hasMore) return;

    _isLoading = true;
    try {
      String categoryId = BaseModel.getString(category, 'id');
      var rsp = await HttpUtils.post(IURLConstant.MALL_COUPON_LIST, {
        'type': categoryId,
        'pageNum': _pageNum.toString(),
        'pageSize': _pageSize.toString(),
      });
      if (!mounted) return;
      if (rsp.retCode == 200) {
        List<dynamic> newItems =
            BaseModel.getDynamicList(rsp.data, 'list') ?? [];

        setState(() {
          if (isLoadMore) {
            _filteredItems.addAll(newItems);
          } else {
            _filteredItems = newItems;
          }

          if (newItems.length < _pageSize) {
            _hasMore = false;
          } else {
            _pageNum++;
          }
        });
      }
    } catch (e) {
      debugPrint('加载优惠券失败: $e');
    } finally {
      _isLoading = false;
    }
  }

  void _onCategoryTap(dynamic category) {
    final index = _categories.indexOf(category);
    if (index < 0 || index == _activeIndex) return;
    setState(() {
      _activeIndex = index;
    });
    _loadPromotionItems(category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LanguageConfig.get(LanguageConfigKeys.Featured_promotion_title),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: IConstant.title_color,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: IConstant.title_color),
      ),
      backgroundColor: IConstant.white_color,
      body: Column(
        children: [
          // 固定的头部，不受滚动影响
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.w),
            child: PromotionHighlight(
              categories: _categories,
              activeIndex: _activeIndex,
              mode: 'row',
              onCategoryTap: _onCategoryTap,
            ),
          ),
          // 可滚动和下拉刷新的商品列表区域
          Expanded(
            child: EasyRefresh(
              header: const MaterialHeader(color: IConstant.main_color),
              footer: CupertinoFooter(
                emptyWidget: Container(
                  padding: EdgeInsets.all(10.w),
                  child: Text(
                    LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_more),
                    style:
                        TextStyle(fontSize: 13.sp, color: IConstant.text_color),
                  ),
                ),
              ),
              onRefresh: () async {
                if (_categories.isNotEmpty) {
                  await _loadPromotionItems(_categories[_activeIndex],
                      isLoadMore: false);
                }
              },
              onLoad: () async {
                if (_categories.isNotEmpty && _hasMore) {
                  await _loadPromotionItems(_categories[_activeIndex],
                      isLoadMore: true);
                  if (!_hasMore) return IndicatorResult.noMore;
                  return IndicatorResult.success;
                }
                return IndicatorResult.noMore;
              },
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    sliver: SliverToBoxAdapter(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        layoutBuilder: (Widget? currentChild,
                            List<Widget> previousChildren) {
                          return Stack(
                            alignment: Alignment.topCenter,
                            children: <Widget>[
                              ...previousChildren,
                              if (currentChild != null) currentChild,
                            ],
                          );
                        },
                        child: PromotionAction(
                          key: ValueKey(_activeIndex),
                          promotionItems: _filteredItems,
                          maxItems: null,
                          scrollable: false, // 让 CustomScrollView 接管滑动
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
