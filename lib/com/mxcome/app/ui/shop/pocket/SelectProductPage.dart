
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:sprintf/sprintf.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IURLConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../event/ProductSelectEvent.dart';
import '../model/SkuModel.dart';
import '../widget/LoadImageView.dart';
import '../widget/SmallTextButton.dart';

class SelectProductPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => SelectProductPageState();
}

class SelectProductPageState extends BaseKeepAliveState<SelectProductPage> {

  int currentIndex = -1;

  dynamic productList = [];

  dynamic mProduct;

  List<SkuModel> skuList = [];

  List<SkuModel> selectList = [];

  @override
  void initState() {
    super.initState();
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    dynamic data = await AppUtils.getUserInfo();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_MERCHANT_PRODUCT,
        {"merchantId": BaseModel.getString(data, "merchantId")});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        productList = rsp.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_select_product),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: getBody(context),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget getBody(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(10.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 150.h,
        mainAxisSpacing: 10.w, //item上下间隔
        crossAxisSpacing: 10.w, //item左右间隔
      ),
      itemCount: productList.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
             setState(() {
               currentIndex = index;
             });
             getProductDetail();
          },
          child: Column(
            children: [
              Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(8.w)),
                  clipBehavior: Clip.antiAlias,
                  elevation: 1,
                  child: Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      LoadImageView(90.w, 90.w, productList[index]["pic"]),
                      buildCheckIcon(index)
                    ],
                  )),
              Text(productList[index]["name"],
                  style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              Container(
                width: double.infinity,
                  padding: EdgeInsets.only(left: 5.w, top: 4.w, right: 5.w),
                  child: PriceText(productList[index]["price"], fontSize: 13.sp))
            ],
          ),
        );
      },
    );
  }

  Widget buildCheckIcon(int index) {
    if (currentIndex == index) {
      return Stack(
        children: [
          Positioned.fill(
            child: Container(
              margin: EdgeInsets.all(5.w),
              color: IConstant.white_color,
            ),
          ),
          Icon(Icons.check_circle, size: 25.w, color: IConstant.main_color),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  Future<void> getProductDetail() async {
    if (currentIndex == -1) return;
    if (currentIndex == -1) return;
    String productId = BaseModel.getString(productList[currentIndex], "id");
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post("${IURLConstant.MALL_PRODUCT_DETAIL}$productId", {"id": productId});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      dynamic skuStockList = rsp.data["skuStockList"];
      List<SkuModel> tempList = [];
      for (dynamic sku in skuStockList) {
        tempList.add(SkuModel.fromJson(sku));
      }
      setState(() {
        mProduct = rsp.data["product"];
        skuList = tempList;
        selectList = [];
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  List<Widget> getSpecWidget() {
    List<Widget> specWidget = [];
    for (SkuModel value in skuList) {
      specWidget.add(ChoiceChip(
        avatar: Icon(
            selectList.contains(value) ? Icons.check_circle : Icons.circle,
            size: 18.w,
            color: selectList.contains(value) ? IConstant.main_color : IConstant.default_select_color),
        padding: EdgeInsets.all(8.w),
        label: Text(value.getSelectValues(),
            style: TextStyle(
                fontSize: 14.sp,
                color: selectList.contains(value) ? IConstant.main_color : IConstant.text_color)),
        shape: RoundedRectangleBorder(
            side: BorderSide(color: selectList.contains(value) ? IConstant.main_color : IConstant.white_bg_color, width: 0.5.w),
            borderRadius: BorderRadius.all(Radius.circular(20.w))),
        backgroundColor: IConstant.white_bg_color,
        selectedColor: IConstant.white_color,
        selected: selectList.contains(value),
        onSelected: (isSelect) => {
          setSelectList(value)
        },
      ));
    }
    return specWidget;
  }

  setSelectList(SkuModel value) {
    setState(() {
      if (selectList.contains(value)) {
        selectList.remove(value);
      } else {
        selectList.add(value);
      }
    });
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      child: Container(
        margin: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 0),
        height: 180.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(LanguageConfig.get(LanguageConfigKeys.Shop_product_spec),
                style: TextStyle(fontSize: 15.sp, color: IConstant.text_color)),
            SizedBox(height: 5.w),
            Expanded(flex: 1, child: getSpecList()),
            Divider(height: 0.5.w),
            Container(
              height: 50.w,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(getSelectSpec(selectList.length), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
                  SmallTextButton(
                      text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_add),
                      left: 30.w, right: 30.w, onTap: () {
                    confirm();
                  })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String getSelectSpec(int size){
    return sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_product_spec_select), [size]);
  }

  Widget getSpecList() {
    if(skuList.isEmpty) {
      return const SizedBox();
    } else {
      return ListView(
        children: [
          Wrap(spacing: 10.w, children: getSpecWidget()),
        ],
      );
    }
  }

  void confirm() {
    EventBusUtil.getInstance().emit(ProductSelectEvent(mProduct: mProduct, selectList: selectList));
    finishContext(context);
  }

}
