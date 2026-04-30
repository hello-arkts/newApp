import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';

class ContactServiceDrawer extends StatelessWidget {
  final List dataList;

  const ContactServiceDrawer({super.key, required this.dataList});

  static void show(BuildContext context, List dataList) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ContactServiceDrawer(dataList: dataList);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.w)),
      ),
      child: Column(
        children: [
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
            child: dataList.isEmpty
                ? Center(
                    child: Text(
                      LanguageConfig.get(
                          LanguageConfigKeys.JumpPage_contact_customer_service),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: IConstant.grey_color,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      final item = dataList[index];
                      final picUrl = BaseModel.getString(item, 'picUrl');
                      return Container(
                        margin: EdgeInsets.only(bottom: 16.w),
                        child: Column(
                          children: [
                            GestureDetector(
                              onLongPress: () async {
                                try {
                                  final ByteData data = await rootBundle
                                      .load('assets/icons/wexin.png');
                                  final Uint8List bytes =
                                      data.buffer.asUint8List();
                                  final result =
                                      await ImageGallerySaver.saveImage(bytes);
                                  if (result['isSuccess']) {
                                    ViewUtils.displayToast(LanguageConfig.get(
                                        LanguageConfigKeys.JumpPage_save_success));
                                  } else {
                                    ViewUtils.displayToast(LanguageConfig.get(
                                        LanguageConfigKeys.JumpPage_save_fail));
                                  }
                                } catch (e) {
                                  ViewUtils.displayToast(LanguageConfig.get(
                                      LanguageConfigKeys.JumpPage_save_error));
                                }
                              },
                              child: Center(
                                child: Image.network(
                                  picUrl,
                                  width: 260.w,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.w),
                            Text(
                              LanguageConfig.get(LanguageConfigKeys
                                  .JumpPage_long_press_save_to_phone),
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
  }
}