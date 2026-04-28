import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/Logger.dart';
import 'package:mxcome/com/mxcome/app/model/homeAdvertiseServer.dart';
import 'package:mxcome/com/mxcome/app/model/BaseRsp.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';

class JumpPage extends StatefulWidget {
  final int? itemId;

  const JumpPage({
    Key? key,
    this.itemId,
  }) : super(key: key);

  @override
  State<JumpPage> createState() => _JumpPageState();
}

class _JumpPageState extends State<JumpPage> {
  @override
  void initState() {
    super.initState();
    _fetchDetailData();
  }

  List picProductList = [];
  List keFuList = [];
  Object? selfApplyAdvertise;

  Future<void> _fetchDetailData() async {
    try {
      BaseRsp rsp = await HomeAdvertiseServer.featuredPromotionDetailUrl({
        'id': widget.itemId.toString(),
      });
      if (rsp.retCode == RspRetCode.SUCCESS) {
        setState(() {
          picProductList = BaseModel.getDynamicList(rsp.data, 'picProductList');
          keFuList = BaseModel.getDynamicList(rsp.data, 'keFuList');
          selfApplyAdvertise = rsp.data['advertise'];
        });
      }
    } catch (e) {
      Logger.log('JumpPage error: $e');
    }
  }

  // 显示联系客服抽屉
  void _showContactDrawer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.w)),
          ),
          child: Column(
            children: [
              // 拖拽把手
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 12.w, bottom: 20.w),
                  width: 40.w,
                  height: 4.w,
                  decoration: BoxDecoration(
                    color: IConstant.grey_color.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: keFuList.length,
                  itemBuilder: (context, index) {
                    final item = keFuList[index];
                    final picUrl = BaseModel.getString(item, 'picUrl');
                    return Container(
                      margin: EdgeInsets.only(bottom: 16.w),
                      child: Column(
                        children: [
                          GestureDetector(
                            onLongPress: () async {
                              try {
                                final ByteData data =
                                    await rootBundle.load('assets/icons/wexin.png');
                                final Uint8List bytes = data.buffer.asUint8List();
                                final result =
                                    await ImageGallerySaver.saveImage(bytes);
                                if (result['isSuccess']) {
                                  ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.JumpPage_save_success));
                                } else {
                                  ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.JumpPage_save_fail));
                                }
                              } catch (e) {
                                ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.JumpPage_save_error));
                              }
                            },
                            child: Image.network(
                              picUrl,
                              width: 260.w,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          SizedBox(height: 8.w),
                          Text(
                            LanguageConfig.get(LanguageConfigKeys.JumpPage_long_press_save_to_phone),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: IConstant.grey_color,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LanguageConfig.get(LanguageConfigKeys.JumpPage_back),
          style: const TextStyle(color: Color(0xFF333333)),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF333333)),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
          child: Column(
            children: [
              // 提示文本区域
              Expanded(
                child: ListView.builder(
                  itemCount: picProductList.length,
                  itemBuilder: (context, index) {
                    final item = picProductList[index];
                    final picUrl = BaseModel.getString(item, 'picUrl');
                    return Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 16.w),
                      child: Image.network(
                        picUrl,
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                      ),
                    );
                  },
                ),
              ),

              // 底部按钮区域
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: _showContactDrawer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5668F4),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.w),
                          ),
                          minimumSize: Size(double.infinity, 48.w),
                        ),
                        child: Text(
                          LanguageConfig.get(LanguageConfigKeys.JumpPage_contact_customer_service),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ),
                ],
              ),
              SizedBox(height: 20.w),
            ],
          ),
        ),
      ),
    );
  }
}
