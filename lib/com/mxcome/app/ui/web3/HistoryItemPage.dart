
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';

import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';

import '../../IConstant.dart';
import '../../IURLConstant.dart';
import '../../model/BaseRsp.dart';
import '../../utils/AppUtils.dart';
import '../../utils/HttpUtils.dart';
import '../../utils/ViewUtils.dart';
import '../shop/widget/LoadImageView.dart';

class HistoryItemPage extends StatefulWidget {

  int flag = 0;

  HistoryItemPage(this.flag);

  @override
  State<HistoryItemPage> createState() => HistoryItemPageState();

}

class HistoryItemPageState extends BaseKeepAliveState<HistoryItemPage> {

  String _userId = "";

  @override
  void initState() {
    super.initState();
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    isLoading = true;
    dynamic data = await AppUtils.getUserInfo();
    _userId = BaseModel.getString(data, "id");
    String url = widget.flag == 0 ? IURLConstant.MALL_COIN_WITHDRAW_LIST : IURLConstant.MALL_COIN_TRADE_LIST;
    BaseRsp rsp = await HttpUtils.get(url, {
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
        body: Container(
          margin: EdgeInsets.only(top: 10.w),
          child: buildBody(),
        )
    );
  }

  Widget buildBody() {
    return datas.isEmpty ? buildHeader() : EasyRefresh(
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
            return buildItem(index);
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 10.w);
          }),
    );
  }

  Widget buildItem(int index) {
    dynamic item = datas[index];
    bool isOut = true;
    if (widget.flag == 1 && _userId == BaseModel.getString(item, "toUserId")) {
      isOut = false;
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
      decoration: BoxDecoration(
          color: IConstant.grey_bg_color,
          borderRadius: BorderRadius.all(Radius.circular(15.w))
      ),
      child: Row(
        children: [
          Padding(padding: EdgeInsets.only(right: 10.w),
              child: LoadImageView(50.w, 50.w, BaseModel.getString(item, "coinPic"))),
          Expanded(child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${BaseModel.getString(item, "coinId")}",
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.text_color)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.w),
                    decoration: BoxDecoration(
                        color: isOut ? IConstant.main_color: IConstant.green_color,
                        borderRadius: BorderRadius.all(Radius.circular(12.w))
                    ),
                    child: Text(isOut? LanguageConfig.get(LanguageConfigKeys.Shop_web3_transfer_out) : LanguageConfig.get(LanguageConfigKeys.Shop_web3_transfer_in),
                        style: TextStyle(fontSize: 12.sp, color: IConstant.white_color)),
                  ),
                ],
              ),
              SizedBox(height: 8.w,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text("${BaseModel.getString(item, "address")}",
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),),
                  SizedBox(width: 20.w,),
                  Text("${BaseModel.getString(item, "createTime")}",
                      style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
                ],
              ),
            ],
          ))
        ],
      ),
    );
  }

}
