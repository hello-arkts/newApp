
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../IURLConstant.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/TextUtils.dart';
import '../model/SelectTabModel.dart';
import '../utils/FormatUtil.dart';
import '../utils/Util.dart';
import '../widget/LoadImageView.dart';
import 'TaskDetailPage.dart';

class HistoryTaskPage extends StatefulWidget {

  @override
  State<HistoryTaskPage> createState() => HistoryTaskPageState();

}

class HistoryTaskPageState extends BaseKeepAliveState<HistoryTaskPage> {

  int _countedTimeout = 7 * 24 * 60;
  List<SelectTabModel> tabList = [];

  @override
  void initState() {
    super.initState();
    tabList.add(SelectTabModel(1, true)); //本周
    tabList.add(SelectTabModel(2, false)); //本月
    tabList.add(SelectTabModel(3, false)); //上月
    tabList.add(SelectTabModel(4, false)); //全部
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    isLoading = true;
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_GET_POCKET_MEMBER, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        datas = rsp.data;
      });
    }
    dynamic data = await AppUtils.getPocketData();
    setState(() {
      _countedTimeout = BaseModel.isNotEmpty(data, "countedTimeout") ? BaseModel.getInt(data, "countedTimeout") : _countedTimeout;
    });
    isLoading = false;
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      body: Container(
        margin: EdgeInsets.only(top: 10.w),
        child: buildBody(),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    getServiceTime();
  }

  Widget buildBody() {
    return Column(
        children: [
          //buildButtons(),
          Expanded(child: datas.isEmpty? buildHeader() : EasyRefresh(
            header: const MaterialHeader(color: IConstant.main_color),
            footer: CupertinoFooter(emptyWidget: Container(
            padding: EdgeInsets.all(10.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_more), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
          )),
            onRefresh: ()=> onRefresh(),
            onLoad: ()=> onLoadMore(),
            child: ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount: datas.length,
                padding: EdgeInsets.only(bottom: 16.w),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      nextPage(TaskDetailPage(datas[index]), false);
                    },
                    child: buildTaskItem(index),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 10.w);
                }),
          ))

        ],
    );
  }

  Widget buildTaskItem(int index) {
    dynamic pocketMemberItem = datas[index];
    dynamic product = pocketMemberItem["product"];
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 0.w),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12.w)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1E000000),
              blurRadius: 6,
              offset: Offset(0, 2),
              spreadRadius: 0,
            ) ,
          ],
      ),
      child: Column(
        children: [
          buildTaskInfo(product, pocketMemberItem),
          SizedBox(height: 2.w,),
          buildBottomItem(product, pocketMemberItem),
        ],
      ),
    );
  }

  Widget buildTaskInfo(dynamic product, dynamic pocketMemberItem){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12.w)),
            child: LoadImageView(0.2 * Adapt.getWindowWidth(), 0.2 * Adapt.getWindowWidth(), BaseModel.getString(product, "pic"))),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 10.w),
            Container(
              constraints: BoxConstraints(
                maxWidth: 240.w
              ),
              child: Text("${BaseModel.getString(product, "name")}", maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
            ),
            SizedBox(height: 10.w),
            Row(
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_wallet_chargeback), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
                SizedBox(width: 4.w),
                Text(getChargeQuantity(pocketMemberItem), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.main_color)),
                SizedBox(width: 24.w),
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_deal), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
                SizedBox(width: 4.w),
                Text(getBuyQuantity(pocketMemberItem), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.main_color)),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget buildBottomItem(dynamic product, dynamic pocketMemberItem){
    return Row(
      children: [
        Expanded(flex: 1, child: Container(
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
        )),
        Expanded(flex: 1, child: buildStopTime(pocketMemberItem)),
        buildStatus(pocketMemberItem),
        SizedBox(width: 16.w),
      ],
    );
  }

  String getChargeQuantity(dynamic item) {
    int chargeQuantity = BaseModel.getInt(item, "returnQuantity");
    return "$chargeQuantity";
  }

  String getBuyQuantity(dynamic item) {
    int buyQuantity = BaseModel.getInt(item, "buyQuantity");
    return "$buyQuantity";
  }

  Widget buildStopTime(dynamic item) {
    int buyQuantity = BaseModel.getInt(item, "buyQuantity");
    if (buyQuantity > 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_get_gold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11.sp, color: IConstant.main_color)),
          SizedBox(width: 4.w),
          PriceText(BaseModel.getDouble(item, "withdrawalBalance"), fontSize: 12.sp),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget buildLockTime(dynamic item) {
    String endTime = BaseModel.getString(item, "endTime");
    if (TextUtils.isEmpty(endTime)) {
      return Container();
    }
    DateTime dateTime = DateTime.parse(endTime);
    dateTime = dateTime.add(Duration(minutes: _countedTimeout));
    String formatDate = FormatUtil.formatLineYMDHMS(dateTime);
    if (Util.isTimeout2(startTime: serviceTime, endTime: formatDate)) {
      return Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_completed_counted),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 10.sp, color: IConstant.green_color));
    } else {
      return SizedBox(
        width: 0.3 * Adapt.getWindowWidth(),
        child: Text("${LanguageConfig.get(LanguageConfigKeys.Shop_pocket_counted_shop)} ${FormatUtil.formatMDHM(dateTime)}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 10.sp, color: IConstant.grey_color)),
      );
    }
  }

  Widget buildStatus(dynamic item) {
    return Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_task_finish), textAlign: TextAlign.center,
        style: TextStyle(fontSize: 10.sp, color: IConstant.text_color));
  }

  Widget buildButtons() {
    return Container(
      height: 30.w,
      margin: EdgeInsets.only(top: 4.w, bottom: 12.w),
      padding: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 0.w),
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: tabList.length,
          itemBuilder: (BuildContext context, int index) {
            return buildButton(tabList[index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(width: 10.w);
          }
      ),
    );
  }

  Widget buildButton(SelectTabModel model) {
    return OutlinedButton(
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
    );
  }

  String getTitle(SelectTabModel model){
    if (model.type == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_pocket_this_week);
    } else if (model.type == 2) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_pocket_this_month);
    } else if (model.type == 3) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_pocket_last_month);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_order_all);
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

}
