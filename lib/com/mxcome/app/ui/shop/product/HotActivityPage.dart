
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CountDownView.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IURLConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/HttpUtils.dart';
import '../brand/BrandShopPage.dart';
import '../detail/ProductDetailPage.dart';
import '../detail/ReceiveTaskPage.dart';
import '../model/SelectTabModel.dart';
import '../utils/FormatUtil.dart';
import '../widget/ClockComponent.dart';
import '../widget/LoadImageView.dart';

class HotActivityPage extends StatefulWidget {

  HotActivityPage();

  @override
  State<StatefulWidget> createState() => HotActivityPageState();
}

class HotActivityPageState extends BaseKeepAliveState<HotActivityPage> {

  List<SelectTabModel> tabList = [];

  List<String> _activityMemberIds = [];

  @override
  void initState() {
    super.initState();
    tabList.add(SelectTabModel(1, true)); //全部
    //tabList.add(SelectTabModel(2, false)); //可接
    loadActivityMemberIds();
    loadContentDatas();
  }

  Future<void> loadActivityMemberIds() async {
    List<String> activityIds = await AppUtils.getActivityMemberIds();
    setState(() {
      _activityMemberIds = activityIds;
    });
  }

  @override
  void didChangeDependencies() {
    getServiceTime();
  }

