
import 'package:badges/badges.dart' as badges;
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/Logger.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/detail/ProductDetailPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/PocketEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/pocket/BuyRecordPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CountDownView.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:share_plus/share_plus.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../IURLConstant.dart';
import '../../../PageConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/TextUtils.dart';
import '../model/SelectTabModel.dart';
import '../utils/ClipboardUtil.dart';
import '../utils/FormatUtil.dart';
import '../utils/Util.dart';
import '../widget/ClockComponent.dart';
import '../widget/IconTextButton.dart';
import '../widget/LoadImageView.dart';
import '../widget/SmallTextButton.dart';
import 'GetPrizeActivityPage.dart';
import 'GetPrizeTaskPage.dart';

class TaskDetailPage extends StatefulWidget {

  dynamic pocketMember;

  int type;

  TaskDetailPage(this.pocketMember, {this.type = 0});

  @override
  State<TaskDetailPage> createState() => TaskDetailPageState();

}

class TaskDetailPageState extends BaseKeepAliveState<TaskDetailPage> {

  dynamic _pocketMember;

  int _buyQuantity = 0;

  int _taskStock = 0;
  
  List<dynamic> buyList = [];

  List<dynamic> pocketGiftList = [];

  List<dynamic> skuStockList = [];

  dynamic pocketEvent;

  final List<SelectTabModel> tabList = [];

  @override
  void initState() {
    super.initState();
    tabList.add(SelectTabModel(1, true)); //购买记录
    tabList.add(SelectTabModel(2, false)); //退单记录
    setState(() {
      _pocketMember = widget.pocketMember;
    });
    pocketEvent = EventBusUtil.getInstance().on<PocketEvent>((event) {
      if (event.pocketType == PocketType.complete) {
        loadContentDatas();
      }
    });
    loadContentDatas();
    loadBuyList();
    EventBusUtil.getInstance().emit(PocketEvent());
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(pocketEvent);
    super.dispose();
  }
  
