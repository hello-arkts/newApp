import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/login/RedLevelPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/GetPrizeEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/UserInfoEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/promotion/MinePrizePage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/promotion/SelectPrizePage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/ShowBottomSheetTool.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CountDownView.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/HeadImageTheme.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import 'package:sprintf/sprintf.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IURLConstant.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/HttpUtils.dart';
import '../../utils/FormatUtil.dart';
import 'PromotionDetailPage.dart';

class RedHistoryPage extends StatefulWidget {

  int pullNewComers;

  final Function callBack;

  RedHistoryPage(this.pullNewComers, {required this.callBack});

  @override
  State<StatefulWidget> createState() {
    return RedHistoryPageState();
  }
}

class RedHistoryPageState extends BaseKeepAliveState<RedHistoryPage> {

  int _oneLevelExtendNum = 0; //推广一级总人数

  int _twoLevelExtendNum = 0; //推广二级总人数

  int _threeLevelExtendNum = 0; //推广三级总人数

  double _redAmount = 0.0;

  List<dynamic> userRedHistoryList = [];

  var userRedNumber = [];

  @override
  void initState() {
    super.initState();
    loadContentDatas();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_GET_HISTORY_RED, {});
    if(rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        _oneLevelExtendNum = BaseModel.getInt(rsp.data, "oneLevelExtendNum");
        _twoLevelExtendNum = BaseModel.getInt(rsp.data, "twoLevelExtendNum");
        _threeLevelExtendNum = BaseModel.getInt(rsp.data, "threeLevelExtendNum");
        _redAmount = BaseModel.getDouble(rsp.data, "redAmountSum");
        userRedHistoryList = BaseModel.isNotEmpty(rsp.data, "memberRedActivityResultList") ? BaseModel.getDynamic(rsp.data, "memberRedActivityResultList") : [];
        if(userRedHistoryList.isNotEmpty) {
          for(int i=0; i< userRedHistoryList.length; i++) {
            userRedNumber.add(BaseModel.getString(userRedHistoryList[i], 'redName'));
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return HeadImageTheme(
      headImageName: 'assets/icons/bg_red_history.png',
      headImageHeight: 207.w,
      fit: BoxFit.fill,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 22.w,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_red_history_title),
            style: TextStyle(fontSize: 17.sp, color: IConstant.white_color, fontWeight: FontWeight.bold)),
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildRedBaseInfo(),
        buildRedNumberSelect(),
        buildRedNumberList()
      ],
    );
  }

  Widget buildRedBaseInfo() {
    return Container(
      margin: EdgeInsets.fromLTRB(18.w, 20.w, 18.w, 20.w),
      padding: EdgeInsets.fromLTRB(15.w, 18.w, 0.w, 20.w),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color(0x1E000000),
              blurRadius: 9,
              offset: Offset(0, 2),
              spreadRadius: 0,
            ) ,
          ],
          borderRadius: BorderRadius.all(Radius.circular(10.w))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 155.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_total_number_promoters), style: TextStyle(fontSize: 14.w, color: const Color(0x8C292929),)),
                SizedBox(height: 14.w,),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: Text('$_oneLevelExtendNum',
                          style: TextStyle(fontSize: 16.w, color: IConstant.text_color, fontWeight: FontWeight.bold)),
                    ),
                    Container(height: 19.w, color: IConstant.line_color, width: 1.w,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text('$_twoLevelExtendNum',
                          style: TextStyle(fontSize: 16.w, color: IConstant.text_color, fontWeight: FontWeight.bold)),
                    ),
                    Container(height: 19.w, color: IConstant.line_color, width: 1.w,),
                    Padding(
                      padding: EdgeInsets.only(left: 12.w),
                      child: Text('$_threeLevelExtendNum',
                          style: TextStyle(fontSize: 16.w, color: IConstant.text_color, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                // SizedBox(height: 15.w,),
                // InkWell(
                //   onTap: () {
                //     //showRedNumberBottomSheet(type: 1);
                //   },
                //   child: Container(
                //     padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 4.w),
                //     decoration: BoxDecoration(
                //         border: Border.all(width: 1.w, color: IConstant.line_color),
                //         borderRadius: BorderRadius.all(Radius.circular(16.r))
                //     ),
                //     child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_promotion_details), style: TextStyle(fontSize: 13.w, color: IConstant.main_color, fontWeight: FontWeight.bold)),
                //   ),
                // )
              ],
            ),
          ),
          Container(height: 98.w, width: 1.w, color: IConstant.white_bg_color,),
          Container(
            padding: EdgeInsets.only(left: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_my_push_value), style: TextStyle(fontSize: 14.w, color: const Color(0x8C292929),)),
                SizedBox(height: 14.w,),
                Text('${widget.pullNewComers}', style: TextStyle(fontSize: 16.w, color: IConstant.main_color)),
                SizedBox(height: 15.w,),
                InkWell(
                  onTap: () {
                    nextPage(SelectPrizePage(_oneLevelExtendNum), false);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.w),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.w, color: IConstant.line_color),
                        borderRadius: BorderRadius.all(Radius.circular(16.r))
                    ),
                    child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_exchange_prizes), style: TextStyle(fontSize: 13.w, color: IConstant.main_color, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildRedNumberSelect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            showRedNumberBottomSheet(type: 0);
          },
          child: Container(
            height: 30.w,
            margin: EdgeInsets.only(left: 21.w),
            padding: EdgeInsets.symmetric(horizontal: 13.w,),
            decoration: BoxDecoration(
                border: Border.all(width: 1.w, color: IConstant.line_color),
                borderRadius: BorderRadius.all(Radius.circular(16.r))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_address_please_select), style: TextStyle(fontSize: 13.w, color: IConstant.text_color.withOpacity(0.55),)),
                Icon(Icons.keyboard_arrow_down, size: 25.w, color: const Color(0xffb2b2b2))
              ],
            )
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 24.w),
          child: Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_red_total_number), ["${ userRedHistoryList.length }"]), style: TextStyle(
              fontSize: 14.sp, color: IConstant.text_color, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  //0 推广明细 1 红包闯关
  showRedNumberBottomSheet({int type = 0}) {
    if(userRedHistoryList.isNotEmpty) {
      ShowBottomSheetTool(titleColor: IConstant.text_color).showSingleRowPicker(context, data: userRedNumber, title: LanguageConfig.get(LanguageConfigKeys.Shop_mine_select_option), normalIndex: 0 , clickCallBack: (int selectIndex, Object selectStr){
        if(type == 0) {
          widget.callBack(BaseModel.getString(userRedHistoryList[selectIndex], 'redActivityId'), BaseModel.getString(userRedHistoryList[selectIndex], 'redName'));
          finishContext(context);
        }else {
          nextPage(PromotionDetailPage(BaseModel.getString(userRedHistoryList[selectIndex], "redActivityId"), _oneLevelExtendNum, _twoLevelExtendNum, _threeLevelExtendNum), false);
        }
      });
    }else {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_mine_red_no_data));
    }
  }

  Widget buildRedNumberList() {
    return Expanded(child:
    ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.w),
        itemBuilder: (ctx, index) => buildRedNumberItem(index),
        itemCount: userRedHistoryList.length,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 20.w);
        }));
  }

  Widget buildRedNumberItem(int index) {
    dynamic redNumberItem = userRedHistoryList[index];
    return InkWell(
      onTap: () {
        widget.callBack(BaseModel.getString(redNumberItem, 'redActivityId'), BaseModel.getString(redNumberItem, 'redName'));
        finishContext(context);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 15.w, 14.w, 15.w),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color(0x1E000000),
                blurRadius: 9,
                offset: Offset(0, 2),
                spreadRadius: 0,
              ) ,
            ],
            borderRadius: BorderRadius.all(Radius.circular(10.w))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(BaseModel.getString(redNumberItem, 'redName'), style: TextStyle(
                      fontSize: 14.sp, color: IConstant.text_color, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis,),
                ),
                Text(getRedStatusText(redNumberItem), style: TextStyle(fontSize: 14.w, color:getRedStatusTextColor(redNumberItem))),
              ],
            ),
            SizedBox(height: 12.w,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${getRedStartTime(redNumberItem)}${LanguageConfig.get(LanguageConfigKeys.Shop_mine_date_to)}${getRedEndTime(redNumberItem)}', style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
                Row(
                  children: [
                    Text('+', style: TextStyle(fontSize: 14.sp, color: IConstant.green_color)),
                    PriceText(BaseModel.getDouble(redNumberItem, 'redAmountSum'), fontSize: 14.sp, color: IConstant.green_color,),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.w,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_wallet_withdrawal_finish), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
                Row(
                  children: [
                    Text('-', style: TextStyle(fontSize: 14.sp, color: IConstant.main_color)),
                    PriceText(BaseModel.getDouble(redNumberItem, 'takeRedAmount'), fontSize: 14.sp, color: IConstant.main_color,),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.w,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_run_to_zero), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
                PriceText(BaseModel.getDouble(redNumberItem, 'redAmountSum') - BaseModel.getDouble(redNumberItem, 'takeRedAmount'), fontSize: 14.sp, color: IConstant.grey_color,),
              ],
            ),
          ],
        ),
      ),
    );
  }

  getRedStartTime(dynamic item) {
    String redStartTime = BaseModel.getString(item, 'redTimeStart');
    if(redStartTime.isNotEmpty) {
      return FormatUtil.formatLineYMD(DateTime.parse(redStartTime));
    }else {
      return '';
    }
  }

  getRedEndTime(dynamic item) {
    String redEndTime = BaseModel.getString(item, 'redTimeEnd');
    if(redEndTime.isNotEmpty) {
      return FormatUtil.formatLineYMD(DateTime.parse(redEndTime));
    }else {
      return '';
    }
  }

  getRedStatusText(dynamic item) {
    int redPower = BaseModel.getInt(item, 'redPower');
    if(redPower == 1 || redPower == 2) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_processing);
    }else if(redPower == -1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_activity_expired);
    }else if(redPower == 3){
      return LanguageConfig.get(LanguageConfigKeys.Shop_activity_over_all_level);
    }else {
      return '';
    }
  }

  getRedStatusTextColor(dynamic item) {
    int redPower = BaseModel.getInt(item, 'redPower');
    if(redPower == 1 || redPower == 2 || redPower == 3) {
      return IConstant.main_color;
    }else {
      return const Color(0x8C292929);
    }
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      elevation: 4.w,
      child: Container(
        padding: EdgeInsets.fromLTRB(18.w, 20.w, 18.w, 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_total_gains), style: TextStyle(fontSize: 14.w, color: IConstant.text_color)),
                SizedBox(width: 11.w,),
                Image.asset("assets/icons/promotion_wallet_2.png", width: 14.w),
                SizedBox(width: 7.w,),
                PriceText(_redAmount, fontSize: 14.sp),
              ],
            ),
            InkWell(
              onTap: () {
                nextPage(MinePrizePage(), false);
              },
              child: Container(
                height: 30.w,
                padding: EdgeInsets.only(left: 7.w, right: 7.w),
                decoration: BoxDecoration(
                    color: IConstant.main_color,
                    borderRadius: BorderRadius.all(Radius.circular(16.r))
                ),
                child: Row(
                  children: [
                    Image.asset("assets/icons/promotion_center_2.png", width: 22.w, height: 22.w,),
                    SizedBox(width: 4.w,),
                    Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_view_prize), style: TextStyle(fontSize: 13.w, color: IConstant.white_color)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
