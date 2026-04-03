import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/IURLConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/model/BaseRsp.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/AddressEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/IconTextButton.dart';
import 'package:mxcome/com/mxcome/app/utils/Adapt.dart';
import 'package:mxcome/com/mxcome/app/utils/AppUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import '../address/EditAddressPage.dart';


class AddressListPage extends StatefulWidget {

  AddressListPage();

  @override
  State<StatefulWidget> createState() {
    return AddressListPageState();
  }

}

class AddressListPageState extends BaseKeepAliveState<AddressListPage> {

  dynamic addressList = [];

  dynamic addressEvent;

  @override
  void initState() {
    super.initState();
    loadContentDatas();
    addressEvent = EventBusUtil.getInstance().on<AddressEvent>((event) {
      loadContentDatas();
    });
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(addressEvent);
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    isLoading = true;
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_MEMBER_ADDRESS_LIST, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        addressList = rsp.data;
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
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_address_receipt_address),
            style: TextStyle(fontSize: 17.w, color: IConstant.text_color)),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return ListView.separated(
        scrollDirection: Axis.vertical,
        itemCount: addressList.length + 1,
        itemBuilder: (context, index) {
          return buildListItem(index);
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 10.w);
        });
  }

  Color defaultBorderColor(dynamic address){
    return address["defaultStatus"].toString() == "1" ?
    IConstant.main_color:
    IConstant.grey_color;
  }

  Color defaultBgColor(dynamic address){
    return address["defaultStatus"].toString() == "1" ?
        IConstant.red_bg_color:
        IConstant.white_color;
  }

  Widget buildListItem(int index) {
    if (index == addressList.length) {
      return Container(
        margin: EdgeInsets.all(16.w),
        child: IconTextButton(
          bgColor: IConstant.line_color,

          onTap: () async {
            if (!await AppUtils.isLogined()) {
              toLogin((ctx) {
                finish();
                loadContentDatas();
              });
            } else {
              showPop(0.92 * Adapt.getWindowHeight(), EditAddressPage(null));
            }
          },
          icon: Icon(Icons.add, size: 20.w, color: IConstant.black_color),
          fontSize: 16.sp,
          textColor: IConstant.black_color,
          text: LanguageConfig.get(LanguageConfigKeys.Shop_address_add_receipt_info),
        ),
      );
    } else {
      return InkWell(
        onLongPress: () {
          ViewUtils.showConfirmDialog(context, LanguageConfig.get(LanguageConfigKeys.Shop_address_is_delete), (context, bl) => {
            if (bl) {
              delete(addressList[index])
            } else {
              Navigator.of(context).pop()
            }
          });
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 0),
          padding: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 12.w),
          decoration: BoxDecoration(
              border: Border.all(width: 1.w, color: IConstant.line_color),
              borderRadius: BorderRadius.all(Radius.circular(12.w))),
          child: Row(
            children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTitle(addressList[index], index),
                  buildSubTitle(addressList[index]),
                ],
              )),
            ],
          ),
        ),
      );
    }
  }

  Widget buildTitle(dynamic address, index){
    return address["defaultStatus"].toString() == "1" ?
    Row(
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: 200.w
          ),
          child: Text("${address["name"]}  ${address["phoneNumber"]}",
              maxLines: 2, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.text_color)),
        ),
        SizedBox(width: 8.w),
        Container(
          padding: EdgeInsets.fromLTRB(4.w, 2.w, 4.w, 2.w),
          decoration: BoxDecoration(
            border: Border.all(width: 1.w, color: IConstant.main_color),
            borderRadius: BorderRadius.all(Radius.circular(4.w)),
          ),
          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_address_default), style: TextStyle(fontSize: 10.sp, color: IConstant.main_color)),
        ),
        expandeSpace,
        buildSelectButton(address, index),
      ],
    ):
    Row(
      children: [
        Container(
          constraints: BoxConstraints(
              maxWidth: 200.w
          ),
          child: Text("${address["name"]}  ${address["phoneNumber"]}",
              maxLines: 2, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.text_color)),
        ),
        expandeSpace,
        buildSelectButton(address, index),
      ],
    );
  }

  Widget buildSubTitle(dynamic address){
    return Text(getAddressDetail(address), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color));
  }

  Widget buildSelectButton(dynamic address, int index){
    return InkWell(onTap: () {
      showPop(0.92 * Adapt.getWindowHeight(), EditAddressPage(address));
    }, child: Icon(Icons.edit, size: 22.w, color: IConstant.grey_color));
  }

  String getAddressDetail(dynamic address){
    if (BaseModel.isNotEmpty(address, "placeId")) {
      return "${address["detailAddress"]}";
    }
    return "${address["detailAddress"]} ${address["region"]} ${address["city"]} ${address["province"]} ${address["postCode"]}";
  }

  Future<void> delete(dynamic item) async {
    ViewUtils.show();
    String id = item["id"].toString();
    String url = "${IURLConstant.MALL_MEMBER_ADDRESS_DELETE}$id";
    BaseRsp rsp = await HttpUtils.post(url, {
      "id": id
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      ViewUtils.displayToast(rsp.msg);
      EventBusUtil.getInstance().emit(AddressEvent(address: item, operateStatus: OperateStatus.delete));
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

}
