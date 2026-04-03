
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/detail/ProductDetailPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/LoadImageView.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:sprintf/sprintf.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';

import '../../IURLConstant.dart';
import '../../model/BaseRsp.dart';
import '../../utils/HttpUtils.dart';
import '../../utils/ViewUtils.dart';

class ProductLotteryDetailPage extends StatefulWidget {

  int index;
  dynamic product;

  ProductLotteryDetailPage(this.index, this.product);

  @override
  State<StatefulWidget> createState() => ProductLotteryDetailPageState();

}

class ProductLotteryDetailPageState extends BaseKeepAliveState<ProductLotteryDetailPage> {

  List<dynamic> _dataList = [];

  @override
  void initState() {
    super.initState();
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    isLoading = true;
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_FIND_DRAW_PRODUCT_LIST, {
      "productId": BaseModel.getString(widget.product, "id")
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        _dataList = BaseModel.getDynamic(rsp.data, "drawHistory");
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        leading: Container(),
        title: Text(LanguageConfig.get(LanguageConfigKeys.shop_web3_winning_list),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16.w),
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
                color: IConstant.line_color,
                borderRadius: BorderRadius.all(Radius.circular(12.w))
            ),
            child: InkWell(
              onTap: () {
                nextPageState(ProductDetailPage(BaseModel.getString(widget.product, "id")), false);
              },
              child: Row(
                children: [
                  LoadImageView(100.w, 100.w, BaseModel.getString(widget.product, "pic")),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(left: 10.w, right: 10.w),
                          child: Text(BaseModel.getString(widget.product, "name"),
                              style: TextStyle(fontSize: 14.sp, color: IConstant.text_color))),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.w),
                          child: Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_activity_st_place), ["${ 1 + widget.index }"]), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.title_color))),
                      Row(
                        children: [
                          SizedBox(width: 10.w),
                          Text("${LanguageConfig.get(LanguageConfigKeys.Shop_mine_value)} ", style: TextStyle(fontSize: 14.sp, color: IConstant.main_color, fontWeight: FontWeight.bold),),
                          PriceText(BaseModel.getDouble(widget.product, "price"),
                              fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.main_color),
                        ],
                      ),
                    ],
                  ))
                ],
              ),
            ),
          ),
          Expanded(child: isLoading ? ViewUtils.buildLoading() : ListView.separated(
              padding: EdgeInsets.only(bottom: 15.w),
              scrollDirection: Axis.vertical,
              itemCount: _dataList.length,
              itemBuilder: (context, index) {
                dynamic item = _dataList[index];
                dynamic userInfo = BaseModel.getDynamic(item, "userInfo");
                dynamic drawInfo = BaseModel.getDynamic(item, "drawInfo");
                return ListTile(
                  leading: ClipOval(child: LoadImageView(40.w, 40.w, BaseModel.getString(userInfo, "icon")),),
                  title: Text(BaseModel.getString(userInfo, "nickname"),
                      style: TextStyle(fontSize: 14.sp, color: IConstant.text_color, fontWeight: FontWeight.bold)),
                  subtitle: Text(BaseModel.getString(drawInfo, "createTime"),
                      style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color, fontWeight: FontWeight.bold)),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Container(height: 1.w, color: IConstant.line_color,);
              }))
        ],
      ),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      elevation: 0.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StyledText(
            text: '${LanguageConfig.get(LanguageConfigKeys.shop_web3_received_prizes)}<green> ${_dataList.length} </green>',
            style: TextStyle(fontSize: 15.sp, color: IConstant.sub_text_color),
            tags: {
              'green': StyledTextTag(style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: IConstant.green_color)),
            },
          ),
          expandeSpace,
          InkWell(
            onTap: () {
              finish();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40.w)),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xffFF3957),
                    Color(0xffFF3957),
                    Color(0xffFFCC16),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: IConstant.black_color,
                    blurRadius: 1,
                    offset: Offset(0, 6),
                    spreadRadius: 0,
                  ) ,
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
              width: 150.w,
              child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_continue_draw), textAlign: TextAlign.center,
                  style: TextStyle(color: IConstant.white_color, fontSize: 16.sp, fontWeight: FontWeight.bold)),
            ),
          ),

        ],
      ),
    );
  }

}
