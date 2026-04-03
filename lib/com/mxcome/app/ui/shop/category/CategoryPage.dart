import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/CategoryEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/search/SearchDelegateBar.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../IURLConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/HttpUtils.dart';
import '../../LanguagePage.dart';
import '../cart/CartBadge.dart';
import '../cart/CartPage.dart';
import '../event/CartEvent.dart';
import 'CategoryRightList.dart';

class CategoryPage extends StatefulWidget {

  String categoryId;

  CategoryPage(this.categoryId);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends BaseKeepAliveState<CategoryPage> {

  int currentIndex = 0;

  List<dynamic> categoryList = [];

  int cartNumber = 0;

  dynamic cartEvent;

  @override
  void initState() {
    super.initState();
    loadContentDatas();
    cartEvent = EventBusUtil.getInstance().on<CartEvent>((event) {
      if (event.cartType == CartType.complete){
        loadCartNum();
      }
    });
    loadCartNum();
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(cartEvent);
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_CATEGORY_TREE_LIST, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        categoryList = rsp.data;
      });
      for (int i = 0; i < categoryList.length; i++) {
        if(BaseModel.getString(categoryList[i], "id") == widget.categoryId) {
          updateCategory(i);
          break;
        }
      }
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  Future<void> loadCartNum() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_CART_LIST, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<dynamic> tempList = rsp.data;
      await AppUtils.setCartData(tempList);
      setState(() {
        cartNumber = tempList.length;
      });
    }
  }

  void updateCategory(int index) {
    setState(() {
      currentIndex = index;
      EventBusUtil.getInstance().emit(CategoryEvent(categoryList[currentIndex]));
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: IConstant.white_color,
        appBar: buildAppBar(),
        body: Row(
          children: [
            Expanded(
                flex: 3,
                child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: categoryList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            updateCategory(index);
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 3.w,
                                height: 60.w,
                                color: index == currentIndex ? IConstant.main_color : IConstant.grey_bg_color,
                              ),
                              Expanded(child: SizedBox(
                                  height: 65.w,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      getIcon(index, 22.w),
                                      Padding(padding: EdgeInsets.only(left: 10.w, right: 10.w),
                                        child: Text(getName(index),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(fontSize: 14.sp,
                                              fontWeight: index == currentIndex ? FontWeight.bold : FontWeight.normal,
                                              color: index == currentIndex ? IConstant.main_color : IConstant.text_color)),)
                                    ],
                                  ))),
                            ],
                          ));
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 5.w,);
                    })),
            VerticalDivider(width: 1.w),
            Expanded(flex: 10, child: CategoryRightList()),
          ],
        ));
  }

  String getName(int index){
    if (categoryList.length > index) {
      if (LanguagePage.language == "ZH") {
        return BaseModel.getString(categoryList[index], "chName");
      } else if (LanguagePage.language == "EN") {
        return BaseModel.getString(categoryList[index], "enName");
      } else {
        return BaseModel.getString(categoryList[index], "name");
      }
    } else {
      return "";
    }
  }

  Widget getIcon(int index, double size) {
    if (index < 9) {
      return Image.asset("assets/icons/category$index.png", width: size, height: size, color: index == currentIndex ? IConstant.main_color : IConstant.text_color);
    } else {
      return Container();
    }
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0.w,
      centerTitle: true,
      title: InkWell(
        onTap: () {
          showSearch(context: context, delegate: SearchDelegateBar());
        },
        child: Container(
          decoration: BoxDecoration(
              color: IConstant.white_bg_color,
              borderRadius: BorderRadius.all(Radius.circular(18.w))),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 7.h, 0, 7.h),
            child: Row(children: [
              Image.asset("assets/icons/search.png",
                  width: 18.w, height: 18.w, color: IConstant.sub_text_color),
              Expanded(child: Padding(
                padding: EdgeInsets.only(left: 7.w),
                child: Text(
                  LanguageConfig.get(LanguageConfigKeys.Shop_product_search),
                  style: TextStyle(
                      fontSize: 15.w, color: IConstant.sub_text_color),
                ),
              )),
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
      ),
      actions: [
        InkWell(
            onTap: () {
              goCartIsLogin();
            },
            child: Container(
              margin: EdgeInsets.only(left: 5.w, right: 5.w),
              child: CartBadge(cartNumber: cartNumber),
            )),
      ],
    );
  }

  goCartIsLogin() async {
    bool isLogin = await AppUtils.isLogined();
    if (isLogin) {
      openCart();
    } else {
      toLogin((ctx) => {
        setState(() {
          finishContext(ctx);
          openCart();
        })
      });
    }
  }

  void openCart(){
    showPop(0.9 * Adapt.getWindowHeight(), CartPage(fromDetail: true));
  }


}
