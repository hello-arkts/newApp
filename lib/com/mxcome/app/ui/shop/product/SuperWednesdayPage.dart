
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/CollectEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/SortView.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IURLConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/HttpUtils.dart';
import '../detail/ProductDetailPage.dart';
import '../detail/ReceiveTaskPage.dart';
import '../model/SelectTabModel.dart';
import '../utils/FormatUtil.dart';
import '../widget/LoadImageView.dart';

class SuperWednesdayPage extends StatefulWidget {

  SuperWednesdayPage();

  @override
  State<StatefulWidget> createState() => SuperWednesdayPageState();
}

class SuperWednesdayPageState extends BaseKeepAliveState<SuperWednesdayPage> {

  List<SelectTabModel> tabList = [];
  bool showCondition = false;
  SortState priceState = SortState.INIT;
  SortState profitState = SortState.INIT;
  SortState saleState = SortState.INIT;

  dynamic collectEvent;

  @override
  void initState() {
    super.initState();
    tabList.add(SelectTabModel(0, true)); //全部
    tabList.add(SelectTabModel(1, false)); //可接
    loadContentDatas();
    collectEvent = EventBusUtil.getInstance().on<CollectEvent>((event) {
      if (event.collectType == CollectType.query) {
        loadContentDatas();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    EventBusUtil.getInstance().off(collectEvent);
  }

  @override
  Future<void> loadContentDatas() async {
    isLoading = true;
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_GET_SUPER_WEDNESDAY, {
      "isReceive": getSelectType(),
      "newProduct": "0",
      "recommend": "0",
      "pageNum": "$page",
      "pageSize": "10",
      "sort": getSort(),
      "type": "2"
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<dynamic> tempList = BaseModel.isNotEmpty(rsp.data, "list") ? BaseModel.getDynamic(rsp.data, "list") : [];
      setState(() {
        count = rsp.data["total"];
        if (page == 1) {
          datas = tempList;
        } else {
          datas.addAll(tempList);
        }
      });
    }
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_super_wednesday),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(child: buildButtons()),
              InkWell(
                onTap: () {
                  setState(() {
                    showCondition = !showCondition;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: 16.w),
                  padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 8.w),
                  decoration: BoxDecoration(
                    color: showCondition ? IConstant.red_bg_color3 : IConstant.line_color,
                    border: Border.all(width: 1.w, color: showCondition ? IConstant.main_color : IConstant.white_color),
                    borderRadius: BorderRadius.circular(30.w),
                  ),
                  child: Image.asset(
                    'assets/icons/shop_choose.png',
                    width: 14.w,
                    height: 14.w,
                    color: showCondition ? IConstant.main_color : IConstant.text_color,
                  ),
                ),
              )
            ],
          ),
          showCondition ? Container(
            margin: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 0.w),
            child: Row(
              children: [
                SortView(LanguageConfig.get(LanguageConfigKeys.Shop_brand_price), priceState, (state)  {
                  setState(() {
                    priceState = state;
                    profitState = SortState.INIT;
                    saleState = SortState.INIT;
                  });
                  page = 1;
                  datas = [];
                  loadContentDatas();
                }),
                SizedBox(width: 30.w),
                SortView(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_share_profit), profitState, (state) {
                  setState(() {
                    priceState = SortState.INIT;
                    profitState = state;
                    saleState = SortState.INIT;
                  });
                  page = 1;
                  datas = [];
                  loadContentDatas();
                }),
                SizedBox(width: 30.w),
                SortView(LanguageConfig.get(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_sale)), saleState, (state) {
                  setState(() {
                    priceState = SortState.INIT;
                    profitState = SortState.INIT;
                    saleState = state;
                  });
                  page = 1;
                  datas = [];
                  loadContentDatas();
                }),
              ],
            ),
          ) : Container(),
          Expanded(child: datas.isEmpty ? buildHeader(): EasyRefresh(
            header: const MaterialHeader(color: IConstant.main_color),
            footer: CupertinoFooter(emptyWidget: Container(
            padding: EdgeInsets.all(10.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_more), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
          )),
            onRefresh: ()=> onRefresh(),
            onLoad: ()=> onLoadMore(), child: GridView.builder(
            padding: EdgeInsets.all(16.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 235.w,
              mainAxisSpacing: 16.w, //item上下间隔
              crossAxisSpacing: 16.w, //item左右间隔
            ),
            itemCount: datas.length,
            itemBuilder: (BuildContext context, int index) {
              return buildListItem(index);
            },
          )))
        ],
      ),
    );
  }

  Widget buildListItem(int index) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: IConstant.line_color, width: 1.w),
          borderRadius: BorderRadius.all( Radius.circular(10.w)),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () => {
                nextPage(ProductDetailPage(BaseModel.getString(datas[index], "id")), false)
              },
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.vertical(top:  Radius.circular(10.w)),
                      child: LoadImageView(double.infinity, 125.w, BaseModel.getString(datas[index], "pic"), fit: BoxFit.cover,)),
                  buildProfit(index),
                ],
              ),
            ),
            buildProfit(index),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.fromLTRB(10.w, 8.w, 10.w, 4.w),
              child: Text(BaseModel.getString(datas[index], "name"),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10.w, 4.w, 9.w, 8.w),
              child: buildPrice(index),
            ),
            SizedBox(width: 8.w),
            SizedBox(
              height: 28.w,
              child: buildAddButton(index),
            ),
          ],
        )
    );
  }

  Widget buildProfit(int index) {
    return Container(
      width: double.infinity,
      height: 20.w,
      color: IConstant.white_color.withOpacity(0.85),
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/icons/profit.png", width: 10.w, height: 10.w),
          SizedBox(width: 2.w),
          Text(getProfitText(index),
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11.sp, color: IConstant.main_color))
        ],
      ),
    );
  }

  String getProfitText(int index) {
    double minProfit = BaseModel.getDouble(datas[index], "minProfit");
    double maxProfit = BaseModel.getDouble(datas[index], "maxProfit");
    return FormatUtil.profitAmount(maxProfit, maxPrice: maxProfit);
  }

  Widget buildStart(int index) {
    List<dynamic> skuStockList = BaseModel.isNotEmpty(datas[index], "skuStockList") ? BaseModel.getDynamic(datas[index], "skuStockList") : [];
    String startText = "";
    Set<double> skuSet = {};
    for (var item in skuStockList) {
      skuSet.add(BaseModel.getDouble(item, "price"));
    }
    if (skuSet.length > 1) {
      startText = LanguageConfig.get(LanguageConfigKeys.Shop_product_rise);
    }
    return Text(startText, style: TextStyle(fontSize: 14.sp, color: IConstant.main_inactive_color));
  }

  Widget buildPrice(int index){
    return Row(
      children: [
        PriceText(BaseModel.getDouble(datas[index], "price"), fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.title_color),
        SizedBox(width: 2.w,),
        buildStart(index),
        expandeSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icons/small_heart.png", width: 12.w, height: 12.w),
            SizedBox(width: 4.w),
            Text(BaseModel.getString(datas[index], "collectionNum"),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.sp, color: IConstant.grey_color)),
          ],
        ),
      ],
    );
  }

  Widget buildAddButton(int index){
    return InkWell(
      onTap: () {
        goMXGetIsLogin(BaseModel.getString(datas[index], "id"));
      },
      child: Container(
        padding: EdgeInsets.only(left: 25.w, right: 25.w),
        decoration: BoxDecoration(
            color: IConstant.main_color,
            borderRadius: BorderRadius.all(Radius.circular(50.w))),
        child: Icon(Icons.add, size: 18.w, color: IConstant.white_color),
      ),
    );
  }

  Widget buildButtons() {
    return Container(
      margin: EdgeInsets.only(top: 8.w, bottom: 8.w),
      padding: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 0.w),
      child: Row(children: tabList.map((item) => buildButton(item)).toList()),
    );
  }

  Widget buildButton(SelectTabModel model) {
    return Container(
        height: 30.w,
        margin: EdgeInsets.only(right: 10.w),
        child: OutlinedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
                EdgeInsets.fromLTRB(10.w, 4.w, 10.w, 4.w)),
            backgroundColor: createTextButtonStyle(model.isSelect),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.w))),
            side: createTextButtonBorderSide(model.isSelect),
          ),
          onPressed: () {
            setState(() {
              page = 1;
              for (var item in tabList) {
                item.isSelect = false;
              }
              model.isSelect = !model.isSelect;
              datas = [];
              loadContentDatas();
            });
          },
          child: Text(getTitle(model),
              maxLines: 1,
              style: TextStyle(fontSize: 13.sp, color: model.isSelect ? IConstant.main_color : IConstant.sub_text_color)),
        ));
  }

  String getTitle(SelectTabModel model){
    if (model.type == 0) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_order_all);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_order_received);
    }
  }

  MaterialStateProperty<BorderSide> createTextButtonBorderSide(bool isSelect) {
    return MaterialStateProperty.all(BorderSide(width: 1.w, color: isSelect ? IConstant.main_color: IConstant.line_color));
  }

  MaterialStateProperty<Color> createTextButtonStyle(bool isSelect) {
    return MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.pressed)) {
        return isSelect ? IConstant.red_bg_color: IConstant.line_color;
      } else if (states.contains(MaterialState.disabled)) {
        return isSelect ? IConstant.red_bg_color: IConstant.line_color;
      }
      return isSelect ? IConstant.red_bg_color: IConstant.line_color;
    });
  }

  MaterialStateProperty<Color> createTextButtonColor(Color color) {
    return MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.pressed)) {
        return color;
      } else if (states.contains(MaterialState.disabled)) {
        return color;
      }
      return color;
    });
  }

  goMXGetIsLogin(String productId) async {
    bool isLogin = await AppUtils.isLogined();
    if (isLogin) {
      goMXGet(productId);
    } else {
      toLogin((ctx) => {
        setState(() {
          finishContext(ctx);
          goMXGet(productId);
        })
      });
    }
  }

  void goMXGet(String productId) async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post("${IURLConstant.MALL_PRODUCT_DETAIL}$productId", {"id": productId});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      dynamic product = rsp.data;
      rsp = await HttpUtils.post(IURLConstant.MALL_PRODUCT_POCKET_LIST, {"productId": productId});
      if (rsp.retCode == RspRetCode.SUCCESS) {
        List<dynamic> pocketList = [];
        List<dynamic> tempList = rsp.data;
        for (var item in tempList) {
          int type = BaseModel.getInt(item, "type"); //只添加普通任务
          if (type == 0) {
            pocketList.add(item);
          }
        }
        if (pocketList.isNotEmpty) {
          showPop(0.8 * Adapt.getWindowHeight(), ReceiveTaskPage(product, pocketList));
        } else {
          ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_late_task_over));
        }
      } else {
        ViewUtils.displayToast(rsp.msg);
      }
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  String getSort() {
    if(priceState == SortState.UP) {
      return "1";
    } else if(priceState == SortState.DOWN) {
      return "2";
    } else if(profitState == SortState.UP) {
      return "3";
    } else if(profitState == SortState.DOWN) {
      return "4";
    } else if(saleState == SortState.UP) {
      return "5";
    } else if(saleState == SortState.DOWN) {
      return "6";
    } else {
      return "";
    }
  }

  String getSelectType() {
    for (SelectTabModel item in tabList) {
      if (item.isSelect) {
        return "${item.type}";
      }
    }
    return "";
  }

}
