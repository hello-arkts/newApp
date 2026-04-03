import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import 'package:sprintf/sprintf.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IURLConstant.dart';
import '../../../../config/LanguageConfig.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/AppUtils.dart';
import '../../../../utils/HttpUtils.dart';
import '../../../../utils/TextUtils.dart';
import '../../event/UserInfoEvent.dart';
import '../../utils/EventBusUtil.dart';
import '../../widget/BigTextButton.dart';
import '../../widget/GenAvatar.dart';
import '../../widget/LoadImageView.dart';

class DeleteAccountPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return DeleteAccountPageState();
  }

}

class DeleteAccountPageState extends BaseKeepAliveState<DeleteAccountPage> {

  dynamic userInfo;

  int idCardStatus = -1;

  String mobile = '';

  @override
  void initState() {
    super.initState();
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    dynamic data = await AppUtils.getUserInfo();
    setState(() {
      userInfo = data;
      idCardStatus = BaseModel.getInt(data, "idCardStatus");
      mobile = BaseModel.getString(data, "phone");
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.5.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_setting_account_cancellation),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: ListView(
        children: [
          buildUserInfo(),
          Container(
            padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 0.w),
          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_setting_account_cancel_tip1),
              style: TextStyle(fontSize: 15.w, fontWeight: FontWeight.bold, color: IConstant.text_color))),
          Container(
            padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_setting_account_cancel_tip2),
                style: TextStyle(fontSize: 13.w, color: IConstant.text_color)),
          )
        ],
      ),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildUserInfo() {
    return Container(
      padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
      child: Row(
          children: [
            ClipOval(child: buildAvatar()),
            SizedBox(width: 10.w),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(constraints: BoxConstraints(maxWidth: 200.w), child: Text(getDisplayName(), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.text_color))),
                    SizedBox(width: 4.w),
                    idCardStatus == 2 ? Image.asset("assets/icons/flower.png", width: 18.w, height: 18.w) : Container()
                  ],
                ),
                Text(BaseModel.getString(userInfo, "generatorId"), style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color))
              ],
            ))
          ]
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

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      child: Container(
        margin: EdgeInsets.all(20.w),
        child: BigTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_setting_account_delete),
            bgColor: IConstant.red_bg_color3, textColor: IConstant.main_color, onTap: () {
              showDeleteDialog();
            }),
      ),
    );
  }

  void showDeleteDialog() {
    ViewUtils.showCustomDialog2(context,
        LanguageConfig.get(LanguageConfigKeys.Shop_setting_account_confirm_delete),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
              color: IConstant.grey_bg_color,
              borderRadius: BorderRadius.circular(8.w)),
          child: Column(
            children: [
              SizedBox(height: 30.w,
              child: Row(children: [
                Icon(Icons.circle, size: 10.w, color: IConstant.main_color),
                SizedBox(width: 6.w),
                Expanded(child: Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_setting_account_confirm_tip1), [FormatUtil.price2String(BaseModel.getDouble(userInfo, "balance"), fixed: 2)]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11.sp, color: IConstant.text_color))),
              ]),),
              SizedBox(height: 6.w),
              SizedBox(height: 30.w,
              child: Row(children: [
                Icon(Icons.circle, size: 10.w, color: IConstant.main_color),
                SizedBox(width: 6.w),
                Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_setting_account_confirm_tip2),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11.sp, color: IConstant.text_color))),
              ]),)
            ],
          ),
        ),
        LanguageConfig.get(LanguageConfigKeys.Shop_setting_account_not_delete),
        LanguageConfig.get(LanguageConfigKeys.Shop_setting_account_now_delete), (ctx, event) {
          if (event == DialogEvent.confirm) {
            finishContext(ctx);
            deleteAccount();
          } else {
            finishContext(ctx);
          }
        }
    );
  }

  Future<void> deleteAccount() async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_DELETE_USER, {
      'telephone': mobile,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      exit();
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  Future<void> exit() async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.LOGOUT_URL, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      await AppUtils.clearData();
      EventBusUtil.getInstance().emit(UserInfoEvent(userInfoStatus: UserInfoStatus.complete));
      backHome();
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

}
