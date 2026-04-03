import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/PageConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/rebate/BindSuperiorPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/rebate/RebateQrScanPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/ImageUtil.dart';
import 'package:mxcome/com/mxcome/app/utils/Adapt.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:recognition_qrcode/recognition_qrcode.dart';

import '../../../BaseKeepAliveState.dart';
import '../event/QRCodeEvent.dart';

class QRCodePage extends StatefulWidget {
 
  QRCodePage();

  @override
  State<StatefulWidget> createState() => QRCodePageState();
}

class QRCodePageState extends BaseKeepAliveState<QRCodePage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          _buildQrView(context),
          Positioned(
            bottom: 40.w,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    showPop(0.9 * Adapt.getWindowHeight(), RebateQrScanPage());
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.w),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icons/ic_rebate_qr_code.png",
                          width: 26.w,
                          height: 26.w,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_exclusive_qr_code),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: IConstant.text_color,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 40.w,),
                InkWell(
                  onTap: () async{
                    XFile pickerImage = await ImageUtil.pickSinglePic(ImageFrom.gallery);
                    RecognitionQrcode.recognition(
                        pickerImage.path).then((result) {
                      if (TextUtils.isNotEmpty(result["value"])) {
                        if (result["value"].startsWith(PageConstant.MXCOME_WEB_URI)) {
                        } else {
                          parserAppScanResult(Uri.parse(result["value"]));
                        }
                      }
                    }).catchError((onError) {
                      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_recognition_error),);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.w),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icons/ic_rebate_qr_album.png",
                          width: 26.w,
                          height: 26.w,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          LanguageConfig.get(LanguageConfigKeys.shop_mine_rebate_album),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: IConstant.text_color,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
          //Expanded(flex: 5, child: _buildQrView(context)),
          // Expanded(
          //   flex: 1,
          //   child: FittedBox(
          //     fit: BoxFit.contain,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: <Widget>[
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: <Widget>[
          //             Container(
          //               margin: const EdgeInsets.all(8),
          //               child: ElevatedButton(
          //                   onPressed: () async {
          //                     await controller?.toggleFlash();
          //                     setState(() {});
          //                   },
          //                   child: FutureBuilder(
          //                     future: controller?.getFlashStatus(),
          //                     builder: (context, snapshot) {
          //                       return Text('Flash: ${snapshot.data}');
          //                     },
          //                   )),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  parserAppScanResult(Uri? uri) {
    try {
      if (uri == null) return;
      String path = uri.path;
      if (path.isNotEmpty && path.contains("bind")) {
        List<String> segments = uri.pathSegments;
        String superiorId = segments.last;
        showPop(0.54 * Adapt.getWindowHeight(), BindSuperiorPage(superiorId: superiorId,));
      }
    } catch (e) {
      TextUtils.println(e);
    }
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    controller.resumeCamera();
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      this.controller!.stopCamera();
      EventBusUtil.getInstance().emit(QRCodeEvent("${result?.code}"));
      finishContext(context);
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

}

