import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/IURLConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/model/BaseRsp.dart';
import 'package:mxcome/com/mxcome/app/ui/LanguagePage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/detail/ProductDetailPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/LoadImageView.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:mxcome/com/mxcome/app/utils/Adapt.dart';
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';

import 'package:url_launcher/url_launcher.dart';

class MonthlyBenefitsPage extends StatefulWidget {

  MonthlyBenefitsPage();

  @override
  State<StatefulWidget> createState() {
    return MonthlyBenefitsPageState();
  }
}

class MonthlyBenefitsPageState extends BaseKeepAliveState<MonthlyBenefitsPage> {

  List<dynamic> pocketList = [];

  String totalRedAmount = "";

  @override
  void initState() {
    super.initState();
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    isLoading = true;
    BaseRsp res = await HttpUtils.post(IURLConstant.MALL_KOL_GET_RED_AMOUNT, {});
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_KOL_GET_NUMSAI_KOL, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<dynamic> tempList = BaseModel.isNotEmpty(rsp.data, "pocketMemberProductList") ? BaseModel.getDynamic(rsp.data, "pocketMemberProductList") : [];
      setState(() {
        totalRedAmount = res.data;
        pocketList = tempList;
      });
    }
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: buildBody(),
    );
  }

  Widget buildBody() {
    String monthlyBenefitsTip2 = LanguageConfig.get(LanguageConfigKeys.shop_home_monthly_benefits_tip_2);
    var tip2 = monthlyBenefitsTip2.split("|");
    return Stack(
      children: [
        SizedBox(
          width: Adapt.getWindowWidth(),
          height: Adapt.getWindowHeight() * 0.44,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(child: Image.asset("assets/icons/bg_monthly_benefits_head.png", fit: BoxFit.cover),),
              Positioned(bottom: 18.w, child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 12.w),
                decoration: ShapeDecoration(
                  color: Colors.white.withOpacity(0.88),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                ),
                child: Column(
                  children: [
                    Text(LanguageConfig.get(LanguageConfigKeys.shop_home_monthly_benefits_tip_1), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color),),
                    SizedBox(height: 6.w,),
                    LanguagePage.language == LanguageType.TH ? Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: tip2[0],
                            style: TextStyle(
                              color: IConstant.text_color,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              height: 1.12,
                            ),
                          ),
                          TextSpan(
                            text: ' ${totalRedAmount}THB ',
                            style: TextStyle(
                              color: IConstant.main_color,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              height: 1.12,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ) : Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: tip2[0],
                            style: TextStyle(
                              color: IConstant.text_color,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              height: 1.12,
                            ),
                          ),
                          TextSpan(
                            text: ' ${totalRedAmount}THB ',
                            style: TextStyle(
                              color: IConstant.main_color,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              height: 1.12,
                            ),
                          ),
                          TextSpan(
                            text: tip2[1],
                            style: TextStyle(
                              color: IConstant.text_color,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              height: 1.12,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
        buildDraggableScrollableSheet(),
        Positioned(top: 60.w, child: InkWell(
          onTap: () {
            finish();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Icon(Icons.arrow_back_ios, size: 26.w, color: Colors.white,),
          ),
        )),
        Positioned(bottom: 40.w, right: 20.w, child: InkWell(
          onTap: () {
            openLineChat();
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(10.w, 6.w, 10.w, 6.w),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1E000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
              color: IConstant.white_color,
              borderRadius: BorderRadius.circular((20.w)),
            ),
            child: Row(
              children: [
                SizedBox(width: 10.w,),
                Image.asset("assets/icons/line_chat.png", width: 25.w, fit: BoxFit.cover),
                SizedBox(width: 10.w,),
                Text("Q&A", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: IConstant.title_color),),
                SizedBox(width: 10.w,),
              ],
            ),
          ),
        ),)
      ],
    );
  }

  Widget taskList(ScrollController scrollController) {
    return pocketList.isEmpty ? buildHeader() : GridView.builder(
      padding: EdgeInsets.all(16.w),
      controller: scrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 270.w,
        mainAxisSpacing: 16.w, //item上下间隔
        crossAxisSpacing: 16.w, //item左右间隔
      ),
      itemCount: pocketList.length,
      itemBuilder: (BuildContext context, int index) {
        return buildListItem(index);
      },
    );
  }

  Widget buildListItem(index) {
    dynamic product = pocketList[index];
    return InkWell(
      onTap: () {
        nextPageState(ProductDetailPage(BaseModel.getString(product, "id")), false);
      },
      child: Container(
        decoration: BoxDecoration(
            color: IConstant.white_color,
            border: Border.all(width: 1.w, color: IConstant.line_color),
            borderRadius: BorderRadius.all(Radius.circular(12.w))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10.w, 4.w, 10.w, 4.w),
              decoration: BoxDecoration(
                  color: IConstant.line_color,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12.w))
              ),
              child: Row(
                children: [
                  ClipOval(child: LoadImageView(22.w, 22.w, BaseModel.getString(product, "shopIcon"))),
                  SizedBox(width: 6.w),
                  Expanded(child: Text(BaseModel.getString(product, "shopName"), maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),)
                ],
              ),
            ),
            Stack(
              children: [
                LoadImageView(171.w, 171.w, BaseModel.getString(product, "pic")),
                Positioned(left: 0.w, right: 0.w, bottom: 0.w, child: buildProfit(product))
              ],
            ),
            Row(
              children: [
                SizedBox(width: 10.w,),
                BaseModel.getInt(product, "isFreePackage") == 1 ? Image.asset("icons/free.png", width: 20.w) : Container(),
                SizedBox(width: 2.w,),
                expandeSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("icons/small_heart.png", width: 12.w, height: 12.w),
                    SizedBox(width: 4.w),
                    Text(BaseModel.getString(product, "collectionNum"),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.sp, color: IConstant.grey_color)),
                  ],
                ),
                SizedBox(width: 10.w,),
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10.w, 3.w, 10.w, 3.w),
              child: Text(BaseModel.getString(product, "name"),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10.w, 3.w, 10.w, 3.w),
              child: PriceText(BaseModel.getDouble(product, "price"), fontSize: 12.sp,
                  fontWeight: FontWeight.bold, color: IConstant.title_color),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfit(dynamic product) {
    return Container(
      width: 160.w,
      color: IConstant.white_translucent_color3,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("icons/profit.png", width: 10.w, height: 10.w),
          SizedBox(width: 2.w),
          Text(getProfitText(product),
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11.sp, color: IConstant.main_color))
        ],
      ),
    );
  }

  String getProfitText(dynamic product) {
    double minProfit = BaseModel.getDouble(product, "minProfit");
    double maxProfit = BaseModel.getDouble(product, "maxProfit");
    return FormatUtil.profitAmount(maxProfit, maxPrice: maxProfit);
  }

  Widget buildDraggableScrollableSheet() {
    return DraggableScrollableActuator(child: Builder(
      builder: (ctx) {
        return DraggableScrollableSheet(
          //初始化占用父容器高度
          initialChildSize: 0.57,
          //占用父组件的最小高度
          minChildSize: 0.57,
          //占用父组件的最大高度
          maxChildSize: 1,
          //是否应扩展以填充其父级中的可用空间默认true 父组件是Center时设置为false，才会实现center布局，但滚动效果是向两边展开
          expand: true,
          //true：触发滚动则滚动到maxChildSize或者minChildSize，不在跟随手势滚动距离 false:滚动跟随手势滚动距离
          snap: true,
          builder: (BuildContext context, ScrollController scrollController)
          {
            return buildProductList(scrollController, ctx);
          },
        );
      },
    ));
  }

  Widget buildProductList(scrollController, ctx) {
    return Container(
      decoration: BoxDecoration(
          color: IConstant.white_color,
          border: Border.all(width: 1.w, color: IConstant.line_color),
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.w))
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 4.w),
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
                color: IConstant.white_color,
                border: Border.all(width: 1.w, color: IConstant.line_color2),
                borderRadius: BorderRadius.all(Radius.circular(12.w))
            ),
            child: Row(
              children: [
                Image.asset("assets/icons/ic_mx_logo.png", width: 30.w,),
                SizedBox(width: 6.w,),
                Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.shop_home_monthly_benefits_tip),
                  maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13.sp, color: IConstant.text_color),))
              ],
            ),
          ),
          Expanded(child: taskList(scrollController))
        ],
      ),
    );
  }

  Widget buildSelectText(String text, Color textColor, String selectText, Color selectColor) {
    var tempList = text.split("|");
    return RichText(
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
        text: TextSpan(
            children: [
              TextSpan(
                text: tempList[0],
                style: TextStyle(height: 1.5, fontSize: getFontSize(), color: textColor),
              ),
              TextSpan(
                text: selectText,
                style: TextStyle(height: 1.5, fontSize: getFontSize() + 2.sp, fontWeight: FontWeight.bold, color: selectColor),
              ),
              TextSpan(
                text: tempList[1],
                style: TextStyle(height: 1.5, fontSize: getFontSize(), color: textColor),
              ),
            ]
        ));
  }

  double getFontSize() {
    double fontSize = 11.sp;
    switch (LanguagePage.language) {
      case "ZH":
        fontSize = 12.sp;
        break;
    }
    return fontSize;
  }

  void openLineChat() async{
    String url = "https://liff.line.me/1645278921-kWRPP32q/?accountId=mxcome";
    String downloadUrl;
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      downloadUrl = "https://apps.apple.com/us/app/line/id443904275";
    } else if (Theme.of(context).platform == TargetPlatform.android) {
      downloadUrl = "https://play.google.com/store/apps/details?id=jp.naver.line.android&hl=en_US";
    } else {
      ViewUtils.displayToast("Only Android and ios are supported");
      return;
    }
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)){
      await launchUrl(uri, mode:LaunchMode.externalApplication);
    } else {
    throw 'Could not launch $url';
    }
  }

}
