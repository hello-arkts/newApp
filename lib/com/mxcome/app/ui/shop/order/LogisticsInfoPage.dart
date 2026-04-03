
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';

import '../../../BaseKeepAliveState.dart';
import '../model/LogisticsModel.dart';
import '../utils/ClipboardUtil.dart';


class LogisticsInfoPage extends StatefulWidget {

  List<dynamic> logisticsInfoList = [];

  LogisticsInfoPage(this.logisticsInfoList);

  @override
  State<StatefulWidget> createState() {
    return LogisticsInfoPageState();
  }

}

class LogisticsInfoPageState extends BaseKeepAliveState<LogisticsInfoPage> {

  List<LogisticsModel> _logisticsInfoList = [];
  @override
  void initState() {
    super.initState();
    List<LogisticsModel> tempList = [];
    for(var item in widget.logisticsInfoList) {
      tempList.add(LogisticsModel.fromJson(item, false));
    }
    if (tempList.isNotEmpty) {
      tempList[0].isSelect = true;
    }
    setState(() {
      _logisticsInfoList = tempList;
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
        leading: Container(),
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_delivery_detail),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: _logisticsInfoList.isEmpty ? buildHeader() : ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _logisticsInfoList.length,
          itemBuilder: (context, index) {
            return buildTitle(_logisticsInfoList[index], index);
          }),
    );
  }

  Widget buildTitle(LogisticsModel title, int index) {
    String waybillNum = title.waybillNum;
    List<dynamic> contentList = TextUtils.isNotEmpty(title.logisticsContent) ? jsonDecode(title.logisticsContent) : [];
    contentList.sort((a, b) => BaseModel.getString(a, "time_utc")
        .compareTo(BaseModel.getString(b, "time_utc")));
    return Container(
      margin: EdgeInsets.fromLTRB(12.w, 12.w, 12.w, 12.w),
      decoration: BoxDecoration(
          color: IConstant.grey_bg_color,
          borderRadius: BorderRadius.circular(12.w)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 6.w),
          Row(
            children: [
              SizedBox(width: 16.w),
              Text(waybillNum, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp, color: IConstant.blue_color)),
              InkWell(onTap: () => ClipboardUtil.setDataToast(waybillNum),
                  child: Image.asset("assets/icons/copy_icon.png", width: 30.w, height: 30.w)),
              expandeSpace,
              Text("${LanguageConfig.get(LanguageConfigKeys.Shop_order_package)} ${index + 1}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp, color: IConstant.blue_color)),
              InkWell(
                onTap: () {
                  setState(() {
                    title.isSelect =  !title.isSelect;
                  });
                },
                child: Icon(title.isSelect ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 26.w, color: IConstant.sub_text_color),
              ),
              SizedBox(width: 16.w),
            ],
          ),
          SizedBox(height: 6.w),
          title.isSelect ? contentList.isNotEmpty ? ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: contentList.length,
              itemBuilder: (context, index) {
                return buildItem(contentList[index], index);
              }) : Container(
            margin: EdgeInsets.fromLTRB(16.w, 0.w, 0.w, 16.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_data), style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
          ) : Container(),
        ],
      ),
    );
  }

  Widget buildItem(dynamic item, int index) {
    String stage = BaseModel.getString(item, "stage");
    String description = BaseModel.getString(item, "description");
    String timeUtc = BaseModel.getString(item, "time_utc");
    DateTime dateTime = DateTime.parse(timeUtc);
    String formatDate = FormatUtil.formatYMDHMS(dateTime);
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: 4.w),
            Row(
              children: [
                SizedBox(width: 46.w),
                Text(stage, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.text_color)),
                expandeSpace,
                Text(formatDate, style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
                SizedBox(width: 16.w),
              ],
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.fromLTRB(46.w, 4.w, 16.w, 4.w),
              child: Text(description, maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
            ),
            SizedBox(height: 4.w),
          ],
        ),
        Positioned(left: 10.w, top: 0.w, bottom: 0.w, child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                Icon(Icons.circle_rounded, size: 26.w, color: IConstant.main_color),
                Positioned(left: 0.w, top: 0.w, right: 0.w, bottom: 0.w,
                    child: Center(
                      child: Text("${index + 1}", textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp, color: IConstant.white_color)),
                    ))
              ],
            ),
            Expanded(child: Container(
              width: 1.w,
              color: IConstant.main_color,
            ))
          ],
        ))
      ],
    );
  }

}
