import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:url_launcher/url_launcher.dart';

class JumpPage extends StatefulWidget {
  final String note;
  final String applyUrl;
  final bool selfApplyStatus;

  const JumpPage({
    Key? key,
    required this.note,
    required this.applyUrl,
    this.selfApplyStatus = false,
  }) : super(key: key);

  @override
  State<JumpPage> createState() => _JumpPageState();
}

class _JumpPageState extends State<JumpPage> {
  // 自行申请点击事件
  Future<void> _handleApplyClick() async {
    if (widget.applyUrl.isNotEmpty) {
      final Uri url = Uri.parse(widget.applyUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 二维码图片
                    Container(
                      width: 260.w,
                      height: 360.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.w),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        image: const DecorationImage(
                          image: AssetImage('assets/icons/wexin.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.w),
                    Text(
                      "长按保存到手机",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: IConstant.grey_color,
                      ),
                    ),
                    SizedBox(height: 40.w), // 底部留白
                  ],
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
        title: const Text(
          '返回',
          style: TextStyle(color: Color(0xFF333333)),
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
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.note.isNotEmpty ? widget.note : widget.applyUrl,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF333333),
                      height: 1.6,
                    ),
                  ),
                ),
              ),

              // 底部按钮区域
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.selfApplyStatus)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: ElevatedButton(
                          onPressed: _handleApplyClick,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5668F4),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.w),
                            ),
                            minimumSize: Size(double.infinity, 48.w),
                          ),
                          child: Text(
                            '自行申请',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: widget.selfApplyStatus ? 8.w : 0),
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
                          '联系客服',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
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
