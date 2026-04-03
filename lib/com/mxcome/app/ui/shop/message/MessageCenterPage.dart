import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';

import '../../../BaseKeepAliveState.dart';
import '../widget/LoadImageView.dart';

class MessageCenterPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return MessageCenterPageState();
  }

}

class MessageCenterPageState extends BaseKeepAliveState<MessageCenterPage> {

  List<dynamic> messageList = [];

  @override
  void initState() {
    super.initState();
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_bg_color,
      appBar: AppBar(
        elevation: 0.5.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_notification),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (messageList.isEmpty) {
      return buildHeader();
    } else {
      return ListView.separated(
          scrollDirection: Axis.vertical,
          itemCount: messageList.length,
          itemBuilder: (context, index) {
            return InkWell(
              child: buildTaskItem(index),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 10.w);
          });
    }
  }

  Widget buildTaskItem(int index) {
    dynamic item = messageList[index];
    return Container(
      margin: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 0.w),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
          color: IConstant.white_color,
          borderRadius: BorderRadius.all(Radius.circular(16.w))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              ClipOval(
                  child: LoadImageView(50.w, 50.w, BaseModel.getString(item, "image"))),
              SizedBox(width: 6.w),
              Expanded(child: Text(BaseModel.getString(item, "message"), maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),)
            ],
          ),
          Text(BaseModel.getString(item, "createTime"), textAlign: TextAlign.right,
              style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))
        ],
      ),
    );
  }

}
