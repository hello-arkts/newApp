
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IURLConstant.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/model/BaseRsp.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/pocket/ChangeTaskPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/pocket/TaskDetailPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/product/RecommendTaskPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CountDownView.dart';
import 'package:mxcome/com/mxcome/app/utils/Adapt.dart';
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sprintf/sprintf.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../PageConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../utils/AppUtils.dart';
import '../brand/BrandShopPage.dart';
import '../utils/ClipboardUtil.dart';
import '../utils/FormatUtil.dart';
import '../utils/Util.dart';
import '../widget/ClockComponent.dart';
import '../widget/LoadImageView.dart';
import '../widget/PriceText.dart';
import 'GetPrizeTaskPage.dart';

class TaskItem extends StatefulWidget {

  int status = 0;

  String serviceTime;

  TaskItem(this.status, {this.serviceTime = '', super.key});

  @override
  State<TaskItem> createState() => TaskItemState();

}

class TaskItemState extends BaseKeepAliveState<TaskItem> {

  List<dynamic> _pocketMemberList = [];

  List<dynamic> _stopPocketMemberList = [];

  List<dynamic> profitProductList = [];

  int _countedTimeout = 7 * 24 * 60;

  dynamic umsPocketConfig;

  @override
  void initState() {
    super.initState();
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    dynamic homeData = await AppUtils.getHomeData();
    dynamic data = await AppUtils.getPocketData();
    umsPocketConfig = BaseModel.getDynamic(data, "umsPocketConfig");
    profitProductList = BaseModel.isNotEmpty(homeData, "profitProductList") ? BaseModel.getDynamic(homeData, "profitProductList") : [];
    _stopPocketMemberList = BaseModel.isNotEmpty(data, "stopPocketMemberList") ? BaseModel.getDynamic(data, "stopPocketMemberList") : [];
    _countedTimeout = BaseModel.isNotEmpty(data, "countedTimeout") ? BaseModel.getInt(data, "countedTimeout") : _countedTimeout;
    List<dynamic> dataList = [];
    List<dynamic> pocketMemberList = BaseModel.isNotEmpty(data, "pocketMemberList") ? BaseModel.getDynamic(data, "pocketMemberList") : [];
    for (var item in pocketMemberList) {
      int status = BaseModel.getInt(item, "status");
      String endTime = BaseModel.getString(item, "endTime");
      DateTime dateTime = DateTime.parse(endTime);
      DateTime countedTime = dateTime.add(Duration(minutes: _countedTimeout));
      if (widget.status == status && status == 0) {
        if (!Util.isTimeout2(startTime: widget.serviceTime, endTime: endTime)) {
          dataList.add(item);
        }
      } else if(widget.status == status && status == 1) {
        if (!Util.isTimeout2(startTime: widget.serviceTime, endTime: FormatUtil.formatLineYMDHMS(countedTime))) {
          dataList.add(item);
        }
      }
    }
    setState(() {
      _pocketMemberList = dataList;
    });
  }

