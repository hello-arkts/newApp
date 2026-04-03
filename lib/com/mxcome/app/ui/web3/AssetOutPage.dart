
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/SelectModel.dart';
import 'package:mxcome/com/mxcome/app/ui/web3/SelectAddressPage.dart';

import '../../model/BaseModel.dart';
import '../../utils/Adapt.dart';
import '../../utils/TextUtils.dart';
import '../../utils/ViewUtils.dart';
import '../../widget/PartRefreshWidget.dart';
import '../shop/widget/LoadImageView.dart';
import 'ActionSliderPage.dart';

class AssetOutPage extends StatefulWidget {

  List<dynamic> walletList = [];

  AssetOutPage(this.walletList);

  @override
  State<StatefulWidget> createState() => AssetOutPageState();

}

class AssetOutPageState extends BaseKeepAliveState<AssetOutPage> {

  List<dynamic> _walletList = [];

  String _exchangeAddress = '';

  final FocusNode _nodeText1 = FocusNode();

  bool isClickEnable = false;

  dynamic _selectCoinInfo;
  List<SelectModel> _selectList = [];

  @override
  void initState() {
    super.initState();
    _walletList = widget.walletList;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.w,
          centerTitle: true,
          title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_web3_transfer_out),
              style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.w),
              child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_web3_address), style: TextStyle(fontSize: 15.sp, color: IConstant.text_color)),),
            Container(
              decoration: BoxDecoration(border: Border.all(color: IConstant.line_color2, width: 1.w),
                  borderRadius: BorderRadius.circular(10.w)),
              margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.w),
              padding: EdgeInsets.only(left: 12.w, right: 12.w),
              child: TextField(
                textInputAction: TextInputAction.next,
                maxLines: 1,
                keyboardType: TextInputType.text,
                focusNode: _nodeText1,
                style: TextStyle(color: IConstant.title_color, fontSize: 14.sp),
                decoration: InputDecoration(
                    icon: Image.asset(
                      'assets/icons/web3_asset_wallet.png',
                      width: 20.w,
                      height: 20.w,
                    ),
                    hintText: LanguageConfig.get(LanguageConfigKeys.Shop_web3_enter_receive_wallet_address),
                    hintStyle: TextStyle(color: IConstant.sub_text_color, fontSize: 14.sp),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: IConstant.line_color, width: 1.w),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: IConstant.line_color, width: 1.w),
                    )),
                controller: ViewUtils.buildTextEditingController(_exchangeAddress, listener: (str) {
                  _exchangeAddress = str;
                  checkInput();
                }),
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.w),
              child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_web3_assets), style: TextStyle(fontSize: 15.sp, color: IConstant.text_color)),),
            InkWell(
              onTap: () {
                changeFocus();
                showPop(0.9 * Adapt.getWindowHeight(), SelectAddressPage(_walletList, (selectCoinInfo, selectList) {
                  _selectCoinInfo = selectCoinInfo;
                  _selectList = selectList;
                  setState((){});
                  checkInput();
                }));
              },
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: IConstant.line_color2, width: 1.w),
                    borderRadius: BorderRadius.circular(10.w)),
                height: 50.w,
                margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 12.w),
                padding: EdgeInsets.symmetric(horizontal: 12.w,),
                child: _selectList.isNotEmpty ? Row(
                  children: [
                    Padding(padding: EdgeInsets.only(right: 10.w),
                        child: LoadImageView(30.w, 30.w, BaseModel.getString(_selectCoinInfo, "didCoin"))),
                    Text(BaseModel.getString(_selectCoinInfo, "didName"), style: TextStyle(fontSize: 15.sp, color: IConstant.text_color, fontWeight: FontWeight.bold)),
                    SizedBox(width: 10.w,),
                    Text("x${_selectList.length}", style: TextStyle(fontSize: 13.sp, color: IConstant.main_color),),
                    expandeSpace,
                    Icon(Icons.chevron_right, size: 24.w, color: IConstant.sub_text_color,),
                  ],
                ) : Row(
                  children: [
                    Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_web3_choose_transfer_assets), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color)),),
                    Icon(Icons.chevron_right, size: 24.w,),
                  ],
                ),
              ),
            ),
            expandeSpace,
            Container(
              height: 70.w,
              margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.w),
              child: Row(
                children: [
                  Container(width: 3.w, color: IConstant.red_bg_color),
                  SizedBox(width: 12.w),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(LanguageConfig.get(LanguageConfigKeys.Shop_web3_user_confirm_tip1),
                          maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color)),
                      Text(LanguageConfig.get(LanguageConfigKeys.Shop_web3_user_confirm_tip2),
                          maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color)),
                    ],
                  ))
                ],
              ),
            )
          ],
        ),
        bottomNavigationBar: buildBottomBar(),
      ),
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
            child: buildSubmit(),
          )
      ),
    );
  }

  GlobalKey<PartRefreshWidgetState> refreshBtn = GlobalKey();

  void checkInput() {
    if (TextUtils.isNotEmpty(_exchangeAddress) && _selectList.isNotEmpty) {
      if (isClickEnable) return;
      isClickEnable = true;
      refreshBtn.currentState?.update();
    } else {
      if (!isClickEnable) return;
      isClickEnable = false;
      refreshBtn.currentState?.update();
    }
  }

  Widget buildSubmit() {
    return PartRefreshWidget(
      refreshBtn,
          () => isClickEnable ? InkWell(onTap: () {
        transfer();
      },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40.w)),
            gradient: const LinearGradient(
              colors: [
                Color(0xffFF3957),
                Color(0xffFF3957),
                Color(0xffFFCC16),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: const [
              BoxShadow(
                color: IConstant.black_color,
                blurRadius: 1,
                offset: Offset(0, 6),
                spreadRadius: 0,
              ) ,
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_submit), textAlign: TextAlign.center,
              style: TextStyle(color: IConstant.white_color, fontSize: 16.sp, fontWeight: FontWeight.bold)),
        ),
      ) : Container(
        decoration: BoxDecoration(
          color: IConstant.grey_bg_color,
          borderRadius: BorderRadius.all(Radius.circular(40.w)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
        child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_submit), textAlign: TextAlign.center,
            style: TextStyle(color: IConstant.sub_text_color, fontSize: 16.sp, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void transfer() {
    showPop(0.5 * Adapt.getWindowHeight(), ActionSliderPage(_selectCoinInfo, _selectList, exchangeAddress: _exchangeAddress));
  }

}
