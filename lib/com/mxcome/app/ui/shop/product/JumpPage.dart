import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/Logger.dart';
import 'package:mxcome/com/mxcome/app/model/homeAdvertiseServer.dart';
import 'package:mxcome/com/mxcome/app/model/BaseRsp.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/detail/ProductDetailPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/ContactServiceDrawer.dart';
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
    ContactServiceDrawer.show(context, keFuList);
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
                    final productId = BaseModel.getInt(item, 'productId');
                    return GestureDetector(
                      onTap: () {
                        if (widget.itemId.toString() == '14') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(productId.toString(), showContactService: true, contactServiceData: keFuList),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 16.w),
                        child: Image.network(
                          picUrl,
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                        ),
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
