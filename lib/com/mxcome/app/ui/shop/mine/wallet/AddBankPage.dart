import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/BankEvent.dart';
import 'package:mxcome/com/mxcome/app/utils/AppUtils.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IURLConstant.dart';
import '../../../../config/LanguageConfig.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/Adapt.dart';
import '../../../../utils/HttpUtils.dart';
import '../../../../utils/TextUtils.dart';
import '../../../../utils/ViewUtils.dart';
import '../../../../widget/PartRefreshWidget.dart';
import '../../model/BankModel.dart';
import '../../utils/EventBusUtil.dart';
import '../../utils/FormatUtil.dart';
import '../../utils/ShowBottomSheetTool.dart';
import '../../widget/BigTextButton.dart';
import 'VerifyMobilePage.dart';

class AddBankPage extends StatefulWidget {

  BankModel? bank;

  AddBankPage(this.bank);

  @override
  State<StatefulWidget> createState() {
    return AddBankPageState();
  }
}

class AddBankPageState extends BaseKeepAliveState<AddBankPage> {
  String id = '';
  String firstName = '';
  String lastName = '';
  String bankName = '';
  String cardNumber = '';
  String username = '';
  DateTime? validDate;

  dynamic userInfo;

  bool isClickEnable = false;

  final FocusNode _nodeText1 = FocusNode();

  final FocusNode _nodeText2 = FocusNode();

  final FocusNode _nodeText3 = FocusNode();

  final FocusNode _nodeText4 = FocusNode();

  List<dynamic> bankList = [];

  int _selectIndex = -1;

  final String _format = 'yyyy-MM';

  bool nameEnable = false;

  int documentType = 0; //0:身份证，1：护照

  String idType = LanguageConfig.get(LanguageConfigKeys.Shop_mine_id_card);

  @override
  void initState() {
    super.initState();
    if (widget.bank != null) {
      id = "${widget.bank!.id}";
      bankName = widget.bank!.bankName;
      cardNumber = widget.bank!.cardNumber;
      String validDateStr = widget.bank!.validDate;
      if (TextUtils.isNotEmpty(validDateStr)) {
        validDate = DateTime.parse(validDateStr);
      } else {
        DateTime current = DateTime.now();
        validDate = DateTime(current.year, current.month, 1);
      }
    }
    loadContentDatas();
    loadBankName();
  }

