
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/UserInfoEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/SmallTextButton.dart';
import 'package:sprintf/sprintf.dart';

class ObtainedRedPage extends StatefulWidget {

  dynamic registerInfo;

  Function(BuildContext context)? callBack;

  ObtainedRedPage(this.registerInfo, {this.callBack});

  @override
  State<StatefulWidget> createState() {
    return ObtainedRedPageState();
  }

}

class ObtainedRedPageState extends BaseKeepAliveState<ObtainedRedPage> {

  int zhongziDay = 7;

  int redActivityValidity = 90;

  @override
  void initState() {
    super.initState();
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    EventBusUtil.getInstance().emit(UserInfoEvent(userInfoStatus: UserInfoStatus.complete));
    isLoading = true;
    setState(() {
      zhongziDay = BaseModel.getInt(widget.registerInfo, "zhongziDay");
      redActivityValidity = BaseModel.getInt(widget.registerInfo, "redActivityValidity");
    });
    isLoading = false;
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
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_product_obtaining_red_qualification),
            style: TextStyle(fontSize: 17.w, color: IConstant.text_color)),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 150.w,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: Image.asset("assets/icons/ic_get_red_pop.png").image)),
          ),
          SizedBox(height: 10.w),
          Container(
            height: 60.w,
            margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.w),
            child: Row(
              children: [
                Container(width: 3.w, color: IConstant.red_bg_color),
                SizedBox(width: 12.w),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(LanguageConfig.get(LanguageConfigKeys.Shop_product_red_pop_tip1),
                        maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.sp, color: IConstant.text_color)),
                    Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_product_red_pop_tip2), [ redActivityValidity ]),
                        maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.sp, color: IConstant.text_color)),
                  ],
                ))
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: buildBottomBar(),
    );
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
          child: SmallTextButton(text: LanguageConfig.get(LanguageConfigKeys.ViewUtils_confirm), onTap: () {
            widget.callBack!(context);
            //finish();
          }),
        ),
      ),
    );
  }


}