  @override
  Future<void> loadContentDatas() async {
    dynamic data = await AppUtils.getPocketData();
    List pocketMemberList = BaseModel.isNotEmpty(data, "pocketMemberList") ? BaseModel.getDynamic(data, "pocketMemberList") : [];
    for (dynamic item in pocketMemberList) {
      if (BaseModel.getString(_pocketMember, "id") == BaseModel.getString(item, "id")) {
        setState(() {
          _pocketMember = item;
        });
        break;
      }
    }
    String pocketCode = BaseModel.getString(_pocketMember, "pocketCode");
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_GET_POCKET_INFO, {
      "pocketCode": pocketCode,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        _buyQuantity = BaseModel.getInt(rsp.data, "buyQuantity");
        _taskStock = BaseModel.getInt(rsp.data, "stock"); //列表taskStock，详情stock
        pocketGiftList = BaseModel.getDynamic(rsp.data, "pocketGiftList");
        skuStockList = BaseModel.getDynamic(rsp.data, "itemList");
      });
    }
  }

  Future<void> loadBuyList() async {
    String pocketCode = BaseModel.getString(_pocketMember, "pocketCode");
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_POCKET_FIND_BY_BUY, {
      "pocketCode": pocketCode
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        buyList = rsp.data;
      });
    }
  }

  Future<void> loadReturnList() async {
    String pocketCode = BaseModel.getString(_pocketMember, "pocketCode");
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_POCKET_FIND_BY_RETURN, {
      "pocketCode": pocketCode
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        buyList = rsp.data;
      });
    } else {
      setState(() {
        buyList = [];
      });
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
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_task_detail),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
        actions: [
          buildPrizeAction()
        ],
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
    dynamic product = BaseModel.getDynamic(_pocketMember, "product");
    return ListView(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            InkWell(
              onTap: () {
                nextPage(ProductDetailPage(BaseModel.getString(_pocketMember, "productId")), false);
              },
              child: SizedBox(
                  width: double.infinity,
                  height: 0.4 * Adapt.getWindowHeight(),
                  child: Container(
                      margin: EdgeInsets.fromLTRB(12.w, 0.w, 12.w, 0.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.r))
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: LoadImageView(0.w, 0.w, BaseModel.getString(product, "pic"))
                  ),
              ),
            ),
            Positioned(
              top: 10.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 6.w),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0xFFFEF5F5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x19000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/icons/task_icon1.png", width: 15.w, height: 15.w),
                    SizedBox(width: 2.w),
                    CountDownView(startTime: serviceTime, endTime: BaseModel.getString(_pocketMember, "endTime"),
                        fontSize: 12.w,
                        textColor: IConstant.main_color,
                        textAlign: TextAlign.right,
                        stop: LanguageConfig.get(LanguageConfigKeys.Shop_activity_closed)),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10.w), child: Container(width: 1.w, height: 16.w, color: Colors.black.withOpacity(0.15),),),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_task_completed),
                            style: TextStyle(
                              color: IConstant.text_color,
                              fontSize: 14.sp,
                            ),
                          ),
                          TextSpan(
                            text: ' $_buyQuantity ',
                            style: TextStyle(
                              color: IConstant.main_color,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: ' / ',
                            style: TextStyle(
                              color: IConstant.text_color.withOpacity(0.65),
                              fontSize: 14.sp,
                            ),
                          ),
                          TextSpan(
                            text: '$_taskStock',
                            style: TextStyle(
                              color: IConstant.text_color,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 6.w),
        Container(
            margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.w),
                Row(
                  children: [
                    Expanded(child: Text(BaseModel.getString(product, "name"), maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13.sp, color: IConstant.text_color))),
                    SizedBox(width: 20.w),
                    buildEnablePrize()
                  ],
                ),
                SizedBox(height: 10.w),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PriceText(BaseModel.getDouble(product, "price"), fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.title_color),
                    SizedBox(width: 2.w),
                    buildStart(),
                    SizedBox(width: 8.w),
                    Container(
                      margin: EdgeInsets.only(top: 4.w),
                      padding: EdgeInsets.fromLTRB(6.w, 0.w, 6.w, 0.w),
                      decoration: BoxDecoration(
                          color: IConstant.red_bg_color3,
                          borderRadius: BorderRadius.circular(20.w)
                      ),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/icons/profit.png", width: 10.w, height: 10.w),
                            SizedBox(width: 2.w),
                            Text(getProfitText(),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 11.sp, color: IConstant.main_color)),
                          ]
                      ),
                    )
                  ],
                ),
                SizedBox(height: 12.w),
                // LinearProgressIndicator(
                //   value: getTimeDouble(_pocketMember),
                //   backgroundColor: IConstant.grey_bg_color,
                //   valueColor: const AlwaysStoppedAnimation<Color>(IConstant.main_color),
                // ),
                // Row(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       CountDownView(startTime: serviceTime, endTime: BaseModel.getString(_pocketMember, "endTime"),
                //           fontSize: 12.w,
                //           textColor: IConstant.main_color,
                //           textAlign: TextAlign.right,
                //           prefix: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_remain),
                //           stop: LanguageConfig.get(LanguageConfigKeys.Shop_activity_closed)),
                //       expandeSpace,
                //       RichText(text: TextSpan(children: [
                //         TextSpan(text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_task_completed), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                //         WidgetSpan(child: SizedBox(width: 10.w)),
                //         TextSpan(text: "$_buyQuantity", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.main_color)),
                //         WidgetSpan(child: Container(
                //             margin: EdgeInsets.fromLTRB(10.w, 0.w, 10.w, 0.w),
                //             width: 1.w, height: 12.w, color: IConstant.line_color)),
                //         TextSpan(text: "$_taskStock", style: TextStyle(fontSize: 12.sp, color: IConstant.grey_color)),
                //       ]))
                //     ]
                // ),
              ],
            )),
        buildBuyTab(),
        buildBuyContent()
      ],
    );
  }

  Widget buildStart() {
    String startText = "";
    Set<double> skuSet = {};
    for (var item in skuStockList) {
      skuSet.add(BaseModel.getDouble(item, "price"));
    }
    if (skuSet.length > 1) {
      startText = LanguageConfig.get(LanguageConfigKeys.Shop_product_rise);
    }
    return Text(startText, style: TextStyle(fontSize: 14.sp, color: IConstant.grey_color));
  }

  Widget buildBuyTab() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: tabList.map((item) => InkWell(
          onTap: () {
            setState(() {
              for (var item in tabList) {
                item.isSelect = false;
              }
              item.isSelect = !item.isSelect;
              if (item.type == 1) {
                loadBuyList();
              } else {
                loadReturnList();
              }
            });
          },
          child: buildTab(item),
        )).toList());
  }

  Widget buildTab(SelectTabModel tabModel) {
    return Container(
      height: 40.w,
      margin: EdgeInsets.fromLTRB(5.w, 16.w, 5.w, 0.w),
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
      return LanguageConfig.get(LanguageConfigKeys.Shop_pocket_purchase_record);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_pocket_chargeback_record);
    }
  }

  Widget buildBuyContent() {
    return buyList.isEmpty ? Container() : Column(
      children: [
        SizedBox(height: 10.w),
        Container(
          margin: EdgeInsets.only(left: 16.w, right: 16.w),
          decoration: BoxDecoration(
              color: IConstant.white_bg_color,
              borderRadius: BorderRadius.all(Radius.circular(10.w))
          ),
          child: InkWell(onTap: () {
            showBuyRecord();
          } ,child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(flex: 1, child: buildImages()),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.chevron_right, size: 24.w, color: IConstant.sub_text_color),
                    )
                  ],
                )
              ],
            ),
          )),
        )
      ],
    );
  }

  void showBuyRecord() {
    showPop(0.6 * Adapt.getWindowHeight(), BuyRecordPage(getSelectModel(), buyList));
  }

  Widget buildImages() {
    List<dynamic> showItemList = buyList.length > 4 ? buyList.sublist(0, 4) : buyList;
    return Row(
      children: showItemList.map((item) => Container(
          margin: EdgeInsets.only(right: 10.w),
          child: buildImageItem(item))).toList(),
    );
  }

  String getDisplayName(dynamic item) {
    String nickName = BaseModel.getString(item, "nickName");
    String generatorId = BaseModel.getString(item, "generatorId");
    return TextUtils.isNotEmpty(nickName) ? nickName: generatorId;
  }

  Widget buildImageItem(dynamic item) {
    String icon = BaseModel.getString(item, "icon");
    String displayName = getDisplayName(item);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipOval(
          child: LoadImageView(50.w, 50.w, icon),
        ),
        SizedBox(height: 4.w),
        Container(constraints: BoxConstraints(maxWidth: 65.w), child: Text(FormatUtil.showName(displayName), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)))
      ],
    );
  }

  Widget buildPrize() {
    if (hasPrize(_pocketMember)) {
      return InkWell(
        onTap: () {
          if (enablePrize(_pocketMember)) {
            nextPage(GetPrizeTaskPage(_pocketMember), false);
          }
        },
        child: enablePrize(_pocketMember) ? Image.asset("assets/icons/task_prize_red.png", width: 14.w, height: 14.w)
            : Image.asset("assets/icons/task_prize.png", width: 22.w, height: 22.w)
      );
    } else {
      return Container();
    }
  }

  String getProfitText() {
    double minProfit = BaseModel.getDouble(_pocketMember, "minProfit");
    double maxProfit = BaseModel.getDouble(_pocketMember, "maxProfit");
    return FormatUtil.profitAmount(maxProfit, maxPrice: maxProfit);
  }

  double getTimeDouble(dynamic item){
    DateTime createTime = DateTime.parse(BaseModel.getString(item, "createTime"));
    DateTime endTime = DateTime.parse(BaseModel.getString(item, "endTime"));
    int spaceTime = endTime.millisecondsSinceEpoch - createTime.millisecondsSinceEpoch;
    int currentSpaceTime = endTime.millisecondsSinceEpoch - FormatUtil.getTHNowTime().millisecondsSinceEpoch;
    return (currentSpaceTime / spaceTime);
  }

  bool hasPrize(dynamic item) {
    List<dynamic> pocketGiftList = BaseModel.isNotEmpty(item, "pocketGiftList") ? BaseModel.getDynamic(item, "pocketGiftList") : [];
    return pocketGiftList.isNotEmpty;
  }

  bool enablePrize(dynamic item) {
    int buyQuantity = BaseModel.getInt(item, "buyQuantity");
    List<dynamic> pocketGiftList = BaseModel.isNotEmpty(item, "pocketGiftList") ? BaseModel.getDynamic(item, "pocketGiftList") : [];
    if (buyQuantity >= 10 && pocketGiftList.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> copy() async {
    String shareUrl = await Util.getShareData(_pocketMember);
    ClipboardUtil.setDataToast(shareUrl);
  }

  Future<void> shareWeb() async {
    String shareUrl = await Util.getShareData(_pocketMember);
    Share.share(shareUrl);
  }

  Widget buildBottomBar(){
    return BottomAppBar(
      height: 110.w,
      child: Container(
        padding: EdgeInsets.only(left: 12.w, right: 12.w),
        height: 60.w,
        child: Row(
          children: [
            Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_get_gold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
                SizedBox(width: 8.w),
                PriceText(BaseModel.getDouble(_pocketMember, "withdrawalBalance"), fontSize: 14.sp, color: IConstant.green_color,),
              ],
            )),
            SizedBox(width: 14.w),
            widget.type == 0 ? buildShare():Container(),
          ],
        ),
      ),
    );
  }

  Widget buildShare() {
    String endTime = BaseModel.getString(_pocketMember, "endTime");
    if (!Util.isTimeout2(startTime: serviceTime, endTime: endTime)) {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: IconTextButton(icon: Image.asset("assets/icons/share.png", width: 14.w, height: 14.w, color: IConstant.white_color),
              bgColor: IConstant.main_color,
              textColor: IConstant.white_color,
              fontSize: 13.sp,
                left: 10.w,
              right: 10.w,
              text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_recommend_now), onTap: () {
                shareWeb();
              }));
    } else {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: IconTextButton(icon: Image.asset("assets/icons/share.png", width: 14.w, height: 14.w, color: IConstant.sub_text_color),
            bgColor: IConstant.grey_bg_color,
            textColor: IConstant.sub_text_color,
            fontSize: 13.sp,
              left: 10.w,
              right: 10.w,
            text: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_recommend_now), onTap: () {})
      );
    }
  }

  SelectTabModel getSelectModel() {
    SelectTabModel tabModel = tabList[0];
    for (SelectTabModel item in tabList) {
      if (item.isSelect) {
        return tabModel = item;
      }
    }
    return tabModel;
  }

  Widget buildEnablePrize() {
    if (hasPrize(_pocketMember)) {
      return enablePrize(_pocketMember) ? Row(
        children: [
          Image.asset("assets/icons/task_prize_red.png", width: 12.w, height: 12.w),
          SizedBox(width: 2.w),
          Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_enable_prize),
              style: TextStyle(fontSize: 12.sp, color: IConstant.main_color))
        ],
      ) : Row(
        children: [
          Image.asset("assets/icons/task_prize.png", width: 24.w, height: 24.w),
          SizedBox(width: 2.w),
          Text("$_buyQuantity",
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.text_color)),
          Text(" / 10",
              style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color))
        ],
      );
    } else {
      return Container();
    }
  }

  Widget buildPrizeAction() {
    if (hasPrize(_pocketMember)) {
      return InkWell(
        onTap: () {
          if (enablePrize(_pocketMember)) {
            nextPage(GetPrizeTaskPage(_pocketMember), false);
          }
        },
        child: enablePrize(_pocketMember) ? Container(
          padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
          child: Image.asset("assets/icons/prize.png"),
        ) : Container(
          padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
          child: Image.asset("assets/icons/task_prize.png"),
        ),
      );
    } else {
      return Container();
    }

  }

  Widget buildGetPrizeAction() {
    if (pocketGiftList.isNotEmpty) {
      return InkWell(
        onTap: () {
          if ((_buyQuantity >= 10 && pocketGiftList.isNotEmpty)) {
            nextPage(GetPrizeTaskPage(_pocketMember), false);
          }
        },
        child: _buyQuantity >= 10 && pocketGiftList.isNotEmpty? Container(
          padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
          child: Image.asset("assets/icons/prize.png"),
        ) : Container(
          padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
          child: Image.asset("assets/icons/task_prize.png"),
        ),
      );
    } else {
      return Container();
    }

  }

}
