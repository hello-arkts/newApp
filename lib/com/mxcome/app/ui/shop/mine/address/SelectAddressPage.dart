
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/AddressEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/AddressModel.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IURLConstant.dart';
import '../../../../config/LanguageConfig.dart';
import '../../../../model/BaseModel.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/Adapt.dart';
import '../../../../utils/HttpUtils.dart';
import '../../../../utils/ViewUtils.dart';
import '../../utils/EventBusUtil.dart';
import '../../widget/IconTextButton.dart';
import 'EditAddressPage.dart';

class SelectAddressPage extends StatefulWidget {

  String id;
  AddressModel? model;

  SelectAddressPage(this.id, { this.model });

  @override
  State<StatefulWidget> createState() {
    return SelectAddressPageState();
  }

}

class SelectAddressPageState extends BaseKeepAliveState<SelectAddressPage> {

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
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_MEMBER_ADDRESS_LIST, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<AddressModel> tempList = [];
      for (var item in rsp.data) {
        String id = BaseModel.getString(item, "id");
        String name = BaseModel.getString(item, "name");
        String phoneNumber = BaseModel.getString(item, "phoneNumber");
        String province = BaseModel.getString(item, "province");
        String city = BaseModel.getString(item, "city");
        String region = BaseModel.getString(item, "region");
        String detailAddress = BaseModel.getString(item, "detailAddress");
        if (TextUtils.isNotEmpty(id) && widget.id == id) {
          tempList.add(AddressModel.fromJson(item, true));
        } else if(widget.model != null
            && widget.model?.name == name
            && widget.model?.phoneNumber == phoneNumber
            && widget.model?.province == province
            && widget.model?.city == city
            && widget.model?.region == region
            && widget.model?.detailAddress == detailAddress) {
          tempList.add(AddressModel.fromJson(item, true));
        } else {
          tempList.add(AddressModel.fromJson(item, false));
        }
      }
      AddressModel? model;
      for (var item in tempList) {
        if (item.defaultStatus == "1") {
          model = item;
          break;
        }
      }
      if(model != null) {
        tempList.remove(model);
        tempList.insert(0, model);
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
        elevation: 0.w,
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

  Widget buildListItem(int index) {
    if (index == addressList.length) {
      return Container(
        margin: EdgeInsets.all(16.w),
        child: IconTextButton(
          bgColor: IConstant.line_color,
          textColor: IConstant.title_color,
          onTap: () {
            showPop(0.9 * Adapt.getWindowHeight(), EditAddressPage(null));
          },
          icon: Icon(Icons.add, size: 16.w, color: IConstant.title_color),
          text: LanguageConfig.get(LanguageConfigKeys.Shop_address_add_receipt_address),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          setSelectModel(addressList[index]);
          callbackSelect();
        },
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
              border: Border.all(width: 0.5.w, color: getSelectColor(addressList[index])),
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

  Widget buildTitle(AddressModel address, index){
    return address.defaultStatus == "1" ?
    Row(
      children: [
        Image.asset('assets/icons/radio_selected.png', height: 20.w, color: getSelectColor(address)),
        SizedBox(width: 8.w),
        Text("${address.name}  ${address.phoneNumber}", style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
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
        Image.asset('assets/icons/radio_selected.png', height: 20.w, color: getSelectColor(address)),
        SizedBox(width: 8.w),
        Text("${address.name}  ${address.phoneNumber}", style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
        expandeSpace,
        buildSelectButton(address, index),
      ],
    );
  }

  Widget buildSubTitle(AddressModel address){
    return address.defaultStatus == "1" ?
    Text(getAddressDetail(address), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)) :
    Text(getAddressDetail(address), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color));
  }

  Widget buildSelectButton(AddressModel address, int index){
    return InkWell(
      onTap: () {
        showPop(0.9 * Adapt.getWindowHeight(), EditAddressPage(address.toJson()));
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



  String getAddressDetail(AddressModel address){
    if (TextUtils.isNotEmpty(address.placeId)) return address.detailAddress;
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

  callbackSelect(){
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
    finishContext(context);
    EventBusUtil.getInstance().emit(AddressEvent(address: selectModel.toJson(), operateStatus: OperateStatus.select));
  }

  Color getSelectColor(AddressModel address){
    return address.isSelect ? IConstant.main_color : IConstant.line_color2;
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
      EventBusUtil.getInstance().emit(AddressEvent(address: item.toJson(), operateStatus: OperateStatus.delete));
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

}
