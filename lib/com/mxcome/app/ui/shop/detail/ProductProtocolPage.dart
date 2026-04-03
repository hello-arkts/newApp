
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IURLConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../../LanguagePage.dart';
import '../widget/SmallTextButton.dart';


class ProductProtocolPage extends StatefulWidget {

  String productId;
  Function(bool sure) callBack;

  ProductProtocolPage(this.productId, this.callBack);

  @override
  State<StatefulWidget> createState() {
    return ProductProtocolPageState();
  }
}

class ProductProtocolPageState extends BaseKeepAliveState<ProductProtocolPage> {

  bool checked = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leading: Container(),
          title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_vip_agreement_title),
            style: TextStyle(fontSize: 17.w, color: IConstant.text_color),
          ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        child: buildBody(),
      ),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Future<String> loadMarkdown() async {
    switch(LanguagePage.language) {
      case 'TH':
        return await rootBundle.loadString('assets/md/product-protocol-th.md');
      case 'ZH':
        return await rootBundle.loadString('assets/md/product-protocol-zh.md');
      case 'EN':
        return await rootBundle.loadString('assets/md/product-protocol-en.md');
      default:
        return await rootBundle.loadString('assets/md/product-protocol-th.md');
    }
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: FutureBuilder<String>(
        future: loadMarkdown(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return MarkdownBody(data: snapshot.requireData);
            }
          } else {
            return const CircularProgressIndicator(); // 加载指示器
          }
        },
      ),
    );
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 120.w,
      child: Column(
       children: [
         Row(
           children: [
             Checkbox(value: checked, fillColor: WidgetStateProperty.resolveWith((states) {
               if (states.contains(WidgetState.selected)) {
                 return IConstant.main_color;  //选中时的背景颜色
               }
               return IConstant.white_color;  //未选中时的背景颜色
             }), checkColor: IConstant.white_color, onChanged: (check) {
               setChecked();
             }),
             InkWell(
               onTap: () {
                 setChecked();
               },
               child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_full_read_agree), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color),),
             )
           ],
         ),
         Row(
           children: [
             SizedBox(width: 20.w,),
             Expanded(child: SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.ViewUtils_cancel), bgColor: IConstant.grey_bg_color, textColor: IConstant.text_color, onTap: () {
                finish();
             }),),
             SizedBox(width: 20.w,),
             Expanded(child:  SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.ViewUtils_confirm), onTap: () {
                agree();
             }),),
             SizedBox(width: 20.w,),
           ],
         )
       ],
      ),
    );
  }

  void setChecked() {
    checked = !checked;
    setState((){});
  }

  Future<void> agree() async {
    if (!checked) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_please_check_agreement));
      return;
    }
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_AGREE, {
      "productId": widget.productId,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      widget.callBack(true);
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

}
