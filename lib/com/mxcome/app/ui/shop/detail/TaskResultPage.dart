import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/pocket/TaskDetailPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../model/BaseModel.dart';
import '../../../utils/AppUtils.dart';
import '../event/MainTabEvent.dart';
import '../widget/SmallTextButton.dart';

class TaskResultPage extends StatefulWidget {

  dynamic pocketMember;

  TaskFailed taskFailed;

  TaskResultPage(this.pocketMember, { this.taskFailed = TaskFailed.ok});

  @override
  State<StatefulWidget> createState() {
    return TaskResultPageState();
  }

}

enum TaskFailed{ ok, repeat, amountLimit }

class TaskResultPageState extends BaseKeepAliveState<TaskResultPage> {

  int taskCount = 0;
  int taskCapacity = 0;
  String pocketLevel = "0";
  int violationCount = 0;
  String violationTime = "";

  @override
  void initState() {
    super.initState();
    loadContentDatas();
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
      pocketLevel = BaseModel.getString(umsPocketConfig, "pocketLevel");
      taskCapacity = BaseModel.getInt(umsPocketConfig, "taskCapacity");
      taskCount = taskStartCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        title: Text(getTitle(),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16.w, 30.w, 16.w, 20.w),
            padding: EdgeInsets.fromLTRB(16.w, 20.w, 16.w, 20.w),
            decoration: BoxDecoration(
                color: IConstant.white_bg_color,
                borderRadius: BorderRadius.circular(10.w)),
            child: Row(
              children: [
                Image.asset("assets/icons/profit.png", width: 16.w, height: 16.w),
                SizedBox(width: 6.w),
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_simple_level), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                SizedBox(width: 2.w),
                Text(pocketLevel, style: TextStyle(fontSize: 15.sp, color: IConstant.green_color)),
                SizedBox(width: 10.w),
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_simple_capacity), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                SizedBox(width: 2.w),
                Text("$taskCount/$taskCapacity", style: TextStyle(fontSize: 15.sp, color: widget.taskFailed == TaskFailed.amountLimit ? IConstant.main_color : IConstant.green_color)),
                SizedBox(width: 10.w),
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_simple_foul), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                SizedBox(width: 2.w),
                Text("$violationCount", style: TextStyle(fontSize: 15.sp, color: IConstant.green_color)),
                expandeSpace,
                buildIcon(),
              ],
            ),
          ),
          buildRule()
        ],
      ),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  String getTitle() {
    if (widget.taskFailed == TaskFailed.ok) { //成功
      return LanguageConfig.get(LanguageConfigKeys.Shop_pocket_order_received_success);
    } else { //失败
      return LanguageConfig.get(LanguageConfigKeys.Shop_pocket_order_receiving_failed);
    }
  }

  Widget buildRule() {
    if (widget.taskFailed == TaskFailed.ok) { //成功
      return Container(
        //height: 90.w,
        margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.w),
        child: Row(
          children: [
            Container(width: 3.w, color: IConstant.red_bg_color),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_success_tips1),
                      maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                  SizedBox(height: 4.w,),
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_success_tips2),
                      maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                  SizedBox(height: 4.w,),
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_success_tips3),
                      maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))
                ],
              ),
            )
          ],
        ));
    } else { //失败
      return Container(
        //height: 90.w,
        margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.w),
        child: Row(
          children: [
            Container(width: 3.w, color: IConstant.red_bg_color),
            SizedBox(width: 12.w),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_failed_level_tips),
                    maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.sp, color: widget.taskFailed == TaskFailed.repeat ? IConstant.main_color : IConstant.grey_color)),
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_failed_capacity_tips),
                    maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.sp, color: widget.taskFailed == TaskFailed.amountLimit ? IConstant.main_color : IConstant.grey_color)),
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_failed_foul_tips),
                    maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.sp, color: IConstant.grey_color))
              ],
            ))
          ],
        ),
      );
    }
  }

  Widget buildIcon() {
    if (widget.taskFailed == TaskFailed.ok) {
      return Icon(Icons.check_circle, size: 28.w, color: IConstant.green_color);
    } else {
      return Icon(Icons.info, size: 28.w, color: IConstant.yellow_color);
    }
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
        height: 50.w,
        alignment: Alignment.center,
        child: SizedBox(
          width: 180.w,
          child: SmallTextButton(text: widget.taskFailed == TaskFailed.ok ? LanguageConfig.get(LanguageConfigKeys.Shop_pocket_view_task) : LanguageConfig.get(LanguageConfigKeys.Shop_pocket_view_pockets) , onTap: () {
            if (widget.taskFailed == TaskFailed.ok) {
              backHome();
              nextPage(TaskDetailPage(widget.pocketMember), false);
            } else {
              backHome();
              EventBusUtil.getInstance().emit(MainTabEvent(pageType: PageType.pocket));
            }
          }),
        ),
      ),
    );
  }
}
