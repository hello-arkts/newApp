
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/CartItem.dart';
import 'package:mxcome/com/mxcome/app/utils/AppUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:sprintf/sprintf.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IURLConstant.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../brand/BrandShopPage.dart';
import '../model/PhotoModel.dart';
import '../model/RefundModel.dart';
import '../utils/ImageUtil.dart';
import '../utils/ShowBottomSheetTool.dart';
import '../widget/ExpandedOutlineText.dart';
import '../widget/LoadImageView.dart';
import '../widget/PriceText.dart';
import '../widget/CommResultPage.dart';
import 'AfterSalesPage.dart';
import 'ReturnCouponPage.dart';

class ApplySubmitPage extends StatefulWidget {

  dynamic order;
  dynamic orderItem;
  RefundModel refundModel;

  ApplySubmitPage(this.order, this.orderItem, this.refundModel);

  @override
  State<ApplySubmitPage> createState() => _ApplySubmitPageState();
}

class _ApplySubmitPageState extends BaseKeepAliveState<ApplySubmitPage> {

  dynamic order;

  dynamic orderItem;

  PhotoModel? selectPhoto;

  List<PhotoModel> photoList = [
    PhotoModel(0, ""),
    PhotoModel(1, ""),
    PhotoModel(2, ""),
    PhotoModel(3, ""),
  ];

  int reasonIndex = 0;
  List<String> reasonList = [];

  int refundIndex = 0;
  List<String> refundList = [];

  bool amountLoading = true;

  double returnAmount = 0;

  double freightAmount = 0;

  dynamic systemSettingsInfo;

