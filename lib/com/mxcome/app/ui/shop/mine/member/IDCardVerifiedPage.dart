
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/UserInfoEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/member/HeroPhotoViewRouteWrapper.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/member/IDCardVerifyingPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IURLConstant.dart';
import '../../../../model/BaseModel.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/Adapt.dart';
import '../../../../utils/AppUtils.dart';
import '../../../../utils/HttpUtils.dart';
import '../../../../utils/PermissionHelper.dart';
import '../../../../utils/TextUtils.dart';
import '../../../../utils/ViewUtils.dart';
import '../../../../widget/PartRefreshWidget.dart';
import '../../utils/ImageUtil.dart';
import '../../widget/BigTextButton.dart';
import '../../widget/LoadImageView.dart';

class IDCardVerifiedPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return IDCardVerifiedPageState();
  }

}

class IDCardVerifiedPageState extends BaseKeepAliveState<IDCardVerifiedPage> {

  dynamic userInfo;

  dynamic idCardInfo;

  String idCard = '';

  DateTime validDate = DateTime.now();

  String firstName = '';

  String lastName = '';

  String idCardUrl = '';

  String phone = '';

  String phoneCode = '';

  int idCardStatus = 0; //-1审核不通过, 0未提交，1审核中，2审核通过

  int documentType = 0; //0:身份证，1：护照

  String idType = LanguageConfig.get(LanguageConfigKeys.Shop_mine_id_card);

  List<String> idTypeList = [
    LanguageConfig.get(LanguageConfigKeys.Shop_mine_id_card),
    LanguageConfig.get(LanguageConfigKeys.Shop_mine_passport)
  ];

  dynamic userInfoEvent;

  bool isClickEnable = false;

  DateTime startDate = DateTime.now();

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();

