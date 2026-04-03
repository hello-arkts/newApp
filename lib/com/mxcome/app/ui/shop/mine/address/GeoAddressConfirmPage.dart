import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/IURLConstant.dart';
import 'package:mxcome/com/mxcome/app/Logger.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/model/BaseRsp.dart';
import 'package:mxcome/com/mxcome/app/ui/LanguagePage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/AddressEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/GeoModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/BigTextButton.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/OutlineBigTextButton.dart';
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import 'package:mxcome/com/mxcome/app/widget/PartRefreshWidget.dart';

class GeoAddressConfirmPage extends StatefulWidget {

  GeoModel model;

  GeoAddressConfirmPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return GeoAddressConfirmPageState();
  }

}

class GeoAddressConfirmPageState extends BaseKeepAliveState<GeoAddressConfirmPage> {

  String id = '';
  String name = '';
  String phoneNumber = '';
  String provinceName = '';
  String cityName = '';
  String regionName = '';
  String regionCode = '';
  String postCode = '';
  String detailAddress = '';
  bool defaultStatus = false;

  List<dynamic> provinceList = [];
  List<dynamic> cityList = [];
  List<dynamic> regionList = [];
  List<dynamic> postCodeList = [];

  int provinceIndex = 0;
  int cityIndex = 0;
  int regionIndex = 0;
  int postCodeIndex = 0;

  String pleaseSelect =  LanguageConfig.get(LanguageConfigKeys.Shop_address_please_select);

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();

  @override
  void initState() {
    super.initState();
    id = widget.model.id;
    name = widget.model.name;
    phoneNumber = widget.model.phoneNumber;
    provinceName = widget.model.province;
    cityName = widget.model.city;
    regionName = widget.model.region;
    regionCode = widget.model.regionCode;
    postCode = widget.model.postCode;
    detailAddress = widget.model.detailAddress;
    defaultStatus = widget.model.defaultStatus;
    loadContentDatas();
    checkInput();
  }

  @override
  Future<void> loadContentDatas() async {
    loadLevelRegion(3, regionName);
  }

