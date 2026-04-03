import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IConstant.dart';
import '../../../../IURLConstant.dart';
import '../../../../config/LanguageConfig.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/HttpUtils.dart';
import '../../utils/FormatUtil.dart';

class BalanceListPage extends StatefulWidget {

  @override
  State<BalanceListPage> createState() => BalanceListPageState();

}

class BalanceListPageState extends BaseKeepAliveState<BalanceListPage> {

  @override
  void initState() {
    super.initState();
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    isLoading = true;
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_BALANCE_LIST,   {
      "pageNum": "$page", "pageSize": "10"
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
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_wallet_balance_detail),
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
          buildChangeBalance(item),
          Text("${LanguageConfig.get(LanguageConfigKeys.Shop_wallet_balance)} ${FormatUtil.price2String(BaseModel.getDouble(item, "accountBalance"))}",
              style: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color)),
        ],
      ),
    );
  }

  Widget buildChangeBalance(dynamic item) {
    int type = BaseModel.getInt(item, "type");
    if (type == 2 || type == 4 || type == 6 || type == 10) {
      return Container(
        padding: EdgeInsets.fromLTRB(4.w, 2.w, 4.w, 2.w),
        decoration: BoxDecoration(
          color: IConstant.red_bg_color3,
          borderRadius: BorderRadius.all(Radius.circular(4.w)),
        ),
        child: Text("-${FormatUtil.priceAbs2String(BaseModel.getDouble(item, "changeBalance"))}",
            style: TextStyle(fontSize: 12.sp, color: IConstant.main_color)),
      );
    } else {
      return Container(
        padding: EdgeInsets.fromLTRB(4.w, 2.w, 4.w, 2.w),
        decoration: BoxDecoration(
          color: IConstant.green_bg_color,
          borderRadius: BorderRadius.all(Radius.circular(4.w)),
        ),
        child: Text("+${FormatUtil.price2String(BaseModel.getDouble(item, "changeBalance"))}",
            style: TextStyle(fontSize: 12.sp, color: IConstant.green_color)),
      );
    }
  }

  String getItemType(dynamic item){
    int type = BaseModel.getInt(item, "type"); //1充值，2提现，3任务分润，4购买商品，5退款，6提现手续费, 7提现(+), 8提现手续费(+)
    if (type == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_recharge);
    } else if (type == 2) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_withdrawal);
    } else if (type == 3) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_task_profit_sharing);
    } else if (type == 4)  {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_buy_goods);
    } else if (type == 5)  {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_refund);
    } else if (type == 6)  {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_service_charges_fee);
    } else if (type == 7)  {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_withdrawal);
    } else if (type == 8)  {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_service_charges_fee);
    } else if (type == 9)  {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_red_packet_withdrawal);
    }else if (type == 10)  {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_chargeback);
    }else if (type == 11)  {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_rebate);
    }else if (type == 12)  {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_daily_benefits);
    }else if (type == 13)  {
      return LanguageConfig.get(LanguageConfigKeys.Shop_wallet_newcomer_join);
    }else {
      return "Unknown";
    }
  }
  
}
