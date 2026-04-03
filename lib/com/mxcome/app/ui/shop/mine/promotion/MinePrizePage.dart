import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/promotion/PrizeExchangePage.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../config/LanguageConfig.dart';

class MinePrizePage extends StatefulWidget {

  MinePrizePage();

  @override
  State<MinePrizePage> createState() => MinePrizePageState();
}

class MinePrizePageState extends BaseKeepAliveState<MinePrizePage>
    with SingleTickerProviderStateMixin {

  late TabController tabController;

  int currentIndex = 0;

  final titles = [
    LanguageConfig.get(LanguageConfigKeys.Shop_mine_exchange_voucher),
    LanguageConfig.get(LanguageConfigKeys.Shop_mine_entity_prizes)
  ];
  
  final pages = [PrizeExchangePage("1"), PrizeExchangePage("0")];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: titles.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: buildAppBar(),
        body: TabBarView(
          controller: tabController,
          children: pages.map((item)=>item).toList(),
        ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      titleSpacing: 10.w,
      centerTitle: true,
      title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_promotion_rewards),
          style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      bottom: buildPreferredSize(),
    );
  }

  PreferredSize buildPreferredSize() {
    return PreferredSize(
      preferredSize: Size.fromHeight(40.w),
      child: TabBar(
        dividerColor: Colors.transparent,
        controller: tabController,
        indicatorColor: IConstant.main_color,
        labelColor: IConstant.main_color,
        unselectedLabelColor: IConstant.text_color,
        tabs: titles.map((item)=>Tab(text: item,)).toList(),
        indicatorWeight: 3,
      ),
    );
  }

}
