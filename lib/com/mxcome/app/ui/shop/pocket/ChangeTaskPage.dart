import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CountDownView.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IURLConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseModel.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../brand/BrandShopPage.dart';
import '../detail/ProductDetailPage.dart';
import '../detail/ReceiveTaskPage.dart';
import '../model/SelectTabModel.dart';
import '../utils/FormatUtil.dart';
import '../widget/LoadImageView.dart';
import '../widget/PriceText.dart';


class ChangeTaskPage extends StatefulWidget {

  dynamic pocketMember;

  ChangeTaskPage(this.pocketMember);

  @override
  State<ChangeTaskPage> createState() => ChangeTaskPageState();
}

class ChangeTaskPageState extends BaseKeepAliveState<ChangeTaskPage> {

  List<SelectTabModel> tabList = [];

  dynamic _pocketMember;

  @override
  void initState() {
    super.initState();
    tabList.add(SelectTabModel(0, true)); //全部
    tabList.add(SelectTabModel(1, false)); //可接
    _pocketMember = widget.pocketMember;
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    isLoading = true;
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_FIND_PRODUCT_BY_POCKET, {
      "isReceive": getSelectType(),
      "newProduct": "0",
      "recommend": "0",
      "pageNum": "$page",
      "pageSize": "100",
      "sort": "",
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
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_change_task),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody(),
    );
  }

  @override
  void didChangeDependencies() {
    getServiceTime();
  }

  Widget buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 16.w),
          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_current_task),
              style: TextStyle(fontSize: 14.w, color: IConstant.text_color)),
        ),
        buildTaskItem(),
        buildButtons(),
        Expanded(child: GridView.builder(
          padding: EdgeInsets.all(16.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 220.w,
            mainAxisSpacing: 16.w, //item上下间隔
            crossAxisSpacing: 16.w, //item左右间隔
          ),
          itemCount: datas.length,
          itemBuilder: (BuildContext context, int index) {
            return buildListItem(index);
          },
        ))
      ],
    );
  }

  Widget buildTaskItem() {
    dynamic pocketMemberItem = _pocketMember;
    dynamic product = pocketMemberItem["product"];
    return Card(
      margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 10.w),
      elevation: 4.w,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(12.w),
      ),
      child: Column(
        children: [
          buildTopItem(product, pocketMemberItem),
          SizedBox(height: 4.w,),
          // LinearProgressIndicator(
          //   value: getTimeDouble(pocketMemberItem),
          //   backgroundColor: IConstant.grey_bg_color,
          //   valueColor: const AlwaysStoppedAnimation<Color>(IConstant.main_color),
          // ),
          buildBottomItem(product, pocketMemberItem),
        ],
      ),
    );
  }

  Widget buildTopItem(dynamic product, dynamic pocketMemberItem){
    return Row(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12.w)),
            child: LoadImageView(80.w, 80.w, BaseModel.getString(product, "pic"))),
        SizedBox(width: 10.w),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.w),
            Row(
              children: [
                Expanded(child: Text("${BaseModel.getString(product, "name")}",
                    maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13.sp, color: IConstant.text_color))),
                SizedBox(width: 12.w)
              ],
            ),
            SizedBox(height: 4.w),
            Row(
              children: [
                PriceText(BaseModel.getDouble(product, "price"), fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.title_color),
                SizedBox(width: 11.w),
                buildStart(),
              ],
            ),
            SizedBox(height: 6.w),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(6.w, 0.w, 6.w, 0.w),
                  decoration: BoxDecoration(
                      color: IConstant.red_bg_color3,
                      borderRadius: BorderRadius.circular(20.w)
                  ),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/icons/profit.png", width: 10.w, height: 10.w),
                        SizedBox(width: 2.w),
                        Text(getProfitText(pocketMemberItem),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 11.sp, color: IConstant.main_color)),
                      ]
                  ),
                ),
                expandeSpace,
                Row(
                  children: [
                    Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_task_completed), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                    SizedBox(width: 10.w),
                    Text(getBuyQuantity(pocketMemberItem), style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.main_color)),
                    Container(
                      width: 1.w,
                      height: 12.w,
                      color: IConstant.line_color,
                      margin: EdgeInsets.fromLTRB(8.w, 0, 8.w, 0),
                    ),
                    Text(getStock(pocketMemberItem), style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
                    SizedBox(width: 12.w)
                  ],
                ),
              ],
            )
          ],
        ))
      ],
    );
  }

  Widget buildStart() {
    dynamic pocketMemberItem = _pocketMember;
    List<dynamic> skuStockList = pocketMemberItem["itemList"];
    String startText = "";
    Set<double> skuSet = {};
    for (var item in skuStockList) {
      skuSet.add(BaseModel.getDouble(item, "price"));
    }
    if (skuSet.length > 1) {
      startText = LanguageConfig.get(LanguageConfigKeys.Shop_product_rise);
    }
    return Text(startText, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color));
  }

  Widget buildBottomItem(dynamic product, dynamic pocketMemberItem){
    return Row(
      children: [
        Expanded(flex: 1, child: InkWell(
          onTap: () {
            nextPage(BrandShopPage(BaseModel.getString(product, "shopId")), false);
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(child: LoadImageView(30.w, 30.w, BaseModel.getString(product, "shopIcon"))),
                SizedBox(width: 6.w),
                Expanded(child: Text(BaseModel.getString(product, "shopName"),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.title_color)))
              ],
            ),
          ),
        )),
        Expanded(flex: 1, child: buildStopTime(pocketMemberItem)),
      ],
    );
  }

  String getProfitText(dynamic item) {
    double minProfit = BaseModel.getDouble(item, "minProfit");
    double maxProfit = BaseModel.getDouble(item, "maxProfit");
    return FormatUtil.profitAmount(maxProfit, maxPrice: maxProfit);
  }

  String getBuyQuantity(dynamic item) {
    int buyQuantity = BaseModel.getInt(item, "buyQuantity");
    return "$buyQuantity";
  }

  String getStock(dynamic item) {
    int stock = BaseModel.getInt(item, "stock");
    return "$stock";
  }

  double getTimeDouble(dynamic item){
    DateTime createTime = DateTime.parse(BaseModel.getString(item, "createTime"));
    DateTime endTime = DateTime.parse(BaseModel.getString(item, "endTime"));
    int spaceTime = endTime.millisecondsSinceEpoch - createTime.millisecondsSinceEpoch;
    int currentSpaceTime = endTime.millisecondsSinceEpoch - FormatUtil.getTHNowTime().millisecondsSinceEpoch;
    return (currentSpaceTime / spaceTime);
  }

  Widget buildStopTime(dynamic item) {
    String endTime = BaseModel.getString(item, "endTime");
    return CountDownView(startTime: serviceTime, endTime: endTime,
        fontSize: 11.w,
        textColor: IConstant.main_color,
        prefix: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_remain),
        stop: LanguageConfig.get(LanguageConfigKeys.Shop_activity_closed));
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
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.vertical(top:  Radius.circular(10.w)),
                      child: LoadImageView(double.infinity, 125.w, BaseModel.getString(datas[index], "pic"))),
                  buildProfit(index)
                ],
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.fromLTRB(10.w, 8.w, 10.w, 4.w),
              child: Text(BaseModel.getString(datas[index], "name"),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10.w, 4.w, 10.w, 8.w),
              child: buildPrice(index),
            ),
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
      color: IConstant.white_translucent_color3,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/icons/profit.png", width: 10.w, height: 10.w),
          SizedBox(width: 2.w),
          Text(getProfitText(datas[index]),
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11.sp, color: IConstant.main_color))
        ],
      ),
    );
  }

  Widget buildPrice(int index){
    return Row(
      children: [
        PriceText(BaseModel.getDouble(datas[index], "price"), fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.title_color),
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

  Widget buildAddButton(int index) {
    return InkWell(
      onTap: () {
        goMXGet(BaseModel.getString(datas[index], "id"));
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
          showPop(0.8 * Adapt.getWindowHeight(), ReceiveTaskPage(product, pocketList, changePocketCode: BaseModel.getString(_pocketMember, "pocketCode")));
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

  String getTitle(SelectTabModel model){
    if (model.type == 0) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_order_all);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_order_received);
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