  @override
  void didChangeDependencies() async{
    BaseRsp res = await HttpUtils.post(IURLConstant.MALL_GET_SERVICE_TIME, {});
    setState(() {
      widget.serviceTime = res.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _pocketMemberList.isEmpty ? buildHeader() : CustomScrollView(
      slivers: <Widget>[
        SliverPadding(padding: EdgeInsets.only(top: 16.w), sliver: SliverList(
          delegate:
          SliverChildBuilderDelegate((BuildContext context, int index) {
            return InkWell(
              onTap: () {
                nextPage(TaskDetailPage(_pocketMemberList[index]), false);
              },
              child: buildTaskItem(index),
            );
          }, childCount: _pocketMemberList.length),
        )),
        widget.status == 0 ? SliverToBoxAdapter(
          child: buildSurplusTaskItem(),
        ): SliverToBoxAdapter(
          child: Container(),
        ),
        widget.status == 0 && _stopPocketMemberList.isNotEmpty? SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(left: 21.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_change_record), style: TextStyle(color: IConstant.main_inactive_color, fontSize: 14.sp),),
          ),
        ):SliverToBoxAdapter(
          child: Container(),
        ),
        widget.status == 0 ? SliverPadding(padding: EdgeInsets.only(top: 16.w), sliver: SliverList(
          delegate:
          SliverChildBuilderDelegate((BuildContext context, int index) {
            return InkWell(
              onTap: () {
                nextPage(TaskDetailPage(_stopPocketMemberList[index]), false);
              },
              child: buildChangeTaskRecordItem(index),
            );
          }, childCount: _stopPocketMemberList.length),
        )):SliverToBoxAdapter(
          child: Container(),
        ),
      ],
    );
  }

  Widget buildTaskItem(int index) {
    dynamic pocketMemberItem = _pocketMemberList[index];
    dynamic product = pocketMemberItem["product"];
      return Container(
        margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10, //阴影范围
              spreadRadius: 0.1, //阴影浓度
              color: Colors.grey.withOpacity(0.3), //阴影颜色
            ),
          ],
        ),
      child: Column(
        children: [
          buildTopItem(product, pocketMemberItem),
          SizedBox(height: 6.w,),
          // widget.status == 0?
          // LinearProgressIndicator(
          //   value: getTimeDouble(pocketMemberItem),
          //   backgroundColor: IConstant.grey_bg_color,
          //   valueColor: const AlwaysStoppedAnimation<Color>(IConstant.main_color),
          // ):Divider(thickness: 4.w, color: IConstant.grey_bg_color,),
          buildBottomItem(product, pocketMemberItem),
        ],
      ),
    );
  }

  Widget buildSurplusTaskItem() {
    int taskCapacity = BaseModel.getInt(umsPocketConfig, "taskCapacity");
    int surPlusTaskNum = taskCapacity - _pocketMemberList.length;
    String surplusTask = LanguageConfig.get(LanguageConfigKeys.Shop_pocket_surplus_task);
    var surplusTasks = surplusTask.split("|");
    if(surPlusTaskNum > 0){
      return InkWell(
        onTap: () {
          nextPage(RecommendTaskPage(profitProductList), false);
        },
        child: Container(
            margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 10, //阴影范围
                  spreadRadius: 0.1, //阴影浓度
                  color: Colors.grey.withOpacity(0.3), //阴影颜色
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(14.w, 25.w, 16.w, 25.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          children: [
                            TextSpan(
                              text: surplusTasks[0],
                              style: TextStyle(fontSize: 12.sp, color: IConstant.title_color),
                            ),
                            TextSpan(
                              text: '$surPlusTaskNum',
                              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.main_color),
                            ),
                            TextSpan(
                              text: surplusTasks[1],
                              style: TextStyle(fontSize: 12.sp, color: IConstant.title_color),
                            ),
                          ]
                      )),
                  Image.asset(
                    'assets/icons/ic_add_pocket_task.png',
                    width: 35.w,
                    height: 35.w,
                  ),
                ],
              ),
            )
        ),
      );
    }else {
      return Container();
    }
  }

  Widget buildChangeTaskRecordItem(int index) {
    dynamic changeTaskRecordItem = _stopPocketMemberList[index];
    dynamic product = changeTaskRecordItem["product"];
    return InkWell(
      onTap: () {
        nextPage(TaskDetailPage(_stopPocketMemberList[index], type: 1,), false);
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10, //阴影范围
              spreadRadius: 0.1, //阴影浓度
              color: Colors.grey.withOpacity(0.3), //阴影颜色
            ),
          ],
        ),
        child: Column(
          children: [
            buildTopItem(product, changeTaskRecordItem, taskType: 1),
            SizedBox(height: 4.w,),
            // widget.status == 0?
            // LinearProgressIndicator(
            //   value: getTimeDouble(changeTaskRecordItem),
            //   backgroundColor: IConstant.grey_bg_color,
            //   valueColor: const AlwaysStoppedAnimation<Color>(IConstant.main_color),
            // ):Divider(thickness: 4.w, color: IConstant.grey_bg_color,),
            buildBottomItem(product, changeTaskRecordItem, taskType: 1),
          ],
        ),
      ),
    );
  }

  Widget buildTopItem(dynamic product, dynamic pocketMemberItem, {int taskType = 0}) {
    if (widget.status == 0) {
      return Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12.w)),
                  child: LoadImageView(85.w, 85.w, BaseModel.getString(product, "pic"))),
              enablePrize(pocketMemberItem) ? Positioned(left: 0.w, right: 0.w, bottom: 0.w, child: Container(
                padding: EdgeInsets.fromLTRB(4.w, 2.w, 4.w, 2.w),
                color: IConstant.white_translucent_color4,
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/icons/task_prize_red.png", width: 12.w, height: 12.w),
                    SizedBox(width: 2.w),
                    Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_enable_prize),
                        style: TextStyle(fontSize: 12.sp, color: IConstant.main_color))
                  ],
                ),
              )) : Container()
            ],
          ),
          SizedBox(width: 10.w),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4.w),
              Row(
                children: [
                  Expanded(child: Text("${BaseModel.getString(product, "name")}",
                      maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13.sp, color: IConstant.text_color))),
                  SizedBox(width: 12.w),
                  (widget.status == 0 && taskType == 0)? buildRightChangeWidgetItem(pocketMemberItem) : Container(),
                  SizedBox(width: 12.w),
                ],
              ),
              SizedBox(height: 4.w),
              Row(
                children: [
                  PriceText(BaseModel.getDouble(product, "price"), fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.title_color),
                  SizedBox(width: 2.w),
                  buildStart(pocketMemberItem),
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
              ),
              SizedBox(height: 2.w),
            ],
          ))
        ],
      );
    } else {
      return Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12.w)),
                  child: LoadImageView(80.w, 80.w, BaseModel.getString(product, "pic"))),
              enablePrize(pocketMemberItem) ? Positioned(left: 0.w, right: 0.w, bottom: 0.w, child: Container(
                padding: EdgeInsets.fromLTRB(4.w, 2.w, 4.w, 2.w),
                color: IConstant.white_translucent_color4,
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/icons/task_prize_red.png", width: 12.w, height: 12.w),
                    SizedBox(width: 2.w),
                    Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_enable_prize),
                        style: TextStyle(fontSize: 12.sp, color: IConstant.main_color))
                  ],
                ),
              )) : Container()
            ],
          ),
          SizedBox(width: 10.w),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4.w),
              Text("${BaseModel.getString(product, "name")}",
                  maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
              SizedBox(height: 12.w),
              Row(
                children: [
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_get_gold), style: TextStyle(fontSize: 13.sp, color: IConstant.main_color)),
                  PriceText(BaseModel.getDouble(pocketMemberItem, "withdrawalBalance"), fontSize: 13.sp),
                  expandeSpace,
                  Row(
                    children: [
                      Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_task_completed), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                      SizedBox(width: 10.w),
                      Text(getBuyQuantity(pocketMemberItem), style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.main_color)),
                      SizedBox(width: 12.w)
                    ],
                  ),
                ],
              ),
              SizedBox(height: 4.w),
            ],
          ))
        ],
      );
    }
  }

  Widget buildRightChangeWidgetItem(dynamic pocketMemberItem) {
    if(widget.status == 0) {
      String updateTime = BaseModel.getString(pocketMemberItem, 'updateTime');
      if(updateTime.isNotEmpty) {
        DateTime updateDateTime = DateTime.parse(updateTime);
        DateTime freezeTime = updateDateTime.add(const Duration(hours: 1));
        if(widget.serviceTime.isNotEmpty) {
          var nowTime = DateTime.parse(widget.serviceTime);
          if(freezeTime.millisecondsSinceEpoch - nowTime.millisecondsSinceEpoch > 1000) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.w),
              decoration: BoxDecoration(
                  color: IConstant.white_bg_color,
                  borderRadius: BorderRadius.circular(6.w)
              ),
              child: CountDownView(startTime: widget.serviceTime, endTime: FormatUtil.formatLineYMDHMS(freezeTime), callBack: () {
                loadContentDatas();
              },),
            );
          }else{
            return InkWell(
                onTap: () {
                  nextPage(ChangeTaskPage(pocketMemberItem), false);
                },
                child: Image.asset("assets/icons/change_task.png", width: 40.w, height: 30.w));
          }
        }
        else {
          return Container();
        }
      }else {
        return InkWell(
            onTap: () {
              nextPage(ChangeTaskPage(pocketMemberItem), false);
            },
            child: Image.asset("assets/icons/change_task.png", width: 40.w, height: 30.w));
      }
    }else {
      return Container();
    }
  }

  Widget buildStart(dynamic pocketMemberItem) {
    List<dynamic> skuStockList = BaseModel.isNotEmpty(pocketMemberItem, "itemList") ? BaseModel.getDynamic(pocketMemberItem, "itemList") : [];
    String startText = "";
    Set<double> skuSet = {};
    for (var item in skuStockList) {
      skuSet.add(BaseModel.getDouble(item, "price"));
    }
    if (skuSet.length > 1) {
      startText = LanguageConfig.get(LanguageConfigKeys.Shop_product_rise);
    }
    return Text(startText, style: TextStyle(fontSize: 12.sp, color: IConstant.grey_color));
  }

  Widget buildBottomItem(dynamic product, dynamic pocketMemberItem, {int taskType = 0}){
    return Row(
      children: [
        SizedBox(width: 8.w),
        Expanded(flex: 1, child: InkWell(
          onTap: () {
            nextPage(BrandShopPage(BaseModel.getString(product, "shopId")), false);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(child: LoadImageView(32.w, 32.w, BaseModel.getString(product, "shopIcon"))),
              SizedBox(width: 6.w),
              Expanded(child: Text(BaseModel.getString(product, "shopName"), maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.title_color)))
            ],
          ),
        )),
        SizedBox(width: 8.w),
        Container(
          color: IConstant.line_color,
          width: 1.w,
          height: 20.w,
        ),
        SizedBox(width: 8.w),
        Expanded(flex: widget.status == 0 ? 1 : 2, child: buildStopTime(pocketMemberItem)),
        taskType == 0 ? Expanded(flex: 1, child: buildRightItem(pocketMemberItem)):Container(),
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

  double getTaskProgress(dynamic item) {
    int buyQuantity = BaseModel.getInt(item, "buyQuantity");
    int stock = BaseModel.getInt(item, "stock");
    return buyQuantity/stock;
  }

  double getTimeDouble(dynamic item){
    DateTime createTime = DateTime.parse(BaseModel.getString(item, "createTime"));
    DateTime endTime = DateTime.parse(BaseModel.getString(item, "endTime"));
    int spaceTime = endTime.millisecondsSinceEpoch - createTime.millisecondsSinceEpoch;
    int currentSpaceTime = endTime.millisecondsSinceEpoch - FormatUtil.getTHNowTime().millisecondsSinceEpoch;
    return (currentSpaceTime / spaceTime);
  }

  bool hasPrize(dynamic item) {
    List<dynamic> pocketGiftList = BaseModel.isNotEmpty(item, "pocketGiftList") ? BaseModel.getDynamic(item, "pocketGiftList") : [];
    return pocketGiftList.isNotEmpty;
  }

  bool enablePrize(dynamic item) {
    int buyQuantity = BaseModel.getInt(item, "buyQuantity");
    List<dynamic> pocketGiftList = BaseModel.isNotEmpty(item, "pocketGiftList") ? BaseModel.getDynamic(item, "pocketGiftList") : [];
    if (buyQuantity >= 10 && pocketGiftList.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> copy(dynamic item) async {
    String shareUrl = await Util.getShareData(item);
    ClipboardUtil.setDataToast(shareUrl);
  }

  Future<void> shareWeb(dynamic item) async {
    String shareUrl = await Util.getShareData(item);
    Share.share(shareUrl);
  }

  Widget buildRightItem(dynamic item) {
     if (widget.status == 0) {
       return InkWell(
           onTap: () {
             shareWeb(item);
           },
           child: Container(
             alignment: Alignment.center,
             margin: EdgeInsets.fromLTRB(6.w, 6.w, 6.w, 8.w),
             padding: EdgeInsets.fromLTRB(6.w, 6.w, 2.w, 6.w),
             decoration: BoxDecoration(
                 color: IConstant.main_color,
                 borderRadius: BorderRadius.circular(20.w)
             ),
             child: Row(
               children: [
                 SizedBox(width: 2.w),
                 Image.asset("assets/icons/share.png", width: 14.w, height: 14.w, color: IConstant.white_color),
                 Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_recommend_now), maxLines: 2, overflow: TextOverflow.ellipsis,
                     textAlign: TextAlign.center, style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)))
               ],
             ),
           ));
     } else {
       return Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_upcoming_profits), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
             style: TextStyle(fontSize: 11.sp, color: IConstant.main_color));
     }
  }

  Widget buildStopTime(dynamic item) {
    if (widget.status == 0) {
      String endTime = BaseModel.getString(item, "endTime");
      return CountDownView(startTime: widget.serviceTime, endTime: endTime,
          fontSize: 11.sp,
          textColor: IConstant.main_color,
          prefix: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_remain),
          stop: LanguageConfig.get(LanguageConfigKeys.Shop_activity_closed));
    } else {
      String endTime = BaseModel.getString(item, "endTime");
      DateTime dateTime = DateTime.parse(endTime);
      DateTime countedTime = dateTime.add(Duration(minutes: _countedTimeout));
      return CountDownView(startTime: widget.serviceTime, endTime: FormatUtil.formatLineYMDHMS(countedTime),
          fontSize: 11.sp,
          textColor: IConstant.main_color,
          prefix: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_counted_shop),
          stop: LanguageConfig.get(LanguageConfigKeys.Shop_activity_closed));
    }
  }

}
