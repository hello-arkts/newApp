
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../IURLConstant.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../model/SelectTabModel.dart';
import '../utils/FormatUtil.dart';
import '../utils/Util.dart';
import '../widget/LoadImageView.dart';
import '../widget/PriceText.dart';
import 'HistoryDetailPage.dart';

class HistoryActivityPage extends StatefulWidget {

  @override
  State<HistoryActivityPage> createState() => HistoryActivityPageState();

}

class HistoryActivityPageState extends BaseKeepAliveState<HistoryActivityPage> {

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
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_FIND_END_ACTIVITY, {
      "pageNum": "$page",
      "pageSize": "10"
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        List<dynamic> list = BaseModel.isNotEmpty(rsp.data, "list") ? BaseModel.getDynamic(rsp.data, "list") : [];
        count = rsp.data["total"];
        if (page == 1) {
          datas = list;
        } else {
          datas.addAll(list);
        }
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
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      activityHistory(datas[index]);
                    },
                    child: buildActivityItem(index),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 10.w);
                }),
          ))

        ],
    );
  }

  void activityHistory(dynamic activityMember) async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_ACTIVITY_MEMBER_INFO, {
      "activityId": BaseModel.getString(activityMember, "activityId")
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      nextPage(HistoryDetailPage(activityMember), false);
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  Widget buildActivityItem(int index) {
    dynamic activityMember = datas[index];
    return Card(
      margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 0.w),
      elevation: 4.w,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(12.w),
      ),
      child: Column(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.w)),
              child: LoadImageView(double.infinity, 92.w, BaseModel.getString(activityMember, "activityPic"),
                  alignment: Alignment.topCenter)
          ),
          SizedBox(height: 2.w,),
          Container(height: 3.w, color: IConstant.white_color,),
          Row(
            children: [
              SizedBox(width: 8.w),
              Expanded(flex: 1, child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(child: LoadImageView(30.w, 30.w, BaseModel.getString(activityMember, "shopIcon"))),
                  SizedBox(width: 6.w),
                  Expanded(child: Text(BaseModel.getString(activityMember, "shopName"),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.title_color)))
                ],
              )),
              Expanded(flex: 1, child: buildStopTime(activityMember)),
              SizedBox(width: 8.w),
              Expanded(flex: 1, child: Container(
                margin: EdgeInsets.fromLTRB(16.w, 6.w, 8.w, 8.w),
                child: buildStatus(activityMember),
              ))
            ],
          ),
          SizedBox(height: 2.w),
        ],
      ),
    );
  }

  Widget buildStopTime(dynamic item) {
    int status = BaseModel.getInt(item, "status");
    double withdrawalBalance = BaseModel.getDouble(item, "withdrawalBalance");
    if (withdrawalBalance > 0) {
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
      // return Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_task_over),
      //     style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color));
      return Container();
    }
  }

  Widget buildStatus(dynamic item) {
    int status = BaseModel.getInt(item, "status");
    if (status == 2) {
      return Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_task_finish),
          textAlign: TextAlign.right, style: TextStyle(fontSize: 11.sp, color: IConstant.text_color));
    } else {
      return Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_task_finish),
          textAlign: TextAlign.right, style: TextStyle(fontSize: 11.sp, color: IConstant.text_color));
    }
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
