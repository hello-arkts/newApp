
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/AddressEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/AddressModel.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IURLConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseModel.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/Adapt.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../mine/address/EditAddressPage.dart';
import '../utils/EventBusUtil.dart';
import '../widget/BigTextButton.dart';
import '../widget/OutlineTextButton.dart';


class ChangeAddressPage extends StatefulWidget {

  dynamic order;

  ChangeAddressPage(this.order);

  @override
  State<StatefulWidget> createState() {
    return ChangeAddressPageState();
  }

}

class ChangeAddressPageState extends BaseKeepAliveState<ChangeAddressPage> {

  List<AddressModel> addressList = [];
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
    String receiverName = BaseModel.getString(widget.order, "receiverName");
    String receiverPhone = BaseModel.getString(widget.order, "receiverPhone");
    String receiverProvince = BaseModel.getString(widget.order, "receiverProvince");
    String receiverCity = BaseModel.getString(widget.order, "receiverCity");
    String receiverRegion = BaseModel.getString(widget.order, "receiverRegion");
    String receiverDetailAddress = BaseModel.getString(widget.order, "receiverDetailAddress");
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_MEMBER_ADDRESS_LIST, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<AddressModel> tempList = [];
      List<dynamic> list = rsp.data;
      for (var item in list){
        String name = BaseModel.getString(item, "name");
        String phoneNumber = BaseModel.getString(item, "phoneNumber");
        String province = BaseModel.getString(item, "province");
        String city = BaseModel.getString(item, "city");
        String region = BaseModel.getString(item, "region");
        String detailAddress = BaseModel.getString(item, "detailAddress");
        if (receiverName == name
            && receiverPhone == phoneNumber
            && receiverProvince == province
            && receiverCity == city
            && receiverRegion == region
            && receiverDetailAddress == detailAddress
        ) {
          tempList.add(AddressModel.fromJson(item, true));
        } else {
          tempList.add(AddressModel.fromJson(item, false));
        }
      }
      setState(() {
        addressList = tempList;
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
        elevation: 0.5.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_change_address),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
        actions: [
          Container(
            margin: EdgeInsets.fromLTRB(10.w, 10.w, 14.w, 10.w),
            child: OutlineTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_address_add), onTap: () {
              showPop(0.8 * Adapt.getWindowHeight(), EditAddressPage(null));
            }),
          )
        ],
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildBody() {
    if (addressList.isEmpty) {
      return buildHeader();
    } else {
      return ListView.separated(
          scrollDirection: Axis.vertical,
          itemCount: addressList.length,
          itemBuilder: (context, index) {
            return buildListItem(index);
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 10.w);
          });
    }
  }

  Widget buildListItem(int index) {
    return InkWell(
      onTap: () {
        setSelectModel(addressList[index]);
      },
      onLongPress: (){
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
            color: defaultBgColor(addressList[index]),
            border: Border.all(width: 0.5.w, color: defaultBorderColor(addressList[index])),
            borderRadius: BorderRadius.all(Radius.circular(18.w))),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: getIcon(addressList[index].isSelect),
            ),
            SizedBox(width: 8.w),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTitle(addressList[index]),
                buildSubTitle(addressList[index]),
              ],
            )),
            buildSelectButton(addressList[index], index),
          ],
        ),
      ),
    );
  }

  Color defaultBorderColor(AddressModel address){
    return IConstant.grey_color;
  }

  Color defaultBgColor(AddressModel address){
    return address.isSelect ? IConstant.red_bg_color3 : IConstant.white_color;
  }

  Widget getIcon(bool check) {
    return check
        ? const Icon(Icons.check_circle, color: IConstant.main_color)
        : const Icon(Icons.circle, color: IConstant.grey_bg_color);
  }

  Widget buildTitle(AddressModel address){
    return address.defaultStatus == "1" ?
    Row(
      children: [
        Text("${address.name}  ${address.phoneNumber}", style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
        SizedBox(width: 8.w),
        Container(
          padding: EdgeInsets.fromLTRB(4.w, 2.w, 4.w, 2.w),
          decoration: BoxDecoration(
            color: IConstant.main_color,
            borderRadius: BorderRadius.all(Radius.circular(4.w)),
          ),
          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_address_default), style: TextStyle(fontSize: 10.sp, color: IConstant.white_color)),
        )
      ],
    ):
    Text("${address.name}  ${address.phoneNumber}", style: TextStyle(fontSize: 14.sp, color: IConstant.text_color));
  }

  Widget buildSubTitle(AddressModel address){
    return address.defaultStatus == "1" ?
    Text(getAddressDetail(address), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)) :
    Text(getAddressDetail(address), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14.sp, color: IConstant.text_color));
  }

  Widget buildSelectButton(AddressModel address, int index){
    return InkWell(
      onTap: () {
        showPop(0.8 * Adapt.getWindowHeight(), EditAddressPage(address.toJson()));
      },
      child: Row(
        children: [
          SizedBox(width: 10.w),
          Icon(Icons.edit, size: 22.w, color: IConstant.grey_color),
          SizedBox(width: 10.w)
        ],
      ),
    );
  }

  updateAddress() async {
    AddressModel? selectModel;
    for (AddressModel model in addressList) {
      if (model.isSelect) {
        selectModel = model;
      }
    }
    if (selectModel == null) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_address_select_change));
      return;
    }
    String orderId = BaseModel.getString(widget.order, "id");
    ViewUtils.show();
    String url = IURLConstant.MALL_UPDATE_ADDRESS;
    BaseRsp rsp = await HttpUtils.post(url, {
      "memberAddressId": selectModel.id,
      "orderShopId": orderId,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      ViewUtils.displayToast(rsp.msg);
      setState(() {
        finishContext(context);
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  String getAddressDetail(AddressModel address){
    return "${address.detailAddress} ${address.region} ${address.city} ${address.province} ${address.postCode}";
  }

  setSelectModel(AddressModel value) {
     setState(() {
       for( AddressModel item in addressList){
         item.isSelect = false;
       }
       value.isSelect = true;
     });
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      child: Container(
        margin: EdgeInsets.all(20.w),
        child: BigTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_confirm_change), onTap: () {
          updateAddress();
        }),
      ),
    );
  }

  Future<void> delete(AddressModel item) async {
    ViewUtils.show();
    String id = item.id;
    String url = "${IURLConstant.MALL_MEMBER_ADDRESS_DELETE}$id";
    BaseRsp rsp = await HttpUtils.post(url, {
      "id": id
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      ViewUtils.displayToast(rsp.msg);
      EventBusUtil.getInstance().emit(AddressEvent());
      finish();
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

}
