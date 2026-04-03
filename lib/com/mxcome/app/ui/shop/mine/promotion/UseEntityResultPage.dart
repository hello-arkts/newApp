import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../model/BaseModel.dart';
import '../../widget/LoadImageView.dart';
import '../../widget/PriceText.dart';
import '../../widget/SmallTextButton.dart';

class UseEntityResultPage extends StatefulWidget {

  dynamic prize;

  Function(BuildContext context) callBack;

  UseEntityResultPage({required this.prize, required this.callBack});

  @override
  State<StatefulWidget> createState() {
    return UseEntityResultPageState();
  }

}

class UseEntityResultPageState extends BaseKeepAliveState<UseEntityResultPage> {

  dynamic _prize;
  int _status = 0;

  @override
  void initState() {
    super.initState();
    _prize = widget.prize;
    _status = BaseModel.getInt(widget.prize, "status");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_waiting_for_shipment),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildBody() {
    dynamic gift = BaseModel.getDynamic(_prize, "gift");
    String pic = BaseModel.getDynamic(gift, "pic");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 10.w),
            padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
            decoration: BoxDecoration(
                border: Border.all(width: 1.w, color: IConstant.line_color),
                borderRadius: BorderRadius.all(Radius.circular(12.w))),
            child: Row(
              children: [
                ClipOval(
                    child: LoadImageView(60.w, 60.w, pic.split(',')[0])),
                SizedBox(width: 10.w),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(BaseModel.getString(gift, "merchantName"),
                                style: TextStyle(
                                    fontSize: 14.sp, color: IConstant.text_color)),
                            SizedBox(width: 10.w),
                            Container(
                              padding: EdgeInsets.fromLTRB(8.w, 2.w, 8.w, 2.w),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1.w, color: IConstant.main_color),
                                  borderRadius: BorderRadius.circular(10.w)),
                              child: Text(getType(BaseModel.getInt(_prize, "type")), style: TextStyle(fontSize: 12.sp, color: IConstant.main_color)),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.w),
                        Row(
                          children: [
                            Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_value), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                            SizedBox(width: 2.w),
                            PriceText(BaseModel.getDouble(gift, "sellPrice"),
                                fontSize: 12.sp, color: IConstant.text_color),
                            expandeSpace,
                            Text("×${BaseModel.getInt(_prize, "quantity")}",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 12.sp, color: IConstant.sub_text_color))
                          ],
                        )
                      ],
                    )),
              ],
            )
        ),
        SizedBox(height: 8.w),
        Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_keep_working_hard),
            style: TextStyle(
                fontSize: 14.sp, color: IConstant.text_color))
      ],
    );
  }

  String getType(int type) {
    if (type == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_exchange_voucher);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_entity_prizes);
    }
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      elevation: 0.w,
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
        height: 50.w,
        alignment: Alignment.center,
        child: SizedBox(
          width: 180.w,
          child: SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_mine_detail), onTap: () {
            widget.callBack(context);
          }),
        ),
      ),
    );
  }

}
