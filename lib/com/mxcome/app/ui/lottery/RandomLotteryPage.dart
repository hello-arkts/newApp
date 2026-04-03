
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/lottery/MyDrawProductPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/LotteryEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/LoadImageView.dart';
import 'package:sprintf/sprintf.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';

import '../../BaseKeepAliveState.dart';
import '../../IConstant.dart';
import '../../IURLConstant.dart';
import '../../config/LanguageConfig.dart';
import '../../model/BaseRsp.dart';
import '../../utils/Adapt.dart';
import '../../utils/AppUtils.dart';
import '../../utils/HttpUtils.dart';
import '../../utils/ViewUtils.dart';
import '../../widget/MarqueeText.dart';
import '../../widget/SimpleLotteryWidget.dart';
import '../shop/detail/ProductDetailPage.dart';
import '../shop/model/CartItem.dart';
import '../shop/order/OrderConfirmPage.dart';
import '../shop/utils/EventBusUtil.dart';
import '../shop/widget/PriceText.dart';
import '../web3/WalletCreatePage.dart';
import 'ProductLotteryDetailPage.dart';

class RandomLotteryPage extends StatefulWidget {

  RandomLotteryPage();

  @override
  State<RandomLotteryPage> createState() => RandomLotteryPageState();

}

class RandomLotteryPageState extends BaseKeepAliveState<RandomLotteryPage> {

  int _drawCount = 0;

  List<dynamic> _dataList = [];

  String _showText = "";

  final SimpleLotteryController _simpleLotteryController = SimpleLotteryController();

  dynamic lotteryEvent;

  int _currentIndex = 0;

  late AudioPlayer player = AudioPlayer();

  @override
  void initState() {
   super.initState();
   lotteryEvent = EventBusUtil.getInstance().on<LotteryEvent>((event) {
     if (event.index == -1) {
       showDrawDialog();
     } else  {
       showPop(0.9 * Adapt.getWindowHeight(), ProductLotteryDetailPage(event.index, _dataList[event.index]));
     }
   });
   loadContentDatas();
   loadProductList();
   newDrawProductList();
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(lotteryEvent);
    super.dispose();
    player.release();
  }

