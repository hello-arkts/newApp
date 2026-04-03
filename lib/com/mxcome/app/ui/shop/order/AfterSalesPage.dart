import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/order/SearchAfterSalesList.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../utils/TextUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../event/OrderSearchEvent.dart';
import '../utils/EventBusUtil.dart';
import '../widget/SmallTextButton.dart';
import 'AfterSalesList.dart';
import 'OrderPage.dart';

class AfterSalesPage extends StatefulWidget {

  String status = "-1";

  AfterSalesPage(this.status, {super.key});

  @override
  State<AfterSalesPage> createState() => _AfterSalesPageState();
}

class _AfterSalesPageState extends BaseKeepAliveState<AfterSalesPage>
    with SingleTickerProviderStateMixin {

  late TabController tabController;

  int currentIndex = 0;

  final titles = [
    LanguageConfig.get(LanguageConfigKeys.Shop_sales_apply),
    LanguageConfig.get(LanguageConfigKeys.Shop_sales_application_record),
  ];

  final pages = [
    AfterSalesList("0"),
    AfterSalesList("-2")
  ];

  String searchText = "";

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
      body: TextUtils.isEmpty(searchText) ? Column(
        children: [
          buildPreferredSize(),
          Expanded(child: TabBarView(
            controller: tabController,
            children: pages.map((item)=>item).toList(),
          ))
        ],
      ) : SearchAfterSalesList(searchText),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      titleSpacing: 10.w,
      centerTitle: true,
      title: Container(
        decoration: BoxDecoration(
            color: IConstant.grey_bg_color,
            borderRadius: BorderRadius.all(Radius.circular(40.w))),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0.w, 0.w, 0.w),
          child: Row(children: [
            Image.asset("assets/icons/search.png",
                width: 18.w, height: 18.w, color: IConstant.sub_text_color),
            SizedBox(width: 10.w),
            Expanded(child: buildSearch()),
            // InkWell(
            //   onTap: () {
            //     showScanDialog();
            //   },
            //   child: Center(
            //       child: Container(
            //         margin: EdgeInsets.only(left: 5.w, right: 10.w),
            //         child: Image.asset("assets/icons/camera.png",
            //             width: 18.w, height: 18.w, color: IConstant.sub_text_color),)),
            // ),
          ]),
        ),
      ),
      actions: <Widget>[
        TextUtils.isEmpty(searchText) ? Container(
            margin: EdgeInsets.fromLTRB(6.w, 10.w, 16.w, 10.w),
            child: SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_mine_order),
                fontSize: 14.sp,
                bgColor: IConstant.grey_bg_color,
                textColor: IConstant.text_color, onTap: () {
                  finish();
                  nextPage(OrderPage("-1"), false);
                })
        ) : Container(
            margin: EdgeInsets.fromLTRB(6.w, 10.w, 16.w, 10.w),
            child: SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.search),
                fontSize: 14.sp, onTap: () {
                  onSearch(searchText);
                })
        )
      ],
    );
  }

  PreferredSize buildPreferredSize() {
    return PreferredSize(
      preferredSize: Size.fromHeight(50.w),
      child: TabBar(
        dividerColor: Colors.transparent,
        controller: tabController,
        indicatorColor: IConstant.main_color,
        labelColor: IConstant.text_color,
        unselectedLabelColor: IConstant.text_color,
        tabs: titles.map((item)=>Tab(text: item,)).toList(),
        indicatorWeight: 3,
      ),
    );
  }

  Widget buildSearch() {
    return ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: 36.w),
        child: TextField(
          textInputAction: TextInputAction.search,
          maxLines: 1,
          keyboardType: TextInputType.text,
          style: TextStyle(color: IConstant.title_color, fontSize: 14.sp),
          decoration: InputDecoration(
            border: InputBorder.none,
            labelStyle: TextStyle(color: IConstant.title_color, fontSize: 14.sp),
            hintText: LanguageConfig.get(LanguageConfigKeys.Shop_order_search),
            hintStyle: TextStyle(color: IConstant.sub_text_color, fontSize: 14.sp),
          ),
          controller: ViewUtils.buildTextEditingController(searchText, listener: (str) {
            searchText = str;
          }),
          onSubmitted: (str) {
            onSearch(str);
          },
        ));
  }

  onSearch(str) {
    setState(() {
      searchText = str;
    });
    EventBusUtil.getInstance().emit(OrderSearchEvent(searchText));
  }

}
