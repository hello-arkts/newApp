import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/IURLConstant.dart';
import 'package:mxcome/com/mxcome/app/PageConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/model/BaseRsp.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/LoadImageView.dart';
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/PermissionHelper.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';

class RebateQrScanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RebateQrScanPageState();
  }
}

class RebateQrScanPageState extends BaseKeepAliveState<RebateQrScanPage> {

  dynamic userInfo;

  String rebateQrInfo = "";

  String parentMemberNickname = "";

  String parentMemberGeneratorId = "";

  GlobalKey repaintKey = GlobalKey();

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
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_SSO_INFO, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        userInfo = rsp.data;
        rebateQrInfo = "${PageConstant.WEB_BASE_URI}bind/${BaseModel.getString(userInfo, "id")}";
        parentMemberNickname = BaseModel.getString(userInfo, "parentMemberNickname");
        parentMemberGeneratorId = BaseModel.getString(userInfo, "parentMemberGeneratorId");
      });
    }else {
      setState(() {
        userInfo = null;
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
        title: Text(LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_exclusive_qr_code), style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildBody() {
    return userInfo == null ? ViewUtils.buildLoading() : Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 20.w),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.w),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: IConstant.blue_color.withOpacity(0.04),
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.w, color: IConstant.blue_color,),
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                parentMemberGeneratorId.isEmpty ? Text(
                  LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_no_superior),
                  style: TextStyle(
                    color: IConstant.blue_color,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold
                  ),
                ) : Row(
                  children: [
                    Text(
                      LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_my_superior),
                      style: TextStyle(
                          color: IConstant.blue_color,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: ClipOval(child: LoadImageView(24.w, 24.w, BaseModel.getString(userInfo, "parentMemberIcon"))),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: 200.w
                      ),
                      child: Text(
                        parentMemberNickname.isEmpty ? parentMemberGeneratorId : parentMemberNickname,
                        style: TextStyle(
                            color: IConstant.text_color,
                            fontSize: 14.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 30.w,),
          RepaintBoundary(
            key: repaintKey,
            child: Container(
              height: 200.w,
              width: 200.w,
              color: Colors.white,
              child: QrImageView(
                data: rebateQrInfo,
                version: QrVersions.auto,
                size: 200.0.w,
              ),
            ),
          ),
          SizedBox(height: 20.w,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 11.w),
            margin: EdgeInsets.symmetric(horizontal: 30.w),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.w, color: IConstant.line_color),
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_my_superior_tips1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: IConstant.text_color,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 2.w,),
                Text(
                  LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_my_superior_tips2),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: IConstant.text_color,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          )
        ],
      )
    );
  }

  Widget buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      elevation: 0.w,
      child: Container(
        margin: EdgeInsets.only(bottom: 50.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                showPermissionDialog(Permission.storage);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.w),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: IConstant.red_bg_color3,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.w, color: IConstant.main_color),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/ic_save_qr_code.png",
                      width: 24.w,
                      height: 24.w,
                    ),
                    SizedBox(width: 10.w,),
                    Text(
                      LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_save),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: IConstant.main_color,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                shareQrImage();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.w),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: IConstant.red_bg_color3,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.w, color: IConstant.main_color),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/ic_promote_subordinates.png",
                      width: 24.w,
                      height: 24.w,
                    ),
                    SizedBox(width: 10.w,),
                    Text(
                      LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_recommend),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: IConstant.main_color,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> showPermissionDialog(Permission permission) async {
    String denied = LanguageConfig.get(LanguageConfigKeys.Shop_permission_denied);
    String granted = LanguageConfig.get(LanguageConfigKeys.Shop_permission_granted);
    String cancel = LanguageConfig.get(LanguageConfigKeys.Shop_permission_setting_cancel);
    String open = LanguageConfig.get(LanguageConfigKeys.Shop_permission_setting_open);
    String title = LanguageConfig.get(LanguageConfigKeys.Shop_permission_photos_title);
    String content = LanguageConfig.get(LanguageConfigKeys.Shop_permission_photos_content);
    String settingTitle = LanguageConfig.get(LanguageConfigKeys.Shop_permission_photos_setting_title);
    String settingContent = LanguageConfig.get(LanguageConfigKeys.Shop_permission_photos_setting_content);
    PermissionHelper.check(permission,
        onSuccess: () {
          Future.delayed(Duration.zero, () {
            savePhoto();
          });
        }, onFailed: () {
          ViewUtils.showRemindDialog2(context,
              title,
              content,
              denied,
              granted, (ctx, event) {
                if (event == DialogEvent.confirm) {
                  PermissionHelper.requestPermission(permission,
                      onSuccess: () {
                        Future.delayed(Duration.zero, () {
                          savePhoto();
                        });
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

  void savePhoto() async {
    RenderRepaintBoundary? boundary = repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    var image = await boundary!.toImage();
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List images = byteData!.buffer.asUint8List();
    await ImageGallerySaver.saveImage(images, quality: 60,);
    ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_save_success));
  }

  void shareQrImage() async {
    File qrFile = await byteDataToFile();
    final files = <XFile>[];
    files.add(XFile(qrFile.path));
    Share.shareXFiles(files);
  }

  Future<File> byteDataToFile() async{
    RenderRepaintBoundary? boundary = repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    var image = await boundary!.toImage();
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List finalPngBytes = byteData!.buffer.asUint8List();
    final document = await getApplicationDocumentsDirectory();
    final dir = Directory('${document.path}/superior_qr.png');
    final imageFile = File(dir.path);
    await imageFile.writeAsBytes(finalPngBytes);
    return imageFile;
  }
}
