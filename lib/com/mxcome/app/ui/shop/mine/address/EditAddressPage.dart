import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/IURLConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/model/BaseRsp.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/AddressEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/GeoModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/BigTextButton.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/OutlineBigTextButton.dart';
import 'package:mxcome/com/mxcome/app/utils/Adapt.dart';
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import 'package:mxcome/com/mxcome/app/widget/PartRefreshWidget.dart';

import 'GeoAddressConfirmPage.dart';
import 'SelectDetailAddressPage.dart';

class EditAddressPage extends StatefulWidget {

  dynamic address;

  EditAddressPage(this.address);

  @override
  State<StatefulWidget> createState() {
    return EditAddressPageState();
  }

}

class EditAddressPageState extends BaseKeepAliveState<EditAddressPage> {
  bool defaultStatus = false;
  String detailAddress = '';
  String id = '';
  String name = '';
  String phoneNumber = '';
  String postCode = '';
  String province = '';
  String city = '';
  String region = '';
  String regionCode = '';
  String showDetailAddress = LanguageConfig.get(LanguageConfigKeys.Shop_address_please_select);

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();

  String language = FormatUtil.getAddressLanguage();

  bool isGoogleList = false;

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      id = BaseModel.getString(widget.address, "id");
      defaultStatus = BaseModel.getString(widget.address, "defaultStatus") == '1' ? true : false;
      detailAddress = BaseModel.getString(widget.address, "detailAddress");
      name = BaseModel.getString( widget.address, "name");
      phoneNumber = BaseModel.getString(widget.address, "phoneNumber");
      province = BaseModel.getString(widget.address, "province");
      city = BaseModel.getString(widget.address, "city");
      region = BaseModel.getString(widget.address, "region");
      regionCode = BaseModel.getString(widget.address, "regionCode");
      postCode = BaseModel.getString(widget.address, "postCode");
      checkInput();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return KeyboardDismissOnTap(child: Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        title: id == '' ? Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_receive_address),
            style: TextStyle(fontSize: 17.w, color: IConstant.text_color)
        ) : Text(LanguageConfig.get(LanguageConfigKeys.Shop_address_edit_receipt_address),
            style: TextStyle(fontSize: 17.w, color: IConstant.text_color)
        ),
      ),
      body: SingleChildScrollView(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 16.w, right: 16.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_address_consignee),
                style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
          ),
          Container(
            margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.w),
            child: TextField(
              textInputAction: TextInputAction.next,
              maxLines: 1,
              keyboardType: TextInputType.text,
              focusNode: _nodeText1,
              style: TextStyle(color: IConstant.text_color, fontSize: 13.sp),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: IConstant.line_color, width: 1.w),
                    borderRadius: BorderRadius.circular(10.w)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: IConstant.line_color, width: 1.w),
                    borderRadius: BorderRadius.circular(10.w)
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: IConstant.line_color, width: 1.w),
                    borderRadius: BorderRadius.circular(10.w)
                ),
                labelText: LanguageConfig.get(LanguageConfigKeys.Shop_address_consignee_empty),
                labelStyle: TextStyle(fontSize: 13.sp, color: IConstant.grey_color),
              ),
              controller: ViewUtils.buildTextEditingController(name),
              onChanged: (str) {
                name = str;
                checkInput();
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.w),
            child: TextField(
              textInputAction: TextInputAction.next,
              maxLines: 1,
              keyboardType: TextInputType.phone,
              focusNode: _nodeText2,
              style: TextStyle(color: IConstant.text_color, fontSize: 13.sp),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: IConstant.line_color, width: 1.w),
                    borderRadius: BorderRadius.circular(10.w)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: IConstant.line_color, width: 1.w),
                    borderRadius: BorderRadius.circular(10.w)
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: IConstant.line_color, width: 1.w),
                    borderRadius: BorderRadius.circular(10.w)
                ),
                labelText: LanguageConfig.get(LanguageConfigKeys.Shop_address_phone_empty),
                labelStyle: TextStyle(fontSize: 13.sp, color: IConstant.grey_color),
              ),
              controller: ViewUtils.buildTextEditingController(phoneNumber),
              onChanged: (str) {
                phoneNumber = str;
                checkInput();
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 16.w, top: 16.w, right: 16.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_address_detail_address),
                style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
          ),
          InkWell(
            onTap: () {
              // if(!check()) return;
              if (TextUtils.isEmpty(id)) {
                showPop(0.8 * Adapt.getWindowHeight(), SelectDetailAddressPage(name, phoneNumber));
              } else {
                GeoModel model = GeoModel(id, name, phoneNumber, province, city, region, regionCode, postCode, detailAddress, defaultStatus);
                showPop(0.92 * Adapt.getWindowHeight(), GeoAddressConfirmPage(model));
              }
            },
            child: Container(
              margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.w),
              decoration: BoxDecoration(border: Border.all(color: IConstant.line_color, width: 1.w), borderRadius: BorderRadius.circular(10.w)),
              child: ListTile(
                title: Text(showDetailAddress, maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
                trailing: Icon(Icons.chevron_right, size: 20.w, color: IConstant.sub_text_color),
              ),
            ),
          ),
        ],
      )),
      bottomNavigationBar: buildBottomBar(),
    ));
  }

  buildDefaultStatus() {
    return InkWell(
      onTap: () {
        setState((){
          defaultStatus = !defaultStatus;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(LanguageConfig.get(LanguageConfigKeys.Shop_address_set_as_default_address), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
          Image.asset("assets/icons/${ defaultStatus ? "switch_active": "switch_default"}.png", width: 40.w,)
        ],),
    );
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      elevation: 0.w,
      height: 190.w,
      child: Container(
        padding: EdgeInsets.fromLTRB(18.w, 0.w, 18.w, 18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDefaultStatus(),
            SizedBox(height: 16.w),
            Text(LanguageConfig.get(LanguageConfigKeys.Shop_address_confirm_delivery_correct),
              maxLines: 2, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color),),
            expandeSpace,
            Container(
              margin: EdgeInsets.fromLTRB(16.w, 4.w, 16.w, 6.w),
              child:  Row(
                children: [
                  SizedBox(width: 14.w,),
                  Expanded(flex: 2, child: OutlineBigTextButton(text:  id == '' ? LanguageConfig.get(LanguageConfigKeys.Base_clean_up) : LanguageConfig.get(LanguageConfigKeys.Base_delete),
                      left: 20.w,
                      right: 20.w,
                      bgColor: IConstant.white_color,
                      borderColor: IConstant.line_color,
                      textColor: IConstant.text_color,
                      onTap: () {
                        if (id == '') {
                          clear();
                        } else {
                          deleteDialog();
                        }
                      }),),
                  expandeSpace,
                  Expanded(flex: 2, child: PartRefreshWidget(refreshBtn, () => BigTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_address_finish), enable: isClickEnable, onTap: () {
                    if (id == '') {
                      add();
                    } else {
                      update();
                    }
                  }))),
                  SizedBox(width: 14.w,),
                ],
              ),
            )
          ],
        ),
      )
    );
  }

  void setResult(GeoModel geoModel) {
     setState(() {
       province = geoModel.province;
       city = geoModel.city;
       region = geoModel.region;
       regionCode = geoModel.regionCode;
       postCode = geoModel.postCode;
       detailAddress = geoModel.detailAddress;
     });
     setAddressDetail();
     checkInput();
  }

  bool check() {
    if (TextUtils.isEmpty(name)) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_address_consignee_empty));
      return false;
    }
    if (TextUtils.isEmpty(phoneNumber)) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_address_phone_empty));
      return false;
    }
    return true;
  }

  Future<void> add() async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.postJSON(IURLConstant.MALL_MEMBER_ADDRESS_ADD, {
      "id": id,
      "defaultStatus": defaultStatus ? "1" : "0",
      "detailAddress": detailAddress,
      "name": name,
      "phoneNumber": phoneNumber,
      "postCode": postCode,
      "province": province,
      "city": city,
      "region": region,
      "regionCode": regionCode,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_operation_successful));
      setState(() {
        finishContext(context);
      });
      EventBusUtil.getInstance().emit(AddressEvent(operateStatus: OperateStatus.add));
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  Future<void> update() async {
    ViewUtils.show();
    String url = "${IURLConstant.MALL_MEMBER_ADDRESS_UPDATE}$id";
    dynamic params = {
      "id": id,
      "defaultStatus": defaultStatus ? "1" : "0",
      "detailAddress": detailAddress,
      "name": name,
      "phoneNumber": phoneNumber,
      "postCode": postCode,
      "province": province,
      "city": city,
      "region": region,
      "regionCode": regionCode,
    };
    BaseRsp rsp = await HttpUtils.postJSON(url, params);
    if (rsp.retCode == RspRetCode.SUCCESS) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_operation_successful));
      EventBusUtil.getInstance().emit(AddressEvent(address: params, operateStatus: OperateStatus.update));
      finish();
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  void clear() {
    setState(() {
      defaultStatus = false;
      detailAddress = '';
      name = '';
      phoneNumber = '';
      postCode = '';
      province = '';
      city = '';
      region = '';
      isGoogleList = false;
      showDetailAddress = LanguageConfig.get(LanguageConfigKeys.Shop_address_please_select);
    });
    checkInput();
  }

  void deleteDialog() {
    ViewUtils.showConfirmDialog(context, LanguageConfig.get(LanguageConfigKeys.Shop_address_is_delete), (ctx, bl) {
      if (bl) {
        finishContext(ctx);
        delete();
      } else {
        finishContext(ctx);
      }
    });
  }

  Future<void> delete() async {
    ViewUtils.show();
    String url = "${IURLConstant.MALL_MEMBER_ADDRESS_DELETE}$id";
    BaseRsp rsp = await HttpUtils.post(url, {
      "id": id
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_operation_successful));
      EventBusUtil.getInstance().emit(AddressEvent(address: widget.address, operateStatus: OperateStatus.delete));
      finish();
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  GlobalKey<PartRefreshWidgetState> refreshBtn = GlobalKey();

  bool isClickEnable = false;

  void checkInput() {
    if (TextUtils.isNotEmpty(detailAddress)) {
      setAddressDetail();
      if (TextUtils.isNotEmpty(phoneNumber) && TextUtils.isNotEmpty(name)) {
        if (isClickEnable) return;
        isClickEnable = true;
      } else {
        if (!isClickEnable) return;
        isClickEnable = false;
      }
      refreshBtn.currentState?.update();
    } else {
      if (!isClickEnable) return;
      isClickEnable = false;
      refreshBtn.currentState?.update();
    }
  }

  void setAddressDetail() {
    setState(() {
      showDetailAddress = "$detailAddress $region $city $province $postCode";
    });
  }
}
