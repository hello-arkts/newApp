
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/GetPrizeEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/promotion/SelectPriceDetailPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:mxcome/com/mxcome/app/utils/AppUtils.dart';
import 'package:sprintf/sprintf.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IConstant.dart';
import '../../../../IURLConstant.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/Adapt.dart';
import '../../../../utils/HttpUtils.dart';
import '../../../../utils/ViewUtils.dart';
import '../../model/SelectTabModel.dart';
import '../../utils/EventBusUtil.dart';
import '../../widget/LoadImageView.dart';
import '../../widget/SmallTextButton.dart';
import 'UseCouponDetailPage.dart';
import 'UseEntityDetailPage.dart';

class SelectPrizePage extends StatefulWidget {

  int oneLevelExtendNum;

  SelectPrizePage(this.oneLevelExtendNum);

  @override
  State<SelectPrizePage> createState() => SelectPrizePageState();

}

class SelectPrizePageState extends BaseKeepAliveState<SelectPrizePage> {

  List<SelectTabModel> tabList = [];
  List<dynamic> myPrizeList = [];
  dynamic getPrizeEvent;
  int pullNewComers = 0;

  @override
  void initState() {
    super.initState();
    tabList.add(SelectTabModel(4, true)); //全部
    tabList.add(SelectTabModel(3, false)); //热门
    tabList.add(SelectTabModel(1, false)); //兑换券
    tabList.add(SelectTabModel(0, false)); //实物奖品
    getPrizeEvent = EventBusUtil.getInstance().on<GetPrizeEvent>((event) {
      myExchangeGift();
      getUserInfo();
    });
    loadContentDatas();
    myExchangeGift();
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(getPrizeEvent);
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    getUserInfo();
    isLoading = true;
    BaseRsp rsp = await HttpUtils.postJSON(IURLConstant.MALL_EXCHANGE_GIFT_LIST, null, body: {
      "status": "0",
      "type": getSelectType(),
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

  getUserInfo() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_SSO_INFO, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      await AppUtils.setUserInfo(rsp.data);
      setState(() {
        pullNewComers = BaseModel.getInt(rsp.data, "pullNewComers");
      });
    }
  }

  Future<void> myExchangeGift() async {
    BaseRsp rsp = await HttpUtils.postJSON(IURLConstant.MALL_MY_EXCHANGE_GIFTS, null, body: {
      "pageNum": "$page",
      "pageSize": "20",
      "status": "0",
      "type": "4",
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<dynamic> tempList = BaseModel.isNotEmpty(rsp.data, "list") ? BaseModel.getDynamic(rsp.data, "list") : [];
      setState(() {
        myPrizeList = tempList;
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        backgroundColor: myPrizeList.isNotEmpty ? IConstant.red_bg_color3: IConstant.white_color,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_select_prizes),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildBody() {
    return Column(
        children: [
          myPrizeList.isEmpty ? Container() : Container(
              height: 190.w,
              padding: EdgeInsets.all(12.w),
              color: IConstant.red_bg_color3,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: myPrizeList.length,
                  itemBuilder: (BuildContext context, int index) {
                  return buildMyPrizeItem(index);
              },
              separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(width: 12.w);
              }
            )
          ),
          buildButtons(),
          Expanded(child: datas.isEmpty ? buildHeader() : EasyRefresh(
            header: const MaterialHeader(color: IConstant.main_color),
            footer: CupertinoFooter(emptyWidget: Container(
            padding: EdgeInsets.all(10.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_more), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
          )),
            onRefresh: ()=> onRefresh(),
            onLoad: ()=> onLoadMore(), child: GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(12.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 182.w,
              mainAxisSpacing: 10.w, //item上下间隔
              crossAxisSpacing: 10.w, //item左右间隔
            ),
            itemCount: datas.length,
            itemBuilder: (BuildContext context, int index) {
              return buildVoucherItem(index);
            },
          )))
        ],
    );
  }

  Widget buildMyPrizeItem(int index) {
    dynamic item = myPrizeList[index];
    dynamic gift = BaseModel.getDynamic(item, "gift");
    String pic = BaseModel.getString(gift, "pic");
    int type = BaseModel.getInt(gift, "type");
    return Container(
      width: 110.w,
      decoration: BoxDecoration(
        color: IConstant.white_color,
        border: Border.all(width: 1.w, color: IConstant.line_color),
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: Column(
        children: [
          SizedBox(height: 8.w),
          ClipOval(child: LoadImageView(45.w, 45.w, pic.split(',')[0])),
          SizedBox(height: 8.w),
          Container(
            padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0.w),
            child: Text(BaseModel.getString(gift, "name"),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.sp, color: IConstant.title_color)),
          ),
          SizedBox(height: 4.w),
          Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_expired), [FormatUtil.formatYMD(DateTime.parse(BaseModel.getString(gift, "endTime")))]),
              style: TextStyle(fontSize: 11.sp, color: IConstant.main_color)),
          SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_mine_now_use), fontSize: 12.sp, onTap: () {
            if (type == 1) {
              showPop(0.95 * Adapt.getWindowHeight(), UseCouponDetailPage(item));
            } else {
              showPop(0.95 * Adapt.getWindowHeight(), UseEntityDetailPage(item));
            }
          }),
          SizedBox(height: 8.w),
        ],
      ),
    );
  }

  Widget buildVoucherItem(int index) {
    dynamic item = datas[index];
    String exchangeLogo = BaseModel.getString(item, "exchangeLogo");
    return InkWell(
      onTap: () {
        nextPage(SelectPrizeDetailPage(item), false);
      },
      child: Container(
        padding: EdgeInsets.only(top: 15.w, bottom: 15.w),
        decoration: BoxDecoration(
          color: IConstant.white_color,
          border: Border.all(width: 1.w, color: IConstant.line_color),
          borderRadius: BorderRadius.circular(10.w),
        ),
        child: Column(
          children: [
            ClipOval(child: LoadImageView(50.w, 50.w, exchangeLogo)),
            SizedBox(height: 16.w),
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0.w),
                child: Text("${BaseModel.getString(item, "merchantName")}-${BaseModel.getString(item, "name")}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13.sp, color: IConstant.title_color)),
              ),
            ),
            SizedBox(height: 16.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 6.w),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: 45.w
                  ),
                  child: PriceText(BaseModel.getDouble(item, "sellPrice"), fontSize: 11.sp, color: IConstant.text_color),
                ),
                Container(
                  width: 1.w,
                  height: 12.w,
                  color: IConstant.line_color,
                  margin: EdgeInsets.fromLTRB(3.w, 0, 3.w, 0),
                ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 45.w
                  ),
                  child: Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_direct_push), [BaseModel.getInt(item, "exchangeNewComers")]),
                      style: TextStyle(fontSize: 11.w, color: IConstant.text_color)),
                ),
                SizedBox(width: 6.w),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtons() {
    return Container(
      height: 30.w,
      margin: EdgeInsets.only(top: 8.w, bottom: 0.w),
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
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_exchange_voucher);
    } else if (model.type == 0) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_entity_prizes);
    } else if (model.type == 3) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_hot);
    } else if (model.type == 4) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_order_all);
    } else {
      return "";
    }
  }

  String getSelectType() {
    for (SelectTabModel item in tabList) {
      if (item.isSelect) {
        return "${item.type}";
      }
    }
    return "";
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

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      elevation: 10.w,
      child: Container(
          padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
          child: Row(
            children: [
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_my_push_value), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
              SizedBox(width: 5.w,),
              Text("$pullNewComers", style: TextStyle(fontSize: 14.sp, color: IConstant.main_color))
            ],
          )
      ),
    );
  }

}
