import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/PrizeModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CountDownView.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:mxcome/com/mxcome/app/utils/AppUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:sprintf/sprintf.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IURLConstant.dart';
import '../../../Logger.dart';
import '../../../model/BaseModel.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../model/GiftModel.dart';
import '../model/PrizeTabModel.dart';
import '../model/PrizeTitleModel.dart';
import '../order/OrderConfirmPage.dart';
import '../utils/Util.dart';
import '../widget/LoadImageView.dart';
import '../widget/SmallTextButton.dart';

class GetPrizeActivityPage extends StatefulWidget {

  dynamic activityDetail;

  dynamic activityMember;

  int selectIndex = 0;

  GetPrizeActivityPage(this.activityDetail, this.activityMember, { this.selectIndex = 0 });

  @override
  State<StatefulWidget> createState() => GetPrizeActivityPageState();
}

class GetPrizeActivityPageState extends BaseKeepAliveState<GetPrizeActivityPage> {

  List<GiftModel> levelGiftSkuList = [];

  List<GiftModel> rankingGiftSkuList = [];

  List<PrizeTitleModel> _levelPrizeList = [];
  List<PrizeModel> _rankingPrizeList = [];

  int _currentIndex = 0;
  final List<PrizeTabModel> _prizeTabList = [];

  String _statusText = "";
  String _endTime = "";

  int _status = 0; //状态（0:进行中 1:待统计 2:通关 -1:未通关）

  int _countedTimeout = 7 * 24 * 60;
  int _prizeGetTimeout = 8 * 24 * 60;

