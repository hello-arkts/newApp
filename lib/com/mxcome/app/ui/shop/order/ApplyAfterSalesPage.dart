import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/RefundModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CountDownView.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CountUpView.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IURLConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseModel.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../../../widget/PartRefreshWidget.dart';
import '../model/RefundTitleModel.dart';
import '../widget/BigTextButton.dart';
import 'ApplySubmitPage.dart';

class ApplyAfterSalesPage extends StatefulWidget {

  dynamic order;
  dynamic orderItem;

  ApplyAfterSalesPage(this.order, this.orderItem);

  @override
  State<ApplyAfterSalesPage> createState() => _ApplyAfterSalesPageState();
}

class _ApplyAfterSalesPageState extends BaseKeepAliveState<ApplyAfterSalesPage> {

  String createTime = "";
  String remainTime = "";
  Timer? timer;
  GlobalKey<PartRefreshWidgetState> timeKey = GlobalKey();

  int status = 0; //订单状态：0->待付款；1->待发货；2->已发货；3->已完成；4->已关闭；5->无效订单
  int isReturn = 0; //是否满足超时免单
  int isOvertimeFree = 0; //是否满足超时免单

  List<RefundTitleModel> refundList = [];

  bool isClickEnable = false;

  @override
  void initState() {
    super.initState();
    refundList.add(RefundTitleModel(LanguageConfig.get(LanguageConfigKeys.Shop_sales_refund), [
      RefundModel(1, LanguageConfig.get(LanguageConfigKeys.Shop_sales_refund_item1), false, false, 1),
      RefundModel(1, LanguageConfig.get(LanguageConfigKeys.Shop_sales_refund_item2), false, false, 2),
      RefundModel(1, LanguageConfig.get(LanguageConfigKeys.Shop_sales_refund_item3), false, false, 3),
    ]));
    // refundList.add(RefundTitleModel(LanguageConfig.get(LanguageConfigKeys.Shop_sales_return_refund), [
    //   RefundModel(2, LanguageConfig.get(LanguageConfigKeys.Shop_sales_return_refund_item1), false, false),
    // ]));
    // refundList.add(RefundTitleModel(LanguageConfig.get(LanguageConfigKeys.Shop_sales_overtime), [
    //   RefundModel(3, LanguageConfig.get(LanguageConfigKeys.Shop_sales_overtime_item1), false, false),
    // ]));
    status = BaseModel.getInt(widget.order, "status");
    loadContentDatas();
    setState(() {
      createTime = BaseModel.getString(widget.order, "createTime");
    });
    //startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getServiceTime();
  }

