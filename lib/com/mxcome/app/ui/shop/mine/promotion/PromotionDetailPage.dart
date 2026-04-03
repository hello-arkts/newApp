import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/RedModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/RedTitleModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/LoadImageView.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:mxcome/com/mxcome/app/utils/AppUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IURLConstant.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/HttpUtils.dart';
import '../../model/SelectTabModel.dart';

class PromotionDetailPage extends StatefulWidget {

  String redActivityId = '';
  int oneLevelExtendNum = 0;
  int twoLevelExtendNum = 0;
  int threeLevelExtendNum = 0;

  PromotionDetailPage(this.redActivityId, this.oneLevelExtendNum, this.twoLevelExtendNum, this.threeLevelExtendNum);

  @override
  State<StatefulWidget> createState() {
    return PromotionDetailPageState();
  }

}

class PromotionDetailPageState extends BaseKeepAliveState<PromotionDetailPage> {

  List<RedTitleModel> redTitleList = [];

  int currentLevel = 1;

  int _redCount = 0;

  double _redAmount = 0;

  dynamic userInfo;

  final List<SelectTabModel> tabList = [];

  @override
  void initState() {
    super.initState();
    tabList.add(SelectTabModel(1, true)); //我的直推
    tabList.add(SelectTabModel(2, false)); //二级推荐
    tabList.add(SelectTabModel(3, false)); //三级推荐
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    dynamic data = await AppUtils.getUserInfo();
    setState(() {
      userInfo = data;
    });
    isLoading = true;
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_RED_RECORD_LIST, {
      "redActivityId": widget.redActivityId,
      "level": getSelectType(),
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      int redCount = 0;
      double redAmount = 0;
      List<RedTitleModel> dataList = [];
      for (var title in rsp.data) {
        List<dynamic> redRecordList = BaseModel.getDynamicList(title, "memberRedRecordList");
        int memberNum = BaseModel.getInt(title, "memberNum");
        String redGrantTime = BaseModel.getString(title, "redGrantTime");
        RedTitleModel titleModel = RedTitleModel(0, 0, "", [], memberNum, redGrantTime);
        for (var item in redRecordList) {
          RedModel redModel = RedModel.fromJson(item);
          titleModel.status = redModel.status;
          titleModel.totalAmount = titleModel.totalAmount + redModel.amount;
          titleModel.pocketEndTime = redModel.pocketEndTime;
          titleModel.redList.add(redModel);
        }
        if (titleModel.status != 1) {
          redAmount += titleModel.totalAmount;
          redCount++;
        }
        dataList.add(titleModel);
      }
      setState(() {
        _redCount = redCount;
        _redAmount = redAmount;
        redTitleList = dataList;
      });
    }else {
      ViewUtils.displayToast(rsp.msg);
      setState(() {
        isLoading = false;
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
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_promotion_details),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        buildButtons(),
        Expanded(child: redTitleList.isEmpty ? buildHeader() : ListView.separated(
          padding: EdgeInsets.only(top: 10.w),
          scrollDirection: Axis.vertical,
          itemCount: redTitleList.length,
          itemBuilder: (context, index) {
            return buildPromotionItem(index);
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 16.w,
            );
          },
        ))
      ],
    );
  }

  Widget buildPromotionItem(int index) {
    RedTitleModel titleModel = redTitleList[index];
    return Card(
      margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 0.w),
      elevation: 4.w,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(12.w),
      ),
      child: Column(
        children: [
          SizedBox(height: 16.w),
          Row(
            children: [
              SizedBox(width: 16.w),
              Expanded(child: Wrap(
                spacing: 10.w,
                runSpacing: 10.w,
                children: buildRedList(titleModel),
              ),),
              SizedBox(width: 16.w),
              SizedBox(width: 70.w, child: Row(
                children: [
                  Text("=", style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
                  SizedBox(width: 10.w),
                  titleModel.status != 1 ? PriceText(titleModel.totalAmount, fontSize: 14.sp, color: IConstant.main_color)
                      : Text("?", style: TextStyle(fontSize: 17.sp, color: IConstant.main_color)),
                ],
              )),
              SizedBox(width: 16.w),
            ],
          ),
          SizedBox(height: 16.w),
          Row(
            children: [
              SizedBox(width: 16.w),
              Image.asset("assets/icons/red_wallet.png", height: 26.w),
              SizedBox(width: 4.w),
              Text(getStatus(titleModel), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
              SizedBox(width: 10.w), titleModel.status != 1 ? Text(titleModel.redGrantTime,
                  style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)) : Container(),
              SizedBox(width: 10.w),
            ],
          ),
          SizedBox(height: 16.w),
        ],
      ),
    );
  }

  List<Widget> buildRedList(RedTitleModel model) {
    List<Widget> rowList = [];
    if (model.status == 1) { //进行中
      int memberNum = model.memberNum;
      for (int i = 0; i < memberNum; i++) {
        RedModel? redModel;
        if (model.redList.length > i) {
          redModel = model.redList[i];
        }
        if (i > 0 && i % 3 != 0) {
          rowList.add(Container(
              width: 12.w, height: 50.w,
              alignment: Alignment.center,
              child: Text("+", style: TextStyle(fontSize: 16.sp, color: IConstant.text_color))));
        }
        rowList.add(redModel != null ? Stack(
          children: [
            LoadImageView(50.w, 50.w, redModel.productPic),
            Positioned(right: 0.w, bottom: 0.w,
                child: ClipOval(child: LoadImageView(24.w, 24.w, redModel.memberIcon))),
          ],
        ) : Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
              color: IConstant.line_color,
              borderRadius: BorderRadius.all(Radius.circular(12.w))
          ),
        ));
      }
    } else { //已发放
      for (int i = 0; i < model.redList.length; i++) {
        RedModel? redModel;
        if (model.redList.length > i) {
          redModel = model.redList[i];
        }
        if (i > 0 && i % 3 != 0) {
          rowList.add(Container(
              width: 12.w, height: 50.w,
              alignment: Alignment.center,
              child: Text("+", style: TextStyle(fontSize: 16.sp, color: IConstant.text_color))));
        }
        rowList.add(redModel != null ? Stack(
          children: [
            LoadImageView(50.w, 50.w, redModel.productPic),
            Positioned(right: 0.w, bottom: 0.w,
                child: ClipOval(child: LoadImageView(24.w, 24.w, redModel.memberIcon))),
          ],
        ) : Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
              color: IConstant.line_color,
              borderRadius: BorderRadius.all(Radius.circular(12.w))
          ),
        ));
      }
    }
    return rowList;
  }

  RedModel? getRedModel(List<RedModel> redList, int index) {
    if (index < redList.length) {
      return redList[index];
    } else {
      return null;
    }
  }

  Widget buildButtons() {
    return Container(
      height: 40.w,
      margin: EdgeInsets.only(top: 8.w, bottom: 0.w),
      padding: EdgeInsets.fromLTRB(10.w, 0.w, 10.w, 0.w),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return buildButton(tabList[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 20.w,
          );
        },
      ),
    );
  }

  Widget buildButton(SelectTabModel model) {
    return InkWell(
      onTap: () {
        setState(() {
          page = 1;
          for (var item in tabList) {
            item.isSelect = false;
          }
          model.isSelect = true;
          loadContentDatas();
        });
      },
      child: Container(
        height: 40.w,
        margin: EdgeInsets.fromLTRB(5.w, 0.w, 5.w, 0.w),
        padding: EdgeInsets.fromLTRB(5.w, 0.w, 5.w, 0.w),
        child: Column(
          children: [
            getTitle(model),
            SizedBox(height: 10.w),
            Container(
              width: 80.w,
              height: 3.w,
              color: model.getBgColor(),
            )
          ],
        ),
      ),
    );
  }

  Widget getTitle(SelectTabModel model) {
    if (model.type == 1) {
      return Row(
        children: [
          Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_my_push), style: TextStyle(fontSize: 13.sp, color: model.getTextColor())),
          SizedBox(width: 4.w),
          Container(
            padding: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
            decoration: BoxDecoration(
              color: IConstant.red_bg_color3,
              borderRadius: BorderRadius.all(Radius.circular(12.w))
            ),
            child: Text("${widget.oneLevelExtendNum}", style: TextStyle(fontSize: 13.sp, color: IConstant.main_color)),
          )
        ],
      );
    } else if (model.type == 2) {
      return Row(
        children: [
          Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_second_level), style: TextStyle(fontSize: 13.sp, color: model.getTextColor())),
          SizedBox(width: 4.w),
          Container(
            padding: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
            decoration: BoxDecoration(
                color: IConstant.red_bg_color3,
                borderRadius: BorderRadius.all(Radius.circular(12.w))
            ),
            child: Text("${widget.twoLevelExtendNum}", style: TextStyle(fontSize: 13.sp, color: IConstant.main_color)),
          )
        ],
      );
    } else {
      return Row(
        children: [
          Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_third_level), style: TextStyle(fontSize: 13.sp, color: model.getTextColor())),
          SizedBox(width: 4.w),
          Container(
            padding: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
            decoration: BoxDecoration(
                color: IConstant.red_bg_color3,
                borderRadius: BorderRadius.all(Radius.circular(12.w))
            ),
            child: Text("${widget.threeLevelExtendNum}", style: TextStyle(fontSize: 13.sp, color: IConstant.main_color)),
          )
        ],
      );
    }
  }

  String getStatus(RedTitleModel model){
    if (model.status == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_processing);
    } else{
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_issued);
    }
  }

  String getSelectType() {
    for (SelectTabModel item in tabList) {
      if (item.isSelect) {
        return "${item.type}";
      }
    }
    return "";
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

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      elevation: 2.w,
      child: Container(
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        height: 60.w,
        child: Row(
          children: [
            Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_obtain_red),
                style: TextStyle(
                    fontSize: 14.sp, color: IConstant.text_color)),
            SizedBox(width: 8.w),
            Text("$_redCount", style: TextStyle(fontSize: 14.sp, color: IConstant.main_color)),
            expandeSpace,
            Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_total),
                style: TextStyle(
                    fontSize: 14.sp, color: IConstant.text_color)),
            SizedBox(width: 8.w),
            PriceText(_redAmount, fontSize: 14.sp),
          ],
        ),
      ),
    );
  }

}
