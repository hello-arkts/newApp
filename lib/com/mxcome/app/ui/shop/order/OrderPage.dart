import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/OrderSearchEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/order/SearchOrderList.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../config/LanguageConfig.dart';
import '../../../utils/ViewUtils.dart';
import '../widget/SmallTextButton.dart';
import 'AfterSalesPage.dart';
import 'OrderList.dart';

class OrderPage extends StatefulWidget {

  String status = "-1";

  OrderPage(this.status, {super.key});

  @override
  State<OrderPage> createState() => OrderPageState();
}

class OrderPageState extends BaseKeepAliveState<OrderPage>
    with SingleTickerProviderStateMixin {

  late TabController tabController;

  int currentIndex = 0;

  final titles = [
    LanguageConfig.get(LanguageConfigKeys.Shop_order_all),
    LanguageConfig.get(LanguageConfigKeys.Shop_order_wait_pay),
    LanguageConfig.get(LanguageConfigKeys.Shop_order_wait_deliver),
    LanguageConfig.get(LanguageConfigKeys.Shop_order_wait_receipt),
    LanguageConfig.get(LanguageConfigKeys.Shop_order_completed),
    LanguageConfig.get(LanguageConfigKeys.Shop_order_canceled),
  ];
  final pages = [
    OrderList("-1"),
    OrderList("0"),
    OrderList("1"),
    OrderList("2"),
    OrderList("3"),
    OrderList("4")
  ];

  String searchText = "";

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: titles.length, vsync: this);
    if (widget.status == "0") {
      tabController.animateTo(1);
    } else if(widget.status == "1") {
      tabController.animateTo(2);
    } else if(widget.status == "2") {
      tabController.animateTo(3);
    } else if(widget.status == "3") {
      tabController.animateTo(4);
    } else if(widget.status == "4") {
      tabController.animateTo(5);
    } else {
      tabController.animateTo(0);
    }
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
        ) : OrderSearchList(searchText),
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
        child: Container(
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
            child: SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_after_sales),
                fontSize: 14.sp,
                bgColor: IConstant.grey_bg_color,
                textColor: IConstant.text_color, onTap: () {
                  finish();
                  nextPage(AfterSalesPage("-1"), false);
                })
        ) : Container(
            margin: EdgeInsets.fromLTRB(6.w, 10.w, 16.w, 10.w),
            child: SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.search),
                fontSize: 14.sp, onTap: () {
                  onSearch(searchText);
                })
        ),
      ],
    );
  }

  PreferredSize buildPreferredSize() {
    return PreferredSize(
      preferredSize: Size.fromHeight(50.w),
      child: TabBar(
        dividerColor: Colors.transparent,
        controller: tabController,
        isScrollable: true,
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