  @override
  void initState() {
    super.initState();
    setState(() {
      order = widget.order;
      orderItem = widget.orderItem;
    });
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    reasonIndex = 0;
    reasonList = [];
    if (widget.refundModel.type == 1) {
      reasonList.add(LanguageConfig.get(LanguageConfigKeys.Shop_sales_refund_item1));
      reasonList.add(LanguageConfig.get(LanguageConfigKeys.Shop_sales_refund_item2));
      reasonList.add(LanguageConfig.get(LanguageConfigKeys.Shop_sales_refund_item3));
    } else if (widget.refundModel.type == 2) {
      reasonList.add(LanguageConfig.get(LanguageConfigKeys.Shop_sales_return_refund_item1));
    } else {
      reasonList.add(LanguageConfig.get(LanguageConfigKeys.Shop_sales_overtime_item1));
    }
    for (int i = 0; i < reasonList.length; i++) {
      if(widget.refundModel.name == reasonList[i]) {
        reasonIndex = i;
        break;
      }
    }
    //退款
    refundIndex = 0;
    refundList = [];
    refundList.add(LanguageConfig.get(LanguageConfigKeys.Shop_sales_balance));

    BaseRsp res = await HttpUtils.post(IURLConstant.MALL_GET_SYSTEM_SETTINGS, {});

    systemSettingsInfo = res.data;

    //查询退款金额
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_RETURN_APPLY_CONFIRM, {
      "orderItemId": BaseModel.getString(orderItem, "id"),
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        amountLoading = false;
        returnAmount = BaseModel.getDouble(rsp.data, "returnAmount");
        freightAmount = BaseModel.getDouble(rsp.data, "freightAmount");
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.5.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_apply_service),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
        // actions: [
        //   Container(
        //     margin: EdgeInsets.all(10.w),
        //     child: SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_sales_policy), bgColor: IConstant.blue_bg_color2, textColor: IConstant.blue_color, onTap: () {
        //       ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_coming_soon));
        //     }),
        //   )
        // ],
      ),
      body: ListView(children: [
        buildBuyItem(),
        buildOption(),
        buildUpload(),
        buildTake(),
        buildFee(),
        buildRefundType(),
        Container(
          height: 60.w,
          margin: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(width: 3.w, color: IConstant.red_bg_color),
              SizedBox(width: 12.w),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_return_refund_tip1), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color)),
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_return_refund_tip2), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color)),
                ],
              ))
            ],
          ),
        )
      ]),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildMerchant() {
    return Row(
      children: [
        InkWell(
            onTap: () {
              nextPage(BrandShopPage(BaseModel.getString(order, "shopId")), false);
            },
            child: Row(
              children: [
                ClipOval(child: LoadImageView(22.w, 22.w, BaseModel.getString(order, "shopIcon"))),
                SizedBox(width: 6.w),
                Container(constraints: BoxConstraints(maxWidth: 200.w), child: Text(BaseModel.getString(order, "shopName"), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))),
                Icon(Icons.chevron_right, size: 20.w, color: IConstant.text_color,),
              ],
            )
        ),
      ],
    );
  }

  Widget buildBuyItem() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
      decoration: BoxDecoration(
          border: Border.all(color: IConstant.grey_bg_color, width: 1.w),
          borderRadius: BorderRadius.circular(12.w)),
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          buildMerchant(),
          SizedBox(height: 4.w),
          Row(
            children: [
              Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(8.w)),
                  clipBehavior: Clip.antiAlias,
                  elevation: 2,
                  child: LoadImageView(70.w, 70.w, orderItem["productPic"])),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: Text(
                          orderItem["productName"],
                          style:
                          TextStyle(fontSize: 13.sp, color: IConstant.text_color),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10.w, top: 2.w),
                        padding: EdgeInsets.fromLTRB(12.w, 4.w, 12.w, 4.w),
                        decoration: BoxDecoration(
                            color: IConstant.grey_bg_color,
                            borderRadius: BorderRadius.all(Radius.circular(10.w))),
                        child: Text(
                          CartItem.getProductAttrValues(orderItem["productAttr"]),
                          style: TextStyle(
                              fontSize: 12.sp, color: IConstant.text_color),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: PriceText(orderItem["productPrice"], fontSize: 14.sp),
                          ),
                          Expanded(child: Container()),
                          Text("×${orderItem["productQuantity"]}")
                        ],
                      ),
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }

  Widget buildOption() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0.w),
      decoration: BoxDecoration(
          border: Border.all(color: IConstant.grey_bg_color, width: 1.w),
          borderRadius: BorderRadius.circular(12.w)),
      padding: EdgeInsets.all(16.w),
      child: InkWell(
        onTap: () {
          ShowBottomSheetTool().showSingleRowPicker(context, data: reasonList, title: LanguageConfig.get(LanguageConfigKeys.Shop_sales_refunded_reason), normalIndex: reasonIndex, clickCallBack: (int selectIndex, Object selectStr){
            setState(() {
              reasonIndex = selectIndex;
            });
          });
        },
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: Text(getApplyInfo(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp, color: IConstant.text_color))),
            Expanded(
                flex: 3,
                child: Container(
                  margin: EdgeInsets.only(left: 20.w, right: 10.w),
                  child: Text(reasonList[reasonIndex],
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 12.sp, color: IConstant.sub_text_color)),
                )),
            Icon(Icons.chevron_right, size: 20.w, color: IConstant.text_color)
          ],
        ),
      ),
    );
  }

  String getApplyInfo() {
    if (widget.refundModel.type == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_sales_refund);
    } else if (widget.refundModel.type == 2) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_sales_return_refund);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_sales_overtime);
    }
  }

  Widget buildUpload() {
    return widget.refundModel.type == 2 ? Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0.w),
      decoration: BoxDecoration(
          border: Border.all(color: IConstant.grey_bg_color, width: 1.w),
          borderRadius: BorderRadius.circular(12.w)),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(10.w, 6.w, 0.w, 6.w),
            decoration: BoxDecoration(
                color: IConstant.line_color,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.w))),
            child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_upload_photo),
                style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
          ),
          SizedBox(height: 16.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: photoList.map((item) => buildUploadItem(item)).toList(),
          ),
          SizedBox(height: 16.w),
          Container(
            margin: EdgeInsets.only(left: 30.w, right: 30.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_upload_photo_tip1),
                style: TextStyle(
                    fontSize: 12.sp, color: IConstant.text_color)),
          ),
          Container(
            margin: EdgeInsets.only(left: 30.w, right: 30.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_upload_photo_tip2),
                style: TextStyle(
                    fontSize: 12.sp, color: IConstant.text_color)),
          ),
          SizedBox(height: 16.w),
        ],
      ),
    ) : Container();
  }

  Widget buildFee() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0.w),
      decoration: BoxDecoration(
          border: Border.all(color: IConstant.grey_bg_color, width: 1.w),
          borderRadius: BorderRadius.circular(12.w)),
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            children: [
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_return_amount),
                  style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
              expandeSpace,
              InkWell(
                onTap: () {
                  ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_coming_soon));
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(6.w, 3.w, 6.w, 3.w),
                  decoration: BoxDecoration(
                      border: Border.all(color: IConstant.grey_bg_color, width: 1.w),
                      borderRadius: BorderRadius.circular(12.w)),
                  child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_service_detail),
                      style: TextStyle(
                          fontSize: 12.sp, color: IConstant.text_color)),
                ),
              )
            ],
          ),
          SizedBox(height: 10.w),
          Row(
            children: [
              Expanded(flex: 2, child: buildReturnAmount()),
              Expanded(flex: 3, child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_total_service_fee),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 12.sp, color: IConstant.text_color))),
                  SizedBox(width: 4.w),
                  PriceText(0, fontSize: 14.sp, color: IConstant.text_color)
                ],
              )),
            ],
          )
        ],
      ),
    );
  }

  Widget buildReturnAmount() {
    return Container(
      alignment: Alignment.centerLeft,
      child: amountLoading ? LottieBuilder.asset(
        'assets/lotties/loading.json', width: 40.w, height: 40.w, repeat: true,
      ): PriceText(returnAmount <0? freightAmount : returnAmount, fontSize: 14.sp, color: IConstant.text_color),
    );
  }

  Widget buildRefundType() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 16.w),
      decoration: BoxDecoration(
          border: Border.all(color: IConstant.grey_bg_color, width: 1.w),
          borderRadius: BorderRadius.circular(12.w)),
      padding: EdgeInsets.all(16.w),
      child: InkWell(
        onTap: () {
          ShowBottomSheetTool().showSingleRowPicker(context, data: refundList, title: LanguageConfig.get(LanguageConfigKeys.Shop_product_select), normalIndex: refundIndex, clickCallBack: (int selectIndex, Object selectStr){
            setState(() {
              refundIndex = selectIndex;
            });
          });
        },
        child: Row(
          children: [
            Expanded(child:  Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_finish_route),
                style: TextStyle(fontSize: 12.sp, color: IConstant.text_color))),
            SizedBox(width: 20.w),
            Expanded(child: Text(refundList[refundIndex],
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp, color: IConstant.main_color))),
            Icon(Icons.chevron_right, size: 20.w, color: IConstant.main_color)
          ],
        ),
      ),
    );
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      child: Container(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        height: 60,
        child: buildButtons(),
      ),
    );
  }

  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // ExpandedOutlineText(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_contact_customer_service),
        //     textColor: IConstant.text_color,
        //     borderColor: IConstant.grey_line_color,
        //     bgColor: IConstant.white_color,
        //     fontSize: 12.sp, onTap: () => ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_coming_soon))),
        expandeSpace,
        expandeSpace,
        ExpandedOutlineText(text: LanguageConfig.get(LanguageConfigKeys.Shop_sales_apply_submit),
            fontSize: 12.sp, onTap: () => applyRefund()),
      ],
    );
  }

  Widget buildUploadItem(PhotoModel photoModel) {
    return TextUtils.isEmpty(photoModel.url) ? InkWell(
      onTap: () {
        selectPhoto = photoModel;
        showSelectionDialog(context);
      },
      child: Container(
        width: 60.w,
        height: 60.w,
        padding: EdgeInsets.only(top: 8.w),
        decoration: BoxDecoration(
            border: Border.all(color: IConstant.grey_bg_color, width: 1.w),
            borderRadius: BorderRadius.circular(12.w)),
        child: Column(
          children: [
            Image.asset("assets/icons/camera_red.png",
                width: 16.w, height: 16.w, color: IConstant.text_color),
            SizedBox(height: 10.w),
            Text("${photoModel.index + 1}/4",
                style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
          ],
        ),
      ),
    ) : Container(
        decoration: BoxDecoration(
            border: Border.all(color: IConstant.grey_bg_color, width: 1.w),
            borderRadius: BorderRadius.circular(12.w)),
      child: LoadImageView(60.w, 60.w, photoModel.url, fit: BoxFit.fill));
  }

  Widget buildTake() {
    String receiverName = BaseModel.getString(order, "receiverName");
    String receiverPhone = BaseModel.getString(order, "receiverPhone");
    String receiverProvince = BaseModel.getString(order, "receiverProvince");
    String receiverCity = BaseModel.getString(order, "receiverCity");
    String receiverRegion = BaseModel.getString(order, "receiverRegion");
    String receiverDetailAddress = BaseModel.getString(order, "receiverDetailAddress");
    return widget.refundModel.type == 2 ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 6.w),
          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_sales_take_info),
              style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
        ),
        InkWell(onTap: () {
          // showPop(0.7 * Adapt.getWindowHeight(), SelectAddressPage("",
          //   model: AddressModel.fromReceiver(receiverName, receiverPhone, receiverProvince, receiverCity, receiverRegion, receiverDetailAddress),
          // ));
        }, child: Container(
          margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 0.w),
          padding: EdgeInsets.fromLTRB(16.w, 10.w, 10.w, 10.w),
          decoration: BoxDecoration(
              color: IConstant.red_bg_color3,
              border: Border.all(width: 1.w, color: IConstant.main_color),
              borderRadius: BorderRadius.all(Radius.circular(15.w))),
          child: Row(
            children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$receiverName   $receiverPhone", style: TextStyle(fontSize: 13.sp, color: IConstant.title_color),),
                  Text(getAddressDetail(receiverProvince, receiverCity, receiverRegion, receiverDetailAddress), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
                ],
              )),
              // Icon(Icons.chevron_right, size: 24.w, color: IConstant.text_color)
            ],
          ),
        ))
      ],
    ) : Container();
  }

  String getAddressDetail(String province, String city, String region, String detailAddress) {
    return "$detailAddress $region $city $province";
  }

  void showSelectionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      builder: (ctx) {
        return SizedBox(
          height: 0.4 * Adapt.getWindowWidth(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(flex: 1, child: GestureDetector(
                child: buildSelectItem(context, LanguageConfig.get(LanguageConfigKeys.Shop_mine_take_picture)),
                onTap: (){
                  Navigator.pop(context);
                  getImage(ImageFrom.camera);
                },
              ),),
              Divider(height: 1.w),
              Expanded(flex: 1, child: GestureDetector(
                child: buildSelectItem(context, LanguageConfig.get(LanguageConfigKeys.Shop_mine_photo_album)),
                onTap: (){
                  Navigator.pop(context);
                  getImage(ImageFrom.gallery);
                },
              ),),
              Divider(height: 1.w),
              Expanded(flex: 1, child: GestureDetector(
                child: buildSelectItem(context, LanguageConfig.get(LanguageConfigKeys.Shop_mine_canceled)),
                onTap: (){
                  Navigator.pop(context);
                },
              ),),
            ],
          ),
        );
      },
    );
  }

  Widget buildSelectItem(BuildContext context, String title) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text(
          title,
          style: TextStyle(fontSize: 16.w, color: IConstant.text_color),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> getImage(ImageFrom imageFrom) async {
    XFile pickerImage = await ImageUtil.pickSinglePic(imageFrom);
    CroppedFile croppedFile = await ImageUtil.cropImage(
        image: pickerImage,
        width: 1000,
        height: 1000);
    List<String> files = [];
    files.add(croppedFile.path);
    BaseRsp rsp = await HttpUtils.uploadFile(IURLConstant.MALL_PARSE_FILES, {}, files);
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        if (selectPhoto != null) {
          photoList[selectPhoto!.index].url = rsp.data["url"];
        }
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  Future<void> applyRefund() async {
    if (widget.refundModel.type == 2 && photoList.length < 2) {
      ViewUtils.displayToast( ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_sales_least_two_pictures)));
      return;
    }
    String photos = "";
    for(PhotoModel item in photoList) {
      if (TextUtils.isNotEmpty(item.url)) {
        photos += "${item.url},";
      }
    }
    if (TextUtils.isNotEmpty(photos)) {
      photos = photos.substring(0, photos.length - 1);
    }
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.postJSON(IURLConstant.MALL_RETRUN_APPLY_CREATE, null, body: {
      "orderId": BaseModel.getString(order, "id"),
      "orderSn": BaseModel.getString(order, "orderSn"),
      "orderItemId": BaseModel.getString(orderItem, "id"),
      "productId": BaseModel.getString(orderItem, "productId"),
      "productCount": BaseModel.getString(orderItem, "productQuantity"),
      "reason": reasonList[reasonIndex],
      "type": widget.refundModel.type,
      "proofPics": photos,
      "reasonId": widget.refundModel.reasonId,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      couponReturnTip();
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  Future<void> couponReturnTip() async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_RETURN_CREATE_COUPON, {
      "orderItemId": BaseModel.getString(orderItem, "id"),
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<dynamic> couponList = rsp.data;
      if (couponList.isEmpty) {
        showPop(0.3 * Adapt.getWindowHeight(), CommResultPage(
            title: LanguageConfig.get(LanguageConfigKeys.Base_submit_hint),
            message: Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_sales_verify_tip3), [ BaseModel.getInt(systemSettingsInfo, 'automaticRefundTime') ]), style: TextStyle(fontSize: 14.sp, color: IConstant.title_color)),
            callBack: (BuildContext ctx) {
              finishContext(ctx);
              backHome();
              nextPage(AfterSalesPage("-1"), false);
            }), enableDrag: false
        );
      } else {
        showPop(0.8 * Adapt.getWindowHeight(), ReturnCouponPage(couponList, (ctx) { //退回优惠券
          finishContext(ctx);
          backHome();
          nextPage(AfterSalesPage("-1"), false);
        }),enableDrag: false);
      }
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

}
