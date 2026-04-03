
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/UserInfoEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/Util.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IURLConstant.dart';
import '../../../../config/LanguageConfig.dart';
import '../../../../model/BaseModel.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/AppUtils.dart';
import '../../../../utils/HttpUtils.dart';
import '../../../../utils/TextUtils.dart';
import '../../../../utils/ViewUtils.dart';
import '../../../../widget/PartRefreshWidget.dart';
import '../../widget/BigTextButton.dart';
import '../../widget/GenAvatar.dart';
import '../../widget/LoadImageView.dart';

class ChangeGenIDPage extends StatefulWidget {

  Function(BuildContext context) callBack;

  ChangeGenIDPage(this.callBack);

  @override
  State<StatefulWidget> createState() {
    return ChangeGenIDPageState();
  }

}

class ChangeGenIDPageState extends BaseKeepAliveState<ChangeGenIDPage> {

  dynamic userInfo;

  String generatorId = '';

  dynamic userInfoEvent;

  bool isClickEnable = false;

  final FocusNode _nodeText1 = FocusNode();

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
    await getServiceTime();
    dynamic data = await AppUtils.getUserInfo();
    setState(() {
      userInfo = data;
      generatorId = BaseModel.getString(userInfo, "generatorId");
    });
    checkInput();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return KeyboardDismissOnTap(
      child: Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_change_account_id),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: ListView(
          children: [
            buildMember(),
            buildGeneratorId(),
          ]
      ),
      bottomNavigationBar: buildBottomBar(),
    ));
  }

  Widget buildMember() {
    return Center(child: Container(
      margin: EdgeInsets.fromLTRB(20.w, 30.w, 20.w, 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(child: buildAvatar()),
          Text(getDisplayName(), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
          Text(generatorId, style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color))
        ],
      ),
    ));
  }

  Widget buildAvatar() {
    String avatar = BaseModel.getString(userInfo, "icon");
    if (TextUtils.isNotEmpty(avatar)) {
      return SizedBox(
        width: 50.w,
        height: 50.w,
        child: GenAvatar(avatar),
      );
    } else {
      String displayName = getDisplayName();
      return Container(
          width: 50.w,
          height: 50.w,
          color: IConstant.red_translucent_color,
          child: Center(
              child: Text(TextUtils.isNotEmpty(displayName) ? displayName.substring(0, 1) : "",
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 20.sp, color: IConstant.white_color))));
    }
  }

  String getDisplayName() {
    String nickname = BaseModel.getString(userInfo, "nickname");
    String username = BaseModel.getString(userInfo, "username");
    String phoneCode = BaseModel.getString(userInfo, "phoneCode");
    String phone = BaseModel.getString(userInfo, "phone");
    return TextUtils.isNotEmpty(nickname) ? nickname: "$phoneCode $phone";
  }

  Widget buildGeneratorId() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
          child: TextField(
            textInputAction: TextInputAction.done,
            maxLines: 1,
            keyboardType: TextInputType.text,
            focusNode: _nodeText1,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[a-z0-9]")), //数字
              LengthLimitingTextInputFormatter(12),
            ],
            style: TextStyle(color: IConstant.title_color, fontSize: 14.sp),
            decoration: InputDecoration(
                labelText: LanguageConfig.get(LanguageConfigKeys.Shop_mine_account_id),
                labelStyle: TextStyle(fontSize: 16.sp, color: IConstant.sub_text_color),
                hintStyle: TextStyle(color: IConstant.sub_text_color, fontSize: 14.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50.w)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: IConstant.grey_bg_color, width: 1.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: IConstant.grey_bg_color, width: 1.w),
                )),
            controller: ViewUtils.buildTextEditingController(generatorId, listener: (str) {
              generatorId = str;
              checkInput();
            }),
            onSubmitted: (str) {
              checkInput();
              if (isClickEnable) {
                if(isGenIDModified()) {
                  ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_mine_account_modify_once));
                }else {
                  updateGenId();
                }
              }
            },
          ),
        ),
        SizedBox(height: 10.w,),
        Container(margin: EdgeInsets.only(right: 20.w), child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_account_modify_once), style: TextStyle(fontSize: 12.sp, color: IConstant.main_color)))
      ],
    );
  }

  GlobalKey<PartRefreshWidgetState> refreshBtn = GlobalKey();

  void checkInput() {
    if (TextUtils.isNotEmpty(generatorId) && generatorId.length >= 6) {
      if (isClickEnable) return;
      isClickEnable = true;
      refreshBtn.currentState?.update();
    } else {
      if (!isClickEnable) return;
      isClickEnable = false;
      refreshBtn.currentState?.update();
    }
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      child: Container(
        margin: EdgeInsets.all(20.w),
        child: PartRefreshWidget(
            refreshBtn, () =>
            BigTextButton(text: LanguageConfig.get(LanguageConfigKeys.ViewUtils_confirm),
                enable: isClickEnable,
                onTap: () {
              if(isGenIDModified()) {
                ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_mine_account_modify_once));
              }else {
                updateGenId();
              }
            })
        ),
      ),
    );
  }

  isGenIDModified() {
    String updateTime = BaseModel.getString(userInfo, 'updateTime');
    if(updateTime.isEmpty) {
      return false;
    }
    var updateDateTime = DateTime.parse(updateTime);
    var endTime = DateTime(updateDateTime.year + 1, updateDateTime.month, updateDateTime.day);
    //var endTime = updateDateTime.add(const Duration(minutes: 5));
    var serviceDateTime = DateTime.parse(serviceTime);
    // 如果剩余时间已经不足一分钟，则不必计时，直接标记超时
    if (endTime.millisecondsSinceEpoch - serviceDateTime.millisecondsSinceEpoch <
        1000) {
      return false;
    } else {
      return true;
    }
  }

  void updateGenId() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_UPDATE_GENERATORID, {
      "generatorId": generatorId
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_operation_successful));
      EventBusUtil.getInstance().emit(UserInfoEvent());
      setState(() {
        widget.callBack(context);
      });
    } else if (rsp.retCode == 407) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_mine_account_id_already_exists));
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

}
