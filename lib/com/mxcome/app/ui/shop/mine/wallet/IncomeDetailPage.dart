
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IURLConstant.dart';
import '../../../../config/LanguageConfig.dart';
import '../../../../model/BaseModel.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/HttpUtils.dart';
import '../../utils/FormatUtil.dart';

class IncomeDetailPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return IncomeDetailPageState();
  }

}

class IncomeDetailPageState extends BaseKeepAliveState<IncomeDetailPage> {

  @override
  void initState() {
    super.initState();
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    isLoading = true;
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_INCOME_INFO,   {
      "pageNum": "$page", "pageSize": "20"
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
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.5.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_wallet_mxget_income),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (datas.isEmpty) {
      return buildHeader();
    } else {
      return Container(
        padding: EdgeInsets.all(10.w),
        child: EasyRefresh(
            header: const MaterialHeader(color: IConstant.main_color),
            footer: CupertinoFooter(emptyWidget: Container(
            padding: EdgeInsets.all(10.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_more), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
          )),
            onRefresh: ()=> onRefresh(),
            onLoad: ()=> onLoadMore(), child: ListView.separated(
            scrollDirection: Axis.vertical,
            itemCount: datas.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {},
                child: buildListItem(datas[index]),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 10.w);
            }),
      ));
    }
  }

  Widget buildListItem(dynamic item) {
    return ListTile(
      title: Text(getItemType(item),
          style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
      subtitle: Text(BaseModel.getString(item, "createTime"),
          style: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color)),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          buildIncomeDetail(item),
          Text("${LanguageConfig.get(LanguageConfigKeys.Shop_wallet_balance)} ${FormatUtil.price2String(BaseModel.getDouble(item, "accountBalance"))}",
              style: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color)),
        ],
      ),
    );
  }

  Widget buildIncomeDetail(dynamic item) {
    int status = BaseModel.getInt(item, "status"); //动态收益：0 1  转入余额：-1  退单：-2
    if (status == 0 || status == 1) {
      return Container(
        padding: EdgeInsets.fromLTRB(4.w, 2.w, 4.w, 2.w),
        decoration: BoxDecoration(
          color: IConstant.green_bg_color,
          borderRadius: BorderRadius.all(Radius.circular(4.w)),
        ),
        child: Text("+${FormatUtil.price2String(BaseModel.getDouble(item, "balance"))}",
            style: TextStyle(fontSize: 12.sp, color: IConstant.green_color)),
      );
    } else {
      return Container(
        padding: EdgeInsets.fromLTRB(4.w, 2.w, 4.w, 2.w),
        decoration: BoxDecoration(
          color: IConstant.red_bg_color3,
          borderRadius: BorderRadius.all(Radius.circular(4.w)),
        ),
        child: Text("-${FormatUtil.price2String(BaseModel.getDouble(item, "balance"))}",
            style: TextStyle(fontSize: 12.sp, color: IConstant.main_color)),
      );
    }
  }

  String getItemType(dynamic item){
    int status = BaseModel.getInt(item, "status"); //动态收益：0 1  转入余额：-1  退单：-2
    if(status == 0 || status == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_mxget_income);
    } else if (status == -1){
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_transferred_balance);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_chargeback);
    }
  }

}
