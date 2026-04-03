import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/pocket/PrizeActivityPage.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../config/LanguageConfig.dart';
import 'PrizeTaskPage.dart';

class PrizeTabPage extends StatefulWidget {

  PrizeTabPage();

  @override
  State<PrizeTabPage> createState() => PrizeTabPageState();
}

class PrizeTabPageState extends BaseKeepAliveState<PrizeTabPage>
    with SingleTickerProviderStateMixin {

  late TabController tabController;

  int currentIndex = 0;

  final titles = [
    LanguageConfig.get(LanguageConfigKeys.Shop_pocket_task),
    LanguageConfig.get(LanguageConfigKeys.Shop_activity),
  ];
  
  final pages = [PrizeTaskPage(), PrizeActivityPage()];

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
      title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_prize),
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