  @override
  void initState() {
    super.initState();
    userInfoEvent = EventBusUtil.getInstance().on<UserInfoEvent>((event) {
      if (event.userInfoStatus == UserInfoStatus.complete) {
        loadContentDatas();
      }
    });
    loadContentDatas();
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(userInfoEvent);
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_GET_IDENTITY_INFO, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      if (TextUtils.isNotEmpty(rsp.data)) {
        setState(() {
          idCardInfo = rsp.data;
          idCard = BaseModel.getString(idCardInfo, "idCard");
          idCardUrl = BaseModel.getString(idCardInfo, "idCardUrl");
          String idCardValidityDate = BaseModel.getString(idCardInfo, "idCardValidityDate");
          if (TextUtils.isNotEmpty(idCardValidityDate)) {
            validDate = DateTime.parse(idCardValidityDate);
          }
          documentType = BaseModel.getInt(idCardInfo, "documentType");
          if (documentType == 0) {
            idType = LanguageConfig.get(LanguageConfigKeys.Shop_mine_id_card);
          } else {
            idType = LanguageConfig.get(LanguageConfigKeys.Shop_mine_passport);
          }
          String idCardName = BaseModel.getString(idCardInfo, "idCardName");
          if (TextUtils.isNotEmpty(idCardName)) {
            List<String> userList = idCardName.trim().split("|");
            firstName = userList[0];
            lastName = userList[1];
          }
        });
      }
    }
    dynamic data = await AppUtils.getUserInfo();
    setState(() {
      userInfo = data;
      phone = BaseModel.getString(userInfo, "phone");
      phoneCode = BaseModel.getString(userInfo, "phoneCode");
      idCardStatus = BaseModel.getInt(userInfo, "idCardStatus");
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return KeyboardDismissOnTap(child: Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.5.w,
        //centerTitle: true,
        titleSpacing: 0,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_real_name_auth),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_select_certificate),
                style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
          ),
          isEnable() ? Container(
            margin: EdgeInsets.fromLTRB(16.w, 6.w, 16.w, 10.w),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                  customButton: Container(
                    padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.w),
                      border: Border.all(
                          color: IConstant.line_color,
                          width: 1.w),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(idType, textAlign: TextAlign.center, maxLines: 1, style: TextStyle(fontSize: 14.w, color: IConstant.text_color)),
                        expandeSpace,
                        Icon(Icons.keyboard_arrow_down, size: 18.w, color: IConstant.text_color)
                      ],
                    ),
                  ),
                  value: idType,
                  onChanged: (String? newPosition) {
                    setState(() {
                      idType = "$newPosition";
                      checkDocumentType();
                    });
                  },
                  items: getIdTypeList()),
            ),
          ) : Container(
            margin: EdgeInsets.fromLTRB(16.w, 6.w, 16.w, 10.w),
            padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
            decoration: BoxDecoration(
                border: Border.all(color: IConstant.line_color, width: 1.w),
                borderRadius: BorderRadius.circular(10.w)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(idType, textAlign: TextAlign.center, maxLines: 1, style: TextStyle(fontSize: 14.w, color: IConstant.text_color)),
                expandeSpace,
                Icon(Icons.keyboard_arrow_down, size: 18.w, color: IConstant.text_color)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 0.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_upload_positive),
                style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),
          ),
          buildImages(),
          TextUtils.isEmpty(idCardUrl) ? Container(
            margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 0.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_upload_after_tip),
                maxLines: 2,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 12.sp, color: IConstant.text_color)),
          ) : Container(),
          SizedBox(height: 16.w),
          Container(
            height: 120.w,
            margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.w),
            child: Row(
              children: [
                Container(width: 3.w, color: IConstant.red_bg_color),
                SizedBox(width: 12.w),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_verify_tip1),
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color)),
                    Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_verify_tip2),
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color)),
                    Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_verify_tip3),
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color)),
                    Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_verify_tip4),
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color)),
                  ],
                ))
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: buildBottomBar(),
    ));
  }

  void checkDocumentType() {
    for (int i = 0; i < idTypeList.length; i++) {
      if (idType == idTypeList[i]) {
        documentType = i;
        break;
      }
    }
  }

  Widget buildImages() {
    if (TextUtils.isEmpty(idCardUrl)) {
      return InkWell(onTap: () async {
        showSelectionDialog(context);
      }, child: Container(
        height: 165.w,
        margin: EdgeInsets.fromLTRB(16.w, 6.w, 16.w, 10.w),
        padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w,),
        decoration: BoxDecoration(
            color: IConstant.line_color,
            border: Border.all(color: IConstant.line_color, width: 1.w),
            borderRadius: BorderRadius.circular(10.w)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 140.w,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(60.w, 35.w, 60.w, 0.w),
                child: Column(
                  children: [
                    Image.asset("assets/icons/camera_icon.png",
                        width: 40.w,
                        height: 40.w),
                    SizedBox(height: 6.w),
                    Text(
                        LanguageConfig.get(LanguageConfigKeys.Shop_mine_color_pictures),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13.sp, color: IConstant.title_color)),
                  ],
                ),
              ),
            )
          ],
        ),
      ));
    } else {
      return Column(
        children: [
          Container(
            height: 165.w,
            margin: EdgeInsets.fromLTRB(16.w, 6.w, 16.w, 10.w),
            padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w,),
            decoration: BoxDecoration(border: Border.all(color: IConstant.line_color, width: 1.w), borderRadius: BorderRadius.circular(10.w)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => openDialog(),
                      child: LoadImageView(220.w, 140.w, idCardUrl),
                    ),
                    Expanded(child: InkWell(
                      onTap: () {
                        if (isEnable()) {
                          showSelectionDialog(context);
                        }
                      },
                      child: Column(
                        children: [
                          Icon(Icons.check_circle, size: 20.w, color: IConstant.main_color),
                          SizedBox(height: 8.w),
                          Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_re_upload), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                        ],
                      ),
                    ))
                  ],
                ),
              ],
            ),
          ),
          buildNickname(),
          buildIdCard(),
          buildPhone(),
        ],
      );
    }
  }


  Widget buildIdCard() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 0),
      decoration: BoxDecoration(border: Border.all(color: IConstant.line_color, width: 1.w), borderRadius: BorderRadius.circular(10.w)),
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(left: 10.w, right: 10),
              child: TextField(
                  enabled: isEnable(),
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  focusNode: _nodeText1,
                  style: TextStyle(color: IConstant.text_color, fontSize: 13.sp),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")), //只允许输入字母
                    LengthLimitingTextInputFormatter(30),
                  ],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: documentType == 0 ? LanguageConfig.get(LanguageConfigKeys.Shop_mine_id_number)
                        : LanguageConfig.get(LanguageConfigKeys.Shop_mine_passport_number),
                    labelStyle: TextStyle(fontSize: 13.sp, color: IConstant.sub_text_color),
                    hintStyle: TextStyle(color: IConstant.sub_text_color, fontSize: 13.sp),
                  ),
                  controller: ViewUtils.buildTextEditingController(idCard, listener: (str) {
                    RegExp regexp = RegExp(r'^0+(?=.)');
                    var match = regexp.firstMatch(str);
                    var matchLength = match?.group(0)?.length ?? 0;
                    if (matchLength != 0) {
                      idCard = str.replaceAll(regexp, '');
                    } else {
                      idCard = str;
                    }
                    checkInput();
                  })
              )
          ),
          Container(width: double.infinity, height: 1.w, color: IConstant.line_color),
          InkWell(
            onTap: () {
              if(isEnable()) {
                showDatePicker();
              }
            },
            child: Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10),
                child: TextField(
                  enabled: false,
                  maxLines: 2,
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: IConstant.text_color, fontSize: 13.sp),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: LanguageConfig.get(LanguageConfigKeys.Shop_mine_validity),
                    labelStyle: TextStyle(fontSize: 13.sp, color: IConstant.sub_text_color),
                    hintStyle: TextStyle(color:IConstant.sub_text_color, fontSize: 13.sp),
                  ),
                  controller: ViewUtils.buildTextEditingController(FormatUtil.formatLineYMD(validDate), listener: (str) {
                    checkInput();
                  }),
                )),
          )
        ],
      ),
    );
  }

  Widget buildNickname() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 0),
      decoration: BoxDecoration(border: Border.all(color: IConstant.line_color, width: 1.w), borderRadius: BorderRadius.circular(10.w)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10),
            child: Row(
              children: [
                Expanded(child: TextField(
                  enabled: isEnable(),
                  textInputAction: TextInputAction.next,
                  maxLines: 2,
                  keyboardType: TextInputType.text,
                  focusNode: _nodeText2,
                  style: TextStyle(color: IConstant.text_color, fontSize: 13.sp),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp('[~!@#%^&*()_+|?><:;{}[]]')),//拒绝特殊符号
                    LengthLimitingTextInputFormatter(50),
                  ],
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: LanguageConfig.get(LanguageConfigKeys.Shop_mine_last_name),
                      labelStyle: TextStyle(fontSize: 13.sp, color: IConstant.sub_text_color),
                      hintStyle: TextStyle(color: IConstant.sub_text_color, fontSize: 13.sp)),
                  controller: ViewUtils.buildTextEditingController(lastName, listener: (str) {
                    lastName = str;
                    checkInput();
                  }),
                )),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: 160.w
                  ),
                  child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_bank_only_en_th),
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 13.sp, color: IConstant.sub_text_color)),
                )
              ],
            ),
          ),
          Container(width: double.infinity, height: 1.w, color: IConstant.line_color),
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10),
            child: Row(
              children: [
                Expanded(child: TextField(
                    enabled: isEnable(),
                    textInputAction: TextInputAction.done,
                    maxLines: 2,
                    keyboardType: TextInputType.text,
                    focusNode: _nodeText3,
                    style: TextStyle(color: IConstant.text_color, fontSize: 13.sp),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp('[~!@#%^&*()_+|?><:;{}[]]|[\u4e00-\u9fa5]')),//拒绝特殊符号
                      LengthLimitingTextInputFormatter(50),
                    ],
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: LanguageConfig.get(LanguageConfigKeys.Shop_mine_first_name),
                        labelStyle: TextStyle(fontSize: 13.sp, color: IConstant.sub_text_color),
                        hintStyle: TextStyle(color: IConstant.sub_text_color, fontSize: 13.sp)),
                    controller: ViewUtils.buildTextEditingController(firstName, listener: (str) {
                      firstName = str;
                      checkInput();
                    })
                )),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 160.w
                  ),
                  child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_bank_only_en_th),
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 13.sp, color: IConstant.sub_text_color)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPhone() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
      padding: EdgeInsets.fromLTRB(10.w, 8.w, 10.w, 8.w),
      decoration: BoxDecoration(color: IConstant.line_color, borderRadius: BorderRadius.circular(10.w)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_register_phone), style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
          SizedBox(height: 4.w),
          Text('$phoneCode $phone', style: TextStyle(fontSize: 13.sp, color: IConstant.title_color)),
        ],
      ),
    );
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      elevation: 0.w,
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
        height: 50.w,
        alignment: Alignment.center,
        child: SizedBox(
          width: 180.w,
          child: buildSubmit(),
        )
      ),
    );
  }

  GlobalKey<PartRefreshWidgetState> refreshBtn = GlobalKey();

  Widget buildSubmit() {
    return PartRefreshWidget(refreshBtn, () => BigTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_mine_verify_confirm), enable: isClickEnable && isEnable(), onTap: () {
      addVerified();
    }));
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
                  showPermissionDialog(Permission.camera, ImageFrom.camera);
                },
              ),),
              Divider(height: 1.w),
              Expanded(flex: 1, child: GestureDetector(
                child: buildSelectItem(context, LanguageConfig.get(LanguageConfigKeys.Shop_mine_photo_album)),
                onTap: (){
                  Navigator.pop(context);
                  showPermissionDialog(Permission.storage, ImageFrom.gallery);
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

  Future<void> showPermissionDialog(Permission permission, ImageFrom imageFrom) async {
    if (Platform.isIOS) {
      getImage(imageFrom);
      return;
    }
    if (Platform.isAndroid && ImageFrom.gallery == imageFrom) {
      getImage(imageFrom);
      return;
    }
    String denied = LanguageConfig.get(LanguageConfigKeys.Shop_permission_denied);
    String granted = LanguageConfig.get(LanguageConfigKeys.Shop_permission_granted);
    String cancel = LanguageConfig.get(LanguageConfigKeys.Shop_permission_setting_cancel);
    String open = LanguageConfig.get(LanguageConfigKeys.Shop_permission_setting_open);
    String title = imageFrom == ImageFrom.camera ? LanguageConfig.get(LanguageConfigKeys.Shop_permission_camera_title) : LanguageConfig.get(LanguageConfigKeys.Shop_permission_photos_title);
    String content = imageFrom == ImageFrom.camera ? LanguageConfig.get(LanguageConfigKeys.Shop_permission_camera_content) : LanguageConfig.get(LanguageConfigKeys.Shop_permission_photos_content);
    String settingTitle = imageFrom == ImageFrom.camera ? LanguageConfig.get(LanguageConfigKeys.Shop_permission_camera_setting_title) : LanguageConfig.get(LanguageConfigKeys.Shop_permission_photos_setting_title);
    String settingContent = imageFrom == ImageFrom.camera ? LanguageConfig.get(LanguageConfigKeys.Shop_permission_camera_setting_content) : LanguageConfig.get(LanguageConfigKeys.Shop_permission_photos_setting_content);
    PermissionHelper.check(permission,
        onSuccess: () {
          getImage(imageFrom);
        }, onFailed: () {
          ViewUtils.showRemindDialog2(context,
              title,
              content,
              denied,
              granted, (ctx, event) {
                if (event == DialogEvent.confirm) {
                  PermissionHelper.requestPermission(permission,
                      onSuccess: () {
                        getImage(imageFrom);
                      }, onFailed: () {
                      }, onOpenSetting: () {
                        ViewUtils.showRemindDialog2(context,
                            settingTitle,
                            settingContent,
                            cancel,
                            open, (ctx, event) {
                              if (event == DialogEvent.confirm) {
                                openAppSettings();
                                finishContext(ctx);
                              } else {
                                finishContext(ctx);
                              }
                            }
                        );
                      });
                  finishContext(ctx);
                } else {
                  finishContext(ctx);
                }
              }
          );
        }, onOpenSetting: () {
          ViewUtils.showRemindDialog2(context,
              settingTitle,
              settingContent,
              cancel,
              open, (ctx, event) {
                if (event == DialogEvent.confirm) {
                  openAppSettings();
                  finishContext(ctx);
                } else {
                  finishContext(ctx);
                }
              }
          );
        });
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
    CroppedFile croppedFile = await ImageUtil.cropImage2(
        image: pickerImage,
        width: 1580,
        height: 1000);
    List<String> files = [];
    files.add(croppedFile.path);
    BaseRsp rsp = await HttpUtils.uploadFile(IURLConstant.MALL_PARSE_FILES, {}, files);
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        idCardUrl = rsp.data["url"];
        checkInput();
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  void addVerified() async {
    BaseRsp rsp = await HttpUtils.postJSON(IURLConstant.MALL_ADD_IDENTITY_INFO, null, body: {
      "documentType": "$documentType",
      "idCard": idCard,
      "idCardUrl": idCardUrl,
      "idCardValidityDate": FormatUtil.formatLineYMDHMS(validDate),
      "idCardName": "$firstName|$lastName".trim()
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      loadContentDatas();
      EventBusUtil.getInstance().emit(UserInfoEvent());
      nextPage(IDCardVerifyingPage(), false);
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  void checkInput() {
    if (TextUtils.isNotEmpty(idCard) && TextUtils.isNotEmpty(lastName) && TextUtils.isNotEmpty(firstName) && isEnable()) {
      if (isClickEnable) return;
      isClickEnable = true;
      refreshBtn.currentState?.update();
    } else {
      if (!isClickEnable) return;
      isClickEnable = false;
      refreshBtn.currentState?.update();
    }
  }

  void showDatePicker() {
    changeFocus();
    DatePicker.showDatePicker(context,
        minDateTime: DateTime(startDate.year),
        maxDateTime: DateTime(startDate.year + 100),
        onConfirm: (DateTime date, List<int> selectedIndex) {
          setState(() {
            validDate = date;
            checkInput();
          });
        },
        initialDateTime: validDate, locale: AppUtils.getLocaleType());
  }

  List<DropdownMenuItem<String>> getIdTypeList() {
    List<DropdownMenuItem<String>> items = [];
    for (dynamic item in idTypeList) {
      DropdownMenuItem<String> menuItem = DropdownMenuItem(
        value: item,
        child: Text(item,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
      );
      items.add(menuItem);
    }
    return items;
  }

  bool isEnable() {
    return idCardStatus != 2;
  }

  void openDialog() {
    nextPage(HeroPhotoViewRouteWrapper(imageProvider: NetworkImage(idCardUrl)), false);
  }

}