  late DateTime _countedTime;
  late DateTime _prizeGetTime;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectIndex;
    _prizeTabList.add(PrizeTabModel(0, LanguageConfig.get(LanguageConfigKeys.Shop_activity_level_prize), 0 == _currentIndex));
    _prizeTabList.add(PrizeTabModel(1, LanguageConfig.get(LanguageConfigKeys.Shop_activity_top_prize), 1 == _currentIndex));
    initData();
    loadContentDatas();
  }

  @override
  void didChangeDependencies() {
    getServiceTime();
  }

  void initData() async {
    await getServiceTime();
    dynamic data = await AppUtils.getPocketData();
    _countedTimeout = BaseModel.isNotEmpty(data, "countedTimeout") ? BaseModel.getInt(data, "countedTimeout") : _countedTimeout;
    _prizeGetTimeout = BaseModel.isNotEmpty(data, "prizeGetTimeout") ? BaseModel.getInt(data, "prizeGetTimeout") : _prizeGetTimeout;
    _status = BaseModel.getInt(widget.activityMember, "status");
    String endTime = BaseModel.getString(widget.activityDetail, "endTime");
    DateTime dateTime = DateTime.parse(endTime);
    _countedTime = dateTime.add(Duration(minutes: _countedTimeout));
    _prizeGetTime = _countedTime.add(Duration(minutes: _prizeGetTimeout));
    if (widget.activityMember != null && !Util.isTimeout2(startTime: serviceTime, endTime: FormatUtil.formatLineYMDHMS(_countedTime))) { //统计时间
      _endTime = FormatUtil.formatLineYMDHMS(_countedTime);
      _statusText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_waiting_statistics);
    } else if (widget.activityMember != null && Util.isTimeout2(startTime: serviceTime, endTime: FormatUtil.formatLineYMDHMS(_countedTime)) && !Util.isTimeout2(startTime: serviceTime, endTime: FormatUtil.formatLineYMDHMS(_prizeGetTime))) { //领取时间
      _endTime = FormatUtil.formatLineYMDHMS(_prizeGetTime);
      _statusText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_remaining_collection_time);
    } else if (widget.activityMember != null && Util.isTimeout2(startTime: serviceTime, endTime: FormatUtil.formatLineYMDHMS(_countedTime))) { //领取结束时间
      _endTime = FormatUtil.formatLineYMDHMS(_prizeGetTime);
      _statusText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_get_prize_finish);
    }
    Logger.log("---endTime: $endTime");
    Logger.log("---countedTimeout: $_countedTimeout prizeGetTimeout: $_prizeGetTimeout");
    Logger.log("---countedTimeout: ${Util.isTimeoutDate(_countedTime)}");
    Logger.log("---prizeGetTime: ${Util.isTimeoutDate(_prizeGetTime)}");
  }

  @override
  Future<void> loadContentDatas() async {
    getServiceTime();
    if(_currentIndex == 0) {
      List<dynamic> levelGiftList = BaseModel.isNotEmpty(widget.activityDetail, "levelGiftList") ? BaseModel.getDynamic(widget.activityDetail, "levelGiftList") : [];
      HashMap<String, List<PrizeModel>> prizeMaps = HashMap();
      for (var item in levelGiftList) {
        PrizeModel model = PrizeModel.fromJson(item, 1, false);
        Logger.log("---level giftItemList length: ${model.giftItemList}");
        String level = sprintf(
            LanguageConfig.get(LanguageConfigKeys.Shop_activity_for_the_level),
            [model.level]);
        if (prizeMaps.containsKey(level)) {
          //存在直接添加
          List<PrizeModel>? oldList = prizeMaps[level];
          oldList?.add(model);
        } else {
          //不存在创建再添加
          List<PrizeModel> newList = [];
          newList.add(model);
          prizeMaps.putIfAbsent(level, () => newList);
        }
      }
      //封装父子关系的对象
      List<PrizeTitleModel> prizeList = [];
      prizeMaps.forEach((key, value) {
        prizeList.add(PrizeTitleModel(key, value));
      });
      prizeList.sort((a, b) => a.title.compareTo(b.title));
      setState(() {
        _levelPrizeList = prizeList;
      });
      loadRandomLevelGift();
    } else {
      List<PrizeModel> dataList = [];
      List<dynamic> giftConfigList = BaseModel.isNotEmpty(widget.activityDetail, "giftConfigList") ? BaseModel.getDynamic(widget.activityDetail, "giftConfigList") : [];
      for (var item in giftConfigList) {
        PrizeModel model = PrizeModel.fromJson(item, 2, false);
        Logger.log("---config giftItemList length: ${model.giftItemList}");
        dataList.add(model);
      }
      setState(() {
        _rankingPrizeList = dataList;
      });
      loadGiftConfigDatas();
    }
  }

  Future<void> loadRandomLevelGift() async {
    String activityId = BaseModel.getString(widget.activityDetail, "id");
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_GET_ACTIVITY_RANDOM_LEVEL_GIFT, {
      "activityId": activityId,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<GiftModel> skuList = [];
      List<dynamic> dataList = rsp.data;
      Map<int, double> tempPrizeMap = HashMap();
      for (var item in dataList) {
        GiftModel model = GiftModel.fromJson(item, 1, true);
        skuList.add(model);
        tempPrizeMap.putIfAbsent(model.skuId, () => model.price);
      }
      setState(() {
        levelGiftSkuList = skuList;
        for (PrizeTitleModel item in _levelPrizeList) {
          for (PrizeModel child in item.dataList) {
            for (int skuId in child.getSkuList()) {
              if (tempPrizeMap.containsKey(skuId)) {
                child.isSelect = true;
              }
            }
          }
        }
      });
    }
  }

  Future<void> loadGiftConfigDatas() async {
    String activityId = BaseModel.getString(widget.activityDetail, "id");
    //获取排名奖励
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_FIND_CONFIG_BY_ACTIVITY, {"activityId": activityId});
    await AppUtils.getActivity(activityId);
    if (rsp.retCode == RspRetCode.SUCCESS) {
      if (!Util.isTimeout2(startTime: serviceTime, endTime: FormatUtil.formatLineYMDHMS(_countedTime))) {
        return;
      }
      List<GiftModel> skuList = [];
      List<dynamic> dataList = rsp.data;
      Map<int, double> tempPrizeMap = HashMap();
      for (var item in dataList) {
        GiftModel model = GiftModel.fromJson(item, 2, true);
        skuList.add(model);
        tempPrizeMap.putIfAbsent(model.skuId, () => model.price);
      }
      setState(() {
        rankingGiftSkuList = skuList;
        for (PrizeModel child in _rankingPrizeList) {
          for (int skuId in child.getSkuList()) {
            if (tempPrizeMap.containsKey(skuId)) {
              child.isSelect = true;
            }
          }
        }
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
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_prize),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        buildTopTab(),
        buildBottomList()
      ],
    );
  }

  Widget buildTopTab() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _prizeTabList.map((item) => InkWell(
          onTap: () {
            setState(() {
              for (var item in _prizeTabList) {
                item.isSelect = false;
              }
              item.isSelect = true;
              _currentIndex = item.index;
              loadContentDatas();
            });
          },
          child: buildTab(item),
        )).toList());
  }

  Widget buildBottomList() {
    return _currentIndex == 0 ? Expanded(child: _levelPrizeList.isEmpty ? buildHeader() : ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _levelPrizeList.length,
        itemBuilder: (context, index) {
          return buildTitle(_levelPrizeList[index]);
        })) : Expanded(child: _rankingPrizeList.isEmpty ? buildHeader() : GridView.builder(
      shrinkWrap: true,
      //physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(10.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 230.w,
        mainAxisSpacing: 16.w, //item上下间隔
        crossAxisSpacing: 16.w, //item左右间隔
      ),
      itemCount: _rankingPrizeList.length,
      itemBuilder: (BuildContext context, int index) {
        return buildItem(_rankingPrizeList[index], index);
      },
    ));
  }

  Widget buildTab(PrizeTabModel tabModel) {
    return Container(
      height: 40.w,
      margin: EdgeInsets.fromLTRB(5.w, 16.w, 5.w, 0.w),
      padding: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 0.w),
      child: Column(
        children: [
          Text(tabModel.title, style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
          SizedBox(height: 10.w),
          Container(
            width: 80.w,
            height: 3.w,
            color: tabModel.getBgColor(),
          )
        ],
      ),
    );
  }

  Widget buildTitle(PrizeTitleModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10.w, top: 10.w),
          child: Text(model.title, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: IConstant.text_color),),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(10.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 230.w,
            mainAxisSpacing: 16.w, //item上下间隔
            crossAxisSpacing: 16.w, //item左右间隔
          ),
          itemCount: model.dataList.length,
          itemBuilder: (BuildContext context, int index) {
            return buildItem(model.dataList[index], index);
          },
        ),
      ],
    );
  }

  Widget buildItem(PrizeModel model, int index) {
    return Container(
      decoration: BoxDecoration(
        color: IConstant.white_color,
        border: Border.all(width: 1.w, color: model.isSelect ? IConstant.main_color : IConstant.line_color),
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(10.w))),
                child: LoadImageView(double.infinity, 150.w, model.productGiftPic),
              ),
              Container(
                constraints: BoxConstraints(
                    maxWidth: 150.w
                ),
                padding: EdgeInsets.fromLTRB(12.w, 4.w, 20.w, 4.w),
                child: Text(model.productGiftName,
                    maxLines: 1 , overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: IConstant.text_color)),
              ),
              SizedBox(height: 4.w),
              Row(
                children: [
                  SizedBox(width: 12.w),
                  Text(FormatUtil.price2String(model.originalPrice),
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, decoration: TextDecoration.lineThrough, color: IConstant.text_color)),
                  expandeSpace,
                  Image.asset("assets/icons/small_heart.png", width: 12.w, height: 12.w),
                  SizedBox(width: 4.w),
                  Text("${model.collectionNum}",
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
                  PriceText(model.price, fontSize: 12.sp, color: IConstant.main_color),
                ],
              ),
            ],
          ),
          buildCenter(model, index)
        ],
      ),
    );
  }

  Widget buildCenter(PrizeModel model, int index) {
    if (model.type == 1) {
      return model.isSelect ? Center(child: Container(
        padding: EdgeInsets.fromLTRB(10.w, 2.w, 10.w, 2.w),
        decoration: BoxDecoration(
          color: IConstant.main_color,
          border: Border.all(width: 1.w, color: IConstant.white_color),
          borderRadius: BorderRadius.all(Radius.circular(10.w)),
        ),
        child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_selected), style: TextStyle(fontSize: 12.sp, color: IConstant.white_color)),
      )) : Container();
    } else {
      return Center(child: Container(
        padding: EdgeInsets.fromLTRB(10.w, 2.w, 10.w, 2.w),
        decoration: BoxDecoration(
          color: model.isSelect ? IConstant.main_color: IConstant.line_color,
          border: Border.all(width: 1.w, color: model.isSelect ? IConstant.white_color : IConstant.line_color),
          borderRadius: BorderRadius.all(Radius.circular(10.w)),
        ),
        child: Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_activity_st_place), ["${ 1 + index }"]),
            style: TextStyle(fontSize: 12.sp, color: model.isSelect ? IConstant.white_color : IConstant.text_color)),
      ));
    }
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
                  buildGetButton(),
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
                        stop: '')
                  ],
                ),
              ),
            )) : Container()
          ],
        ),
      ),
    );
  }

  Widget buildTotal() {
    double total = 0;
    if (_currentIndex == 0) {
      for (var item in levelGiftSkuList){
        total += item.price;
      }
    } else {
      for (var item in rankingGiftSkuList){
        total += item.price;
      }
    }
    return PriceText(total, fontSize: 15.sp);
  }

  Widget buildGetButton() {
    int count = levelGiftSkuList.length;
    if (_currentIndex == 0) {
      count = levelGiftSkuList.length;
    } else {
      count = rankingGiftSkuList.length;
    }
    String btnText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_get);
    if (widget.activityMember == null) {
      if (_currentIndex == 0) {
        btnText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_no_lottery);
      } else {
        btnText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_not_counted);
      }
    }
    if (count > 0 && Util.isTimeout2(startTime: serviceTime, endTime: FormatUtil.formatLineYMDHMS(_countedTime)) && !Util.isTimeout2(startTime: serviceTime, endTime: FormatUtil.formatLineYMDHMS(_prizeGetTime))) {
      GiftModel model;
      if (_currentIndex == 0) {
        model = levelGiftSkuList[0];
      } else {
        model = rankingGiftSkuList[0];
      }
      if (model.prizeEnable()) {
        return SmallTextButton(
            bgColor: IConstant.main_color,
            textColor: IConstant.white_color,
            fontSize: 12.w,
            left: 6.w,
            right: 6.w,
            text: btnText,
            onTap: () {
              goOrder();
            });
      } else {
        return SmallTextButton(
            bgColor: IConstant.grey_bg_color,
            textColor: IConstant.sub_text_color,
            fontSize: 12.w,
            left: 6.w,
            right: 6.w,
            text: model.getStatusText(),
            onTap: () {});
      }
    } else {
      int status = 0;
      if (_currentIndex == 0) {
        if(levelGiftSkuList.isNotEmpty) {
          status =  levelGiftSkuList[0].status;
        }
      } else {
        if(rankingGiftSkuList.isNotEmpty) {
          status =  rankingGiftSkuList[0].status;
        }
      }
      return SmallTextButton(
          bgColor: IConstant.grey_bg_color,
          textColor: IConstant.sub_text_color,
          fontSize: 12.w,
          left: 6.w,
          right: 6.w,
          text: getStatusText(status),
          onTap: () {
      });
    }
  }

  String getStatusText(int status) {
    if (status == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_activity_received);
    } else if (status == -1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_activity_expired);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_activity_get);
    }
  }

  void goOrder() {
    List<GiftModel> selectGiftList = [];
    if (_currentIndex == 0) {
      selectGiftList.addAll(levelGiftSkuList);
    } else {
      selectGiftList.addAll(rankingGiftSkuList);
    }
    if (selectGiftList.isEmpty) {
      ViewUtils.displayToast(LanguageConfig.get(
          LanguageConfigKeys.Shop_activity_please_select_prize));
      return;
    }
    orderConfirm();
  }

  void orderConfirm() {
    List<GiftModel> selectGiftList = [];
    if (_currentIndex == 0) {
      selectGiftList.addAll(levelGiftSkuList);
    } else {
      selectGiftList.addAll(rankingGiftSkuList);
    }
    nextPage(OrderConfirmPage([], false, selectGiftList), false);
  }

}
