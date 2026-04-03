import 'package:common_utils/common_utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/IURLConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/model/BaseRsp.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/LoadImageView.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import 'package:sprintf/sprintf.dart';

class RebateDetailPage extends StatefulWidget {

  final String cycleId;

  RebateDetailPage({required this.cycleId});

  @override
  State<RebateDetailPage> createState() => RebateDetailPageState();
}

class RebateDetailPageState extends BaseKeepAliveState<RebateDetailPage> {

  List<dynamic> rebateRecordList = [];

  dynamic rebateCycle;

  dynamic memberRebateCycle;

  List<dynamic> rebateCycleList = [];

  String orderCalculateTime = "";

  String orderStatementTime = "";

  String cycleId = "";

  bool isLoadingData = false;

  int itemNum = 0;

  @override
  void initState() {
    super.initState();
    cycleId = widget.cycleId;
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async{
    setState(() {
      isLoadingData = true;
    });
    BaseRsp res = await HttpUtils.post(IURLConstant.MALL_SSO_REBATE_CYCLE, {});
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_SSO_REBATE_DETAIL, {"cycleId": cycleId});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        rebateCycleList = [];
        rebateCycleList = res.data;
        orderCalculateTime = BaseModel.getString(rsp.data, "endTime");
        orderStatementTime = BaseModel.getString(rsp.data, "statementTime");
        rebateRecordList = BaseModel.isNotEmpty(rsp.data, "orderItemList") ? BaseModel.getDynamic(rsp.data, "orderItemList") : [];
        rebateCycle = BaseModel.isNotEmpty(rsp.data, "rebateCycle") ? BaseModel.getDynamic(rsp.data, "rebateCycle") : null;
        memberRebateCycle = BaseModel.isNotEmpty(rsp.data, "memberRebateCycle") ? BaseModel.getDynamic(rsp.data, "memberRebateCycle") : null;
        itemNum = BaseModel.getInt(rsp.data, "itemNum");
      });
      setState(() {
        isLoadingData = false;
      });
    }else {
      setState(() {
        isLoadingData = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        leading: Container(),
        title: Text(LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_my_profits), style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
      floatingActionButton: buildFloatingActionButton(),
    );
  }

  Widget buildBody() {
    int status = BaseModel.getInt(memberRebateCycle, "status");
    return isLoadingData ? ViewUtils.buildLoading() : Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<dynamic>(
                dropdownStyleData: DropdownStyleData(
                  elevation: 1,
                  maxHeight: 260.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.white,
                  ),
                  offset: Offset(0, -10.w),
                ),
                customButton: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.w),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.w, color: IConstant.line_color),
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(getCurrentWeekName(), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8.w,),
                          Text(getCurrentWeekDate(), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
                        ],
                      ),
                      Icon(Icons.keyboard_arrow_down, size: 20.w, color: IConstant.sub_text_color),
                    ],
                  ),
                ),
                onChanged: (dynamic item) {
                  rebateCycle = BaseModel.getDynamic(item, "rebateCycle");
                  cycleId = BaseModel.getString(item, "cycleId");
                  loadContentDatas();
                },
                items: listToDropdownMenu(rebateCycleList),menuItemStyleData: MenuItemStyleData(
              height: 50.w,
            ),),
          ),
        ),
        SizedBox(height: 24.w,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 17.w),
          margin: EdgeInsets.symmetric(horizontal: 18.w),
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: Image.asset("assets/icons/bg_my_rebate.png").image)
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Image.asset("assets/icons/ic_calculate_time.png", width: 24.w, height: 24.w,),
                  Padding(padding: EdgeInsets.only(top: 5.w , bottom: 5.w,), child: Container(height: 42.w, width: 1.w, color: Colors.black.withOpacity(0.15),),),
                  Image.asset("assets/icons/ic_settlement_rebate.png", width: 24.w, height: 24.w,),
                ],
              ),
              SizedBox(width: 8.w,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_calculate_order), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                            Text("x${BaseModel.getInt(memberRebateCycle, "statisticsOrderNum")}", style: TextStyle(fontSize: 14.sp, color: IConstant.text_color, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(orderCalculateTime.isNotEmpty ? FormatUtil.formatLineYMDHMS(DateTime.parse(orderCalculateTime)) : "", style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.w),
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  color: status == 0 ? IConstant.red_bg_color3 : const Color(0x0C72C472),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      getCalculateOrderStatusText(BaseModel.getInt(memberRebateCycle, "status")),
                                      style: TextStyle(
                                        color: status == 0 ? IConstant.main_color : IConstant.green_color,
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 28.w,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_settlement_order), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                            Text(status == 2 ? "x${BaseModel.getInt(memberRebateCycle, "settlementOrderNum")}" : "-", style: TextStyle(fontSize: 14.sp, color: IConstant.text_color, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(orderStatementTime.isNotEmpty ? FormatUtil.formatLineYMDHMS(DateTime.parse(orderStatementTime)) : "", style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.w),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: ShapeDecoration(
                                      color: status == 2 ? const Color(0x0C72C472) : IConstant.red_bg_color3,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    ),
                                    child: Text(
                                      getSettlementOrderStatusText(BaseModel.getInt(memberRebateCycle, "status")),
                                      style: TextStyle(
                                        color: status == 2 ? IConstant.green_color : IConstant.main_color,
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 20.w,), child: Container(
          height: 32.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: IConstant.blue_color.withOpacity(0.05),
            border: Border(
              top: BorderSide(width: 1.w, color: const Color(0x59358DF4)),
              bottom: BorderSide(width: 1.w, color: const Color(0x59358DF4)),
            ),
          ),
          child: getRebateInfoStatusText(),
        )),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w,),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_purchase_users),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 12.sp, fontWeight: FontWeight.normal, color: IConstant.sub_text_color)),
              ),
              Expanded(
                flex: 5,
                child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_purchase_time),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 12.sp, fontWeight: FontWeight.normal, color: IConstant.sub_text_color)),
              ),
              Expanded(
                flex: status == 0 ? 4 : 2,
                child: Text(LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_order_num),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12.sp, fontWeight: FontWeight.normal, color: IConstant.sub_text_color)),
              ),
              Expanded(
                flex: 3,
                child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_wallet_rebate),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12.sp, fontWeight: FontWeight.normal, color: IConstant.sub_text_color)),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.w),
        Expanded(
            child: rebateRecordList.isNotEmpty ? ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount: rebateRecordList.length,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.w),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return buildRebateItem(index);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 10.w);
                }) : ViewUtils.buildNoData()),
      ],
    );
  }

  String getCurrentWeekName() {
    String name = BaseModel.getString(rebateCycle, "name");
    return name.isNotEmpty ? sprintf(LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_period_range), [name]) : LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_data);
  }

  String getCurrentWeekDate() {
    String startTime = BaseModel.getString(rebateCycle, "startTime");
    String endTime = BaseModel.getString(rebateCycle, "startTime");
    if(startTime.isEmpty || endTime.isEmpty) {
      return "";
    }
    String formatStartTime = FormatUtil.formatYMD(DateTime.parse(BaseModel.getString(rebateCycle, "startTime")));
    String formatEndTime = FormatUtil.formatYMD(DateTime.parse(BaseModel.getString(rebateCycle, "endTime")));
    return "$formatStartTime-$formatEndTime";
  }

  String getCalculateOrderStatusText(int status) {
    switch(status) {
      case 0:
        return LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_to_be_counted);
      case 1:
        return LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_already_counted);
      case 2:
        return LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_already_counted);
      default:
        return LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_to_be_counted);
    }
  }

  String getSettlementOrderStatusText(int status) {
    switch(status) {
      case 0:
        return LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_pending_settlement);
      case 1:
        return LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_pending_settlement);
      case 2:
        return LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_settled);
      default:
        return LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_pending_settlement);
    }
  }

  Widget getRebateInfoStatusText() {
    int status = BaseModel.getInt(memberRebateCycle, "status");
    switch(status) {
      case 0:
        return Text(LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_status_hint_1), style: TextStyle(color: IConstant.text_color, fontSize: 12.sp,),);
      case 1:
        return Text(LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_status_hint_2), style: TextStyle(color: IConstant.text_color, fontSize: 12.sp,),);
      case 2:
        return Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_status_hint_3),
                style: TextStyle(
                  color: IConstant.text_color,
                  fontSize: 12.sp,
                ),
              ),
              TextSpan(
                text: " ${LanguageConfig.get(LanguageConfigKeys.Shop_mine_account_balance)} ",
                style: TextStyle(
                  color: IConstant.main_color,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        );
      default:
        return Text(LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_status_hint_1), style: TextStyle(color: IConstant.text_color, fontSize: 12.sp,),);
    }
  }

  Widget buildRebateItem(int index) {
    dynamic item = rebateRecordList[index];
    int status = BaseModel.getInt(memberRebateCycle, "status");
    int cycleStatus = BaseModel.getInt(item, "cycleStatus");
    return Row(
      children: [
        Expanded(flex: 5, child: buildImageItem(item)),
        Expanded(flex: 5, child: Text(getBuyTime(BaseModel.getString(item, "orderTime")),
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color))),
        Expanded(flex: status == 0 ? 4 : 2, child: Text("×${BaseModel.getString(item, "productQuantity")}",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color))),
        Expanded(flex: 3, child: Text(cycleStatus == -1 ? LanguageConfig.get(LanguageConfigKeys.shop_home_rebate_order_unfinished_tip) : FormatUtil.price2String(BaseModel.getDouble(item, "predictRebateAmount")), textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.sp, color: status == 1 ? IConstant.text_color : IConstant.main_color)))
      ],
    );
  }

  Widget buildImageItem(dynamic item) {
    String icon = BaseModel.getString(item, "icon");
    if (TextUtil.isEmpty(icon)) {
      String displayName = getDisplayName(item);
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
              child: Container(
                  width: 24.w,
                  height: 24.w,
                  color: IConstant.red_translucent_color,
                  child: Center(
                      child: Text(FormatUtil.showIcon(displayName),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20.sp, color: IConstant.text_color))))),
          SizedBox(width: 4.w),
          Container(constraints: BoxConstraints(maxWidth: 65.w), child: Text(FormatUtil.showName(displayName), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10.sp, color: IConstant.text_color)))
        ],
      );
    } else {
      String displayName = getDisplayName(item);
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: LoadImageView(24.w, 24.w, BaseModel.getString(item, "icon")),
          ),
          SizedBox(width: 8.w),
          Container(constraints: BoxConstraints(maxWidth: 70.w), child: Text(FormatUtil.showName(displayName), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.sp, color: IConstant.text_color)))
        ],
      );
    }
  }

  String getDisplayName(dynamic item) {
    String nickName = BaseModel.getString(item, "nickName");
    String generatorId = BaseModel.getString(item, "generatorId");
    return TextUtils.isNotEmpty(nickName) ? nickName: generatorId;
  }

  String getBuyTime(String buyTime) {
    if(buyTime.isEmpty) {
      return "";
    }else {
      DateTime calcTime = DateTime.parse(buyTime);
      return FormatUtil.formatYMDHMS(calcTime);
    }
  }

  List<DropdownMenuItem<dynamic>> listToDropdownMenu(List<dynamic> selectList) {
    List<DropdownMenuItem<dynamic>> items = [];
    for (dynamic item in selectList) {
      dynamic rebateCycle = BaseModel.getDynamic(item, "rebateCycle");
      String beforeStartTime = BaseModel.getString(rebateCycle, "startTime");
      String beforeEndTime = BaseModel.getString(rebateCycle, "endTime");
      String startTime = beforeStartTime.isEmpty ? "" : FormatUtil.formatYMD(DateTime.parse(beforeStartTime));
      String endTime = beforeEndTime.isEmpty ? "" : FormatUtil.formatYMD(DateTime.parse(beforeEndTime));
      int status = BaseModel.getInt(item, "status");
      DropdownMenuItem<dynamic> menuItem = DropdownMenuItem(
        value: item,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sprintf(LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_period_range), [BaseModel.getString(rebateCycle, "name")]), style: TextStyle(fontSize: 12.sp, color: IConstant.grey_color)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$startTime-$endTime", style: TextStyle(fontSize: 10.sp, color: IConstant.text_color)),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.w),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: status == 0 ? IConstant.red_bg_color3 : const Color(0x0C72C472),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            getCalculateOrderStatusText(status),
                            style: TextStyle(
                              color: status == 0 ? IConstant.main_color : IConstant.green_color,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 6.w,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.w),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: status == 2 ? const Color(0x0C72C472) : IConstant.red_bg_color3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            getSettlementOrderStatusText(status),
                            style: TextStyle(
                              color: status == 2 ? IConstant.green_color : IConstant.main_color,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      );
      items.add(menuItem);
    }
    return items;
  }

  Widget buildBottomBar() {
    int status = BaseModel.getInt(memberRebateCycle, "status");
    return BottomAppBar(
      height: 110.w,
      elevation: 4.w,
      child: Container(
        padding: EdgeInsets.only(left: 28.w, right: 28.w),
        height: 68.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_total_rebate), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color,)),
            PriceText(BaseModel.getDouble(memberRebateCycle, status == 1 ? "predictRebateAmount" : "settlementRebateAmount"), fontSize: 14.sp, fontWeight: FontWeight.bold,),
          ],
        ),
      ),
    );
  }

  Widget buildFloatingActionButton() {
    String rebateStatusHint4 = LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_status_hint_4);
    var rebateStatus1 = rebateStatusHint4.split("|");
    int status = BaseModel.getInt(memberRebateCycle, "status");
    return (status == 0 && itemNum < 8) ? Container(
      margin: EdgeInsets.only(bottom: 0.w, right: 10.w),
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 3.w),
      transform: Matrix4.translationValues(0.0, 25.w, 0.0),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.w, color: IConstant.main_color),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: rebateStatus1[0],
              style: TextStyle(
                color: IConstant.text_color,
                fontSize: 12.sp,
              ),
            ),
            TextSpan(
              text: ' 1 ',
              style: TextStyle(
                color: IConstant.main_color,
                fontSize: 12.sp,
              ),
            ),
            TextSpan(
              text: rebateStatus1[1],
              style: TextStyle(
                color: IConstant.text_color,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    ) : Container();
  }

}
