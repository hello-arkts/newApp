import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/OutlineTextButton.dart';
import 'package:sprintf/sprintf.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IConstant.dart';
import '../../../../IURLConstant.dart';
import '../../../../config/LanguageConfig.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/HttpUtils.dart';
import '../../../../utils/ViewUtils.dart';
import '../../model/SelectTabModel.dart';
import '../../utils/FormatUtil.dart';
import '../../widget/LoadImageView.dart';
import '../../widget/PriceText.dart';
import 'UseCouponPage.dart';

class CouponItemPage extends StatefulWidget {
  @override
  State<CouponItemPage> createState() => CouponItemPageState();
}

class CouponItemPageState extends BaseKeepAliveState<CouponItemPage> {
  List<SelectTabModel> tabList = [];

  String status = "0";

  @override
  void initState() {
    super.initState();
    tabList.add(SelectTabModel(0, true)); //待使用
    tabList.add(SelectTabModel(1, false)); //已使用
    tabList.add(SelectTabModel(2, false)); //已过期
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    status = getSelectStatus();
    isLoading = true;
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_MY_COUPON_LIST, {
      "type": "1",
      "useStatus": status,
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        buildButtons(),
        Expanded(
            child: datas.isEmpty
                ? buildHeader()
                : EasyRefresh(
                    header: const MaterialHeader(color: IConstant.main_color),
                    footer: CupertinoFooter(emptyWidget: Container(
            padding: EdgeInsets.all(10.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_more), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
          )),
                    onRefresh: () => onRefresh(),
                    onLoad: () => onLoadMore(),
                    child: ListView.separated(
                        scrollDirection: Axis.vertical,
                        itemCount: datas.length,
                        itemBuilder: (context, idx) {
                          return InkWell(
                            onTap: () {},
                            child: buildCouponItem(idx),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: 10.w);
                        })))
      ],
    );
  }

  Widget buildCouponItem(int index) {
    dynamic item = datas[index];
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(16.w, 4.w, 16.w, 4.w),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x1E000000),
                blurRadius: 9,
                offset: Offset(0, 2),
                spreadRadius: 0,
              )
            ],
          ),
          child: Row(
            children: [Expanded(flex: 6, child: buildLeft(item)), Expanded(flex: 3, child: buildRight(item))],
          ),
        ),
        status != "0"
            ? Positioned(
                top: 0.w,
                bottom: 0.w,
                left: 0.w,
                right: 0.w,
                child: Container(
                  decoration: BoxDecoration(color: IConstant.white_translucent_color, borderRadius: BorderRadius.circular(12.w)),
                ),
              )
            : Container()
      ],
    );
  }

  Widget buildLeft(dynamic item) {
    dynamic coupon = BaseModel.getDynamic(item, "coupon");
    dynamic shop = BaseModel.getDynamic(item, "shop");
    int shopId = BaseModel.getInt(shop, "id");
    String shopIcon = BaseModel.getString(shop, "logo");
    String shopName = BaseModel.getString(shop, "name");
    int isAllProducts = BaseModel.getInt(coupon, "isAllProducts");
    if (shopId == 0) {
      shopName = LanguageConfig.get(LanguageConfigKeys.app_name);
    }
    return Padding(
      padding: EdgeInsets.only(left: 10.w, top: 8.w, bottom: 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                  child: shopId == 0
                      ? Image.asset("assets/icons/official_icon.png", width: 34.w, height: 34.w)
                      : LoadImageView(34.w, 34.w, shopIcon)),
              SizedBox(width: 4.w),
              Container(
                constraints: BoxConstraints(
                  maxWidth: 80.w,
                ),
                child: Text(shopName,
                    maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13.sp, color: IConstant.title_color)),
              ),
              // SizedBox(width: 2.w),
              // Image.asset("assets/icons/ip_icon.png", width: 20.w),
              SizedBox(width: 6.w),
              Container(
                padding: EdgeInsets.fromLTRB(6.w, 3.w, 6.w, 3.w),
                constraints: BoxConstraints(maxWidth: 85.w),
                decoration:
                    BoxDecoration(border: Border.all(width: 1.w, color: IConstant.main_color), borderRadius: BorderRadius.circular(6.w)),
                child: Text(getType(shopId), style: TextStyle(fontSize: 12.sp, color: IConstant.main_color)),
              )
            ],
          ),
          SizedBox(height: 2.w),
          Text(BaseModel.getString(coupon, "name"), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: IConstant.text_color), maxLines: 1, overflow: TextOverflow.ellipsis),
          SizedBox(height: 2.w),
          Text(getUseType(BaseModel.getInt(coupon, "useType"), shopId, isAllProducts),
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: IConstant.text_color)),
          SizedBox(height: 6.w),
          Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_valid_to), [FormatUtil.formatYMDHM(DateTime.parse(BaseModel.getString(coupon, "endTime")))]),
              style: TextStyle(fontSize: 12.sp, color: IConstant.text_color.withOpacity(0.55)))
        ],
      ),
    );
  }

  Widget buildRight(dynamic item) {
    dynamic shop = BaseModel.getDynamic(item, "shop");
    dynamic coupon = BaseModel.getDynamic(item, "coupon");
    String btnText;
    if (status == "0") {
      btnText = LanguageConfig.get(LanguageConfigKeys.Shop_mine_to_use);
    } else if (status == "1") {
      btnText = LanguageConfig.get(LanguageConfigKeys.Shop_mine_used);
    } else {
      btnText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_expired);
    }
    return Container(
      padding: EdgeInsets.only(top: 8.w, bottom: 8.w),
      decoration: BoxDecoration(
          color: status != "0" ? IConstant.black_translucent_color : IConstant.red_bg_color3,
          borderRadius: BorderRadius.horizontal(right: Radius.circular(10.w))),
      child: Column(
        children: [
          SizedBox(height: 4.w),
          PriceText(BaseModel.getDouble(coupon, "amount"),
              fontSize: 20.sp, color: status != "0" ? IConstant.white_color : IConstant.main_color),
          SizedBox(height: 6.w),
          Text(getUseLimitType(BaseModel.getDouble(coupon, "minPoint")),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, color: status != "0" ? IConstant.white_color : IConstant.text_color)),
          SizedBox(height: 6.w),
          OutlineTextButton(
              fontSize: 12.sp,
              text: btnText,
              left: 20.w,
              right: 20.w,
              bgColor: status != "0" ? IConstant.black_translucent_color : IConstant.white_color,
              borderColor: status != "0" ? IConstant.white_color : IConstant.main_color,
              textColor: status != "0" ? IConstant.white_color : IConstant.main_color,
              onTap: () {
                if (status == "0") {
                  nextPage(UseCouponPage(shop, coupon), false);
                }
              })
        ],
      ),
    );
  }

  Widget buildButtons() {
    return Container(
      margin: EdgeInsets.only(top: 16.w, bottom: 16.w),
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
            padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(10.w, 4.w, 10.w, 4.w)),
            backgroundColor: createTextButtonStyle(model.isSelect),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.w))),
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
              maxLines: 1, style: TextStyle(fontSize: 13.sp, color: model.isSelect ? IConstant.main_color : IConstant.sub_text_color)),
        ));
  }

  String getSelectStatus() {
    for (var item in tabList) {
      if (item.isSelect) {
        return "${item.type}";
      }
    }
    return "";
  }

  String getTitle(SelectTabModel model) {
    if (model.type == 0) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_to_be_use);
    } else if (model.type == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_used);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_activity_expired);
    }
  }

  String getIsHold(int isHold) {
    if (isHold == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_to_use);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_get_now);
    }
  }

  // String getUseType(int type, double minPoint) {
  //   if (minPoint > 0) {
  //     return sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_full_available), [FormatUtil.price2String(minPoint)]);
  //   } else {
  //     if (type == 0) {
  //       return LanguageConfig.get(LanguageConfigKeys.Shop_mine_all_platforms);
  //     } else if (type == 1) {
  //       return LanguageConfig.get(LanguageConfigKeys.Shop_mine_category_available);
  //     } else {
  //       return LanguageConfig.get(LanguageConfigKeys.Shop_mine_specific_product_available);
  //     }
  //   }
  // }

  String getUseLimitType(double minPoint) {
    if (minPoint > 0) {
      return sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_full_available), [ minPoint.toStringAsFixed(2) ]);
    } else {
      return sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_full_available), [ 0.toStringAsFixed(2) ]);
    }
  }

  String getUseType(int type, int shopId, int isAllProducts) {
    if(shopId == 0) {
      if (type == 0) {
        return LanguageConfig.get(LanguageConfigKeys.Shop_mine_all_platforms);
      } else {
        return LanguageConfig.get(LanguageConfigKeys.Shop_mine_specific_product_available);
      }
    }else {
      if(isAllProducts == 1) {
        return LanguageConfig.get(LanguageConfigKeys.Shop_mine_all_shops);
      }else {
        return LanguageConfig.get(LanguageConfigKeys.Shop_mine_specific_product_available);
      }
    }
  }

  String getType(int shopId) {
    if (shopId == 0) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_platform_voucher);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_merchant_voucher);
    }
  }

  MaterialStateProperty<BorderSide> createTextButtonBorderSide(bool isSelect) {
    return MaterialStateProperty.all(BorderSide(width: 1.w, color: isSelect ? IConstant.main_color : IConstant.line_color));
  }

  MaterialStateProperty<Color> createTextButtonStyle(bool isSelect) {
    return MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.pressed)) {
        return isSelect ? IConstant.red_bg_color : IConstant.line_color;
      } else if (states.contains(MaterialState.disabled)) {
        return isSelect ? IConstant.red_bg_color : IConstant.line_color;
      }
      return isSelect ? IConstant.red_bg_color : IConstant.line_color;
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
}
