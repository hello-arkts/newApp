
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/Logger.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/CouponModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/BigTextButton.dart';
import 'package:sprintf/sprintf.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseModel.dart';
import '../utils/FormatUtil.dart';
import '../widget/LoadImageView.dart';
import '../widget/PriceText.dart';


class SelectCouponPage extends StatefulWidget {

  List<CouponModel> couponList;

  Function(BuildContext context, List<CouponModel>) callBack;

  SelectCouponPage(this.couponList, this.callBack);

  @override
  State<SelectCouponPage> createState() => SelectCouponPageState();

}

class SelectCouponPageState extends BaseKeepAliveState<SelectCouponPage> {

  List<CouponModel> _couponList = [];

  double _total = 0;

  @override
  void initState() {
    super.initState();
    _couponList = widget.couponList;
    setSelectTotal();
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 22.w,
                color: Colors.black,
              ),
              onPressed: () {
                widget.callBack(context, _couponList);
              }),
        ),
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_use_coupons),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
        actions: [
          Container()
        ],
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildBody() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 6.w),
            child: Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_currently_available), [ _couponList.length ]),
                style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
          ),
          Expanded(child: _couponList.isEmpty ? buildHeader() : ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: _couponList.length,
              itemBuilder: (context, idx) {
                return buildCouponItem(idx);
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 10.w);
              }))
        ],
    );
  }

  Widget buildCouponItem(int index) {
    CouponModel model = _couponList[index];
    Logger.log("---model type: ${model.type} useType: ${model.useType} shopId: ${model.shopId} amount: ${model.amount}");
    double marginTop = 0;
    if (index > 0) {
      CouponModel prevModel = _couponList[index - 1];
      if (model.type != prevModel.type
          || model.shopId != prevModel.shopId) {
        marginTop = 20.w;
      }
    }
    return InkWell(
      onTap: () {
        setSelectModel(index, model);
        setSelectTotal();
      },
      child: Card(
        margin: EdgeInsets.fromLTRB(16.w, marginTop, 16.w, 0.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(12.w),
        ),
        child: Row(
          children: [
            Expanded(flex: 3, child: buildLeft(model)),
            Expanded(flex: 7, child: buildMiddle(model)),
            Expanded(flex: 1, child: getIcon(model)),
          ],
        ),
      ),
    );
  }

  void setSelectModel(int index, CouponModel model) {
    List<CouponModel> groupList = [];
    for (CouponModel item in _couponList) { //代金券和平台券
      if (model.type == 0 || model.shopId == 0) {
        if (item.type == 0 || item.shopId == 0) {
          groupList.add(item);
        }
      } else {
        if (item.type == model.type && item.shopId == model.shopId) {
          groupList.add(item);
        }
      }
    }
    if (groupList.length == 1) {
      setState(() {
        model.isSelect = !model.isSelect;
      });
    } else if (groupList.length > 1) {
      if (model.isSelect) {
        model.isSelect = false;
      } else {
        setState(() {
          for (CouponModel item in groupList) {
            item.isSelect = false;
          }
          model.isSelect = true;
        });
      }
    }
  }

  Widget buildMiddle(CouponModel item) {
    int shopId = item.shopId;
    String shopIcon = item.shopIcon;
    String shopName = item.shopName;
    if (shopId == 0) {
      shopName = LanguageConfig.get(LanguageConfigKeys.app_name);
    }
    if (item.type == 0) { //代金券
      return Padding(
        padding: EdgeInsets.only(left: 10.w,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(child: Image.asset("assets/icons/official_icon.png", width: 34.w, height: 34.w)),
                SizedBox(width: 4.w),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 70.w,
                  ),
                  child: Text(LanguageConfig.get(LanguageConfigKeys.app_name),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14.sp, color: IConstant.title_color)),
                ),
              ],
            ),
            SizedBox(height: 2.w),
            // Text(getUseType(item.useType, item.minPoint), textAlign: TextAlign.center,
            //     style: TextStyle(fontSize: 13.sp, color: IConstant.sub_text_color)),
            Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_all_platforms), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
            SizedBox(height: 6.w),
            Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_valid_to), [ FormatUtil.formatYMDHM(DateTime.parse(item.endTime)) ]), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color.withOpacity(0.55)))
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(child: shopId == 0 ? Image.asset("assets/icons/official_icon.png", width: 34.w, height: 34.w)
                    : LoadImageView(34.w, 34.w, shopIcon)),
                SizedBox(width: 4.w),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 80.w,
                  ),
                  child: Text(shopName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14.sp, color: IConstant.title_color)),
                ),
                // SizedBox(width: 2.w),
                // Image.asset("assets/icons/ip_icon.png", width: 20.w),
                SizedBox(width: 6.w),
                Container(
                  padding: EdgeInsets.fromLTRB(6.w, 3.w, 6.w, 3.w),
                  constraints: BoxConstraints(
                      maxWidth: 75.w
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.w, color: IConstant.main_color),
                      borderRadius: BorderRadius.circular(10.w)),
                  child: Text(getType(item.type, shopId), maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12.sp, color: IConstant.main_color)),
                )
              ],
            ),
            SizedBox(height: 2.w),
            Text(item.name, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: IConstant.text_color), maxLines: 1, overflow: TextOverflow.ellipsis),
            SizedBox(height: 2.w),
            Text(getUseType(item.useType, shopId, item.isAllProducts),
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: IConstant.text_color)),
            SizedBox(height: 6.w),
            Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_valid_to), [ FormatUtil.formatYMDHM(DateTime.parse(item.endTime)) ]), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color.withOpacity(0.55)))
          ],
        ),
      );
    }
  }

  Widget buildLeft(CouponModel model) {
    return Container(
      padding: EdgeInsets.fromLTRB(0.w, 18.w, 0.w, 40.w),
      decoration: BoxDecoration(
          color: model.type == 0 ? IConstant.gold_color : IConstant.red_bg_color3,
          borderRadius: BorderRadius.horizontal(left: Radius.circular(10.w))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PriceText(model.amount, fontSize: 20.sp),
          SizedBox(height: 18.w,),
          Text(getUseLimitType(model.minPoint), textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
        ],
      ),
    );
  }

  String getIsHold(int isHold) {
    if (isHold == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_to_use);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_get_now);
    }
  }

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

  String getType(int type, int shopId) {
    if (type == 0) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_voucher);
    } else {
      if (shopId == 0) {
        return LanguageConfig.get(LanguageConfigKeys.Shop_mine_platform_voucher);
      } else {
        return LanguageConfig.get(LanguageConfigKeys.Shop_mine_merchant_voucher);
      }
    }
  }

  Widget getIcon(CouponModel model) {
    return model.isSelect
        ? Icon(Icons.check_circle, size: 26.w, color: IConstant.main_color)
        : Icon(Icons.circle, size: 26.w, color: IConstant.grey_bg_color);
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

  void setSelectTotal() {
    double total = 0;
    for (CouponModel item in _couponList) {
      if (item.isSelect) {
        total += item.amount;
      }
    }
    setState(() {
      _total = total;
    });
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      child: Container(
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        height: 60.w,
        child: Row(
          children: [
            Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_discount_deduction),
                style: TextStyle(
                    fontSize: 12.sp, color: IConstant.text_color)),
            SizedBox(width: 6.w),
            PriceText(_total, fontSize: 14.sp),
            expandeSpace,
            Expanded(
                flex: 2,
                child: BigTextButton(text: LanguageConfig.get(LanguageConfigKeys.ViewUtils_confirm), onTap: () {
                  widget.callBack(context, _couponList);
                })
            )
          ],
        ),
      ),
    );
  }

}
