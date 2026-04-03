
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/promotion/ExchangePage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/BigTextButton.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CountDownView.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IConstant.dart';
import '../../../../IURLConstant.dart';
import '../../../../config/LanguageConfig.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/Adapt.dart';
import '../../../../utils/AppUtils.dart';
import '../../../../utils/HttpUtils.dart';
import '../../../../utils/TextUtils.dart';
import '../../../../utils/ViewUtils.dart';
import '../../event/GetPrizeEvent.dart';
import '../../model/SelectTabModel.dart';
import '../../utils/EventBusUtil.dart';
import '../../widget/ClockComponent.dart';
import '../../widget/LoadImageView.dart';

class SelectPrizeDetailPage extends StatefulWidget {

  dynamic prize;

  SelectPrizeDetailPage(this.prize);

  @override
  State<SelectPrizeDetailPage> createState() => SelectPrizeDetailPageState();

}

class SelectPrizeDetailPageState extends BaseKeepAliveState<SelectPrizeDetailPage> {

  dynamic _prize;

  List<String> albumPics = [];

  final List<SelectTabModel> tabList = [];

  late SelectTabModel selectTabModel;

  dynamic getPrizeEvent;

  int pullNewComers = 0;

  String startTime = '';

  @override
  void initState() {
    super.initState();
    _prize = widget.prize;
    List<String> tempList =  BaseModel.getString(_prize, "pic").split(",").toList();
    for (String element in tempList) {
      if (!TextUtils.isEmpty(element)) {
        albumPics.add(element);
      }
    }
    tabList.add(SelectTabModel(1, true)); //详情
    tabList.add(SelectTabModel(2, false)); //兑换记录
    selectTabModel = tabList[0];
    getPrizeEvent = EventBusUtil.getInstance().on<GetPrizeEvent>((event) {
      reloadData();
    });
    loadContentDatas();
  }

