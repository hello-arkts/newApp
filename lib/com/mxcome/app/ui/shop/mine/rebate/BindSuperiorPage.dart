
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/IURLConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/model/BaseRsp.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/LoadImageView.dart';
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';

class BindSuperiorPage extends StatefulWidget {

  String superiorId;

  BindSuperiorPage({required this.superiorId});

  @override
  State<StatefulWidget> createState() {
    return BindSuperiorPageState();
  }
}

class BindSuperiorPageState extends BaseKeepAliveState<BindSuperiorPage> {

  dynamic memberInfo;

  @override
  void initState() {
    super.initState();
    loadContentDatas();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_SSO_INFO_BY_ID, {"memberId" : widget.superiorId});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        memberInfo = rsp.data;
      });
    }else {
      setState(() {
        memberInfo = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        leading: Container(),
        title: Text(LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_bind_superior), style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return memberInfo == null ? ViewUtils.buildLoading() : Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 20.w),
        child: Column(
          children: [
            Column(
              children: [
                ClipOval(child: LoadImageView(90.w, 90.w, BaseModel.getString(memberInfo, "icon"))),
                SizedBox(height: 10.w,),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: 200.w
                  ),
                  child: Text(
                    getDisplayName(memberInfo),
                    style: TextStyle(
                      color: IConstant.text_color,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 3.w),
              margin: EdgeInsets.only(top: 25.w),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: IConstant.blue_color.withOpacity(0.04),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.w, color: IConstant.blue_color),
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: Text(
                LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_bind_superior_tips),
                style: TextStyle(
                  color: IConstant.text_color,
                  fontSize: 12.sp,
                  height: 1.14
                ),
              ),
            ),
            SizedBox(height: 60.w,),
            InkWell(
              onTap: () async{
                confirmBindSuperior();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 8.w),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: IConstant.main_color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/ic_confirm_bind.png",
                      width: 24.w,
                      height: 24.w,
                    ),
                    SizedBox(width: 10.w,),
                    Text(
                      LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_bind_superior_confirm),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        )
    );
  }

  String getDisplayName(dynamic item) {
    String nickName = BaseModel.getString(item, "nickname");
    String generatorId = BaseModel.getString(item, "generatorId");
    return TextUtils.isNotEmpty(nickName) ? nickName: generatorId;
  }

  Future<void> confirmBindSuperior() async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_SSO_BIND_SUPERIOR, {
      "memberId": widget.superiorId,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_bind_superior_success));
      finish();
    }  else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }
}