  @override
  Future<void> loadContentDatas() async {
    ViewUtils.show();
    dynamic data = await AppUtils.getUserInfo();
    setState(() {
      _drawCount = BaseModel.getInt(data, "drawCount");
    });
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_SSO_INFO, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      await AppUtils.setUserInfo(rsp.data);
      setState(() {
        _drawCount = BaseModel.getInt(rsp.data, "drawCount");
      });
    }
  }

  Future<void> loadProductList() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_DRAW_PRODUCT_LIST, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        _dataList = rsp.data;
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  Future<void> newDrawProductList() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_NEW_DRAW_PRODUCT_LIST, {
      "pageNum": "$page",
      "pageSize": "3",
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<dynamic> newDrawList = rsp.data;
      for (dynamic item in newDrawList) {
        dynamic userInfo = BaseModel.getDynamic(item, "userInfo");
        dynamic productInfo = BaseModel.getDynamic(item, "productInfo");
        dynamic nickname = BaseModel.getString(userInfo, "nickname");
        String productName = BaseModel.getString(productInfo, "name");
        String price = BaseModel.getString(productInfo, "price");
        _showText = "$_showText ${sprintf(LanguageConfig.get(LanguageConfigKeys.shop_web3_winning_draws_hint), [nickname, productName, "${IConstant.currency}$price"]) }";
      }
      setState(() {
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.black_color,
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          elevation: 0.w,
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, size: 22.w, color: Colors.white70,),
              onPressed: () {
                finish();
              }),
          title: Text(LanguageConfig.get(LanguageConfigKeys.shop_web3_luck_draw),
              style: TextStyle(fontSize: 17.sp, color: IConstant.white_color)),
          pinned: true,
          //固定标题栏
          expandedHeight: 230.w - statusBarHeight,
          //显示的高度
          flexibleSpace: FlexibleSpaceBar(
            background:  Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: Image.asset(
                        "assets/icons/lottery_adv.png",
                      ).image)
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: TextUtil.isEmpty(_showText) ? Container() : Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
            color: IConstant.main_inactive_color,
            child: MarqueeText(text: _showText, style: TextStyle(fontSize: 16.sp, color: IConstant.white_color), scrollSpeed: 20),
          ),
        ),
        SliverToBoxAdapter(child: Container(
          decoration: BoxDecoration(
            color: IConstant.main_inactive_color,
            borderRadius: BorderRadius.all(Radius.circular(20.w)),
          ),
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.w),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 18.w, bottom: 10.w),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.w),
                decoration: BoxDecoration(
                  color: IConstant.black_color,
                  border: Border.all(color: IConstant.white_color, width: 1.w),
                  borderRadius: BorderRadius.all(Radius.circular(20.w)),
                ),
                child: StyledText(
                  text: sprintf(LanguageConfig.get(LanguageConfigKeys.shop_web3_chance_lucky_draw), [ "<red> $_drawCount </red>"]),
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: IConstant.white_color),
                  tags: {
                    'red': StyledTextTag(style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: IConstant.main_color)),
                  },
                ),
              ),
              Center(
                child: SimpleLotteryWidget(
                  commodityList: _dataList,
                  simpleLotteryController: _simpleLotteryController,
                ),
              ),
              Row(
                children: [
                  SizedBox(width: 20.w,),
                  InkWell(
                    onTap: () {
                      nextPage(MyDrawProductPage(), false);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: IConstant.black_color,
                        border: Border.all(color: IConstant.main_color, width: 1.w),
                        borderRadius: BorderRadius.all(Radius.circular(40.w)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
                      width: 120.w,
                      child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_my_prize), textAlign: TextAlign.center,
                          style: TextStyle(color: IConstant.white_color, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  expandeSpace,
                  InkWell(
                    onTap: () {
                      if (_drawCount <= 0) {
                        getDrawCount();
                      } else {
                        if (!_simpleLotteryController.value.isPlaying) {
                          randomDraw();
                        }
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40.w)),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xffFF3957),
                            Color(0xffFF3957),
                            Color(0xffFFCC16),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: IConstant.black_color,
                            blurRadius: 1,
                            offset: Offset(0, 6),
                            spreadRadius: 0,
                          ) ,
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
                      width: 160.w,
                      child: Text(_drawCount <= 0 ? LanguageConfig.get(LanguageConfigKeys.Shop_web3_get) : LanguageConfig.get(LanguageConfigKeys.shop_web3_start_lottery), textAlign: TextAlign.center,
                          style: TextStyle(color: IConstant.white_color, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(width: 20.w,),
                ],
              ),
              SizedBox(height: 20.w,),
            ],
          ),
        ),)
      ],
    );
  }

  Future<void> randomDraw() async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_RANDOM_DRAW, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      int index = rsp.data ?? 8;
      _simpleLotteryController.start(index);
      playAudio();
      drawProduct(index);
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  Future<void> drawProduct(int index) async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_DRAW_PRODUCT, {
      "productId": "${BaseModel.getString(_dataList[index], "id")}"
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        _drawCount = _drawCount - 1;
        _currentIndex = index;
      });
      loadProductList();
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  void showDrawDialog() {
    dynamic product = _dataList[_currentIndex];
    showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.9),
        builder: (BuildContext ctx) {
          return Dialog(
              elevation: 0.w,
              insetPadding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 0),
              child: Container(
                width: 352.w,
                height: 508.w,
                decoration: BoxDecoration(
                  color: IConstant.main_inactive_color,
                  borderRadius: BorderRadius.all(Radius.circular(20.w)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 324.w,
                      height: 360.w,
                      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.w),
                      decoration: BoxDecoration(
                        color: IConstant.white_color,
                        borderRadius: BorderRadius.all(Radius.circular(20.w)),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 16.w,),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 16.w), child:  Text(LanguageConfig.get(LanguageConfigKeys.shop_web3_winning_following_prizes),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color, fontWeight: FontWeight.bold),),),
                          SizedBox(height: 16.w,),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.w),
                            child: LoadImageView(200.w, 200.w, BaseModel.getString(product, "pic")),
                          ),
                          SizedBox(height: 16.w,),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(BaseModel.getString(product, "name"), maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 17.sp, color: IConstant.text_color, fontWeight: FontWeight.bold),),),
                          SizedBox(height: 10.w,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${LanguageConfig.get(LanguageConfigKeys.Shop_mine_value)} ", style: TextStyle(fontSize: 17.sp, color: IConstant.main_color, fontWeight: FontWeight.bold),),
                              PriceText(BaseModel.getDouble(product, "price"),
                                  fontSize: 17.sp, fontWeight: FontWeight.bold, color: IConstant.main_color),
                            ],
                          ),
                          SizedBox(height: 16.w,),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.w,),
                    Row(
                      children: [
                        SizedBox(width: 16.w,),
                        InkWell(
                          onTap: () {
                            showPop(0.9 * Adapt.getWindowHeight(), ProductLotteryDetailPage(_currentIndex, product));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: IConstant.black_color,
                              border: Border.all(color: IConstant.main_color, width: 1.w),
                              borderRadius: BorderRadius.all(Radius.circular(40.w)),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
                            width: 130.w,
                            child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_view_prize), textAlign: TextAlign.center,
                                style: TextStyle(color: IConstant.white_color, fontSize: 15.sp, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        expandeSpace,
                        InkWell(
                          onTap: () {
                            buy(product);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(40.w)),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xffFF3957),
                                  Color(0xffFF3957),
                                  Color(0xffFFCC16),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: IConstant.black_color,
                                  blurRadius: 1,
                                  offset: Offset(0, 6),
                                  spreadRadius: 0,
                                ) ,
                              ],
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
                            width: 160.w,
                            child: Text(LanguageConfig.get(LanguageConfigKeys.shop_web3_claim_prizes), textAlign: TextAlign.center,
                                style: TextStyle(color: IConstant.white_color, fontSize: 15.sp, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SizedBox(width: 16.w,),
                      ],
                    ),
                  ],
                ),
              ),);
        });
  }

  Future<void> buy(dynamic product) async {
    String productId = BaseModel.getString(product, "id");
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post("${IURLConstant.MALL_DRAW_PRODUCT_DETAIL}$productId", {"id": productId});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<dynamic> skuStockList = BaseModel.getDynamic(rsp.data, "skuStockList");
      if (skuStockList.isNotEmpty) {
        List<CartItem> selectCartList = [];
        CartItem cartItem =  CartItem.toCartItemNoPrice(product, skuStockList[0]);
        selectCartList.add(cartItem);
        nextPage(OrderConfirmPage(selectCartList, false, [], productId: productId), false);
      }
    } else {
      nextPageState(ProductDetailPage(productId), false);
    }
    ViewUtils.dismiss();
  }

  void getDrawCount() async {
    dynamic userInfo = await AppUtils.getUserInfo();
    if (BaseModel.isEmpty(userInfo, "email")) {
      showPop(0.5 * Adapt.getWindowHeight(), WalletCreatePage(), topColor: IConstant.web3_create_bg_color);
    } else {
      ViewUtils.show();
      BaseRsp rsp = await HttpUtils.get(IURLConstant.MALL_PRODUCT_ADVERTISING, {});
      if (rsp.retCode == RspRetCode.SUCCESS) {
        List<dynamic> advList = rsp.data;
        if (advList.isNotEmpty) {
          String productId = BaseModel.getString(advList[0], "productId");
          nextPageState(ProductDetailPage(productId, isLottery: true), false);
        } else {
          ViewUtils.showToastShort(LanguageConfig.get(LanguageConfigKeys.Shop_web3_not_config_adv));
        }
      } else {
        ViewUtils.displayToast(rsp.msg);
      }
      ViewUtils.dismiss();
    }
  }

  Future<void> playAudio() async {
    await player.play(AssetSource('audio/lottery.mp3'));
  }

}