  @override
  Future<void> loadContentDatas() async {
    isLoading = true;
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_GET_IDENTITY_INFO, {});
    isLoading = false;
    if (rsp.retCode == RspRetCode.SUCCESS) {
     setState(() {
       documentType = BaseModel.getInt(rsp.data, "documentType");
       if (documentType == 0) {
         idType = LanguageConfig.get(LanguageConfigKeys.Shop_bank_id_card_user);
       } else {
         idType = LanguageConfig.get(LanguageConfigKeys.Shop_bank_passport_user);
       }
       String idCardName = BaseModel.getString(rsp.data, "idCardName");
       if (TextUtils.isNotEmpty(idCardName)) {
         List<String> userList = idCardName.trim().split("|");
         firstName = userList[0];
         lastName = userList[1];
       }
     });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  Future<void> loadBankName() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_GET_BANK, {
      "phoneCode": ""
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        bankList = rsp.data;
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return KeyboardDismissOnTap(child: Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_bank_add_card),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.w),
              child: Text(idType, style: TextStyle(fontSize: 13.sp, color: IConstant.sub_text_color)),
            ),
            Container(
                margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.w),
                padding: EdgeInsets.only(left: 16.w, right: 4.w),
                decoration: BoxDecoration(
                    color: nameEnable ? IConstant.white_color: IConstant.line_color,
                    border: Border.all(color: IConstant.line_color, width: 1.w),
                    borderRadius: BorderRadius.circular(10.w)),
                child: Row(
                  children: [
                    Expanded(child: TextField(
                      enabled: nameEnable,
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      focusNode: _nodeText1,
                      style: TextStyle(fontSize: 13.sp, color: IConstant.text_color),
                      inputFormatters: [
                        //FilteringTextInputFormatter.deny(RegExp('[~!@#%^&*()_+|?><:;{}[]]|[\u4e00-\u9fa5]|[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]')),//拒绝特殊符号
                        LengthLimitingTextInputFormatter(50),
                      ],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: LanguageConfig.get(LanguageConfigKeys.Shop_mine_last_name),
                        labelStyle: TextStyle(fontSize: 13.sp, color: IConstant.text_color),
                      ),
                      controller: ViewUtils.buildTextEditingController(lastName, listener: (str) {
                        lastName = str;
                        checkInput();
                      }),
                    ),),
                    nameEnable ? Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_bank_only_en_th),
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 13.sp, color: IConstant.sub_text_color))) : Container(),
                    SizedBox(width: 10.w),
                  ],
                )),
            Container(
              margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.w),
              padding: EdgeInsets.only(left: 16.w, right: 4.w),
              decoration: BoxDecoration(
                  color: nameEnable ? IConstant.white_color: IConstant.line_color,
                  border: Border.all(color: IConstant.line_color, width: 1.w),
                  borderRadius: BorderRadius.circular(10.w)
              ),
              child: Row(
                children: [
                  Expanded(child: TextField(
                    enabled: nameEnable,
                    textInputAction: TextInputAction.done,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    focusNode: _nodeText2,
                    style: TextStyle(fontSize: 13.sp, color: IConstant.text_color),
                    inputFormatters: [
                      //FilteringTextInputFormatter.deny(RegExp('[~!@#%^&*()_+|?><:;{}[]]|[\u4e00-\u9fa5]|[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]')),//拒绝特殊符号
                      LengthLimitingTextInputFormatter(50),
                    ],
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: LanguageConfig.get(LanguageConfigKeys.Shop_mine_first_name),
                      labelStyle: TextStyle(fontSize: 13.sp, color: IConstant.text_color),
                    ),
                    controller: ViewUtils.buildTextEditingController(firstName, listener: (str) {
                      firstName = str;
                      checkInput();
                    }),
                  )),
                  nameEnable ? Expanded(child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_bank_only_en_th),
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 13.sp, color: IConstant.sub_text_color))) : Container(),
                  SizedBox(width: 10.w),
                ],
              ),
            ),
            buildModifyName(),
            InkWell(
              onTap: () {
                showBankName();
              },
              child:  Container(
                margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.w),
                padding: EdgeInsets.only(left: 16.w, right: 4.w),
                decoration: BoxDecoration(
                    border: Border.all(color: IConstant.line_color, width: 1.w),
                    borderRadius: BorderRadius.circular(10.w)),
                child: TextField(
                  enabled: false,
                  textInputAction: TextInputAction.done,
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  focusNode: _nodeText3,
                  style: TextStyle(fontSize: 13.sp, color: IConstant.text_color),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: LanguageConfig.get(
                          LanguageConfigKeys.Shop_bank_bank_name),
                      labelStyle: TextStyle(fontSize: 13.sp, color: IConstant.text_color),
                      suffixIcon: Icon(Icons.keyboard_arrow_down, size: 22.w, color: IConstant.text_color)
                  ),
                  controller: ViewUtils.buildTextEditingController(bankName, listener: (str) {
                    bankName = str;
                    checkInput();
                  }),
                  onSubmitted: (str) {
                    if (isClickEnable) {
                      showPop(0.7 * Adapt.getWindowHeight(),
                          VerifyMobilePage((ctx, code) {
                            finishContext(ctx);
                            if (id == '') {
                              add(code);
                            } else {
                              update(code);
                            }
                          }));
                    }
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.w),
              padding: EdgeInsets.only(left: 16.w, right: 16.w),
              decoration: BoxDecoration(
                  border: Border.all(color: IConstant.line_color, width: 1.w),
                  borderRadius: BorderRadius.circular(10.w)),
              child: TextField(
                textInputAction: TextInputAction.next,
                maxLines: 1,
                keyboardType: TextInputType.number,
                focusNode: _nodeText4,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),//数字
                  LengthLimitingTextInputFormatter(25),
                ],
                style: TextStyle(fontSize: 13.sp, color: IConstant.text_color),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: LanguageConfig.get(
                      LanguageConfigKeys.Shop_bank_card_number),
                  labelStyle:
                      TextStyle(fontSize: 13.sp, color: IConstant.text_color),
                ),
                controller: ViewUtils.buildTextEditingController(cardNumber, listener: (str) {
                  setState(() {
                    cardNumber = TextUtil.formatSpace4(str);
                  });
                  checkInput();
                }),
              ),
            ),
            // buildValidDate()
          ],
      ),
      bottomNavigationBar: buildBottomBar(),
    ));
  }

  Widget buildValidDate() {
    return InkWell(
      onTap: () {
        showDatePicker();
      },
      child: Container(
          margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.w),
          padding: EdgeInsets.fromLTRB(16.w, 0.w, 3.w, 0),
          decoration: BoxDecoration(
              border: Border.all(color: IConstant.grey_bg_color, width: 1.w),
              borderRadius: BorderRadius.circular(10.w)),
          child: TextField(
              enabled: false,
              maxLines: 1,
              keyboardType: TextInputType.text,
              style: TextStyle(color: IConstant.title_color, fontSize: 13.sp),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: LanguageConfig.get(LanguageConfigKeys.shop_wallet_expire_date),
                  labelStyle: TextStyle(fontSize: 13.sp, color: IConstant.text_color),
                  hintStyle: TextStyle(color: IConstant.text_color, fontSize: 13.sp),
                  suffixIcon: IconButton(onPressed: null, icon: Icon(Icons.chevron_right, size: 22.w, color: IConstant.text_color))
              ),
              controller: ViewUtils.buildTextEditingController(getValidDate()))
      ),
    );
  }

  buildModifyName() {
    return documentType == 1 ? Container(
      margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.w),
      padding: EdgeInsets.fromLTRB(16.w, 10.w, 4.w, 10),
      decoration: BoxDecoration(color: IConstant.line_color,
          border: Border.all(color: IConstant.line_color, width: 1.w), borderRadius: BorderRadius.circular(10.w)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 25.w,
            child: Row(
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.shop_wallet_change_name),
                    style: TextStyle(fontSize: 11.sp, color: IConstant.sub_title_color)),
                expandeSpace,
                Switch(
                  value: nameEnable,
                  activeColor: IConstant.main_color,
                  onChanged: (value) {
                    setState(() {
                      nameEnable = !nameEnable;
                    });
                  },
                )
              ],
            ),
          ),
          SizedBox(
            width: 0.7 * Adapt.getWindowWidth(),
            child:  Text(LanguageConfig.get(LanguageConfigKeys.shop_wallet_change_name_tip),
                style: TextStyle(fontSize: 11.sp, color: IConstant.text_color)),
          )
        ],
      ),
    ) : Container();
  }

  void showBankName() {
    if (bankList.isEmpty) return;
    List<String> nameList = [];
    for (int i = 0; i < bankList.length; i++) {
      String bName = BaseModel.getString(bankList[i], "bankName");
      if(bankName == bName) {
        _selectIndex = i;
      }
      nameList.add(bName);
    }
    ShowBottomSheetTool().showSingleRowPicker(context, data: nameList, title: LanguageConfig.get(LanguageConfigKeys.Shop_mine_select_bank), normalIndex: _selectIndex, clickCallBack: (int selectIndex, Object selectStr){
      setState(() {
        _selectIndex = selectIndex;
        bankName = BaseModel.getString(bankList[_selectIndex], "bankName");
        checkInput();
      });
    });
  }

  void showDatePicker() {
    changeFocus();
    DatePicker.showDatePicker(context,
        pickerMode: DateTimePickerMode.date,
        onMonthChangeStartWithFirstDate: true,
        dateFormat: _format,
        onConfirm: (DateTime date, List<int> selectedIndex) {
          setState(() {
            validDate = date;
            checkInput();
          });
        },
        initialDateTime: validDate,
        locale: AppUtils.getLocaleType());
  }

  String getValidDate() {
    if (validDate != null) {
      return FormatUtil.formatYM(validDate!);
    }
    return "";
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 190.w,
      elevation: 0.w,
      child: SizedBox(
          height: 190.w,
          child: Column(
            children: [
              Container(
                height: 100.w,
                margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
                child: Row(
                  children: [
                    Container(width: 3.w, color: IConstant.red_bg_color),
                    SizedBox(width: 12.w),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                            LanguageConfig.get(
                                LanguageConfigKeys.Shop_bank_add_card_tip1),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 11.sp,
                                color: IConstant.sub_text_color)),
                        Text(
                            LanguageConfig.get(
                                LanguageConfigKeys.Shop_bank_add_card_tip2),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 11.sp,
                                color: IConstant.sub_text_color)),
                        Text(
                            LanguageConfig.get(
                                LanguageConfigKeys.Shop_bank_add_card_tip3),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 11.sp,
                                color: IConstant.sub_text_color)),
                      ],
                    ))
                  ],
                ),
              ),
              SizedBox(
                width: 150.w,
                child: buildNext(),
              ),
            ],
          )),
    );
  }

  GlobalKey<PartRefreshWidgetState> refreshBtn = GlobalKey();

  Widget buildNext() {
    return PartRefreshWidget(refreshBtn, () => BigTextButton(
        text: LanguageConfig.get(LanguageConfigKeys.Shop_bank_next_step),
        enable: isClickEnable,
        onTap: () {
          showPop(0.7 * Adapt.getWindowHeight(),
              VerifyMobilePage((ctx, code) {
                finishContext(ctx);
                if (id == '') {
                  add(code);
                } else {
                  update(code);
                }
              }));
        }));
  }

  void checkInput() {
    if (TextUtils.isNotEmpty(firstName) && TextUtils.isNotEmpty(lastName) && TextUtils.isNotEmpty(bankName) && TextUtils.isNotEmpty(cardNumber) && cardNumber.length >= 12) {
      if (isClickEnable) return;
      isClickEnable = true;
      refreshBtn.currentState?.update();
    } else {
      if (!isClickEnable) return;
      isClickEnable = false;
      refreshBtn.currentState?.update();
    }
  }

  Future<void> add(String code) async {
    ViewUtils.show();
    // String validDateStr = "";
    // if (validDate != null) {
    //   validDateStr = FormatUtil.formatLineYMDHMS(validDate!);
    // }
    String mCardNumber = cardNumber.replaceAll(RegExp(r"\s*"), "");
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_ADD_BANK, {
      "bankId": BaseModel.getString(bankList[_selectIndex], "id"),
      "authCode": code,
      "bankName": bankName,
      "cardNumber": mCardNumber,
      "idCardName": "$firstName|$lastName".trim()
      // "validDate": validDateStr,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_successfully_added));
      setState(() {
        finishContext(context);
      });
      EventBusUtil.getInstance().emit(BankEvent());
    } else if (rsp.retCode == 407) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_bank_card_already_exist));
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  Future<void> update(String code) async {
    ViewUtils.show();
    // String validDateStr = "";
    // if (validDate != null) {
    //   validDateStr = FormatUtil.formatLineYMDHMS(validDate!);
    // }
    String mCardNumber = cardNumber.replaceAll(RegExp(r"\s*"), "");
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_EDIT_BANK, {
      "bankId": BaseModel.getString(bankList[_selectIndex], "id"),
      "id": id,
      "authCode": code,
      "bankName": bankName,
      "cardNumber": mCardNumber,
      "idCardName": "$firstName|$lastName".trim()
      // "validDate": validDateStr,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_successfully_modified));
      setState(() {
        finishContext(context);
      });
      EventBusUtil.getInstance().emit(BankEvent());
    } else if (rsp.retCode == 407) {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_bank_card_already_exist));
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }
}
