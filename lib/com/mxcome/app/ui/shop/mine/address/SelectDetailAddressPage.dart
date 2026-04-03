
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/IURLConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseRsp.dart';
import 'package:mxcome/com/mxcome/app/ui/LanguagePage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/GeoModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/BigTextButton.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/OutlineTextButton.dart';
import 'package:mxcome/com/mxcome/app/utils/Adapt.dart';
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import 'package:mxcome/com/mxcome/app/widget/PartRefreshWidget.dart';
import 'GeoAddressConfirmPage.dart';

class SelectDetailAddressPage extends StatefulWidget {

  String name = '';
  String phoneNumber = '';

  SelectDetailAddressPage(this.name, this.phoneNumber);

  @override
  State<StatefulWidget> createState() {
    return SelectDetailAddressPageState();
  }

}

class SelectDetailAddressPageState extends BaseKeepAliveState<SelectDetailAddressPage> {

  int currentSelectFlag = 0;

  List<dynamic> currentSelectList = [];

  String name = '';
  String phoneNumber = '';
  String provinceName = '';
  String cityName = '';
  String regionName = '';
  String regionCode = '';
  String postCode = '';
  String detailAddress = '';
  String selectItem = LanguageConfig.get(LanguageConfigKeys.Shop_address_please_select_region);

  List<dynamic> provinceList = [];
  List<dynamic> cityList = [];
  List<dynamic> regionList = [];
  List<dynamic> postCodeList = [];

  int provinceIndex = 0;
  int cityIndex = 0;
  int regionIndex = 0;
  int postCodeIndex = 0;

  String pleaseSelect =  LanguageConfig.get(LanguageConfigKeys.Shop_address_please_select);

