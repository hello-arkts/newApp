import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PromotionAction.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PromotionHighlight.dart';

class FeaturedOfferDetails extends StatefulWidget {
  const FeaturedOfferDetails({super.key});

  @override
  State<FeaturedOfferDetails> createState() => _FeaturedOfferDetailsState();
}

class _FeaturedOfferDetailsState extends State<FeaturedOfferDetails> {
  int _activeIndex = 0;

  // 模拟分类数据
  final List<dynamic> _categories = [
    {'id': 1, 'chName': '网红餐厅'},
    {'id': 2, 'chName': '酒店住宿'},
    {'id': 3, 'chName': '租车接机'},
    {'id': 4, 'chName': '景点门票'},
    {'id': 5, 'chName': '热门泰货'},
    {'id': 6, 'chName': '休闲娱乐'},
  ];

  // 模拟数据 - 后续可以从 API 获取
  final List<dynamic> _allPromotionItems = List.generate(10, (index) => {
    'id': index,
    'name': '优惠商品 ${index + 1}',
    'discount': '满${(index + 1) * 100}减${(index + 1) * 10}',
    'logo': 'https://via.placeholder.com/80',
  });

  List<dynamic> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(_allPromotionItems);
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
            ),
          ),
          // 商品列表
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
