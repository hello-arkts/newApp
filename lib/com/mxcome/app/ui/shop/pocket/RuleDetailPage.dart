
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/Logger.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';
import 'package:sprintf/sprintf.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../IURLConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/HttpUtils.dart';
import '../widget/PriceText.dart';

class RuleDetailPage extends StatefulWidget {

  dynamic umsPocketConfig;

  RuleDetailPage(this.umsPocketConfig);

  @override
  State<RuleDetailPage> createState() => RuleDetailPageState();

}

class RuleDetailPageState extends BaseKeepAliveState<RuleDetailPage> {

  List<dynamic> ruleList = [];

  int _activityStartCount = 0; //进行中活动数

  int _taskStartCount = 0; //进行中任务数

  int _memberDealCount = 0; //成交数

  @override
  void initState() {
    super.initState();
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    dynamic data = await AppUtils.getPocketData();
    List<dynamic> activityMemberList = BaseModel.isNotEmpty(data, "activityMemberList") ? BaseModel.getDynamic(data, "activityMemberList") : [];
    List<dynamic> pocketMemberList = BaseModel.getDynamic(data, "pocketMemberList");
    int activityStartCount = 0; //进行中活动数
    int taskStartCount = 0; //进行中任务数
    for (var item in activityMemberList) {
      int status = BaseModel.getInt(item, "status");
      if (status == 0) {
        activityStartCount++;
      }
    }
    for (var item in pocketMemberList) {
      int status = BaseModel.getInt(item, "status");
      if (status == 0) {
        taskStartCount++;
      }
    }
    setState(() {
      _memberDealCount = BaseModel.getInt(data, "memberDealCount");
      _activityStartCount = activityStartCount;
      _taskStartCount = taskStartCount;
    });
    isLoading = true;
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_GET_POCKET_CONFIG, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        ruleList = rsp.data;
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
        leading: Container(),
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_detail),
            style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: IConstant.text_color)),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 19.w),
      child: Column(
        children: [
          buildCapacityTop(),
          buildCapacityBottom(),
          buildNextLevel() ,
          buildNextLevelTop(),
          buildNextLevelBottom(),
        ],
      ),
    );
  }

  Widget buildCapacityTop() {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
        decoration: BoxDecoration(
            color: IConstant.red_bg_color3,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.w))
        ),
        child: RichText(maxLines: 2, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, text: TextSpan(text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_current_level), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color),
          children: [
            TextSpan(text: " Lv.${BaseModel.getInt(widget.umsPocketConfig, "pocketLevel")}  ", style: TextStyle(fontSize: 13.sp, color: IConstant.main_color)),
            TextSpan(text: getLevelTip(), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color))
          ]
        )));
        // child: Row(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_current_level), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
        //     Text(" Lv.${BaseModel.getInt(widget.umsPocketConfig, "pocketLevel")}", style: TextStyle(fontSize: 13.sp, color: IConstant.main_color)),
        //     SizedBox(width: 10.w),
        //     Text(getLevelTip(), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
        //   ],
        // ));
  }

  String getLevelTip() {
    return sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_current_level_tip), ["${IConstant.currency}${getCurrentLimit()}"]);
  }

  Widget buildCapacityBottom() {
    return Container(
      padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
      decoration: BoxDecoration(
          border: Border.all(width: 1.w, color: IConstant.line_color),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.w))
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_task_volume),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 13.sp, color: IConstant.sub_text_color)),
                SizedBox(height: 6.w),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("$_taskStartCount",
                        style: TextStyle(fontSize: 15.sp, color: IConstant.main_color, fontWeight: FontWeight.bold)),
                    Text(" / ${ BaseModel.getInt(widget.umsPocketConfig, "taskCapacity") }",
                        style: TextStyle(fontSize: 15.sp, color: IConstant.text_color, fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_activity_volume),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 13.sp, color: IConstant.sub_text_color)),
                SizedBox(height: 6.w),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("$_activityStartCount",
                        style: TextStyle(fontSize: 15.sp, color: IConstant.main_color, fontWeight: FontWeight.bold)),
                    Text(" / ${ BaseModel.getInt(widget.umsPocketConfig, "activityCapacity") }",
                        style: TextStyle(fontSize: 15.sp, color: IConstant.text_color, fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_pocket_upgrade),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 13.sp, color: IConstant.sub_text_color)),
                SizedBox(height: 6.w),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(getCompleteOrderCount(),
                        style: TextStyle(fontSize: 15.sp, color: IConstant.main_color, fontWeight: FontWeight.bold)),
                    Text(" / ${ getCurrentLevelOrderCount() } ",
                        style: TextStyle(fontSize: 15.sp, color: IConstant.text_color, fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildNextLevel() {
    return hasNextLevel() ? Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 20.w),
      child:  Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_upgrade), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: IConstant.text_color)),
    ) : SizedBox(
     height: 20.w,
    );
  }

  Widget buildNextLevelTop() {
    return Container(
        padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
        decoration: BoxDecoration(
            color: IConstant.grey_bg_color,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.w))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_simple_level), textAlign: TextAlign.center, style: TextStyle(fontSize: 13.sp, color: IConstant.sub_text_color))),
            Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_number_to_be_completed), textAlign: TextAlign.center, style: TextStyle(fontSize: 13.sp, color: IConstant.sub_text_color))),
            Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_task_profit_sharing), textAlign: TextAlign.center, style: TextStyle(fontSize: 13.sp, color: IConstant.sub_text_color))),
          ],
        )
    );
  }

  Widget buildNextLevelBottom() {
    return Container(
      padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
      decoration: BoxDecoration(
          border: Border.all(width: 1.w, color: IConstant.line_color),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.w))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: Text(getNextLevel(), textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp, color: IConstant.text_color))),
          Expanded(child: Text(getNextLevelOrderCount(), textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp, color: IConstant.text_color))),
          Expanded(child: PriceText(getNextProfitLimit(), textAlign: TextAlign.center, fontSize: 14.sp, color: IConstant.text_color)),
        ],
      ),
    );
  }

  bool hasNextLevel() {
    int pocketLevel = BaseModel.getInt(widget.umsPocketConfig, "pocketLevel") + 1;
    if (ruleList.isEmpty || pocketLevel >= ruleList.length) {
      return false;
    } else {
      return true;
    }
  }

  String getNextLevel() {
    int pocketLevel = BaseModel.getInt(widget.umsPocketConfig, "pocketLevel") + 1;
    if (ruleList.isNotEmpty && pocketLevel < ruleList.length) {
      return "$pocketLevel";
    } else {
      return "${BaseModel.getString(widget.umsPocketConfig, "pocketLevel")}";
    }
  }

  double getCurrentLimit() {
   return BaseModel.getDouble(widget.umsPocketConfig, "profitLimit");
  }

  String getCompleteOrderCount() {
    return "$_memberDealCount";
  }

  int getCurrentLevelOrderCount() {
    int levelOrderCount = BaseModel.getInt(widget.umsPocketConfig, "levelOrderCount");
    return _memberDealCount + levelOrderCount;
  }

  String getNextLevelOrderCount() {
    int pocketLevel = BaseModel.getInt(widget.umsPocketConfig, "pocketLevel") + 1;
    if (ruleList.isNotEmpty) {
      int levelOrderCount = 0;
      if (pocketLevel < ruleList.length) {
        for (var item in ruleList) {
          if (pocketLevel == BaseModel.getInt(item, "pocketLevel")) {
            levelOrderCount = BaseModel.getInt(item, "levelOrderCount");
            break;
          }
        }
      } else {
        levelOrderCount = BaseModel.getInt(ruleList.last, "levelOrderCount");
      }
      return "$levelOrderCount";
    } {
      return "${BaseModel.getInt(widget.umsPocketConfig, "levelOrderCount")}";
    }
  }

  double getNextProfitLimit() {
    int pocketLevel = BaseModel.getInt(widget.umsPocketConfig, "pocketLevel") + 1;
    if (ruleList.isNotEmpty && pocketLevel < ruleList.length) {
      double profitLimit = BaseModel.getDouble(widget.umsPocketConfig, "profitLimit");
      if (pocketLevel < ruleList.length) {
        for (var item in ruleList) {
          if (pocketLevel == BaseModel.getInt(item, "pocketLevel")) {
            profitLimit = BaseModel.getDouble(item, "profitLimit");
            break;
          }
        }
      } else {
        profitLimit = BaseModel.getDouble(ruleList.last, "profitLimit");
      }
      return profitLimit;
    } else {
      return BaseModel.getDouble(widget.umsPocketConfig, "profitLimit");
    }
  }

  int getNextTaskCapacity() {
    int pocketLevel = BaseModel.getInt(widget.umsPocketConfig, "pocketLevel") + 1;
    if (ruleList.isNotEmpty && pocketLevel < ruleList.length) {
      int taskCapacity = BaseModel.getInt(widget.umsPocketConfig, "activityCapacity");
      if (pocketLevel < ruleList.length) {
        for (var item in ruleList) {
          if (pocketLevel == BaseModel.getInt(item, "pocketLevel")) {
            taskCapacity = BaseModel.getInt(item, "taskCapacity");
            break;
          }
        }
      } else {
        taskCapacity = BaseModel.getInt(ruleList.last, "taskCapacity");
      }
      return taskCapacity;
    } else {
      return BaseModel.getInt(widget.umsPocketConfig, "taskCapacity");
    }
  }

  int getNextActivityCapacity() {
    int pocketLevel = BaseModel.getInt(widget.umsPocketConfig, "pocketLevel") + 1;
    if (ruleList.isNotEmpty && pocketLevel < ruleList.length) {
      int activityCapacity = BaseModel.getInt(widget.umsPocketConfig, "activityCapacity");
      if (pocketLevel < ruleList.length) {
        for (var item in ruleList) {
          if (pocketLevel == BaseModel.getInt(item, "pocketLevel")) {
            activityCapacity = BaseModel.getInt(item, "activityCapacity");
            break;
          }
        }
      } else {
        activityCapacity = BaseModel.getInt(ruleList.last, "activityCapacity");
      }
      return activityCapacity;
    } else {
      return BaseModel.getInt(widget.umsPocketConfig, "activityCapacity");
    }
  }

}
