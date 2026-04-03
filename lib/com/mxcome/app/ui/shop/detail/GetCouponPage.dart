//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:mxcome/com/mxcome/app/ui/shop/widget/OutlineBigTextButton.dart';
// import 'package:sprintf/sprintf.dart';
//
// import '../../../BaseKeepAliveState.dart';
// import '../../../IConstant.dart';
// import '../../../IURLConstant.dart';
// import '../../../config/LanguageConfig.dart';
// import '../../../model/BaseModel.dart';
// import '../../../model/BaseRsp.dart';
// import '../../../utils/HttpUtils.dart';
// import '../../../utils/ViewUtils.dart';
// import '../widget/LoadImageView.dart';
// import '../widget/OutlineTextButton.dart';
// import '../widget/PriceText.dart';
//
//
// class GetCouponPage extends StatefulWidget {
//
//   dynamic product;
//   List<dynamic> couponList;
//
//   GetCouponPage(this.product, this.couponList);
//
//   @override
//   State<GetCouponPage> createState() => GetCouponPageState();
//
// }
//
// class GetCouponPageState extends BaseKeepAliveState<GetCouponPage> {
//
//   dynamic _product;
//   List<dynamic> _couponList = [];
//   bool isAllHold = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _product = widget.product;
//     _couponList = widget.couponList;
//     checkHold();
//   }
//
//   @override
//   Future<void> loadContentDatas() async {
//     String productId = BaseModel.getString(_product, "id");
//     String url = "${IURLConstant.MALL_LIST_BY_PRODUCT_SHOP}$productId";
//     BaseRsp rsp = await HttpUtils.post(url, {
//       "productId": productId,
//     });
//     if (rsp.retCode == RspRetCode.SUCCESS) {
//       setState(() {
//         _couponList =  rsp.data;
//       });
//       checkHold();
//     } else {
//       ViewUtils.displayToast(rsp.msg);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Scaffold(
//       backgroundColor: IConstant.white_color,
//       appBar: AppBar(
//         elevation: 0.w,
//         centerTitle: true,
//         title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_product_get_coupon),
//             style: TextStyle(fontSize: 17.w, color: IConstant.text_color)),
//       ),
//       body: buildBody(),
//       bottomNavigationBar: _couponList.isNotEmpty ? buildBottomBar() : null,
//     );
//   }
//
//   Widget buildBody() {
//     return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Image.asset("icons/coupon_adv.png", width: double.infinity,),
//           SizedBox(height: 12.w,),
//           Row(children: [
//             SizedBox(width: 16.w,),
//             Image.asset("icons/ip_icon.png", width: 22.w, height: 22.w),
//             SizedBox(width: 8.w,),
//             Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_product_get_coupon_tip),
//                 style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),),
//             SizedBox(width: 16.w,),
//           ]),
//           SizedBox(height: 12.w,),
//           Expanded(child: _couponList.isEmpty ? buildHeader() : ListView.separated(
//               scrollDirection: Axis.vertical,
//               itemCount: _couponList.length,
//               itemBuilder: (context, idx) {
//                 return buildCouponItem(idx);
//               },
//               separatorBuilder: (BuildContext context, int index) {
//                 return Container(height: 10.w);
//               })),
//         ],
//     );
//   }
//
//   Widget buildCouponItem(int index) {
//     dynamic item = _couponList[index];
//     return Container(
//       margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0.w),
//       constraints: BoxConstraints(
//         maxHeight: 140.w
//       ),
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(color: IConstant.line_color,
//               offset: Offset(3, 4), // 偏移量
//               blurRadius: 8.w)
//         ],
//         color: IConstant.white_color,
//         borderRadius: BorderRadius.circular((10.w)),
//       ),
//       child: Row(
//         children: [
//           Expanded(flex: 5, child: buildLeft(item)),
//           Expanded(flex: 2, child: buildRight(item))
//         ],
//       ),
//     );
//   }
//
//   Widget buildLeft(dynamic item) {
//     int type = BaseModel.getInt(item, "type");
//     int shopId = BaseModel.getInt(_product, "shopId");
//     String shopIcon = BaseModel.getString(_product, "shopIcon");
//     String shopName = BaseModel.getString(_product, "shopName");
//     if (shopId == 0) {
//       shopName = LanguageConfig.get(LanguageConfigKeys.app_name);
//     }
//     return Padding(
//       padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               ClipOval(child: shopId == 0 ? Image.asset("icons/official_icon.png", width: 45.w, height: 45.w)
//                   : LoadImageView(45.w, 45.w, shopIcon)),
//               SizedBox(width: 4.w),
//               Container(
//                 constraints: BoxConstraints(
//                   maxWidth: 60.w,
//                 ),
//                 child: Text(shopName,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(fontSize: 13.sp, color: IConstant.title_color)),
//               ),
//               SizedBox(width: 6.w),
//               Container(
//                 padding: EdgeInsets.fromLTRB(6.w, 2.w, 6.w, 2.w),
//                 constraints: BoxConstraints(
//                   maxWidth: 85.w,
//                 ),
//                 decoration: BoxDecoration(
//                     border: Border.all(width: 1.w, color: IConstant.main_color),
//                     borderRadius: BorderRadius.circular(6.w)),
//                 child: Text(getType(type, shopId), style: TextStyle(fontSize: 12.sp, color: IConstant.main_color)),
//               )
//             ],
//           ),
//           SizedBox(height: 2.w),
//           Text(BaseModel.getString(item, "name"), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: IConstant.text_color)),
//           SizedBox(height: 2.w),
//           Text(getUseType(BaseModel.getInt(item, "isAllProducts")), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: IConstant.text_color)),
//           SizedBox(height: 6.w),
//           Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_order_valid_to), [ BaseModel.getString(item, "endTime") ]), style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color))
//         ],
//       ),
//     );
//   }
//
//   Widget buildRight(dynamic item) {
//     int type = BaseModel.getInt(item, "type");
//     String isHold = BaseModel.getString(item, "isHold");
//     String btnText = "";
//     if (isHold == "1") {
//       btnText = LanguageConfig.get(LanguageConfigKeys.Shop_order_coupon_received);
//     } else {
//       btnText = LanguageConfig.get(LanguageConfigKeys.Shop_product_now_get);
//     }
//     return Container(
//       decoration: BoxDecoration(
//           color: type == 0 ? IConstant.gold_color : IConstant.red_bg_color3,
//           borderRadius: BorderRadius.horizontal(right: Radius.circular(10.w))),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           SizedBox(height: 8.w),
//           PriceText(BaseModel.getDouble(item, "amount"), fontSize: BaseModel.getDouble(item, "amount") >= 10000 ? 14.sp : 20.sp, fontWeight: FontWeight.bold,),
//           SizedBox(height: 8.w),
//           Text(getUseLimitType(BaseModel.getDouble(item, "minPoint")),
//               textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
//           SizedBox(height: 16.w),
//           OutlineTextButton(text: btnText,
//               bgColor: isHold == "1" ? Colors.transparent : IConstant.main_color,
//               borderColor: isHold == "1" ? IConstant.main_color : IConstant.main_color,
//               textColor: isHold == "1" ? IConstant.main_color : IConstant.white_color, onTap: () {
//                 if (isHold != "1") {
//                   couponGet(item);
//                 }
//               }),
//           SizedBox(height: 8.w),
//         ],
//       ),
//     );
//   }
//
//   String getUseLimitType(double minPoint) {
//     if (minPoint > 0) {
//       return sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_order_full_available), [ minPoint.toStringAsFixed(2) ]);
//     } else {
//       return sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_order_full_available), [ 0.toStringAsFixed(2) ]);
//     }
//   }
//
//   String getUseType(isAllProducts) {
//     if (isAllProducts == 1) {
//       return LanguageConfig.get(LanguageConfigKeys.Shop_order_all_shops);
//     } else {
//       return LanguageConfig.get(LanguageConfigKeys.Shop_order_specific_product_available);
//     }
//   }
//
//   String getVoucherType(int type) {
//     if (type == 0) {
//       return LanguageConfig.get(LanguageConfigKeys.Shop_order_all_platforms);
//     } else if (type == 1) {
//       return LanguageConfig.get(LanguageConfigKeys.Shop_order_category_available);
//     } else {
//       return LanguageConfig.get(LanguageConfigKeys.Shop_order_specific_product_available);
//     }
//   }
//
//   String getType(int type, int shopId) {
//     if (type == 0) {
//       return LanguageConfig.get(LanguageConfigKeys.Shop_order_voucher);
//     } else {
//       if (shopId == 0) {
//         return LanguageConfig.get(LanguageConfigKeys.Shop_order_platform);
//       } else {
//         return LanguageConfig.get(LanguageConfigKeys.Shop_order_brand);
//       }
//     }
//   }
//
//   BottomAppBar buildBottomBar() {
//     return BottomAppBar(
//       elevation: 0,
//       height: 85.w,
//       child: Container(
//         margin: EdgeInsets.fromLTRB(80.w, 8.w, 80.w, 8.w),
//         child: OutlineBigTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_product_on_click_get),
//             bgColor: isAllHold ? IConstant.grey_bg_color : IConstant.red_bg_color3,
//             borderColor: isAllHold ? IConstant.grey_bg_color : IConstant.main_color,
//             textColor: isAllHold ? IConstant.sub_text_color : IConstant.main_color,
//             onTap: () {
//           if (!isAllHold) {
//             batchGet();
//           }
//         }
//       )),
//     );
//   }
//
//   Future<void> batchGet() async {
//     for (var item in _couponList) {
//       String isHold = BaseModel.getString(item, "isHold");
//       if (isHold != 1) {
//         String id = BaseModel.getString(item, "id");
//         String url = "${IURLConstant.MALL_COUPON_ADD}$id";
//         BaseRsp rsp = await HttpUtils.post(url, {
//           "id": id
//         });
//         if (rsp.retCode == RspRetCode.SUCCESS) {
//           ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_order_received_successfully));
//         } else {
//           ViewUtils.displayToast(rsp.msg);
//         }
//       }
//     }
//     loadContentDatas();
//   }
//
//   checkHold() {
//     int holdCount = 0;
//     for (var item in _couponList) {
//       String isHold = BaseModel.getString(item, "isHold");
//       if(isHold == "1") {
//         holdCount++;
//       }
//     }
//     setState(() {
//       isAllHold = (_couponList.length == holdCount);
//     });
//   }
//
//   Future<void> couponGet(dynamic item) async {
//     String isHold = BaseModel.getString(item, "isHold");
//     if (isHold != "1") {
//       ViewUtils.show();
//       String id = BaseModel.getString(item, "id");
//       String url = "${IURLConstant.MALL_COUPON_ADD}$id";
//       BaseRsp rsp = await HttpUtils.post(url, {
//         "id": id
//       });
//       if (rsp.retCode == RspRetCode.SUCCESS) {
//         ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_order_received_successfully));
//         loadContentDatas();
//       } else {
//         ViewUtils.displayToast(rsp.msg);
//       }
//       ViewUtils.dismiss();
//     }
//   }
// }
