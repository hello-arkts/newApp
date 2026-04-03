import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../model/BaseModel.dart';
import '../model/CartItem.dart';
import '../widget/LoadImageView.dart';
import '../widget/PriceText.dart';


class SelectOrderItemPage extends StatefulWidget {

  List<dynamic> orderItemList;

  int from;

  Function(BuildContext context, dynamic orderItem,) callBack;

  SelectOrderItemPage(this.orderItemList, this.callBack, {this.from = 0});

  @override
  State<StatefulWidget> createState() {
    return SelectOrderItemPageState();
  }

}

class SelectOrderItemPageState extends BaseKeepAliveState<SelectOrderItemPage> {


  List<dynamic> orderItemList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      orderItemList = widget.orderItemList;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: IConstant.white_color,
        appBar: AppBar(
          elevation: 0.5.w,
          centerTitle: true,
          title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_select_product),
              style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
        ),
        body: buildBody()
    );
  }


  Widget buildBody() {
    return orderItemList.isEmpty ? buildHeader() : ListView.separated(
      padding: EdgeInsets.only(bottom: 10.w),
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            int afterSalesStatus = BaseModel.getInt(orderItemList[index], "afterSalesStatus");
            int status = BaseModel.getInt(orderItemList[index], "status");
            if ((afterSalesStatus == -2 && status == 1) || widget.from == 1) {
              widget.callBack(context, orderItemList[index]);
            } else {
              return;
            }
          },
          child: buildItem(orderItemList[index]),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 10.w);
      },
      itemCount: orderItemList.length,
    );
  }

  Widget buildItem(dynamic orderItem){
    int afterSalesStatus = BaseModel.getInt(orderItem, "afterSalesStatus");
    return Container(
      decoration: BoxDecoration(
          color: getAfterSalesStatusBg(orderItem),
          borderRadius: BorderRadius.all(Radius.circular(10.w))),
      margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 0.w),
      padding: EdgeInsets.only(right: 14.w),
      child: Row(
        children: [
          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(8.w)),
              clipBehavior: Clip.antiAlias,
              elevation: 2,
              child: LoadImageView(70.w, 70.w, orderItem["productPic"])),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: Text(
                          orderItem["productName"],
                          style:
                          TextStyle(fontSize: 13.sp, color: IConstant.text_color),
                        ),
                      )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 16.w, bottom: 4.w),
                            child: PriceText(orderItem["productPrice"], fontSize: 12.sp, color: IConstant.title_color),
                          ),
                          Text("×${orderItem["productQuantity"]}")
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10.w, top: 2.w),
                        padding: EdgeInsets.fromLTRB(12.w, 4.w, 12.w, 4.w),
                        decoration: BoxDecoration(
                            color: IConstant.grey_bg_color,
                            borderRadius: BorderRadius.all(Radius.circular(10.w))),
                        child: Text(
                          CartItem.getProductAttrValues(orderItem["productAttr"]),
                          style: TextStyle(
                              fontSize: 12.sp, color: IConstant.text_color),
                        ),
                      ),
                      expandeSpace,
                      Text(widget.from == 1? '' : getApplyInfo(orderItem), style: TextStyle(
                          fontSize: 12.sp, color: IConstant.main_color))
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }

  Color getAfterSalesStatusBg(dynamic orderItem) {
    int afterSalesStatus = BaseModel.getInt(orderItem, "afterSalesStatus");
    int status = BaseModel.getInt(orderItem, "status");
    if(widget.from == 1 || (afterSalesStatus == -2 && status == 1)) {
      return IConstant.white_color;
    }else {
      return IConstant.grey_bg_color;
    }
  }

  String getApplyInfo(dynamic orderItem){
    int afterSalesStatus = BaseModel.getInt(orderItem, "afterSalesStatus");
    int status = BaseModel.getInt(orderItem, "status");
    if(status == 2) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_order_shipped);
    }
    if (afterSalesStatus == 0) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_verifying);
    } else if (afterSalesStatus == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_order_wait_receipt);
    } else if (afterSalesStatus == 2){
      return LanguageConfig.get(LanguageConfigKeys.Shop_sales_pending_refunded);
    }else if (afterSalesStatus == 3){
      return LanguageConfig.get(LanguageConfigKeys.Shop_sales_refunded);
    }else {
      return "";
    }
  }

}
