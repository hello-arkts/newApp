
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/LanguagePage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/AssetUpdateEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/LoadImageView.dart';
import 'package:mxcome/com/mxcome/app/ui/web3/AssetTransferPage.dart';

import '../../IURLConstant.dart';
import '../../model/BaseRsp.dart';
import '../../utils/Adapt.dart';
import '../../utils/HttpUtils.dart';
import '../../utils/ViewUtils.dart';
import '../shop/detail/ProductDetailPage.dart';
import '../shop/utils/EventBusUtil.dart';
import 'AssetOutPage.dart';
import 'HistoryPage.dart';
import 'WalletAddressListPage.dart';

class WalletManagerPage extends StatefulWidget {

  WalletManagerPage();

  @override
  State<StatefulWidget> createState() => WalletManagerPageState();

}

class WalletManagerPageState extends BaseKeepAliveState<WalletManagerPage> {

  List<dynamic> _walletList = [];
  bool _isLoading = false;

  List<dynamic> _advList = [];
  bool _advLoading = false;

  dynamic assetUpdateEvent;

  @override
  void initState() {
    super.initState();
    assetUpdateEvent = EventBusUtil.getInstance().on<AssetUpdateEvent>((event) {
      loadContentDatas();
    });
    loadAdv();
    loadContentDatas();
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(assetUpdateEvent);
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    _isLoading = true;
    BaseRsp rsp = await HttpUtils.get(IURLConstant.MALL_GET_COIN_LIST, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        _walletList = rsp.data;
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    _isLoading = false;
  }

  Future<void> loadAdv() async {
    _advLoading = true;
    BaseRsp rsp = await HttpUtils.get(IURLConstant.MALL_PRODUCT_ADVERTISING, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        _advList = rsp.data;
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    _advLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.web3_manager_bg_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        backgroundColor: IConstant.web3_manager_bg_color,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new, size: 24.w, color: Colors.white54,), onPressed: () {
          finish();
        }),
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_web3_wallet),
            style: TextStyle(fontSize: 17.sp, color: IConstant.white_color)),
        actions: [
          IconButton(icon: Image.asset("assets/icons/web3_history.png", width: 40.w, height: 40.w,), onPressed: () {
            nextPage(HistoryPage(), false);
          }),
          SizedBox(width: 10.w,),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 220.w,
            margin: EdgeInsets.all(10.w),
            child: _advLoading ? ViewUtils.buildLoading() : Swiper(
              loop: _advList.length > 1 ? true : false,
              autoplay: _advList.length > 1 ? true : false,
              autoplayDelay: 5000,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                   clickProduct(index);
                  },
                  child: LoadImageView(double.infinity, double.infinity, getPic(index), fit: BoxFit.contain),
                );
              },
              itemCount: _advList.length,
              // pagination: SwiperPagination(),
            ),
          ),
          SizedBox(
            height: 30.w,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  clickProduct(0);
                },
                child: Column(children: [
                  Image.asset("assets/icons/web3_gift.png", width: 42.w, height: 42.w,),
                  SizedBox(height: 10.w,),
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_web3_get), style: TextStyle(fontSize: 12.sp, color: IConstant.white_color)),
                ],),
              ),
              InkWell(
                onTap: () {
                  ViewUtils.showToastShort(LanguageConfig.get(LanguageConfigKeys.Base_coming_soon));
                },
                child: Column(children: [
                  Image.asset("assets/icons/web3_plus.png", width: 42.w, height: 42.w,),
                  SizedBox(height: 10.w,),
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_web3_stored_value), style: TextStyle(fontSize: 12.sp, color: IConstant.white_color)),
                ],),
              ),
              InkWell(
                onTap: () {
                  if (_walletList.isEmpty) {
                    return;
                  }
                  nextPage(AssetOutPage(_walletList), false);
                },
                child: Column(children: [
                  Image.asset("assets/icons/web3_output.png", width: 42.w, height: 42.w,),
                  SizedBox(height: 10.w,),
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_web3_transfer_out), style: TextStyle(fontSize: 12.sp, color: IConstant.white_color)),
                ],),
              ),
              InkWell(
                onTap: () {
                  if (_walletList.isEmpty) {
                    return;
                  }
                  nextPage(AssetTransferPage(_walletList), false);
                },
                child: Column(children: [
                  Image.asset("assets/icons/web3_switch.png", width: 42.w, height: 42.w,),
                  SizedBox(height: 10.w,),
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_web3_transfer), style: TextStyle(fontSize: 12.sp, color: IConstant.white_color)),
                ],),
              )
            ],
          ),
          SizedBox(
            height: 40.w,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_web3_did_assets),
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: IConstant.white_color))
              ),
              Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: Image.asset("assets/icons/web3_outline.png", width: 20.w, height: 20.w,),
              )
            ],
          ),
          SizedBox(height: 20.w,),
          Expanded(child: _isLoading ? ViewUtils.buildLoading() : ListView.separated(
              padding: EdgeInsets.only(top: 15.w, bottom: 15.w),
              scrollDirection: Axis.vertical,
              itemCount: _walletList.length,
              itemBuilder: (context, index) {
                return buildListItem(index);
              },
              separatorBuilder: (BuildContext context, int index) {
                return Container(height: 10.w);
              }))
        ],
      ),
    );
  }

  Widget buildListItem(int index) {
    dynamic walletInfo = _walletList[index];
    dynamic item = BaseModel.getDynamic(walletInfo, "coinInfo");
    List<dynamic> coinAddressList = BaseModel.getDynamic(walletInfo, "coinAddressList");
    return InkWell(
      onTap: () {
        showPop(0.9 * Adapt.getWindowHeight(), WalletAddressListPage(BaseModel.getString(item, "didName"), coinAddressList));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          border: Border.all(width: 1.w, color: Colors.white10),
          borderRadius: BorderRadius.circular(14.w),
        ),
        child: Row(
          children: [
            Padding(padding: EdgeInsets.all(10.w),
                child: LoadImageView(50.w, 50.w, BaseModel.getString(item, "didCoin"))),
            Expanded(child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${BaseModel.getString(item, "didName")}",
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: IConstant.white_color)),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            Text("${BaseModel.getString(item, "didPrice")}",
                                style: TextStyle(fontSize: 14.sp, color: IConstant.white_color)),
                            SizedBox(width: 10.w,),
                            buildRate(item)
                          ],
                        )
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("x${coinAddressList.length}",
                        style: TextStyle(fontSize: 14.sp, color: Colors.white70)),
                    Padding(padding: EdgeInsets.only(right: 10.w),
                      child: Icon(Icons.more_horiz, size: 22.w, color: Colors.white54),)
                  ],
                )
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget buildRate(dynamic item) {
    String increaseRate = BaseModel.getString(item, "increaseRate");
    if (increaseRate.startsWith("-")) {
      return Text(increaseRate,
          style: TextStyle(fontSize: 14.sp, color: IConstant.main_color));
    } else {
      return Text(increaseRate,
          style: TextStyle(fontSize: 14.sp, color: IConstant.web3_green_color));
    }
  }

  void clickProduct(int index) {
    String productId = BaseModel.getString(_advList[index], "productId");
    nextPageState(ProductDetailPage(productId, isLottery: true), false);
  }

  String getPic(int index) {
    if (LanguagePage.language == "ZH") {
      return BaseModel.getString(_advList[index], "picZh");
    } else if (LanguagePage.language == "EN") {
      return BaseModel.getString(_advList[index], "picEn");
    } else {
      return BaseModel.getString(_advList[index], "picTh");
    }
  }

}
