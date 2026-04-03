import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/Logger.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/order/OrderConfirmPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CountDownView.dart';
import 'package:mxcome/com/mxcome/app/utils/Adapt.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IURLConstant.dart';
import '../../../model/BaseModel.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/TextUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../model/GiftModel.dart';
import '../utils/FormatUtil.dart';
import '../utils/Util.dart';
import '../widget/LoadImageView.dart';
import '../widget/SmallTextButton.dart';
import 'BuyTaskPrizePage.dart';

class GetPrizeTaskPage extends StatefulWidget {

  dynamic pocketMember;

  GetPrizeTaskPage(this.pocketMember);

  @override
  State<StatefulWidget> createState() => GetPrizeTaskPageState();
}

class GetPrizeTaskPageState extends BaseKeepAliveState<GetPrizeTaskPage> {

  List<dynamic> _prizeList = [];

  String _statusText = "";
  String _endTime = "";

  int _status = 0; //状态（1:未完成 0:进行中 1:待统计 2:完成 3:暂停）-

  int _countedTimeout = 7 * 24 * 60;
  int _prizeGetTimeout = 8 * 24 * 60;

  late DateTime _countedTime;
  late DateTime _prizeGetTime;

  int isGetGift = 0;

  int isReceiveGift = 0;

  List<dynamic> pocketGiftList = [];

  @override
  void initState() {
    super.initState();
    initData();
    loadContentDatas();
  }

