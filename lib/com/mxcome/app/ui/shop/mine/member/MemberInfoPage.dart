
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/member/ChangeGenIDPage.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IURLConstant.dart';
import '../../../../config/LanguageConfig.dart';
import '../../../../model/BaseModel.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/Adapt.dart';
import '../../../../utils/AppUtils.dart';
import '../../../../utils/HttpUtils.dart';
import '../../../../utils/PermissionHelper.dart';
import '../../../../utils/TextUtils.dart';
import '../../../../utils/ViewUtils.dart';
import '../../event/UserInfoEvent.dart';
import '../../utils/EventBusUtil.dart';
import '../../utils/FormatUtil.dart';
import '../../utils/ImageUtil.dart';
import '../../utils/ShowBottomSheetTool.dart';
import '../../widget/BigTextButton.dart';
import '../../widget/GenAvatar.dart';
import '../../widget/SmallTextButton.dart';
import '../wallet/VerifyMobilePage.dart';
import 'ChangeMobilePage.dart';
import 'IDCardVerifiedPage.dart';
import 'IDCardVerifyingPage.dart';

class MemberInfoPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return MemberInfoPageState();
  }

}

class MemberInfoPageState extends BaseKeepAliveState<MemberInfoPage> {

  dynamic userInfo;

  String username = '';

  String phone = '';

  String generatorId = '';

  String nickname = '';

  String personalizedSignature = '';

  int gender = 0;

  int idCardStatus = -1;

  DateTime? startDate;

  String avatar = '';

  List<String> genderArr = [
    LanguageConfig.get(LanguageConfigKeys.Shop_mine_unknown),
    LanguageConfig.get(LanguageConfigKeys.Shop_mine_boy),
    LanguageConfig.get(LanguageConfigKeys.Shop_mine_girl)
  ];

  dynamic userInfoEvent;

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();

  bool isLoadingData = false;

  @override
  void initState() {
    super.initState();
    userInfoEvent = EventBusUtil.getInstance().on<UserInfoEvent>((event) {
      if (event.userInfoStatus == UserInfoStatus.complete) {
        //loadContentDatas();
        updateAvatar();
      }
    });
    loadContentDatas();
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(userInfoEvent);
    super.dispose();
  }

  Future<void> updateAvatar() async {
    dynamic data = await AppUtils.getUserInfo();
    setState(() {
      avatar = BaseModel.getString(data, "icon");
    });
  }

