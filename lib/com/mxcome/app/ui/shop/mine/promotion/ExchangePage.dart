
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/GetPrizeEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IURLConstant.dart';
import '../../../../model/BaseModel.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/AppUtils.dart';
import '../../../../utils/HttpUtils.dart';
import '../../../../utils/ViewUtils.dart';
import '../../widget/BigTextButton.dart';
import '../../widget/CartNumberView.dart';
import '../../widget/LoadImageView.dart';

class ExchangePage extends StatefulWidget {

  dynamic prize;

  ExchangePage(this.prize);

  @override
  State<StatefulWidget> createState() {
    return ExchangePageState();
  }

}

class ExchangePageState extends BaseKeepAliveState<ExchangePage> {

  dynamic _prize;

  int buyNum = 1;

  int pullNewComers = 0;

  @override
  void initState() {
    super.initState();
    _prize = widget.prize;
   loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    dynamic data = await AppUtils.getUserInfo();
    setState(() {
      pullNewComers = BaseModel.getInt(data, "pullNewComers");
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_exchange_prizes),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildBody() {
    String pic = BaseModel.getString(_prize, "pic");
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          ClipOval(child: LoadImageView(60.w, 60.w, pic.split(',')[0])),
          SizedBox(height: 10.w),
          Text(BaseModel.getString(_prize, "name"),
              style: TextStyle(fontSize: 14.sp, color: IConstant.title_color)),
          SizedBox(height: 10.w),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_value), style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
              SizedBox(width: 2.w),
              PriceText(BaseModel.getDouble(_prize, "sellPrice"), fontSize: 12.sp, color: IConstant.text_color),
              Text(" | ", style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_stock), style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
              SizedBox(width: 2.w),
              Text(getStock(), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))
            ],
          ),
          SizedBox(height: 10.w),
          Container(
            padding: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
            constraints: BoxConstraints(
              maxWidth: 220.w
            ),
            decoration: BoxDecoration(
              color: IConstant.red_bg_color3,
              borderRadius: BorderRadius.all(Radius.circular(12.w)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_direct_push_value), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                SizedBox(width: 8.w),
                Text("${BaseModel.getInt(_prize, "exchangeNewComers")}", style: TextStyle(fontSize: 12.sp, color: IConstant.main_color)),
                SizedBox(width: 8.w),
                Text(" | ", style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                SizedBox(width: 8.w),
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_enable), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                SizedBox(width: 8.w),
                Text("${getPerLimit()}", style: TextStyle(fontSize: 12.sp, color: IConstant.main_color))
              ],
            ),
          ),
          SizedBox(height: 10.w),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CartNumberView(buyNum, (number) {
                setState(() {
                  buyNum = number;
                });
              }, limitNum: -1,)
            ],
          ),
          expandeSpace,
        ],
      ),
    );
  }

  String getStock() {
    int stock = BaseModel.getInt(_prize, "stock");
    return "$stock";
  }

  int getPerLimit() {
     if (BaseModel.isEmpty(_prize, "perLimit")) {
       return 99;
     } else {
       return BaseModel.getInt(_prize, "perLimit");
     }
  }

  bool getEnable() {
    int exchangeNewComers = BaseModel.getInt(_prize, "exchangeNewComers");
    if(pullNewComers < exchangeNewComers) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> exchangeGift() async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_EXCHANGE_GIFT, {
      "giftId": BaseModel.getString(_prize, "id"),
      "num": "$buyNum"
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      EventBusUtil.getInstance().emit(GetPrizeEvent());
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_mine_exchange_successful));
      finish();
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      child: Container(
        height: 40.w,
        margin: EdgeInsets.fromLTRB(50.w, 12.w, 50.w, 20.w),
        child: BigTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_mine_confirm_exchange), enable: getEnable(), onTap: () {
          exchangeGift();
        }),
      ),
    );
  }

}