  void initData() async {
    await getServiceTime();
    dynamic data = await AppUtils.getPocketData();
    _countedTimeout = BaseModel.isNotEmpty(data, "countedTimeout") ? BaseModel.getInt(data, "countedTimeout") : _countedTimeout;
    _prizeGetTimeout = BaseModel.isNotEmpty(data, "prizeGetTimeout") ? BaseModel.getInt(data, "prizeGetTimeout") : _prizeGetTimeout;
    _status = BaseModel.getInt(widget.pocketMember, "status");
    //_prizeList = BaseModel.getDynamic(widget.pocketMember, "productGiftList");
    String endTime = BaseModel.getString(widget.pocketMember, "endTime");
    DateTime dateTime = DateTime.parse(endTime);
    _countedTime = dateTime.add(Duration(minutes: _countedTimeout));
    _prizeGetTime = _countedTime.add(Duration(minutes: _prizeGetTimeout));
    if (widget.pocketMember != null && !Util.isTimeout2(startTime: serviceTime, endTime: FormatUtil.formatLineYMDHMS(_countedTime))) { //统计时间
      _endTime = FormatUtil.formatLineYMDHMS(_countedTime);
      _statusText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_waiting_statistics);
    } else if (widget.pocketMember != null && Util.isTimeout2(startTime: serviceTime, endTime: FormatUtil.formatLineYMDHMS(_countedTime)) && !Util.isTimeout2(startTime: serviceTime, endTime: FormatUtil.formatLineYMDHMS(_prizeGetTime))) { //领取时间
      _endTime = FormatUtil.formatLineYMDHMS(_prizeGetTime);
      _statusText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_remaining_collection_time);
    } else if (widget.pocketMember != null && Util.isTimeout2(startTime: serviceTime, endTime: FormatUtil.formatLineYMDHMS(_prizeGetTime))) { //领取结束时间
      _statusText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_get_prize_finish);
    }
    Logger.log("---endTime: $endTime");
    Logger.log("---countedTimeout: $_countedTimeout prizeGetTimeout: $_prizeGetTimeout");
    Logger.log("---countedTimeout: ${Util.isTimeoutDate(_countedTime)}");
    Logger.log("---prizeGetTime: ${Util.isTimeoutDate(_prizeGetTime)}");
  }

  @override
  Future<void> loadContentDatas() async {
    String pocketCode = BaseModel.getString(widget.pocketMember, "pocketCode");
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_GET_POCKET_INFO, {
      "pocketCode": pocketCode,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<dynamic> dataList = BaseModel.getDynamic(rsp.data, "productGiftList");
      List<dynamic> memberGiftList = BaseModel.isNotEmpty(rsp.data, "memberGiftList") ? BaseModel.getDynamic(rsp.data, "memberGiftList") : [];
      pocketGiftList = BaseModel.isNotEmpty(rsp.data, "pocketGiftList") ? BaseModel.getDynamic(rsp.data, "pocketGiftList") : [];
      setState(() {
        _status = BaseModel.getInt(rsp.data, "status");
        isGetGift = BaseModel.getInt(rsp.data, "isGetGift");
        if(memberGiftList.isNotEmpty) {
          isReceiveGift = BaseModel.getInt(memberGiftList[0], 'status');
        }
        _prizeList = dataList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.5.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_task_prize),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  @override
  void didChangeDependencies() {
    getServiceTime();
  }

  Widget buildBody() {
    return _prizeList.isEmpty ? buildHeader() : GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(10.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 230.w,
        mainAxisSpacing: 20.w, //item上下间隔
        crossAxisSpacing: 20.w, //item左右间隔
      ),
      itemCount: _prizeList.length,
      itemBuilder: (BuildContext context, int index) {
        return buildItem(_prizeList[index]);
      },
    );
  }

  Widget buildItem(dynamic item) {
    return Container(
      decoration: BoxDecoration(
        color: IConstant.white_color,
        border: Border.all(width: 1.w, color: IConstant.line_color),
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10.w))),
            child: LoadImageView(double.infinity, 150.w, BaseModel.getString(item, "pic")),
          ),
          Container(
            constraints: BoxConstraints(
                maxWidth: 150.w
            ),
            padding: EdgeInsets.fromLTRB(12.w, 4.w, 20.w, 4.w),
            child: Text(BaseModel.getString(item, "name"),
                maxLines: 1 , overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: IConstant.text_color)),
          ),
          SizedBox(height: 4.w),
          Row(
            children: [
              SizedBox(width: 12.w),
              Text(FormatUtil.price2String(BaseModel.getDouble(item, "price")),
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, decoration: TextDecoration.lineThrough, color: IConstant.text_color)),
              expandeSpace,
              Image.asset("assets/icons/small_heart.png", width: 12.w, height: 12.w),
              SizedBox(width: 4.w),
              Text(BaseModel.getString(item, "collectionNum"),
                  style: TextStyle(fontSize: 12.sp, color: IConstant.grey_color)),
              SizedBox(width: 10.w),
            ],
          ),
          SizedBox(height: 6.w),
          Row(
            children: [
              SizedBox(width: 12.w),
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_prize_price),
                  style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
              SizedBox(width: 4.w),
              Text("?",
                  style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      elevation: 0.w,
      child: SizedBox(
        height: 90.w,
        child: Stack(
          children: [
            Positioned(left: 0.w, right: 0.w, bottom: 50.w, child: Container(
              color: IConstant.line_color,
              height: 2.w,
            )),
            Positioned(left: 0.w, right: 0.w, bottom: 0.w, child: Container(
              height: 40.w,
              margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 6.w),
              child: Row(
                children: [
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_after_receiving_check_order),
                      style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                  expandeSpace,
                  buildGetButton()
                ],
              ),
            )),
            TextUtils.isNotEmpty(_statusText) ?
            Positioned(top: 0.w, right: 16.w, child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(10.w),
                    topEnd: Radius.circular(10.w),
                    bottomStart: Radius.circular(10.w),
                  )),
              clipBehavior: Clip.antiAlias,
              elevation: 4.w,
              child: Container(
                height: 30.w,
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(10.w, 0.w, 10.w, 0.w),
                child: Row(
                  children: [
                    Text(_statusText, style: TextStyle(fontSize: 12.sp, color: IConstant.main_inactive_color)),
                    CountDownView(startTime: serviceTime, endTime: _endTime,
                        fontSize: 12.sp,
                        textColor: IConstant.main_color,
                        textAlign: TextAlign.right,
                        stop: '',  callBack: ()  {
                        Future.delayed(const Duration(milliseconds: 80)).then((e) {
                          setState(() {
                            if(_statusText == LanguageConfig.get(LanguageConfigKeys.Shop_activity_waiting_statistics)) {
                              _statusText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_remaining_collection_time);
                            }else if(_statusText == LanguageConfig.get(LanguageConfigKeys.Shop_activity_remaining_collection_time)) {
                              _statusText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_get_prize_finish);
                            }
                          });
                        });
                      },)
                  ],
                ),
              ),
            )) : Container()
          ],
        ),
      ),
    );
  }

  Widget buildGetButton() {
    //1:未完成 0:进行中 1:待统计 2:完成 3:暂停
      if (_status == 2 && _statusText != LanguageConfig.get(LanguageConfigKeys.Shop_activity_get_prize_finish)) {
        if(isReceiveGift == 1) {
          return SmallTextButton(
              bgColor: IConstant.grey_bg_color,
              textColor: IConstant.sub_text_color,
              fontSize: 12.w,
              left: 6.w,
              right: 6.w,
              text: LanguageConfig.get(LanguageConfigKeys.Shop_activity_received),
              onTap: () { });
        }else {
          return SmallTextButton(
              bgColor: IConstant.main_color,
              textColor: IConstant.white_color,
              fontSize: 12.w,
              left: 6.w,
              right: 6.w,
              text: isGetGift == 0 ? LanguageConfig.get(LanguageConfigKeys.Shop_activity_lottery_draw): LanguageConfig.get(LanguageConfigKeys.Shop_activity_get_prize),
              onTap: () {
                if(isGetGift == 0) {
                  drawTaskLottery();
                }else{
                  getGiftPrize();
                }
              });
        }
      } else { //不可用
        return SmallTextButton(
            bgColor: IConstant.grey_bg_color,
            textColor: IConstant.sub_text_color,
            fontSize: 12.w,
            left: 6.w,
            right: 6.w,
            text: isGetGift == 0 ? LanguageConfig.get(LanguageConfigKeys.Shop_activity_lottery_draw): LanguageConfig.get(LanguageConfigKeys.Shop_activity_get_prize),
            onTap: () { });
      }
  }

  void drawTaskLottery() async {
    ViewUtils.show();
    String pocketCode = BaseModel.getString(widget.pocketMember, "pocketCode");
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_FIND_GIFT_BY_POCKET_CODE, {
      "pocketCode": pocketCode
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      loadContentDatas();
      GiftModel giftModel =  GiftModel.fromJson(rsp.data, 0, true);
      showPop(0.6 * Adapt.getWindowHeight(), BuyTaskPrizePage(giftModel));
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  getGiftPrize() async{
    String pocketCode = BaseModel.getString(widget.pocketMember, "pocketCode");
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_FIND_GIFT_BY_POCKET_CODE, {
      "pocketCode": pocketCode
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      GiftModel giftModel =  GiftModel.fromJson(rsp.data, 0, true);
      List<GiftModel> selectGiftList = [];
      selectGiftList.add(giftModel);
      nextPage(OrderConfirmPage([], false, selectGiftList), false);
    }
  }

}