  loadLevelRegion(int level, String name) async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_UTIL_GET_REGION, {
      "isSameLevel" : "1",
      "level": "$level",
      "name": name
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      if (level == 3) {
        if (TextUtils.isNotEmpty(rsp.data)) {
          List<dynamic> tempList = rsp.data;
          int index = findRegion(tempList, name);
          setState(() {
            regionList = tempList;
            regionIndex = index;
            String postalCode = BaseModel.getString(tempList[index], "postalCode");
            List<String> postalCodeArr = postalCode.split(',');
            List<dynamic> childList = [];
            if (postalCodeArr.isNotEmpty && postalCodeArr.length > 1) {
              for (int i = 0; i < postalCodeArr.length; i++) {
                dynamic item = postalCodeArr[i];
                childList.add({"name": item, "enName": item});
                if (postCode == item) {
                  postCodeIndex = i;
                }
              }
              postCodeList = childList;
            } else {
              postCodeIndex = 0;
              String firstItem = postalCodeArr[postCodeIndex];
              childList.add({"name": firstItem, "enName": firstItem});
              postCodeList = childList;
            }
          });
        }
        loadLevelRegion(2, cityName);
      } else if(level == 2) {
        if (TextUtils.isNotEmpty(rsp.data)) {
          List<dynamic> tempList = rsp.data;
          int index = findRegion(tempList, name);
          setState(() {
            cityList = tempList;
            cityIndex = index;
          });
        }
        loadLevelRegion(1, provinceName);
      } else if (level == 1) {
        if (TextUtils.isNotEmpty(rsp.data)) {
          List<dynamic> tempList = rsp.data;
          int index = findRegion(tempList, name);
          setState(() {
            provinceList = tempList;
            provinceIndex = index;
          });
          checkInput();
        } else {
          ViewUtils.show();
          BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_UTIL_GET_REGION, {"level": "1"});
          if (rsp.retCode == RspRetCode.SUCCESS) {
            List<dynamic> tempList = rsp.data;
            setState(() {
              provinceList = tempList;
            });
            checkInput();
          }
          ViewUtils.dismiss();
        }
      }
    }
  }

  int findRegion(List<dynamic> regionList, String name) {
    int index = 0;
    for (int i=0 ; i<regionList.length; i++) {
      dynamic item = regionList[i];
      if (item["name"] == name || item["enName"] == name) {
        index = i;
        break;
      }
    }
    return index;
  }

  RegExp _filterPattern = RegExp("[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]");

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return KeyboardDismissOnTap(child: Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
      elevation: 0.w,
      centerTitle: true,
      title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_receive_address),
          style: TextStyle(fontSize: 17.w, color: IConstant.text_color))),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            margin: EdgeInsets.only(left: 16.w, right: 16.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_address_consignee),
                style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
          ),
          Container(
            margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.w),
            decoration: BoxDecoration(
                border: Border.all(width: 1.w, color: IConstant.grey_color),
                borderRadius: BorderRadius.all(Radius.circular(10.w))
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    focusNode: _nodeText1,
                    // inputFormatters: [
                    //   FilteringTextInputFormatter.deny(_filterPattern),
                    // ],
                    style: TextStyle(color: IConstant.title_color, fontSize: 14.sp),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: LanguageConfig.get(LanguageConfigKeys.Shop_mine_name),
                      labelStyle: TextStyle(fontSize: 13.sp, color: IConstant.grey_color),
                      suffixIcon: Icon(Icons.edit, color: IConstant.text_color, size: 12.w),
                    ),
                    controller: ViewUtils.buildTextEditingController(name),
                    onChanged: (str) {
                      name = str;
                      checkInput();
                    },
                  ),
                ),
                Container(height: 1.w, color: IConstant.line_color,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    maxLines: 1,
                    keyboardType: TextInputType.phone,
                    focusNode: _nodeText2,
                    style: TextStyle(color: IConstant.title_color, fontSize: 14.sp),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: LanguageConfig.get(LanguageConfigKeys.Shop_address_phone),
                      labelStyle: TextStyle(fontSize: 13.sp, color: IConstant.grey_color),
                      suffixIcon: Icon(Icons.edit, color: IConstant.text_color, size: 12.w),
                    ),
                    controller: ViewUtils.buildTextEditingController(phoneNumber),
                    onChanged: (str) {
                      phoneNumber = str;
                      checkInput();
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 16.w, top: 10.w, right: 16.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_address_detail_address),
                style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
          ),
          Container(
            margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.w),
            decoration: BoxDecoration(
                border: Border.all(width: 1.w, color: IConstant.grey_color),
                borderRadius: BorderRadius.all(Radius.circular(10.w))
            ),
            child: Column(
              children: [
                PopupMenuButton(
                  constraints: BoxConstraints(
                      maxHeight: 260.w
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  itemBuilder: (BuildContext context) {
                    return listToPopupMenu(provinceList);
                  },
                  position: PopupMenuPosition.under,
                  onSelected: (dynamic value) {
                    _nodeText3.unfocus();
                    provinceIndex = int.parse(value);
                    dynamic province = provinceList[provinceIndex];
                    provinceName = getName(province);
                    String provinceCode = province["code"];
                    loadCityReselect(provinceCode);
                  },
                  child: ListTile(
                    title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_address_government), style: TextStyle(fontSize: 13.sp, color: IConstant.grey_color),),
                    subtitle: Text(provinceName, style: TextStyle(fontSize: 13.sp, color: IConstant.title_color),),
                    trailing: Icon(Icons.keyboard_arrow_down, size: 20.w, color: IConstant.sub_text_color),
                  ),
                ),
                Container(height: 1.w, color: IConstant.line_color,),
                PopupMenuButton(
                  constraints: BoxConstraints(
                      maxHeight: 260.w
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  itemBuilder: (BuildContext context) {
                    return listToPopupMenu(cityList);
                  },
                  position: PopupMenuPosition.under,
                  onSelected: (dynamic value) {
                    _nodeText3.unfocus();
                    cityIndex = int.parse(value);
                    dynamic city = cityList[cityIndex];
                    cityName = getName(city);
                    String cityCode = city["code"];
                    loadRegionReselect(cityCode);
                  },
                  child: ListTile(
                    title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_address_county), style: TextStyle(fontSize: 13.sp, color: IConstant.grey_color),),
                    subtitle: Text(cityName, style: TextStyle(fontSize: 13.sp, color: cityList.isEmpty ? IConstant.main_color : IConstant.title_color),),
                    trailing: Icon(Icons.keyboard_arrow_down, size: 20.w, color: IConstant.sub_text_color),
                  ),
                ),
                Container(height: 1.w, color: IConstant.line_color,),
                PopupMenuButton(
                  constraints: BoxConstraints(
                      maxHeight: 260.w
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  position: PopupMenuPosition.under,
                  itemBuilder: (BuildContext context) {
                    return listToPopupMenu(regionList);
                  },
                  onSelected: (dynamic value) {
                    _nodeText3.unfocus();
                    regionIndex = int.parse(value);
                    Logger.log("---regionIndex: $regionIndex");
                    dynamic region = regionList[regionIndex];
                    regionCode = region["code"];
                    String postalCode = region["postalCode"];
                    List<String> postalCodeArr = postalCode.split(',');
                    List<dynamic> tempList = [];
                    if (postalCodeArr.isNotEmpty && postalCodeArr.length > 1) {
                      for (var item in postalCodeArr) {
                        tempList.add({"name": item, "enName": item});
                      }
                      postCodeList = tempList;
                      postCode = pleaseSelect;
                    } else {
                      postCodeIndex = 0;
                      String firstItem = postalCodeArr[postCodeIndex];
                      tempList.add({"name": firstItem, "enName": firstItem});
                      postCodeList = tempList;
                      postCode = firstItem;
                    }
                    setState(() {
                      regionName = getName(region);
                    });
                    checkInput();
                  },
                  child: ListTile(
                    title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_address_village), style: TextStyle(fontSize: 13.sp, color: IConstant.grey_color),),
                    subtitle: Text(regionName, style: TextStyle(fontSize: 13.sp, color: regionList.isEmpty ? IConstant.main_color : IConstant.title_color),),
                    trailing: Icon(Icons.keyboard_arrow_down, size: 20.w, color: IConstant.sub_text_color),
                  ),
                ),
                Container(height: 1.w, color: IConstant.line_color,),
                PopupMenuButton(
                  constraints: BoxConstraints(
                      maxHeight: 260.w
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  itemBuilder: (BuildContext context) {
                    return listToPopupMenu(postCodeList);
                  },
                  position: PopupMenuPosition.under,
                  onSelected: (dynamic value) {
                    _nodeText3.unfocus();
                    postCodeIndex = int.parse(value);
                    dynamic region = postCodeList[postCodeIndex];
                    setState(() {
                      postCode = getName(region);
                    });
                    checkInput();
                  },
                  child: ListTile(
                    title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_address_post_code), style: TextStyle(fontSize: 13.sp, color: IConstant.grey_color),),
                    subtitle: Text(postCode, style: TextStyle(fontSize: 13.sp, color: postCodeList.isEmpty ? IConstant.main_color : IConstant.title_color),),
                    trailing: Icon(Icons.keyboard_arrow_down, size: 20.w, color: IConstant.sub_text_color),
                  ),
                ),
                Container(height: 1.w, color: IConstant.line_color,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13.w),
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    focusNode: _nodeText3,
                    // inputFormatters: [
                    //   FilteringTextInputFormatter.deny(_filterPattern),
                    // ],
                    style: TextStyle(color: IConstant.title_color, fontSize: 14.sp),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: LanguageConfig.get(LanguageConfigKeys.Shop_address_street_address),
                      labelStyle: TextStyle(fontSize: 14.sp, color: IConstant.grey_color),
                      suffixIcon: Icon(Icons.edit, color: IConstant.text_color, size: 12.w),
                    ),
                    controller: ViewUtils.buildTextEditingController(detailAddress),
                    onChanged: (str) {
                      detailAddress = str;
                      checkInput();
                    },
                  ),
                ),
              ],
            ),
          ),
          buildDefaultStatus(),
        ],
      )),
      bottomNavigationBar: buildBottomBar(),
    ));
  }

  getName(dynamic item) {
    if (LanguagePage.language == "TH") {
      return item["name"];
    } else {
      return item["enName"];
    }
  }

  buildDefaultStatus() {
    return Container(
      margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.w),
      padding: EdgeInsets.only(left: 12.w, right: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(LanguageConfig.get(LanguageConfigKeys.Shop_address_set_as_default_address), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
          InkWell(
            onTap: () {
              setState((){
                defaultStatus = !defaultStatus;
              });
            },
            child: Image.asset("assets/icons/${ defaultStatus ? "switch_active": "switch_default"}.png", width: 40.w,),
          )
        ],),
    );
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      elevation: 0.w,
      height: 135.w,
      child: Container(
          margin: EdgeInsets.fromLTRB(16.w, 4.w, 16.w, 6.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_address_confirm_delivery_correct),
                maxLines: 2, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color),),
              SizedBox(height: 30.w,),
              Row(
                children: [
                  SizedBox(width: 14.w,),
                  Expanded(flex: 2, child: OutlineBigTextButton(text: LanguageConfig.get(LanguageConfigKeys.Base_clean_up),
                      left: 20.w,
                      right: 20.w,
                      bgColor: IConstant.white_color,
                      borderColor: IConstant.line_color,
                      textColor: IConstant.text_color,
                      onTap: () {
                        clear();
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
              )
            ],
          )),
    );
  }

  void clear() {
    setState(() {
      name = '';
      phoneNumber = '';
      postCode = '';
      provinceName = '';
      cityName = '';
      regionName = '';
      regionCode = '';
      detailAddress = '';
    });
    checkInput();
  }


  List<PopupMenuItem> listToPopupMenu(List<dynamic> selectList) {
    List<PopupMenuItem> tempList = [];
    for (var i = 0; i < selectList.length; i++) {
      dynamic item = selectList[i];
      tempList.add(PopupMenuItem(
        value: "$i",
        child: Text(getName(item),
            style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
      ));
    }
    return tempList;
  }

  GlobalKey<PartRefreshWidgetState> refreshBtn = GlobalKey();

  bool isClickEnable = false;

  void checkInput() {
    if (TextUtils.isNotEmpty(phoneNumber)
        && TextUtils.isNotEmpty(name)
        && TextUtils.isNotEmpty(provinceName)
        && TextUtils.isNotEmpty(cityName)
        && TextUtils.isNotEmpty(regionName)
        && TextUtils.isNotEmpty(postCode)
        && TextUtils.isNotEmpty(detailAddress)
        && cityName != pleaseSelect
        && regionName != pleaseSelect
        && postCode != pleaseSelect
    ) {
      if (isClickEnable) return;
      isClickEnable = true;
      refreshBtn.currentState?.update();
    } else {
      if (!isClickEnable) return;
      isClickEnable = false;
      refreshBtn.currentState?.update();
    }
  }

  Future<void> loadCityReselect(String provinceCode) async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_UTIL_GET_REGION, {"parentCode": provinceCode});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<dynamic> tempList = rsp.data;
      setState(() {
        cityList = tempList;
        cityName = pleaseSelect;
        regionName = pleaseSelect;
        postCode = pleaseSelect;
      });
      checkInput();
    }
    ViewUtils.dismiss();
  }

  Future<void> loadRegionReselect(String cityCode) async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_UTIL_GET_REGION, {"parentCode": cityCode});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<dynamic> tempList = rsp.data;
      setState(() {
        regionList = tempList;
        regionName = pleaseSelect;
        postCode = pleaseSelect;
      });
      checkInput();
    }
    ViewUtils.dismiss();
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
      "province": provinceName,
      "city": cityName,
      "region": regionName,
      "regionCode": regionCode,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_operation_successful));
      EventBusUtil.getInstance().emit(AddressEvent(operateStatus: OperateStatus.add));
      finish();
      finish();
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
      "province": provinceName,
      "city": cityName,
      "region": regionName,
      "regionCode": regionCode,
    };
    BaseRsp rsp = await HttpUtils.postJSON(url, params);
    if (rsp.retCode == RspRetCode.SUCCESS) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_operation_successful));
      EventBusUtil.getInstance().emit(AddressEvent(address: params, operateStatus: OperateStatus.update));
      finish();
      finish();
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

}
