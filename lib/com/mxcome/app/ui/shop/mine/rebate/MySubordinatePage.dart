import 'package:easy_refresh/easy_refresh.dart';
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
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';

class MySubordinatePage extends StatefulWidget {

  MySubordinatePage();

  @override
  State<MySubordinatePage> createState() => MySubordinatePageState();
}

class MySubordinatePageState extends BaseKeepAliveState<MySubordinatePage> {

  @override
  void initState() {
    super.initState();
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async{
    isLoading = true;
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_SSO_MY_SUBORDINATE, {
      "pageNum": "$page",
      "pageSize": "10",
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<dynamic> tempList = BaseModel.isNotEmpty(rsp.data, "list") ? BaseModel.getDynamic(rsp.data, "list") : [];
      setState(() {
        count = rsp.data["total"];
        if (page == 1) {
          datas = tempList;
        } else {
          datas.addAll(tempList);
        }
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
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
        centerTitle: true,
        leading: Container(),
        title: Text(LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_my_subordinate), style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildBody() {
    return datas.isEmpty? buildHeader() : Container(
      padding: EdgeInsets.symmetric(vertical: 20.w),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 30.w, right: 30.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_purchase_users), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
                Text(LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_bind_time), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
              ],
            ),
          ),
          SizedBox(height: 20.w),
          Expanded(
              child: EasyRefresh(
                header: const MaterialHeader(color: IConstant.main_color),
                footer: CupertinoFooter(emptyWidget: Container(
            padding: EdgeInsets.all(10.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_more), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
          )),
                onRefresh: ()=> onRefresh(),
                onLoad: ()=> onLoadMore(),
                child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: datas.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {},
                        child: buildBuyItem(index),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 25.w);
                    }),
              )),
        ],
      ),
    );
  }

  Widget buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      elevation: 8.w,
      child: Container(
        padding: EdgeInsets.only(left: 28.w, right: 28.w),
        height: 60.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_my_subordinate_nums), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
            Text("$count", style: TextStyle(fontSize: 16.sp, color: IConstant.main_color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget buildBuyItem(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildImageItem(datas[index]),
        Text(getBindTime(BaseModel.getString(datas[index], "createTime")), style: TextStyle(color: IConstant.text_color.withOpacity(0.55), fontSize: 12.sp),)
      ],
    );
  }

  String getDisplayName(dynamic item) {
    String nickname = BaseModel.getString(item, "nickname");
    String generatorId = BaseModel.getString(item, "generatorId");
    return TextUtils.isNotEmpty(nickname) ? nickname: generatorId;
  }

  String getBindTime(String buyTime) {
    DateTime calcTime = DateTime.parse(buyTime);
    return FormatUtil.formatYMDHMS(calcTime);
  }

  Widget buildImageItem(dynamic item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipOval(
          child: LoadImageView(46.w, 46.w, BaseModel.getString(item, "icon")),
        ),
        SizedBox(width: 8.w),
        Container(constraints: BoxConstraints(maxWidth: 100.w), child: Text(getDisplayName(item), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)))
      ],
    );
  }
}
