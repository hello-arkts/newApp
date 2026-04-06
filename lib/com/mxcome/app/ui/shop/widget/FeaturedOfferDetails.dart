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

  // 模拟数据 - 后续可以从 API 获取
  final List<dynamic> _allPromotionItems = List.generate(
      10,
      (index) => {
            'id': index,
            'name': '优惠商品 ${index + 1}',
            'discount': '满${(index + 1) * 100}减${(index + 1) * 10}',
            'logo': 'https://via.placeholder.com/80',
          });

  List<dynamic> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    if (_categories.isNotEmpty) {
      _loadPromotionItems(_categories[0]);
    }
  }

  Future<void> _loadPromotionItems(dynamic category) async {
    try {
      String categoryId = BaseModel.getString(category, 'id');
      var rsp = await HttpUtils.post(IURLConstant.MALL_COUPON_LIST, {
        'type': categoryId,
        'pageNum': '1',
        'pageSize': '999',
      });
      if (!mounted) return;
      if (rsp.retCode == 200) {
        setState(() {
          _filteredItems = BaseModel.getDynamicList(rsp.data, 'list') ?? [];
        });
      }
    } catch (e) {
      debugPrint('加载优惠券失败: $e');
      if (!mounted) return;
      setState(() {
        _filteredItems = List.from(_allPromotionItems);
      });
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.w),
            child: PromotionHighlight(
              categories: _categories,
              activeIndex: _activeIndex,
              mode: 'row',
              onCategoryTap: _onCategoryTap,
            ),
          ),
          // 商品列表
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                layoutBuilder:
                    (Widget? currentChild, List<Widget> previousChildren) {
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
                  scrollable: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