  @override
  void didChangeDependencies() {
    getServiceTime();
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(getPrizeEvent);
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    isLoading = true;
    BaseRsp res = await HttpUtils.post(IURLConstant.MALL_GET_SERVICE_TIME, {});
    dynamic data = await AppUtils.getUserInfo();
    setState(() {
      startTime = res.data;
      pullNewComers = BaseModel.getInt(data, "pullNewComers");
    });
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_PRIZE_BUY_LIST, {
      "giftId": BaseModel.getString(_prize, "id"),
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

  Future<void> reloadData() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_EXCHANGE_GIFT_DETAIL, {
      "giftId": BaseModel.getString(_prize, "id"),
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        _prize = rsp.data;
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    rsp = await HttpUtils.post(IURLConstant.MALL_PRIZE_BUY_LIST, {
      "giftId": BaseModel.getString(_prize, "id"),
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
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: Adapt.getWindowWidth(),
                    height: Adapt.getWindowWidth(),
                    child: Swiper(
                      key: UniqueKey(),
                      itemBuilder: (BuildContext context, int index) {
                        return LoadImageView(0.w, 0.w, albumPics[index]);
                      },
                      itemCount: albumPics.length,
                      loop: albumPics.length == 1 ? false : true,
                      autoplay: true,
                      pagination: const SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                          color: IConstant.grey_bg_color,
                          activeColor: IConstant.main_color,
                        ),
                      ),
                    ),
                  ),
                  Positioned(bottom: 120.w, right: 20.w, child: Container(
                    padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
                    decoration: BoxDecoration(
                        color: IConstant.white_translucent_color,
                        borderRadius: BorderRadius.all(Radius.circular(50.w))
                    ),
                    child: PriceText(BaseModel.getDouble(_prize, "sellPrice"), fontSize: 24.sp, color: IConstant.title_color),
                  )),
                ],
              ),
              expandeSpace,
            ],
          ),
          Positioned(left: 10.w, top: 50.w, child: InkWell(
            onTap: () {
              finish();
            },
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: IConstant.black_translucent_color,
                borderRadius: BorderRadius.all(Radius.circular(40.w)),
              ),
              child: Icon(Icons.arrow_back, size: 26.w, color: IConstant.white_color),
            ),
          )),
          Positioned(left: 0.w, top: Adapt.getWindowWidth() - 80.w, bottom: 0.w, right: 0.w, child: Container(
            decoration: BoxDecoration(
                color: IConstant.white_color,
                border: Border.all(width: 1.w, color: IConstant.white_color),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.w))
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(14.w, 10.w, 14.w, 10.w),
                  child: Row(
                    children: [
                      ClipOval(child: LoadImageView(60.w, 60.w, BaseModel.getString(_prize, "exchangeLogo"))),
                      SizedBox(width: 8.w),
                      Expanded(child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: 130.w
                                ),
                                child: Text(BaseModel.getString(_prize, "name"),
                                    style: TextStyle(fontSize: 14.sp, color: IConstant.title_color)),
                              ),
                              SizedBox(width: 10.w),
                              Container(
                                padding: EdgeInsets.fromLTRB(8.w, 2.w, 8.w, 2.w),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1.w, color: IConstant.main_color),
                                    borderRadius: BorderRadius.circular(8.w)),
                                child: Text(getType(BaseModel.getInt(_prize, "type")), style: TextStyle(fontSize: 12.sp, color: IConstant.main_color)),
                              ),
                              expandeSpace,
                              Text("${ BaseModel.getInt(_prize, "sellCounts") }", style: TextStyle(fontSize: 12.sp, color: IConstant.main_color)),
                              Text(" / ", style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                              Text(getTotalStock(), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))
                            ],
                          ),
                          SizedBox(height: 8.w),
                          LinearProgressIndicator(
                            value: getTimeDouble(),
                            backgroundColor: IConstant.grey_bg_color,
                            valueColor: const AlwaysStoppedAnimation<Color>(IConstant.main_color),
                          ),
                          SizedBox(height: 8.w),
                          Row(
                            children: [
                              Text(getTypeTip(BaseModel.getInt(_prize, "type")), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                              Text(" | ", style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: 88.w
                                ),
                                child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_end_remain),
                                    style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                              ),
                              buildStopTime(),
                            ],
                          )
                        ],
                      )),
                    ],
                  ),
                ),
                Container(
                  width: Adapt.getWindowWidth(),
                  height: 1.w,
                  color: IConstant.line_color,
                ),
                buildTab(),
                Expanded(child: buildTabContent()),
              ],
            ),
          )),
        ],
      ),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildItem(dynamic item) {
    String icon = BaseModel.getString(item, "icon");
    String quantity = BaseModel.getString(item, "quantity");
    String createTime = BaseModel.getString(item, "createTime");
    return Container(
      margin: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 0.w),
      child: Row(
        children: [
          ClipOval(
              child: LoadImageView(35.w, 35.w, icon)),
          SizedBox(width: 8.w),
          Expanded(child: Text(FormatUtil.showName(getDisplayName(item)), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))),
          SizedBox(width: 10.w),
          Expanded(child: Text("×$quantity",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color))),
          Expanded(flex: 3, child: Text(FormatUtil.formatYMDHMS(DateTime.parse(createTime)), textAlign: TextAlign.right, style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color))),
        ],
      ),
    );
  }

  Widget buildStopTime() {
    String endTime = BaseModel.getString(_prize, "endTime");
    return CountDownView(startTime: serviceTime, endTime: endTime,
        fontSize: 12.w,
        textColor: IConstant.main_color,
        stop: LanguageConfig.get(LanguageConfigKeys.Shop_activity_closed));
  }

  double getTimeDouble() {
    DateTime startTime = DateTime.parse(BaseModel.getString(_prize, "startTime"));
    DateTime endTime = DateTime.parse(BaseModel.getString(_prize, "endTime"));
    int spaceTime = endTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch;
    int currentSpaceTime = endTime.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
    return (currentSpaceTime / spaceTime);
  }

  bool getEnable() {
    int exchangeNewComers = BaseModel.getInt(_prize, "exchangeNewComers");
    if(pullNewComers < exchangeNewComers) {
      return false;
    } else {
      return true;
    }
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      child: Container(
        height: 40.w,
        margin: EdgeInsets.fromLTRB(50.w, 12.w, 50.w, 20.w),
        child: BigTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_mine_exchange_prizes), enable: getEnable(), onTap: () {
          showPop(0.6 * Adapt.getWindowHeight(), ExchangePage(_prize));
        }),
      ),
    );
  }

  String getTypeTip(int type) {
    if (type == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_store_consumption);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_express_delivery);
    }
  }

  String getType(int type) {
    if (type == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_exchange_voucher);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_entity_prizes);
    }
  }

  String getTotalStock() {
    int stock = BaseModel.getInt(_prize, "stock");
    //int replenishment = BaseModel.getInt(_prize, "replenishment");
    int replenishment = 0;
    int totalStock = stock + replenishment; //总库存
    return "$totalStock";
  }

  Widget buildTab() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: tabList.map((item) => InkWell(
          onTap: () {
            setState(() {
              selectTabModel = item;
              for (var item in tabList) {
                item.isSelect = false;
              }
              item.isSelect = !item.isSelect;
            });
          },
          child: buildTabItem(item),
        )).toList());
  }

  Widget buildTabItem(SelectTabModel tabModel) {
    return Container(
      height: 40.w,
      margin: EdgeInsets.fromLTRB(5.w, 8.w, 5.w, 8.w),
      padding: EdgeInsets.fromLTRB(10.w, 0.w, 1.w, 0.w),
      child: Column(
        children: [
          Text(getTitle(tabModel), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
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

  String getTitle(SelectTabModel model){
    if (model.type == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_product_detail);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_exchange_records);
    }
  }

  Widget buildTabContent() {
    String exchangeTip = LanguageConfig.get(LanguageConfigKeys.Shop_mine_exchange_success_tip);
    var tips = exchangeTip.split("|");
    return selectTabModel.type == 1 ? SingleChildScrollView(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(30.w, 10.w, 30.w, 10.w),
        child: Html(data: BaseModel.getString(_prize, "detailDesc")),
      ),
    ) : Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(12.w, 6.w, 12.w, 6.w),
          decoration: BoxDecoration(
            color: IConstant.red_bg_color3,
            borderRadius: BorderRadius.all(Radius.circular(20.w)),
          ),
          child: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                  children: [
                    TextSpan(
                      text: tips[0],
                      style: TextStyle(fontSize: 13.sp, color: IConstant.title_color),
                    ),
                    TextSpan(
                      text: "$count",
                      style: TextStyle(fontSize: 13.sp, color: IConstant.main_color),
                    ),
                    TextSpan(
                      text: tips[1],
                      style: TextStyle(fontSize: 13.sp, color: IConstant.title_color),
                    ),
                  ]
              )),
        ),
        Expanded(child: datas.isEmpty ? buildHeader() : ListView.separated(
            padding: EdgeInsets.only(top: 10.w),
            itemBuilder: (ctx, idx) => buildItem(datas[idx]),
            itemCount: datas.length,
            separatorBuilder: (BuildContext context, int index) {
              return Container(height: 10.w);
            }))
      ],
    );
  }

  String getDisplayName(dynamic item) {
    String userName = BaseModel.getString(item, "userName");
    String generatorId = BaseModel.getString(item, "generatorId");
    return TextUtils.isNotEmpty(userName) ? userName: generatorId;
  }

}