  @override
  Future<void> loadContentDatas() async {
    setState(() {
      isLoadingData = true;
    });
    dynamic data = await AppUtils.getUserInfo();
    setState(() {
      userInfo = data;
      generatorId = BaseModel.getString(data, "generatorId");
      phone = BaseModel.getString(data, "phone");
      nickname = BaseModel.getString(data, "nickname");
      avatar = BaseModel.getString(userInfo, "icon");
      String birthDayStr = BaseModel.getString(data, "birthday");
      if (TextUtils.isNotEmpty(birthDayStr)) {
        startDate = DateTime.parse(birthDayStr);
      }
      personalizedSignature = BaseModel.getString(data, "personalizedSignature");
      gender = BaseModel.getInt(data, "gender");
      idCardStatus = BaseModel.getInt(data, "idCardStatus");
    });
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_GET_IDENTITY_INFO, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      String idCardName = BaseModel.getString(rsp.data, "idCardName");
      if (TextUtils.isNotEmpty(idCardName)) {
        List<String> userList = idCardName.trim().split("|");
        String firstName = userList[0];
        String lastName = userList[1];
        setState(() {
          username = "$lastName $firstName";
        });
      }
      setState(() {
        isLoadingData = false;
      });
    } else {
      setState(() {
        isLoadingData = false;
      });
      ViewUtils.displayToast(rsp.msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return KeyboardDismissOnTap(
      child: Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.5.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_edit_member_info),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: isLoadingData ? ViewUtils.buildLoading() : ListView(
          children: [
            buildMember(),
            buildUsername(),
            buildGeneratorId(),
            buildNickname(),
            buildSignature(),
            buildBirthDay(),
            buildGender(),
            SizedBox(height: 16.w)
          ]
        ),
      bottomNavigationBar: buildBottomBar(),
    ));
  }


  Widget buildMember() {
    return InkWell(onTap: () async {
      showSelectionDialog(context);
    }, child: Container(
      margin: EdgeInsets.fromLTRB(20.w, 30.w, 20.w, 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(child: buildAvatar()),
          SizedBox(height: 2.w),
          Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_change_avatar), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color))
        ],
      ),
    ));
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      child: Container(
        margin: EdgeInsets.all(20.w),
        child: BigTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_address_save),
            bgColor: IConstant.red_bg_color3, textColor: IConstant.main_color, onTap: () {
          updateInfo();
        }),
      ),
    );
  }

  String getDisplayName() {
    String nickname = BaseModel.getString(userInfo, "nickname");
    String username = BaseModel.getString(userInfo, "username");
    String phoneCode = BaseModel.getString(userInfo, "phoneCode");
    String phone = BaseModel.getString(userInfo, "phone");
    return TextUtils.isNotEmpty(nickname) ? nickname: "$phoneCode $phone";
  }

  Widget buildAvatar() {
    if (TextUtils.isEmpty(avatar)) {
      avatar = IConstant.AVATAR_URL;
    }
    if (TextUtils.isNotEmpty(avatar)) {
      return SizedBox(
        width: 60.w,
        height: 60.w,
        child: GenAvatar(avatar),
      );
    } else {
      String displayName = getDisplayName();
      return Container(
          width: 60.w,
          height: 60.w,
          color: IConstant.red_translucent_color,
          child: Center(
              child: Text(TextUtils.isNotEmpty(displayName) ? displayName.substring(0, 1) : "",
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 20.sp, color: IConstant.white_color))));
    }
  }

  Widget buildUsername() {
    return InkWell(
      onTap: () {
        int idCardStatus = BaseModel.getInt(userInfo, "idCardStatus"); //-1审核不通过, 0未提交，1审核中，2审核通过
        if (idCardStatus == -1) { //审核不通过
          nextPage(IDCardVerifyingPage(verifying: false), false);
        } else if (idCardStatus == 1) { //审核中
          nextPage(IDCardVerifyingPage(verifying: true), false);
        } else if (idCardStatus == 0) { //未提交
          nextPage(IDCardVerifiedPage(), false);
        } else {

        }
      },
      child: Container(
          margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
          padding: EdgeInsets.fromLTRB(10.w, 0.w, 10.w, 0),
          decoration: BoxDecoration(
              border: Border.all(color: IConstant.grey_bg_color, width: 1.w),
              borderRadius: BorderRadius.circular(10.w)),
          child: Row(
            children: [
              Expanded(child: TextField(
                  enabled: false,
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: IConstant.text_color, fontSize: 13.sp),
                  inputFormatters: [
                    //FilteringTextInputFormatter.deny(RegExp('[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]')),//拒绝特殊符号
                  ],
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: LanguageConfig.get(LanguageConfigKeys.Shop_mine_name),
                      labelStyle: TextStyle(fontSize: 13.sp, color: IConstant.sub_text_color),
                      hintStyle: TextStyle(color: IConstant.sub_text_color, fontSize: 13.sp)),
                  controller: ViewUtils.buildTextEditingController(username, listener: (str) {
                    username = str;
                  })
              )),
              buildVerifyStatus()
            ],
          )
      ),
    );
  }

  Widget buildGeneratorId() {
    return Container(
        margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
        padding: EdgeInsets.fromLTRB(10.w, 0.w, 10.w, 0),
        decoration: BoxDecoration(
            border: Border.all(color: IConstant.grey_bg_color, width: 1.w),
            borderRadius: BorderRadius.circular(10.w)),
        child: Row(
          children: [
            Expanded(child: TextField(
                enabled: false,
                maxLines: 1,
                keyboardType: TextInputType.text,
                style: TextStyle(color: IConstant.text_color, fontSize: 13.sp),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: LanguageConfig.get(LanguageConfigKeys.Shop_mine_account_id),
                    labelStyle: TextStyle(fontSize: 13.sp, color: IConstant.sub_text_color),
                    hintStyle: TextStyle(color: IConstant.sub_text_color, fontSize: 13.sp)),
                controller: ViewUtils.buildTextEditingController(generatorId, listener: (str) {
                  generatorId = str;
                })
            )),
            SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_mine_change_account_id),
                fontSize: 12.sp,
                bgColor: IConstant.text_color, top: 0, bottom: 0, onTap: () {
                  updateGenID();
                })
          ],
        )
    );
  }

  Widget buildNickname() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
      padding: EdgeInsets.fromLTRB(10.w, 0.w, 10.w, 0),
      decoration: BoxDecoration(
          border: Border.all(color: IConstant.grey_bg_color, width: 1.w),
          borderRadius: BorderRadius.circular(10.w)),
      child: TextField(
        textInputAction: TextInputAction.next,
        maxLines: 2,
        keyboardType: TextInputType.text,
        focusNode: _nodeText1,
        style: TextStyle(color: IConstant.text_color, fontSize: 13.sp),
        maxLength: 50,
        inputFormatters: [
          //FilteringTextInputFormatter.deny(RegExp('[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]')),//拒绝特殊符号
        ],
        decoration: InputDecoration(
            border: InputBorder.none,
            labelText: LanguageConfig.get(LanguageConfigKeys.Shop_mine_nickname),
            labelStyle: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color),
            hintStyle: TextStyle(color: IConstant.sub_text_color, fontSize: 14.sp)),
        controller: ViewUtils.buildTextEditingController(nickname, listener: (str) {
          nickname = str;
        }),
      ),
    );
  }

  Widget buildSignature() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
      padding: EdgeInsets.fromLTRB(10.w, 0.w, 10.w, 0),
      decoration: BoxDecoration(
          border: Border.all(color: IConstant.grey_bg_color, width: 1.w),
          borderRadius: BorderRadius.circular(10.w)),
      child: TextField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        focusNode: _nodeText2,
        style: TextStyle(color: IConstant.text_color, fontSize: 13.sp),
        inputFormatters: [
          //FilteringTextInputFormatter.deny(RegExp('[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]')),//拒绝特殊符号
        ],
        decoration: InputDecoration(
            border: InputBorder.none,
            labelText: LanguageConfig.get(LanguageConfigKeys.Shop_mine_describe),
            labelStyle: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color),
            hintStyle: TextStyle(color: IConstant.sub_text_color, fontSize: 14.sp)),
        controller: ViewUtils.buildTextEditingController(personalizedSignature, listener: (str) {
          personalizedSignature = str;
        }),
      ),
    );
  }

  Widget buildBirthDay() {
    return InkWell(
      onTap: () {
        showDatePicker();
      },
      child: Container(
          margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
          padding: EdgeInsets.fromLTRB(10.w, 0.w, 10.w, 0),
          decoration: BoxDecoration(
              border: Border.all(color: IConstant.grey_bg_color, width: 1.w),
              borderRadius: BorderRadius.circular(10.w)),
          child: Row(
            children: [
              Expanded(child: TextField(
                  enabled: false,
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: IConstant.text_color, fontSize: 13.sp),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: LanguageConfig.get(LanguageConfigKeys.Shop_mine_birthday),
                      labelStyle: TextStyle(fontSize: 13.sp, color: IConstant.sub_text_color),
                      hintStyle: TextStyle(color: IConstant.sub_text_color, fontSize: 13.sp)),
                  controller: ViewUtils.buildTextEditingController(getBirthday()))),
              Icon(Icons.chevron_right, size: 20.w, color: IConstant.text_color)
            ],
          )
      ),
    );
  }

  String getBirthday() {
    if (startDate != null) {
      return FormatUtil.formatLineYMD(startDate!);
    }
    return "";
  }

  Widget buildGender() {
    return InkWell(
      onTap: () {
        ShowBottomSheetTool().showSingleRowPicker(context, data: genderArr, title: LanguageConfig.get(LanguageConfigKeys.Shop_mine_select_gender), normalIndex: gender, clickCallBack: (int selectIndex, Object selectStr){
          setState(() {
            gender = selectIndex;
          });
        });
      },
      child: Container(
          margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
          padding: EdgeInsets.fromLTRB(10.w, 0.w, 10.w, 0),
          decoration: BoxDecoration(
              border: Border.all(color: IConstant.grey_bg_color, width: 1.w),
              borderRadius: BorderRadius.circular(10.w)),
          child: Row(
            children: [
              Expanded(child: TextField(
                enabled: false,
                maxLines: 1,
                keyboardType: TextInputType.text,
                style: TextStyle(color: IConstant.text_color, fontSize: 13.sp),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: LanguageConfig.get(LanguageConfigKeys.Shop_mine_gender),
                    labelStyle: TextStyle(fontSize: 13.sp, color: IConstant.sub_text_color),
                    hintStyle: TextStyle(color: IConstant.sub_text_color, fontSize: 13.sp)),
                controller: ViewUtils.buildTextEditingController(genderArr[gender]),
              )),
              Icon(Icons.chevron_right, size: 20.w, color: IConstant.text_color)
            ],
          )
      ),
    );
  }

  Widget buildVerifyStatus() {
    if (idCardStatus == 1) {
      return Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_verifying), style: TextStyle(fontSize: 12.sp, color: IConstant.main_color));
    } else if (idCardStatus == 2) {
      return Container(
        padding: EdgeInsets.fromLTRB(4.w, 2.w, 4.w, 2.w),
        decoration: BoxDecoration(
            border: Border.all(color: IConstant.main_color, width: 1.w),
            borderRadius: BorderRadius.circular(6.w)),
        child: Row(
          children: [
            Image.asset("assets/icons/flower.png", width: 18.w, height: 18.w),
            SizedBox(width: 2.w),
            Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_passed), style: TextStyle(fontSize: 12.sp, color: IConstant.main_color))
          ],
        ),
      );
    } else if(idCardStatus == -1){
      return Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_verify_failed), style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color));
    } else {
      return Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_unreal_name), style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color));
    }
  }

  String handleDate(DateTime dateTime) {
    return FormatUtil.formatLineYMD(dateTime); //格式化日期
  }

  void showDatePicker() {
    changeFocus();
    DateTime now = DateTime.now();
    DatePicker.showDatePicker(context,
        minDateTime: DateTime(now.year - 70),
        maxDateTime: DateTime(now.year - 14),
        onConfirm: (DateTime date, List<int> selectedIndex) {
          setState(() {
            startDate = date;
          });
        },
        initialDateTime: startDate, locale: AppUtils.getLocaleType());
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
    CroppedFile croppedFile = await ImageUtil.cropImage3(
        image: pickerImage,
        width: 512,
        height: 512);
    List<String> files = [];
    files.add(croppedFile.path);
    BaseRsp rsp = await HttpUtils.uploadFile(IURLConstant.MALL_PARSE_FILES, {}, files);
    if (rsp.retCode == RspRetCode.SUCCESS) {
      String icon = BaseModel.getString(rsp.data, "url");
      updateIcon(icon);
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  void updateInfo() async {
    String birthday = "";
    if (startDate != null) {
      birthday = FormatUtil.formatLineYMDHMS(startDate!);
      if (DateTime.now().year - startDate!.year < 14) {
        ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_mine_year_tip));
        return;
      }
    }
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_UPDATE_INFO,
        {
          "nickname": nickname,
          "birthday": birthday,
          "email": "",
          "personalizedSignature": personalizedSignature,
          "gender": "$gender",
        }
    );
    if (rsp.retCode == RspRetCode.SUCCESS) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_operation_successful));
      EventBusUtil.getInstance().emit(UserInfoEvent());
      finishContext(context);
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  void updateIcon(String icon) async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_UPDATE_ICON, {
      "icon": icon
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_operation_successful));
      EventBusUtil.getInstance().emit(UserInfoEvent());
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  void updateGenID() {
    showPop(0.7 * Adapt.getWindowHeight(), ChangeGenIDPage((ctx) => {
            setState(() {
              finishContext(ctx);
              //loadContentDatas();
              refreshGenID();
            })
          }));
  }

  refreshGenID() async{
    BaseRsp res = await HttpUtils.post(IURLConstant.MALL_SSO_INFO, {});
    setState(() {
      generatorId = BaseModel.getString(res.data, "generatorId");
    });
  }

  void updateMobile() {
    showPop(0.7 * Adapt.getWindowHeight(), VerifyMobilePage((ctx, code){
      finishContext(ctx);
      showPop(0.7 * Adapt.getWindowHeight(), ChangeMobilePage((ctx) => {
        setState(() {
          finishContext(ctx);
          loadContentDatas();
        })
      }));
    }));
  }

}
