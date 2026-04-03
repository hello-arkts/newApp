import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/detail/TaskResultPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/detail/TaskRulePage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/detail/TimePromptPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/PocketItemModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/PocketModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CountDownView.dart';
import 'package:mxcome/com/mxcome/app/utils/AppUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:sprintf/sprintf.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IURLConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../event/PocketEvent.dart';
import '../model/SkuModel.dart';
import '../utils/EventBusUtil.dart';
import '../widget/LoadImageView.dart';
import '../widget/SmallTextButton.dart';

class ReceiveTaskPage extends StatefulWidget {

  dynamic product;
  List<SkuModel> skuList = [];
  List<dynamic> pocketList;
  String changePocketCode;
  ReceiveTaskPage(this.product, this.pocketList, { this.changePocketCode = "" });

  @override
  State<StatefulWidget> createState() {
    return ReceiveTaskPageState();
  }
}

class ReceiveTaskPageState extends BaseKeepAliveState<ReceiveTaskPage> {

  bool isSelectAll = false;
  List<PocketModel> pocketList = [];

  int taskCount = 0;

  int taskCapacity = 0;

  @override
  void initState() {
    super.initState();
    List<PocketModel> tempList = [];
    for (dynamic item in widget.pocketList) {
      tempList.add(PocketModel.fromJson(item));
    }
    if (tempList.isNotEmpty) {
      tempList[0].isSelect = true;
    }
    setState(() {
      pocketList = tempList;
    });
    loadContentDatas();
    checkState();
  }

  @override
  Future<void> loadContentDatas() async {
    dynamic data = await AppUtils.getPocketData();
    dynamic umsPocketConfig = BaseModel.getDynamic(data, "umsPocketConfig");
    List<dynamic> pocketMemberList = BaseModel.isNotEmpty(data, "pocketMemberList") ? BaseModel.getDynamic(data, "pocketMemberList") : [];
    int taskStartCount = 0; //进行中任务数
    for (var item in pocketMemberList) {
      int status = BaseModel.getInt(item, "status");
      if (status == 0) {
        taskStartCount++;
      }
    }
    setState(() {
      taskCapacity = BaseModel.getInt(umsPocketConfig, "taskCapacity");
      taskCount = taskStartCount;
    });
  }