  @override
  void initState() {
    super.initState();
    name = widget.name;
    phoneNumber = widget.phoneNumber;
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_UTIL_GET_REGION, {"level": "1"});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      provinceList = rsp.data;
      setState(() {
        provinceIndex = 0;
        currentSelectFlag = 0;
        currentSelectList = provinceList;
      });
    }
  }

  Future<void> loadCity(String provinceCode) async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_UTIL_GET_REGION, {"parentCode": provinceCode});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      cityList = rsp.data;
      setState(() {
        cityIndex = 0;
        currentSelectFlag = 1;
        currentSelectList = cityList;
      });
    }
    ViewUtils.dismiss();
  }

  Future<void> loadRegion(String cityCode) async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_UTIL_GET_REGION, {"parentCode": cityCode});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      regionList = rsp.data;
      setState(() {
        regionIndex = 0;
        currentSelectFlag = 2;
        currentSelectList = regionList;
      });
    }
    ViewUtils.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return KeyboardDismissOnTap(child: Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
      elevation: 0.w,
      centerTitle: true,
      title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_address_detail_address),
          style: TextStyle(fontSize: 17.w, color: IConstant.text_color))),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildRegionHeader(),
            currentSelectFlag == 4 ? Expanded(child: buildDetailAddress()): Expanded(child: buildRegionList()),
      ]),
      bottomNavigationBar: buildBottomBar(),
    ));
  }

  Widget buildRegionList() {
    return currentSelectList.isEmpty ? Container() : ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(getName(currentSelectList[index]), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
          trailing: Icon(Icons.chevron_right, size: 16.w, color: IConstant.sub_text_color),
          onTap: () {
            setState(() {
              if (currentSelectFlag == 0) {
                provinceIndex = index;
                dynamic province = currentSelectList[provinceIndex];
                provinceName = getName(province);
                String provinceCode = province["code"];
                loadCity(provinceCode);
              } else if (currentSelectFlag == 1) {
                cityIndex = index;
                dynamic city = currentSelectList[cityIndex];
                cityName = getName(city);
                String cityCode = city["code"];
                loadRegion(cityCode);
              } else if (currentSelectFlag == 2) {
                regionIndex = index;
                dynamic region = currentSelectList[regionIndex];
                regionName = getName(region);
                regionCode = region["code"];
                String postalCode = region["postalCode"];
                List<String> postalCodeArr = postalCode.split(',');
                List<dynamic> tempList = [];
                if (postalCodeArr.isNotEmpty && postalCodeArr.length > 1) {
                  for (var item in postalCodeArr) {
                    tempList.add({"name": item, "enName": item});
                  }
                  currentSelectList = tempList;
                  postCodeList = tempList;
                } else {
                  String firstItem = postalCodeArr[postCodeIndex];
                  tempList.add({"name": firstItem, "enName": firstItem});
                  currentSelectList = tempList;
                  postCodeList = tempList;
                }
                currentSelectFlag = 3;
              } else if (currentSelectFlag == 3) {
                postCodeIndex = index;
                dynamic postalCode = currentSelectList[postCodeIndex];
                postCode = getName(postalCode);
                currentSelectFlag = 4;
              }
            });
          },
        );
      },
      itemCount: currentSelectList.length,
    );
  }

  getName(dynamic item) {
    if (LanguagePage.language == "TH") {
      return item["name"];
    } else {
      return item["enName"];
    }
  }

  Widget buildRegionHeader() {
    return Container(
      padding: EdgeInsets.all(8.w),
      child: Row(
        children: [
          // 府 > 县 > 镇 > 邮编 > 街道及门牌
          InkWell(
            onTap: () {
              //loadContentDatas();
            },
            child: Row(
             children: [
               Text(LanguageConfig.get(LanguageConfigKeys.Shop_address_government), style: TextStyle(fontSize: 12.sp, color: getColor(0))),
               Icon(Icons.chevron_right, size: 14.w, color: IConstant.sub_text_color),
             ],
            ),
          ),
          InkWell(
            onTap: () {
              // dynamic province = currentSelectList[provinceIndex];
              // String provinceCode = province["code"];
              // loadCity(provinceCode);
            },
            child: Row(
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_address_county), style: TextStyle(fontSize: 12.sp, color: getColor(1))),
                Icon(Icons.chevron_right, size: 14.w, color: IConstant.sub_text_color),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              // dynamic city = currentSelectList[cityIndex];
              // String cityCode = city["code"];
              // loadRegion(cityCode);
            },
            child: Row(
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_address_village), style: TextStyle(fontSize: 12.sp, color: getColor(2))),
                Icon(Icons.chevron_right, size: 14.w, color: IConstant.sub_text_color),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              // dynamic region = currentSelectList[regionIndex];
              // regionName = getName(region);
              // regionCode = region["code"];
              // String postalCode = region["postalCode"];
              // List<String> postalCodeArr = postalCode.split(',');
              // List<dynamic> tempList = [];
              // if (postalCodeArr.isNotEmpty && postalCodeArr.length > 1) {
              //   for (var item in postalCodeArr) {
              //     tempList.add({"name": item, "enName": item});
              //   }
              //   currentSelectList = tempList;
              //   postCodeList = tempList;
              // } else {
              //   String firstItem = postalCodeArr[postCodeIndex];
              //   tempList.add({"name": firstItem, "enName": firstItem});
              //   currentSelectList = tempList;
              //   postCodeList = tempList;
              // }
            },
            child: Row(
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_address_post_code), style: TextStyle(fontSize: 12.sp, color: getColor(3))),
                Icon(Icons.chevron_right, size: 14.w, color: IConstant.sub_text_color),
              ],
            ),
          ),
          Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_address_street_address), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp, color: getColor(4))))
        ]
      ),
    );
  }

  Widget buildDetailAddress() {
    return Container(
      margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 12.w),
      child: TextField(
        textInputAction: TextInputAction.done,
        maxLines: 2,
        keyboardType: TextInputType.text,
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
          labelText: LanguageConfig.get(LanguageConfigKeys.Shop_address_please_enter),
          labelStyle: TextStyle(fontSize: 13.sp, color: IConstant.grey_color),
        ),
        controller: ViewUtils.buildTextEditingController(detailAddress),
        onChanged: (str) {
          detailAddress = str;
          checkInput();
        },
      ),
    );
  }

  Color getColor(index) {
    if (index == currentSelectFlag) {
      return IConstant.main_color;
    } else {
      return IConstant.sub_text_color;
    }
  }

  void setSelectAddress() {
    finish();
    GeoModel model = GeoModel('', name, phoneNumber, provinceName, cityName, regionName, regionCode, postCode, detailAddress, false);
    showPop(0.92 * Adapt.getWindowHeight(), GeoAddressConfirmPage(model));
  }

  GlobalKey<PartRefreshWidgetState> refreshBtn = GlobalKey();

  bool isClickEnable = false;

  void checkInput() {
    if (TextUtils.isNotEmpty(provinceName)
        && TextUtils.isNotEmpty(cityName)
        && TextUtils.isNotEmpty(regionName)
        && TextUtils.isNotEmpty(postCode)
        && TextUtils.isNotEmpty(detailAddress)
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

  List<PopupMenuItem> listToPopupMenu(List<dynamic> selectList) {
    List<PopupMenuItem> tempList = [];
    for (var i = 0; i < selectList.length; i++) {
      dynamic item = selectList[i];
      tempList.add(PopupMenuItem(
        value: "$i",
        child: Text(getName(item), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
      ));
    }
    return tempList;
  }

  Widget? buildBottomBar() {
    return currentSelectFlag == 4 ? BottomAppBar(
      height: 80.w,
      elevation: 0.w,
      child: Container(
        margin: EdgeInsets.only(left: 100.w, right: 100.w, bottom: 20.w),
        child: PartRefreshWidget(refreshBtn, () => OutlineTextButton(text: LanguageConfig.get(LanguageConfigKeys.ViewUtils_confirm),
            borderColor: IConstant.main_color,
            bgColor: IConstant.white_color,
            textColor: IConstant.main_color,
            enable: isClickEnable, onTap: () {
          setSelectAddress();
        })),
      ),
    ) : null;
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

}
