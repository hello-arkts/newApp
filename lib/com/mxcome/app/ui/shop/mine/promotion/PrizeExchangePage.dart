
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/promotion/UseCouponDetailPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/SmallTextButton.dart';
import 'package:mxcome/com/mxcome/app/utils/Adapt.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import 'package:sprintf/sprintf.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IConstant.dart';
import '../../../../IURLConstant.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/HttpUtils.dart';
import '../../event/GetPrizeEvent.dart';
import '../../model/SelectTabModel.dart';
import '../../utils/EventBusUtil.dart';
import '../../widget/LoadImageView.dart';
import 'UseEntityDetailPage.dart';

class PrizeExchangePage extends StatefulWidget {

  String type;

  PrizeExchangePage(this.type);


  @override
  State<PrizeExchangePage> createState() => PrizeExchangePageState();

}

class PrizeExchangePageState extends BaseKeepAliveState<PrizeExchangePage> {

  List<SelectTabModel> tabList = [];
  dynamic getPrizeEvent;

  @override
  void initState() {
    super.initState();
    tabList.add(SelectTabModel(-2, true)); //全部
    tabList.add(SelectTabModel(0, false)); //待使用
    tabList.add(SelectTabModel(1, false)); //已使用
    tabList.add(SelectTabModel(-1, false)); //已过期
    getPrizeEvent = EventBusUtil.getInstance().on<GetPrizeEvent>((event) {
      loadContentDatas();
    });
    loadContentDatas();
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(getPrizeEvent);
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    isLoading = true;
    BaseRsp rsp = await HttpUtils.postJSON(IURLConstant.MALL_MY_EXCHANGE_GIFTS, null, body: {
      "pageNum": "$page",
      "pageSize": "10",
      "status": getSelectStatus(),
      "type": widget.type,
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
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        buildButtons(),
        Expanded(child: datas.isEmpty ? buildHeader() : EasyRefresh(
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
              return buildVoucherItem(index);
            },
            separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 10.w);
            })),
          )
        ],
    );
  }

  Widget buildVoucherItem(int index) {
    dynamic item = datas[index];
    int status = BaseModel.getInt(item, "status");
    String statusText = "";
    Color statusColor = IConstant.text_color;
    if (status == 0) {
      statusText = LanguageConfig.get(LanguageConfigKeys.Shop_mine_to_be_use);
      statusColor = IConstant.green_color;
    } else if (status == -1) {
      statusText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_expired);
      statusColor = IConstant.sub_text_color;
    } else {
      statusText = LanguageConfig.get(LanguageConfigKeys.Shop_mine_used);
      statusColor = IConstant.main_color;
    }
    dynamic gift = BaseModel.getDynamic(item, "gift");
    String pic = BaseModel.getString(gift, "pic");
    int type = BaseModel.getInt(gift, "type");
    return Container(
      margin: EdgeInsets.fromLTRB(10.w, 0.w, 10.w, 0.w),
      padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
      decoration: BoxDecoration(
        border: Border.all(color: IConstant.line_color, width: 1.w),
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: Row(
        children: [
          ClipOval(child: LoadImageView(60.w, 60.w, pic.split(',')[0])),
          SizedBox(width: 10.w),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(BaseModel.getString(gift, "name"),
                      style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
                  SizedBox(width: 10.w,),
                  Text("×${BaseModel.getInt(item, "quantity")}",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 12.sp, color: IConstant.sub_text_color))
                ],
              ),
              SizedBox(height: 4.w,),
              PriceText(BaseModel.getDouble(gift, "sellPrice"), fontSize: 12.sp, color: IConstant.sub_text_color),
              SizedBox(height: 4.w,),
              Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_valid_to), [ FormatUtil.formatYMDHMS(DateTime.parse(BaseModel.getString(gift, "endTime"))) ]),
                  style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))
            ],
          )),
          SizedBox(
            width: 80.w,
            child: Column(
              children: [
                Text(statusText,
                    style: TextStyle(fontSize: 12.sp, color: statusColor)),
                SmallTextButton(text:  status == 0 ? LanguageConfig.get(LanguageConfigKeys.Shop_mine_now_use) 
                    : LanguageConfig.get(LanguageConfigKeys.Shop_mine_detail),
                    bgColor: status == 0 ? IConstant.main_color: IConstant.grey_bg_color,
                    textColor: status == 0 ? IConstant.white_color: IConstant.text_color,
                    fontSize: 12.sp, onTap: () {
                  if (type == 1) {
                    showPop(0.95 * Adapt.getWindowHeight(), UseCouponDetailPage(item));
                  } else {
                    showPop(0.95 * Adapt.getWindowHeight(), UseEntityDetailPage(item));
                  }
                })
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildButtons() {
    return Container(
      margin: EdgeInsets.only(top: 8.w, bottom: 16.w),
      padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 0.w),
      child: Row(children: tabList.map((item) => buildButton(item)).toList()),
    );
  }

  Widget buildButton(SelectTabModel model) {
    return Container(
        height: 30.w,
        margin: EdgeInsets.only(right: 10.w),
        child: OutlinedButton(
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
        ));
  }

  String getSelectStatus() {
    for(var item in tabList) {
      if (item.isSelect) {
        return "${item.type}";
      }
    }
    return "";
  }

  String getTitle(SelectTabModel model){
    if (model.type == 0) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_to_be_use);
    } else if (model.type == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_used);
    } else if(model.type == -1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_activity_expired);
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