  @override
  void didChangeDependencies() {
    getServiceTime();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_product_mxget),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
        actions: [
          Container(
            margin: EdgeInsets.all(10.w),
            child: SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_rule_title),
                fontSize: 14.sp,
                bgColor: IConstant.white_color,
                textColor: IConstant.blue_color, onTap: () {
               showPop(0.8 * Adapt.getWindowHeight(), TaskRulePage());
            }),
          )
        ],
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: Text(BaseModel.getString(widget.product, "name"), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
        ),
        buildProduct(),
        SizedBox(height: 16.w),
        Expanded(
            flex: 1,
            child: ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount: pocketList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        setSelectList(pocketList[index]);
                      },
                      child: getSpecRow(index));
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 10.w);
                })),
        TextUtils.isNotEmpty(widget.changePocketCode) ? Padding(
          padding: EdgeInsets.only(bottom: 41.w, left: 15.w),
          child: Row(
            children: [
              Container(
                width: 2.w,
                height: 44.w,
                color: IConstant.red_bg_color4,
              ),
              SizedBox(width: 14.5.w,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_change_task_tips1), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                    SizedBox(height: 6.w,),
                    Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_change_task_tips2), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                  ],
                ),
              ),
            ],
          ),
        ) : Container()
      ],
    );
  }

  Widget getSpecRow(int index) {
    PocketModel model = pocketList[index];
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("${LanguageConfig.get(LanguageConfigKeys.Shop_pocket_task)}${index + 1}"),
              Expanded(child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset("assets/icons/task_icon2.png", width: 11.w, height: 11.w),
                  SizedBox(width: 6.w),
                  Text(model.taskStock, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                  Container(
                    width: 1.w,
                    height: 12.w,
                    color: IConstant.line_color,
                    margin: EdgeInsets.fromLTRB(8.w, 0.w, 8.w, 0.w),
                  ),
                  Image.asset("assets/icons/task_icon1.png", width: 11.w, height: 11.w),
                  SizedBox(width: 2.w),
                  SizedBox(width: 85.w,
                    child: CountDownView(startTime: serviceTime, endTime: model.endTime, fontSize: 12.sp),
                  )
                ],
              ))
            ],
          ),
          SizedBox(height: 12.w),
          Container(
            padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1.w,
                      color: model.isSelect
                          ? IConstant.main_color
                          : IConstant.grey_bg_color),
                  borderRadius: BorderRadius.all(Radius.circular(18.w))),
              child: Row(
                children: [
                  Expanded(child: Wrap(children: model.itemList.map((itemModel) => getSpecItem(model, itemModel)).toList())),
                  getIcon(model.isSelect)
                ],
              )
          ),
        ],
      ),
    );
  }

  Widget getSpecItem(PocketModel model, PocketItemModel itemModel) {
    return Container(
        margin: EdgeInsets.only(top: 4.w, bottom: 4.w),
        padding: EdgeInsets.fromLTRB(12.w, 4.w, 12.w, 4.w),
        decoration: BoxDecoration(
            border: Border.all(
                width: 1.w,
                color: IConstant.line_color
            ),
            borderRadius: BorderRadius.all(Radius.circular(20.w))),
        child: Row(
          children: [
            Image.asset("assets/icons/profit.png", width: 12.w, height: 12.w),
            SizedBox(width: 4.w),
            Text(FormatUtil.profitAmount(itemModel.memberProfitAmount, unit: false),
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.sp, color: IConstant.main_color)),
            Container(
              width: 1.w,
              height: 12.w,
              margin: EdgeInsets.fromLTRB(8.w, 0, 8.w, 0),
              color: IConstant.line_color,
            ),
            Expanded(child: Text(itemModel.getSelectValues(), textAlign: TextAlign.left, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))),
            SizedBox(width: 6.w)
          ],
        ));
  }

  Widget buildProduct() {
    return Container(
      height: 100.w,
      margin: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 0),
      decoration: BoxDecoration(
          color: IConstant.white_bg_color,
          borderRadius: BorderRadius.all(Radius.circular(10.w))),
      child: Row(
        children: [
          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(8.w)),
              clipBehavior: Clip.antiAlias,
              elevation: 1,
              child: LoadImageView(
                  80.w, 80.w, BaseModel.getString(widget.product, "pic"))),
          SizedBox(width: 6.w),
          Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 4.w),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 4.w),
                    padding: EdgeInsets.fromLTRB(6.w, 2.w, 6.w, 2.w),
                    decoration: BoxDecoration(
                        color: IConstant.white_color,
                        borderRadius: BorderRadius.all(Radius.circular(10.w))),
                    child: Row(
                        children: [
                          Image.asset("assets/icons/profit.png", width: 12.w, height: 12.w),
                          SizedBox(width: 4.w),
                          Text("${LanguageConfig.get(LanguageConfigKeys.Shop_wallet_mxget_profit)} ${getProfitPrice()}",
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12.sp, color: IConstant.main_color)),
                        ]
                    ),
                  ),
                  expandeSpace
                ],
              ),
              Row(
                  children: [
                    SizedBox(width: 10.w),
                    Image.asset("assets/icons/task_icon2.png", width: 12.w, height: 12.w),
                    SizedBox(width: 4.w),
                    Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_task_stock),
                         style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
                    SizedBox(width: 4.w),
                    Expanded(child: Text(getTaskStock(),
                        style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))),
                  ]
              ),
              getGiftList().isNotEmpty ? Row(
                  children: [
                    SizedBox(width: 10.w),
                    Image.asset("assets/icons/task_icon3.png", width: 12.w, height: 12.w),
                    SizedBox(width: 4.w),
                    Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_task_prize),
                        style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
                    SizedBox(width: 4.w),
                    Expanded(child: Text(getTaskPrize(),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))),
                  ]
              ) : Container(),
              SizedBox(height: 4.w),
            ],
          ))
        ],
      ),
    );
  }

  String getProfitPrice() {
    List<double> maxProfitAmount = [];
    for (PocketModel model in pocketList) {
      if (model.isSelect) {
        if (model.minProfitAmount > 0) {
          maxProfitAmount.add(model.minProfitAmount);
        }
        maxProfitAmount.add(model.maxProfitAmount);
      }
    }
    if (maxProfitAmount.length == 1) {
      double price = maxProfitAmount[0];
      return FormatUtil.profitAmount(price);
    } else if (maxProfitAmount.length > 1) {
      maxProfitAmount.sort((a, b) => a.compareTo(b));
      double price = maxProfitAmount[0];
      double maxPrice = maxProfitAmount[maxProfitAmount.length -1];
      return FormatUtil.profitAmount(price, maxPrice: maxPrice);
    } else {
      return FormatUtil.profitAmount(0);
    }
  }

  String getTaskStock() {
    int taskStock = 0;
    for (PocketModel model in pocketList) {
      if (model.isSelect) {
        for(PocketItemModel item in model.itemList) {
          taskStock += item.taskStock;
        }
      }
    }
    if (TextUtils.isEmpty(taskStock)) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_pocket_task_stock);
    } else {
      return sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_total_pieces), [taskStock]);
    }
  }

  String getTaskTime() {
    String endTime = "";
    for (PocketModel model in pocketList) {
      if (model.isSelect) {
        endTime = model.endTime;
      }
    }
    if (TextUtils.isEmpty(endTime)) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_pocket_time);
    } else {
      return "${LanguageConfig.get(LanguageConfigKeys.Shop_pocket_time)} ${FormatUtil.formatYMDHMS(DateTime.parse(endTime))}";
    }
  }

  String getTaskPrize(){
    return LanguageConfig.get(LanguageConfigKeys.Shop_pocket_complete_orders);
  }

  List<dynamic> getGiftList() {
    List<dynamic> pocketGiftList = [];
    for (PocketModel model in pocketList) {
      if (model.isSelect) {
        pocketGiftList = model.pocketGiftList;
        break;
      }
    }
    return pocketGiftList;
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      child: Container(
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        height: 60.w,
        child: Row(
          children: [
            InkWell(
              onTap: () {
                selectAll();
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 30.w,
                    height: 30.w,
                    child: getIcon(isSelectAll),
                  ),
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_cart_select_all),
                      style: TextStyle(
                          fontSize: 12.sp, color: IConstant.text_color))
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Row(
                  children: [
                    SizedBox(width: 10.w),
                    RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_task_volume),
                                style: TextStyle(fontSize: 12.sp, color: IConstant.text_color,),
                              ),
                              TextSpan(
                                text: '  $taskCount',
                                style: TextStyle(fontSize: 12.sp, color: IConstant.main_color,),
                              ),
                              TextSpan(
                                text: ' / $taskCapacity',
                                style: TextStyle(fontSize: 12.sp, color: IConstant.text_color),
                              ),
                            ])),
                  ],
                )),
            buildReceive()
          ],
        ),
      ),
    );
  }

  Widget buildReceive() {
    if (TextUtils.isNotEmpty(widget.changePocketCode)) {
      return SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_confirm_change), left: 14.w, right: 14.w, onTap: () {
        if (check(type: 1)) {
          changeTask();
        }
      });
    } else {
      return SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_accept_task), left: 14.w, right: 14.w, onTap: () {
        if (check()) {
          receiveTask();
        }
      });
    }
  }

  setSelectList(PocketModel model) {
    setState(() {
      model.isSelect = !model.isSelect;
    });
    checkState();
  }

  void checkState(){
    int count = 0;
    for (PocketModel item in pocketList) {
      if (item.isSelect) {
        count++;
      }
    }
    if (count > 0 && count == pocketList.length) {
      setState(() {
        isSelectAll = true;
      });
    } else {
      setState(() {
        isSelectAll = false;
      });
    }
  }

  String getTaskCount() {
    return "${LanguageConfig.get(LanguageConfigKeys.Shop_pocket_task_volume)} $taskCount / $taskCapacity";
  }

  void selectAll() {
    setState(() {
      isSelectAll = !isSelectAll;
      for (var item in pocketList) {
        item.isSelect = isSelectAll;
      }
    });
  }

  Widget getIcon(bool check) {
    return check
        ? const Icon(Icons.check_circle, color: IConstant.main_color)
        : const Icon(Icons.circle, color: IConstant.grey_bg_color);
  }

  bool check({int type = 0}) {
    int totalStock = 0;
    String endTime = "";
    for (PocketModel model in pocketList) {
      if (model.isSelect) {
        totalStock += FormatUtil.num2int(model.taskStock);
        endTime = model.endTime;
      }
    }
    if (TextUtils.isEmpty(endTime)) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_select_a_task));
      return false;
    }
    if (totalStock == 0) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_task_stock_insufficient));
      return false;
    }
    DateTime endDT = DateTime.parse(endTime);
    DateTime newDT = DateTime.parse(serviceTime);
    if (endDT.difference(newDT).inMilliseconds < 48 * 60 * 60 * 1000) {
      showPop(0.4 * Adapt.getWindowHeight(), TimePromptPage(endTime, (ctx, yes) => {
        setState(() {
          finishContext(ctx);
          if (yes) {
            if(type == 0) {
              receiveTask();
            }else {
              changeTask();
            }
          }
        })
      }));
      return false;
    }
    return true;
  }

  Future<void> receiveTask() async {
    List<PocketModel> selectList = [];
    for (PocketModel model in pocketList) {
      if (model.isSelect) {
        selectList.add(model);
      }
    }
    ViewUtils.show();
    List<dynamic> bodyList = [];
    for (PocketModel model in selectList) {
      for(PocketItemModel itemModel in model.itemList) {
        bodyList.add({
          "id": itemModel.id,
          "lockStock": itemModel.lockStock,
          "pocketId": itemModel.pocketId,
          "price":  itemModel.price,
          "productId": itemModel.productId,
          "receiveStatus": itemModel.receiveStatus,
          "skuCode": itemModel.skuCode,
          "skuId": itemModel.skuId,
          "taskStock": itemModel.taskStock,
        });
      }
    }
    BaseRsp rsp = await HttpUtils.postJSON(IURLConstant.MALL_POCKET_MEMBER_SAVE, null, body: bodyList);
    if (rsp.retCode == RspRetCode.SUCCESS) {
      EventBusUtil.getInstance().emit(PocketEvent());
      showTaskResult(rsp.data, TaskFailed.ok);
    } else {
      if (rsp.retCode == 401 || rsp.retCode == 402) {
        showTaskResult(null, TaskFailed.amountLimit);
      } else {
        showTaskResult(null, TaskFailed.repeat);
      }
    }
    ViewUtils.dismiss();
  }

  Future<void> changeTask() async {
    List<PocketModel> selectList = [];
    for (PocketModel model in pocketList) {
      if (model.isSelect) {
        selectList.add(model);
      }
    }
    ViewUtils.show();
    List<dynamic> bodyList = [];
    for (PocketModel model in selectList) {
      for(PocketItemModel itemModel in model.itemList) {
        bodyList.add({
          "id": itemModel.id,
          "lockStock": itemModel.lockStock,
          "pocketId": itemModel.pocketId,
          "price":  itemModel.price,
          "productId": itemModel.productId,
          "receiveStatus": itemModel.receiveStatus,
          "skuCode": itemModel.skuCode,
          "skuId": itemModel.skuId,
          "taskStock": itemModel.taskStock,
        });
      }
    }
    var paramBody = {
      "pocketCode": widget.changePocketCode,
      "itemList": bodyList,
    };
    BaseRsp rsp = await HttpUtils.postJSON(IURLConstant.MALL_CHANGE_POCKET, null, body: paramBody);
    if (rsp.retCode == RspRetCode.SUCCESS) {
      EventBusUtil.getInstance().emit(PocketEvent());
      showTaskResult(rsp.data, TaskFailed.ok);
    } else {
      if (rsp.retCode == 401 || rsp.retCode == 402) {
        showTaskResult(null, TaskFailed.amountLimit);
      } else {
        showTaskResult(null, TaskFailed.repeat);
      }
    }
    ViewUtils.dismiss();
  }

  void showTaskResult(dynamic pocketMember, TaskFailed taskFailed) {
    showPop(0.6 * Adapt.getWindowHeight(), TaskResultPage(pocketMember, taskFailed: taskFailed));
  }

}
