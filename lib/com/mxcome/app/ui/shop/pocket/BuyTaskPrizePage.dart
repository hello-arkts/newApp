import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';

import '../../../BaseKeepAliveState.dart';
import '../model/GiftModel.dart';
import '../order/OrderConfirmPage.dart';
import '../utils/FormatUtil.dart';
import '../widget/LoadImageView.dart';
import '../widget/SmallTextButton.dart';

class BuyTaskPrizePage extends StatefulWidget {

  GiftModel giftModel;

  BuyTaskPrizePage(this.giftModel);

  @override
  State<StatefulWidget> createState() => BuyTaskPrizePageState();
}

class BuyTaskPrizePageState extends BaseKeepAliveState<BuyTaskPrizePage> {

  late GiftModel _giftModel;
  
  @override
  void initState() {
    super.initState();
    _giftModel = widget.giftModel;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_winning_task_prize),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar()
    );
  }

  Widget buildBody() {
    return ListView(
      children: [
        SizedBox(height: 10.w),
        Container(
          alignment: Alignment.center,
          child: buildItem(),
        ),
        SizedBox(height: 40.w),
        SizedBox(
          width: 320.w,
          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_winning_task_prize_tip),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
        ),
      ],
    );
  }

  Widget buildItem() {
    return Container(
      width: 180.w,
      decoration: BoxDecoration(
        color: IConstant.white_color,
        border: Border.all(width: 1.w, color: IConstant.main_color),
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10.w))),
            child: LoadImageView(double.infinity, 150.w, _giftModel.productPic),
          ),
          Container(
            constraints: BoxConstraints(
                maxWidth: 150.w
            ),
            padding: EdgeInsets.fromLTRB(12.w, 4.w, 20.w, 4.w),
            child: Text(_giftModel.productName,
                maxLines: 1 , overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: IConstant.text_color)),
          ),
          SizedBox(height: 4.w),
          Row(
            children: [
              SizedBox(width: 12.w),
              Text(FormatUtil.price2String(_giftModel.productPrice),
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, decoration: TextDecoration.lineThrough, color: IConstant.text_color)),
              expandeSpace,
              Image.asset("assets/icons/small_heart.png", width: 12.w, height: 12.w),
              SizedBox(width: 4.w),
              Text('${_giftModel.collectionNum??''}',
                  style: TextStyle(fontSize: 12.sp, color: IConstant.grey_color)),
              SizedBox(width: 10.w),
            ],
          ),
          SizedBox(height: 4.w),
          Row(
            children: [
              SizedBox(width: 12.w),
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_prize_price),
                  style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
              SizedBox(width: 4.w),
              Text(FormatUtil.price2String(_giftModel.price),
                  style: TextStyle(fontSize: 12.sp, color: IConstant.main_color)),
            ],
          ),
          SizedBox(height: 6.w),
        ],
      ),
    );
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      elevation: 0.w,
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
        height: 50.w,
        alignment: Alignment.center,
        child: SizedBox(
          width: 180.w,
          child: SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.ViewUtils_confirm), onTap: () {
             goOrder();
          }),
        ),
      ),
    );
  }

  void goOrder() {
    List<GiftModel> selectGiftList = [];
    selectGiftList.add(_giftModel);
    nextPage(OrderConfirmPage([], false, selectGiftList), false);
  }

}
