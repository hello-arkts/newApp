import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';

import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';

import '../../config/LanguageConfig.dart';
import 'HistoryItemPage.dart';

class HistoryPage extends StatefulWidget {

  HistoryPage();

  @override
  State<HistoryPage> createState() => HistoryPageState();
}

class HistoryPageState extends BaseKeepAliveState<HistoryPage>
    with SingleTickerProviderStateMixin {

  late TabController tabController;

  int currentIndex = 0;

  final titles = [
    LanguageConfig.get(LanguageConfigKeys.Shop_web3_transfer_out),
    LanguageConfig.get(LanguageConfigKeys.Shop_web3_transfer),
  ];
  
  final pages = [HistoryItemPage(0), HistoryItemPage(1)];

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
      title: buildPreferredSize(),
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
        isScrollable: false,
        tabAlignment: TabAlignment.center,
        tabs: titles.map((item)=>Tab(text: item,)).toList(),
        indicatorWeight: 3,
      ),
    );
  }

}
