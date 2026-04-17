
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/category/CategoryPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/HomeEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/product/RecommendTaskPage.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../IURLConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../../LanguagePage.dart';
import '../detail/ProductDetailPage.dart';
import '../detail/ReceiveTaskPage.dart';
import '../utils/EventBusUtil.dart';
import '../utils/FormatUtil.dart';
import '../widget/LoadImageView.dart';
import '../widget/PriceText.dart';

class ProductTask extends StatefulWidget {

  ProductTask();

  @override
  State<ProductTask> createState() => ProductTaskState();

}

class ProductTaskState extends BaseKeepAliveState<ProductTask> {

  String memberNum = "0";
  int currentIndex = 0;

  List<dynamic> categoryList = [];
  List<dynamic> profitProductList = [];

  List<Color> colorList = [
    const Color(0xFFFFFFFF),
    const Color(0xFFEEFBFE),
    const Color(0xFFFCF2F1),
    const Color(0xFFF5F5FD),
  ];

  dynamic homeEvent;

  @override
  void initState() {
    super.initState();
    homeEvent = EventBusUtil.getInstance().on<HomeEvent>((event) {
      if (event.homeType == HomeType.complete) {
       loadContentDatas();
      }
    });
    loadContentDatas();
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(homeEvent);
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    dynamic data = await AppUtils.getHomeData();
    setState(() {
      memberNum = BaseModel.getString(data, "memberNum");
      categoryList = BaseModel.isNotEmpty(data, "productCategoriesList") ? BaseModel.getDynamic(data, "productCategoriesList") : [];
      profitProductList = BaseModel.isNotEmpty(data, "profitProductList") ? BaseModel.getDynamic(data, "profitProductList") : [];
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildBody();
  }

  Widget buildBody() {
    return Column(
      children: [
        if (profitProductList.isNotEmpty) ...[
          buildTaskList(),
          buildMXGet(),
        ]
      ],
    );
  }

  Widget getIcon(int index, double size) {
    return Image.asset("assets/icons/category_pic$index.png", width: size, height: size);
  }

  String getId(int index){
    if (categoryList.length > index) {
      return BaseModel.getString(categoryList[index], "id");
    } else {
      return "";
    }
  }

  String getName(int index){
    if (categoryList.length > index) {
      if (LanguagePage.language == "ZH") {
        return BaseModel.getString(categoryList[index], "chName");
      } else if (LanguagePage.language == "EN") {
        return BaseModel.getString(categoryList[index], "enName");
      } else {
        return BaseModel.getString(categoryList[index], "name");
      }
    } else {
      return "";
    }
  }

  Color getBgColor(int index){
    return colorList[index];
  }

  Widget buildMXGet() {
    return Container(
        margin: EdgeInsets.only(top: 8.w),
        padding: EdgeInsets.fromLTRB(12.w, 10.w, 0.w, 5.w),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  goTaskRecommendIsLogin();
                },
                child: Row(
                  children: [
                    Image.asset("assets/icons/like.png", width: 18.w, height: 18.w),
                    SizedBox(width: 6.w),
                    Text(LanguageConfig.get(LanguageConfigKeys.Shop_product_task_recommend),
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: IConstant.title_color),
                    ),
                    Icon(Icons.chevron_right, size: 22.w),
                  ],
                ),
              ),
            ]));
  }

  Widget buildJoinMXGet() {
    String joinMXGet = LanguageConfig.get(LanguageConfigKeys.Shop_product_user_join_mxget);
    var golds = joinMXGet.split("|");
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(12.w, 10.w, 12.w, 10.w),
      decoration: BoxDecoration(
        color: IConstant.red_bg_color3,
        borderRadius: BorderRadius.horizontal(left: Radius.circular(20.w)),
      ),
      child: Row(
        children: [
          Expanded(child: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                  children: [
                    TextSpan(
                      text: golds[0],
                      style: TextStyle(fontSize: 12.sp, color: IConstant.title_color),
                    ),
                    TextSpan(
                      text: memberNum,
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.main_color),
                    ),
                    TextSpan(
                      text: golds[1],
                      style: TextStyle(fontSize: 12.sp, color: IConstant.title_color),
                    ),
                  ]
              ))),
          SizedBox(width: 6.w),
          Image.asset("assets/icons/warn.png", width: 16.w, height: 16.w)
        ],
      )
    );
  }

  Widget buildBrand() {
    return Container(
        padding: EdgeInsets.fromLTRB(12.w, 10.w, 0.w, 6.w),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("assets/icons/shop_icon.png", width: 18.w, height: 18.w, color: IConstant.main_color),
              SizedBox(width: 6.w),
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_product_shop_stroll),
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: IConstant.title_color),
              ),
              expandeSpace,
              // Expanded(flex: 5, child: buildRecommend())
            ]));
  }

  Widget buildRecommend() {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(10.w, 6.w, 10.w, 6.w),
        decoration: BoxDecoration(
          color: IConstant.red_bg_color3,
          borderRadius: BorderRadius.horizontal(left: Radius.circular(20.w)),
        ),
        child: Row(
          children: [
            Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_product_shop_stroll_tip),
                maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp, color: IConstant.title_color))),
            SizedBox(width: 4.w),
            Image.asset("assets/icons/warn.png", width: 16.w, height: 16.w)
          ],
        )
    );
  }

  Widget buildTaskList() {
    if (profitProductList.isEmpty) {
      return SizedBox(
        height: 160.w,
        child: buildHeader(),
      );
    }
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.fromLTRB(18.w, 15.w, 18.w, 15.w),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 274.w,
            mainAxisSpacing: 16.w, //item上下间隔
            crossAxisSpacing: 16.w, //item左右间隔
          ),
          itemCount: profitProductList.length,
          itemBuilder: (BuildContext context, int index) {
            return buildListItem(index);
          },
        ),
        InkWell(
          onTap: () {
            goTaskRecommendIsLogin();
          },
          child: Container(
            width: 340.w,
            padding: EdgeInsets.symmetric(vertical: 6.w),
            margin: EdgeInsets.only(bottom: 15.w),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.w, color: const Color(0x8C292929)),
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
            child: Text(
              LanguageConfig.get(LanguageConfigKeys.shop_home_load_more),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: IConstant.text_color,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildListItem(int index) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: IConstant.white_bg_color, width: 1.w),
          borderRadius: BorderRadius.all( Radius.circular(10.w)),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () => {
                nextPageState(ProductDetailPage(BaseModel.getString(profitProductList[index], "id")), false)
              },
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.vertical(top:  Radius.circular(10.w)),
                      child: LoadImageView(171.w, 171.w, BaseModel.getString(profitProductList[index], "pic"))),
                  buildProfit(index)
                ],
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.fromLTRB(10.w, 8.w, 10.w, 4.w),
              child: Text(BaseModel.getString(profitProductList[index], "name"),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
            ),
            Container(
              height: 30.w,
              padding: EdgeInsets.only(left: 6.w, right: 6.w),
              child: buildPrice(index),
            ),
            SizedBox(
              height: 28.w,
              child: buildAddButton(index),
            ),
          ],
        )
    );
  }

  Widget buildProfit(int index) {
    return Container(
      height: 24.w,
      color: IConstant.white_color.withOpacity(0.85),
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/icons/profit.png", width: 10.w, height: 10.w),
          SizedBox(width: 2.w),
          Text(getProfitText(index),
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11.sp, color: IConstant.main_color))
        ],
      ),
    );
  }

  String getProfitText(int index) {
    double minProfit = BaseModel.getDouble(profitProductList[index], "minProfit");
    double maxProfit = BaseModel.getDouble(profitProductList[index], "maxProfit");
    return FormatUtil.profitAmount(maxProfit, maxPrice: maxProfit);
  }

  Widget buildAddButton(int index){
    return InkWell(
      onTap: () {
        goMXGetIsLogin(BaseModel.getString(profitProductList[index], "id"));
      },
      child: Container(
        padding: EdgeInsets.only(left: 25.w, right: 25.w),
        decoration: BoxDecoration(
            color: IConstant.main_color,
            borderRadius: BorderRadius.all(Radius.circular(50.w))),
        child: Icon(Icons.add, size: 18.w, color: IConstant.white_color),
      ),
    );
  }

  goTaskRecommendIsLogin() async {
    bool isLogin = await AppUtils.isLogined();
    if (isLogin) {
      nextPage(RecommendTaskPage(profitProductList), false);
    } else {
      toLogin((ctx) => {
        setState(() {
          finishContext(ctx);
          nextPage(RecommendTaskPage(profitProductList), false);
        })
      });
    }
  }

  goMXGetIsLogin(String productId) async {
    bool isLogin = await AppUtils.isLogined();
    if (isLogin) {
      goMXGet(productId);
    } else {
      toLogin((ctx) => {
        setState(() {
          finishContext(ctx);
          goMXGet(productId);
        })
      });
    }
  }

  void goMXGet(String productId) async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post("${IURLConstant.MALL_PRODUCT_DETAIL}$productId", {"id": productId});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      dynamic product = rsp.data;
      rsp = await HttpUtils.post(IURLConstant.MALL_PRODUCT_POCKET_LIST, {"productId": productId});
      if (rsp.retCode == RspRetCode.SUCCESS) {
        List<dynamic> pocketList = [];
        List<dynamic> tempList = rsp.data;
        for (var item in tempList) {
          int type = BaseModel.getInt(item, "type"); //只添加普通任务
          if (type == 0) {
            pocketList.add(item);
          }
        }
        if (pocketList.isNotEmpty) {
          showPop(0.8 * Adapt.getWindowHeight(), ReceiveTaskPage(product, pocketList));
        } else {
          ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_late_task_over));
        }
      } else {
        ViewUtils.displayToast(rsp.msg);
      }
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  Widget buildPrice(int index){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        PriceText(BaseModel.getDouble(profitProductList[index], "price"), fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.title_color),
        SizedBox(width: 8.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icons/small_heart.png", width: 12.w, height: 12.w),
            SizedBox(width: 4.w),
            Text(BaseModel.getString(profitProductList[index], "collectionNum"),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.sp, color: IConstant.grey_color)),
          ],
        )
      ],
    );
  }

}