  @override
  void dispose() {
    if (timer != null) {
      timer?.cancel();
    }
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    if (status == 1) { //待发货，可以申请售后
      isReturn = 0;
      isOvertimeFree = 0;
      refreshAfterSales();
    } else if (status == 3) { //已完成，可以申请售后
      BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_RETURN_APPLY_INFO_BY_ORDER_ID, {
        "orderId": BaseModel.getString(widget.order, "id")
      });
      if (rsp.retCode == RspRetCode.SUCCESS) {
        isReturn = BaseModel.getInt(rsp.data, "isReturn");
        isOvertimeFree = BaseModel.getInt(rsp.data, "isOvertimeFree");
        refreshAfterSales();
      } else {
        ViewUtils.displayToast(rsp.msg);
      }
    }
  }

  void refreshAfterSales() {
    setState(() {
      if (status == 1) { //待发货，可以申请售后
        for (RefundTitleModel title in refundList) {
          for (RefundModel model in title.dataList) {
            if (model.type == 1) {
              model.isEnable = true;
            } else if (model.type == 2) {
              model.isEnable = isReturn == 1;
            } else if (model.type == 3) {
              model.isEnable = isOvertimeFree == 1;
            }
          }
        }
      } else if (status == 3) { //已完成，可以申请售后
        for (RefundTitleModel title in refundList) {
          for (RefundModel model in title.dataList) {
            if (model.type == 1) {
              model.isEnable = false;
            } else if (model.type == 2) {
              model.isEnable = isReturn == 1;
            } else if (model.type == 3) {
              model.isEnable = isOvertimeFree == 1;
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar:AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_apply_service),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        buildTime(),
        buildRefund(),
        Container(
          height: 50.w,
          margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 20.w),
          child: Row(
            children: [
              Container(width: 3.w, color: IConstant.red_bg_color),
              SizedBox(width: 12.w),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_service_tip1), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color)),
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_service_tip2), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color)),
                ],
              ))
            ],
          ),
        )
      ],
    );
  }

  Widget buildTime() {
    return Container(
      margin: EdgeInsets.fromLTRB(14.w, 4.w, 14.w, 0),
      padding: EdgeInsets.fromLTRB(14.w, 10.w.w, 14.w, 10.w),
      decoration: BoxDecoration(
          color: IConstant.red_bg_color,
          borderRadius: BorderRadius.circular(12.w)),
      child: Row(children: [
        Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_order_elapsed), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
        SizedBox(width: 10.w),
        // Expanded(child: PartRefreshWidget(timeKey, () => Text(remainTime, textAlign: TextAlign.right, style: TextStyle(fontSize: 13.sp, color: IConstant.main_color))
        // )),
        expandeSpace,
        CountUpView(startTime: createTime, endTime: serviceTime, fontSize: 13.sp, textColor: IConstant.main_color, ),
        // InkWell(onTap: () {
        //   ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_coming_soon));
        // }, child: Container(
        //   padding: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
        //   decoration: BoxDecoration(
        //       border: Border.all(width: 1.w, color: IConstant.blue_color),
        //       borderRadius: BorderRadius.circular(15.w)),
        //   child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_policy), style: TextStyle(fontSize: 11.sp, color: IConstant.blue_color)),
        // ),)
      ],),
    );
  }

  Widget buildRefund() {
    return Expanded(child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: refundList.length,
        itemBuilder: (context, index) {
          return buildTitle(refundList[index]);
        }));
  }

  Widget buildTitle(RefundTitleModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 14.w, top: 16.w),
          child: Text(model.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp, color: IConstant.text_color)),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(10.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 34.w,
            mainAxisSpacing: 10.w, //item上下间隔
            crossAxisSpacing: 14.w, //item左右间隔
          ),
          itemCount: model.dataList.length,
          itemBuilder: (BuildContext context, int index) {
            return buildItem(model.dataList[index]);
          },
        ),
      ],
    );
  }

  Widget buildItem(RefundModel model) {
    return InkWell(onTap: () {
      if (model.isEnable) {
        setSelectModel(model);
      }
    }, child: Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 2.w, right: 2.w),
      padding: EdgeInsets.fromLTRB(12.w, 2.w, 12.w, 2.w),
      decoration: BoxDecoration(
          color: model.getBgColor(),
          border: Border.all(width: 1, color: model.getBorderColor()),
          borderRadius: BorderRadius.circular(30.w)),
      child: Text(model.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp, color: model.getTextColor())),
    ),);
  }

  void startTimer() {
    if (timer != null && timer!.isActive) timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeKey.currentState?.update();
      calculateTime(DateTime.now());
    });
  }

  void calculateTime(nowTime) {
    var surplus = nowTime.difference(createTime);
    int day = (surplus.inSeconds ~/ 3600) ~/ 24;
    int hour = (surplus.inSeconds ~/ 3600) % 24;
    int minute = surplus.inSeconds % 3600 ~/ 60;
    int second = surplus.inSeconds % 60;

    var str = '';
    if (day > 0) {
      str = '$day${LanguageConfig.get(LanguageConfigKeys.Shop_pocket_days)}';
    }
    if (hour > 0 || (day > 0 && hour == 0)) {
      if (hour < 10) {
        str = "${str}0";
      }
      str = "$str$hour:";
    }
    if (minute < 10) {
      str = "${str}0";
    }
    str = "$str$minute:";
    if (second < 10) {
      str = "${str}0";
    }
    str = "$str$second";
    remainTime = str;
  }

  setSelectModel(RefundModel value) {
    setState(() {
      for (RefundTitleModel titleModel in refundList){
        for (RefundModel model in titleModel.dataList){
          model.isSelect = false;
        }
      }
      value.isSelect = true;
      isClickEnable = true;
    });
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      elevation: 0.w,
      child: Container(
        margin: EdgeInsets.all(20.w),
        child: BigTextButton(text: LanguageConfig.get(LanguageConfigKeys.ViewUtils_confirm),
            enable: isClickEnable,
            onTap: () {
          gotoAfterSales();
        }),
      ),
    );
  }

  void gotoAfterSales() {
    RefundModel? refundModel;
    for (RefundTitleModel titleModel in refundList){
      for (RefundModel model in titleModel.dataList){
        if (model.isSelect) {
          refundModel = model;
        }
      }
    }
    if (refundModel != null) {
      nextPage(ApplySubmitPage(widget.order, widget.orderItem, refundModel), false);
    }
  }

}