  @override
  Future<void> loadContentDatas() async {
    isLoading = true;
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_ACTIVITY_LIST, {
      "isReceive": "0",
      "pageNum": "$page",
      "pageSize": "10"
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
    }
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_mxget_activity),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: Column(
        children: [
          buildButtons(),
        Expanded(
          child: EasyRefresh(
              header: const MaterialHeader(color: IConstant.main_color),
              footer: CupertinoFooter(emptyWidget: Container(
            padding: EdgeInsets.all(10.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_more), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
          )),
              onLoad: ()=> onLoadMore(),
              onRefresh: ()=> _onRefresh(),
              child: datas.isEmpty ? buildHeader(): ListView.builder(
                  padding: EdgeInsets.only(top: 10.w),
                  scrollDirection: Axis.vertical,
                  itemCount: datas.length,
                  itemBuilder: (context, index) {
                    return buildActivityItem(index);
                  }
              )),
        ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    isLoading = false;
    page = 1;
    count = 0;
    loadContentDatas();
  }

  Widget buildActivityItem(int index) {
    dynamic activity = datas[index];
    return Card(
      margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 16.w),
      elevation: 4.w,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(12.w),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.w)),
            child: InkWell(
              onTap: () {
                //activityStart(activity, false);
                gotoActivity(activity);
              },
              child: LoadImageView(double.infinity, 92.w, BaseModel.getString(activity, "img"), alignment: Alignment.topCenter),
            ),
          ),
          SizedBox(height: 4.w,),
          // LinearProgressIndicator(
          //   value: getTimeDouble(activity),
          //   backgroundColor: IConstant.white_color,
          //   valueColor: const AlwaysStoppedAnimation<Color>(IConstant.main_color),
          // ),
          Row(
            children: [
              Expanded(flex: 4, child: InkWell(
                onTap: () {
                  nextPage(BrandShopPage(BaseModel.getString(activity, "shopId")), false);
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipOval(child: LoadImageView(30.w, 30.w, BaseModel.getString(activity, "shopIcon"))),
                      SizedBox(width: 6.w),
                      Expanded(child: Text(BaseModel.getString(activity, "shopName"),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.title_color)))
                    ],
                  ),
                ),
              )),
              Expanded(flex: 5, child: buildStopTime(activity)),
              Expanded(flex: 4, child: Container(
                margin: EdgeInsets.fromLTRB(16.w, 6.w, 8.w, 8.w),
                child: buildRightItem(activity),
              ))
            ],
          )
        ],
      ),
    );
  }

  gotoActivity(dynamic activity) async{
    if (!await AppUtils.isLogined()) {
      toLogin((ctx) => {
        setState(() {
          finishContext(ctx);
        })
      });
    }else {
      ViewUtils.show();
      BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_ACTIVITY_MEMBER_INFO, {
        "activityId": BaseModel.getString(activity, "id")
      });
      if (rsp.retCode == RspRetCode.SUCCESS) {
        gotoPage(activity, rsp.data, false);
      } else {
        ViewUtils.dismiss();
        ViewUtils.displayToast(rsp.msg);
      }
    }
  }

  double getTimeDouble(dynamic item) {
    DateTime createTime = DateTime.parse(BaseModel.getString(item, "createTime"));
    DateTime endTime = DateTime.parse(BaseModel.getString(item, "endTime"));
    int spaceTime = endTime.millisecondsSinceEpoch - createTime.millisecondsSinceEpoch;
    int currentSpaceTime = endTime.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
    return (currentSpaceTime / spaceTime);
  }

  Widget buildRightItem(dynamic activity) {
    if (_activityMemberIds.contains(BaseModel.getString(activity, "id"))) {
      return InkWell(onTap: () {
        gotoActivity(activity);
      },
          child: Container(
            padding: EdgeInsets.fromLTRB(10.w, 6.w, 10.w, 6.w),
            decoration: BoxDecoration(
                color: IConstant.red_bg_color3,
                borderRadius: BorderRadius.circular(20.w)
            ),
            child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_participated), maxLines: 2, overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center, style: TextStyle(fontSize: 11.sp, color: IConstant.main_color)),
          ));
    } else {
      return InkWell(onTap: () {
        gotoActivity(activity);
      },
          child: Container(
            padding: EdgeInsets.fromLTRB(10.w, 6.w, 10.w, 6.w),
            decoration: BoxDecoration(
                color: IConstant.main_color,
                borderRadius: BorderRadius.circular(20.w)
            ),
            child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_join_now), maxLines: 2, overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center, style: TextStyle(fontSize: 11.sp, color: IConstant.white_color)),
          ));
    }
  }

  Widget buildStopTime(dynamic item) {
    String endTime = BaseModel.getString(item, "endTime");
    return CountDownView(startTime: serviceTime, endTime: endTime,
        fontSize: 11.w,
        textColor: IConstant.main_color,
        prefix: LanguageConfig.get(LanguageConfigKeys.Shop_pocket_remain),
        stop: LanguageConfig.get(LanguageConfigKeys.Shop_activity_closed));
  }

  Widget buildButtons() {
    return Container(
      margin: EdgeInsets.only(top: 8.w, bottom: 8.w),
      padding: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 0.w),
      child: Row(children: tabList.map((item) => buildButton(item)).toList()),
    );
  }

  Widget buildButton(SelectTabModel model) {
    return Container(
        height: 30.w,
        margin: EdgeInsets.only(right: 10.w),
        child: OutlinedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
                EdgeInsets.fromLTRB(10.w, 4.w, 10.w, 4.w)),
            backgroundColor: createTextButtonStyle(model.isSelect),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.w))),
            side: createTextButtonBorderSide(model.isSelect),
          ),
          onPressed: () {
            setState(() {
              page = 1;
              for (var item in tabList) {
                item.isSelect = false;
              }
              model.isSelect = !model.isSelect;
              datas = [];
              loadContentDatas();
            });
          },
          child: Text(getTitle(model),
              maxLines: 1,
              style: TextStyle(fontSize: 13.sp, color: model.isSelect ? IConstant.main_color : IConstant.sub_text_color)),
        ));
  }

  String getTitle(SelectTabModel model){
    if (model.type == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_order_all);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_order_received);
    }
  }

  MaterialStateProperty<BorderSide> createTextButtonBorderSide(bool isSelect) {
    return MaterialStateProperty.all(BorderSide(width: 1.w, color: isSelect ? IConstant.main_color: IConstant.line_color));
  }

  MaterialStateProperty<Color> createTextButtonStyle(bool isSelect) {
    return MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.pressed)) {
        return isSelect ? IConstant.red_bg_color: IConstant.line_color;
      } else if (states.contains(MaterialState.disabled)) {
        return isSelect ? IConstant.red_bg_color: IConstant.line_color;
      }
      return isSelect ? IConstant.red_bg_color: IConstant.line_color;
    });
  }

  MaterialStateProperty<Color> createTextButtonColor(Color color) {
    return MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.pressed)) {
        return color;
      } else if (states.contains(MaterialState.disabled)) {
        return color;
      }
      return color;
    });
  }

  Widget buildBottomItem(dynamic product){
    return Row(
      children: [
        Expanded(flex: 3, child: InkWell(
          onTap: () {
            nextPage(BrandShopPage(BaseModel.getString(product, "shopId")), false);
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(child: LoadImageView(30.w, 30.w, BaseModel.getString(product, "shopIcon"))),
                SizedBox(width: 6.w),
                Expanded(child: Text(BaseModel.getString(product, "shopName"),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.title_color)))
              ],
            ),
          ),
        )),
        Expanded(flex: 3, child: buildStopTime(product)),
        Expanded(flex: 2, child: Container(
          margin: EdgeInsets.fromLTRB(10.w, 6.w, 8.w, 8.w),
          child: buildRightItem(product),
        )),
      ],
    );
  }


  goMXGetIsLogin(String productId) async {
    bool isLogin = await AppUtils.isLogined();
    if (isLogin) {
      goMXGet(productId);
    } else {
      toLogin((ctx) => {
        setState(() {
          finishContext(ctx);
          //goMXGet(productId);
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

}
