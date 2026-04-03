
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/GetPrizeEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/mine/promotion/UseEntityResultPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/OutlineTextButton.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:sprintf/sprintf.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IConstant.dart';
import '../../../../IURLConstant.dart';
import '../../../../config/LanguageConfig.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/Adapt.dart';
import '../../../../utils/HttpUtils.dart';
import '../../../../utils/ViewUtils.dart';
import '../../event/AddressEvent.dart';
import '../../order/LogisticsInfoPage.dart';
import '../../utils/ClipboardUtil.dart';
import '../../utils/EventBusUtil.dart';
import '../../widget/BigTextButton.dart';
import '../../widget/CommResultPage.dart';
import '../../widget/LoadImageView.dart';
import '../address/EditAddressPage.dart';
import '../address/SelectAddressPage.dart';

class UseEntityDetailPage extends StatefulWidget {

  dynamic prize;

  UseEntityDetailPage(this.prize);

  @override
  State<UseEntityDetailPage> createState() => UseEntityDetailPageState();
}

class UseEntityDetailPageState extends BaseKeepAliveState<UseEntityDetailPage> {

  dynamic _prize;

  dynamic addressEvent;

  dynamic defaultAddress;

  int _status = 0; //订单状态：0->待使用；1->待发货；2->已发货；3->已收货；4->已完成；5->已关闭;-1：已过期

  List<dynamic> logisticsList = [];

  bool isSubmit = false;

  @override
  void initState() {
    super.initState();
    _prize = widget.prize;
    _status = BaseModel.getInt(_prize, "status");
    addressEvent = EventBusUtil.getInstance().on<AddressEvent>((event) {
      if (event.address != null) {
        setState(() {
          defaultAddress = event.address;
        });
      } else {
        getAddressList();
      }
    });
    loadContentDatas();
    getAddressList();
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(addressEvent);
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_PRIZE_LOGISTICS_DETAIL_LIST, {
      "orderId": BaseModel.getString(_prize, "id")
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        logisticsList = rsp.data;
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  void getAddressList() async {
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_MEMBER_ADDRESS_LIST, {});
    if (rsp.retCode == RspRetCode.SUCCESS) {
      dynamic addressList = rsp.data;
      setAddress(addressList);
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  void setAddress(dynamic addressList) {
    List<dynamic> tempList = [];
    for (dynamic item in addressList) {
      tempList.add(item);
      if (BaseModel.getString(item, "defaultStatus") == "1") {
        setState(() {
          defaultAddress = item;
        });
        break;
      }
    }
    if (defaultAddress == null && tempList.isNotEmpty) {
      setState(() {
        defaultAddress = tempList[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
          leading: Container(),
          leadingWidth: 0.w,
          elevation: 0.w,
          centerTitle: false,
          title: Text(getTitle(),
              style: TextStyle(fontSize: 17.sp, color: IConstant.text_color))),
      body: buildBody(),
      bottomNavigationBar: _status == 0 || _status == 2 || _status == 3? buildBottomBar() : null,
    );
  }

  Widget buildBody() {
    dynamic gift = BaseModel.getDynamic(_prize, "gift");
    String pic = BaseModel.getString(gift, "pic");
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 10.w),
          child: Row(
            children: [
              _status == 0 ? Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_valid_to),
                  [ FormatUtil.formatYMDHMS(DateTime.parse(BaseModel.getString(gift, "endTime"))) ]),
                  style: TextStyle(fontSize: 12.sp, color: IConstant.main_color)) :
              _status == -1 ? Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_usage_expiration_time),
                  [ FormatUtil.formatYMDHMS(DateTime.parse(BaseModel.getString(gift, "endTime"))) ]),
                  style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)) : Text(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_mine_usage_time),
                  [ FormatUtil.formatYMDHMS(DateTime.parse(BaseModel.getString(_prize, "useTime"))) ]),
                  style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
              expandeSpace,
              _status != 0 && _status != -1 ? Text(getStatusText(),
                  style: TextStyle(fontSize: 12.sp, color: IConstant.main_color, fontWeight: FontWeight.bold)) : Container(),
            ],
          ),
        ),
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
                            Text(BaseModel.getString(gift, "name"),
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
        _status == 0 ? Container(
          margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_receive_address), style: TextStyle(
              fontSize: 15.sp, color: IConstant.text_color)),
        ): Container(),
        _status == 0 ? buildAddress() : Container(),
        Container(
          margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_prize_info), style: TextStyle(
              fontSize: 15.sp, color: IConstant.text_color)),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 10.w),
          padding: EdgeInsets.fromLTRB(0.w, 10.w, 20.w, 10.w),
          decoration: BoxDecoration(
              border: Border.all(width: 1.w, color: IConstant.line_color),
              borderRadius: BorderRadius.all(Radius.circular(12.w))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                child: Text(BaseModel.getString(gift, "name"),
                    style: TextStyle(
                        fontSize: 14.sp, color: IConstant.text_color)),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0.w, 10.w, 0.w, 10.w),
                height: 1.w, color: IConstant.line_color),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 10.w),
                          Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_exchange_number), style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
                          SizedBox(width: 10.w),
                          Text(BaseModel.getString(_prize, "orderSn"),
                              style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                          SizedBox(width: 10.w),
                        ],
                      ),
                      SizedBox(height: 4.w),
                      Row(
                        children: [
                          SizedBox(width: 10.w),
                          Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_exchange_time), style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
                          SizedBox(width: 10.w),
                          Text(BaseModel.getString(_prize, "createTime"),
                              style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                          SizedBox(width: 12.w),
                        ],
                      ),
                      SizedBox(height: 4.w),
                      Row(
                        children: [
                          SizedBox(width: 10.w),
                          Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_using_direct_push_value), style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
                          SizedBox(width: 10.w),
                          Text("${BaseModel.getInt(_prize, "exchangeNewComers")}", style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                          SizedBox(width: 12.w),
                        ],
                      )
                    ],
                  ),
                  _status == -1 ? Image.asset(
                    'assets/icons/ic_prize_expiration.png',
                    width: 50.w,
                    height: 50.w,
                  ): Container(),
                ],
              ),
            ],
          ),
        ),
        _status == 0 || _status == -1 ? Container(
          margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
          padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
          decoration: BoxDecoration(
              color: IConstant.line_color,
              borderRadius: BorderRadius.all(Radius.circular(12.w))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_usage_rules), style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.text_color)),
              SizedBox(height: 10.w),
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_usage_rules_tip1), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
              SizedBox(height: 10.w),
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_usage_rules_tip2), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
              SizedBox(height: 10.w),
              Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_usage_rules_tip3), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
            ],
          ),
        ) : Container(),
        _status != 0 && _status != -1 ? Container(
          margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_logistics_info), style: TextStyle(
              fontSize: 15.sp, color: IConstant.text_color)),
        ) : Container(),
        _status != 0 && _status != -1 ? Container(
          margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 10.w),
          padding: EdgeInsets.fromLTRB(0.w, 10.w, 0.w, 10.w),
          decoration: BoxDecoration(
              color: IConstant.red_bg_color3,
              borderRadius: BorderRadius.all(Radius.circular(12.w))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(width: 10.w),
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_delivery_type), style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
                  SizedBox(width: 10.w),
                  Text(getDeliveryType(),
                      style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                  SizedBox(width: 10.w),
                ],
              ),
              SizedBox(height: 4.w),
              Row(
                children: [
                  SizedBox(width: 10.w),
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_order_sn), style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
                  SizedBox(width: 10.w),
                  Text(getLogisticsNo(),
                      style: TextStyle(fontSize: 12.sp, color: IConstant.main_color)),
                  SizedBox(width: 8.w),
                  logisticsList.isNotEmpty ? InkWell(onTap: () => ClipboardUtil.setDataToast(getLogisticsNo()),
                    child: Image.asset("assets/icons/copy_icon.png", width: 30.w, height: 30.w),) : Container()
                ],
              ),
              SizedBox(height: 4.w),
              Row(
                children: [
                  SizedBox(width: 10.w),
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_delivery_time), style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
                  SizedBox(width: 10.w),
                  Text(getCreateTime(),
                      style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                  SizedBox(width: 10.w),
                ],
              ),
              SizedBox(height: 4.w),
              Row(
                children: [
                  SizedBox(width: 10.w),
                  Text(LanguageConfig.get(LanguageConfigKeys.Shop_mine_receiving_time), style: TextStyle(fontSize: 12.sp, color: IConstant.sub_text_color)),
                  SizedBox(width: 10.w),
                  Text(getDeliveryTime(), style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
                  SizedBox(width: 10.w),
                ],
              ),
              SizedBox(height: 4.w),
              buildDeliver()
            ],
          ),
        ) : Container()
      ],
    );
  }

  Widget buildDeliver() {
    String receiverName = BaseModel.getString(_prize, "receiverName");
    String receiverPhone = BaseModel.getString(_prize, "receiverPhone");
    String receiverProvince = BaseModel.getString(_prize, "receiverProvince");
    String receiverCity = BaseModel.getString(_prize, "receiverCity");
    String receiverRegion = BaseModel.getString(_prize, "receiverRegion");
    String receiverDetailAddress = BaseModel.getString(_prize, "receiverDetailAddress");
    String receiverPostCode = BaseModel.getString(_prize, "receiverPostCode");
    return Row(
      children: [
        SizedBox(width: 10.w),
        Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_receive_address),
            style: TextStyle(
                fontSize: 12.sp, color: IConstant.sub_text_color)),
        SizedBox(width: 10.w),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$receiverName $receiverPhone",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12.sp, color: IConstant.text_color)),
            Text("$receiverDetailAddress $receiverRegion $receiverCity $receiverProvince $receiverPostCode",
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12.sp, color: IConstant.sub_text_color)),
          ],
        )),
        SizedBox(width: 10.w),
      ],
    );
  }


  Widget buildAddress() {
    if (defaultAddress != null) {
      return InkWell(
          onTap: () {
            showPop(0.8 * Adapt.getWindowHeight(), SelectAddressPage(BaseModel.getString(defaultAddress, "id")));
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 12.w,),
            padding: EdgeInsets.fromLTRB(16.w, 10.w, 10.w, 10.w),
            decoration: BoxDecoration(
                border: Border.all(width: 1.w, color: IConstant.line_color),
                borderRadius: BorderRadius.all(Radius.circular(10.w))),
            child: Row(
              children: [
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${BaseModel.getString(defaultAddress, "name")}   ${BaseModel.getString(defaultAddress, "phoneNumber")}",
                      style: TextStyle(fontSize: 15.sp, color: IConstant.title_color),),
                    Text(getAddressDetail(defaultAddress), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
                  ],
                )),
                Icon(Icons.chevron_right, size: 22.w, color: IConstant.text_color)
              ],
            ),
          ));
    } else {
      return InkWell(
          onTap: () {
            showPop(0.8 * Adapt.getWindowHeight(), EditAddressPage(null));
          },
          child: ListTile(
              title: Text(LanguageConfig.get(
                  LanguageConfigKeys.Shop_address_add_receipt_address)),
              trailing: Icon(Icons.chevron_right, size: 24.w)));
    }
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      child: _status == 0 ? Container(
        height: 40.w,
        margin: EdgeInsets.fromLTRB(50.w, 12.w, 50.w, 20.w),
        child: BigTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_submit), bgColor: isSubmit ? IConstant.grey_color : IConstant.main_color,fontSize: 15.sp, onTap: () {
          if(!isSubmit) {
            nowUse();
          }
        }),
      ): _status == 2 ?Container(
        height: 60.w,
        margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
        child: Row(
          children: [
            Expanded(child: OutlineTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_view_logistics),
                borderColor: IConstant.line_color,
                textColor: IConstant.text_color, fontSize: 14.sp, onTap: () {
              logisticsInfo();
            })),
            expandeSpace,
            Expanded(child: OutlineTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_confirm_receipt),
                borderColor: IConstant.main_color,
                bgColor: IConstant.red_bg_color3,
                textColor: IConstant.main_color,
                fontSize: 15.sp, onTap: () {
                  showPop(0.3 * Adapt.getWindowHeight(), CommResultPage(
                      title: LanguageConfig.get(LanguageConfigKeys.Shop_order_confirm_receipt),
                      message: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_confirm_receipt_tip),
                          style: TextStyle(fontSize: 14.sp, color: IConstant.title_color)),
                      callBack: (BuildContext ctx) {
                        finishContext(ctx);
                        confirmReceipt();
                      })
                  );
            }))
          ],
        ),
      ): Container(
        height: 60.w,
        margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
        child: Row(
          children: [
            OutlineTextButton(text: LanguageConfig.get(LanguageConfigKeys.Shop_order_view_logistics),
                borderColor: IConstant.line_color,
                textColor: IConstant.text_color, fontSize: 14.sp, left: 30, right: 30, onTap: () {
                  logisticsInfo();
                }),
            expandeSpace,
          ],
        ),
      ),
    );
  }

  Future<void> nowUse() async {
    if(defaultAddress == null){
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Shop_order_select_receive_address));
      return;
    }
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.postJSON(IURLConstant.MALL_PRIZE_USE_ORDER, null, body: {
      "orderId": BaseModel.getString(_prize, "id"),
      "receiverCity": BaseModel.getString(defaultAddress, "city"),
      "receiverDetailAddress": BaseModel.getString(defaultAddress, "detailAddress"),
      "receiverName": BaseModel.getString(defaultAddress, "name"),
      "receiverPhone": BaseModel.getString(defaultAddress, "phoneNumber"),
      "receiverPostCode": BaseModel.getString(defaultAddress, "postCode"),
      "receiverProvince": BaseModel.getString(defaultAddress, "province"),
      "receiverRegion": BaseModel.getString(defaultAddress, "region"),
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        isSubmit = true;
      });
      EventBusUtil.getInstance().emit(GetPrizeEvent());
      showPop(0.4 * Adapt.getWindowHeight(), UseEntityResultPage(prize: rsp.data,  callBack: (BuildContext ctx) {
        finishContext(ctx);
        finishContext(context);
        showPop(0.95 * Adapt.getWindowHeight(), UseEntityDetailPage(rsp.data));
      }));
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    ViewUtils.dismiss();
  }

  String getAddressDetail(dynamic address) {
    return "${address["detailAddress"]} ${address["region"]} ${address["city"]} ${address["province"]} ${address["postCode"]}";
  }

  String getType(int type) {
    if (type == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_exchange_voucher);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_entity_prizes);
    }
  }

  String getTitle() {
    String statusText = "";
    if (_status == 0) {
      statusText = LanguageConfig.get(LanguageConfigKeys.Shop_mine_to_be_use);
    } else if (_status == -1) {
      statusText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_expired);
    } else {
      statusText = LanguageConfig.get(LanguageConfigKeys.Shop_mine_used);
    }
    return statusText;
  }

  String getStatusText() { //订单状态：0->待使用；1->待发货；2->已发货；3->已收货；4->已完成；5->已关闭;-1：已过期
    String statusText = "";
    if (_status == 0) {
      statusText = LanguageConfig.get(LanguageConfigKeys.Shop_mine_to_be_use);
    } else if (_status == 1) {
      statusText = LanguageConfig.get(LanguageConfigKeys.Shop_order_wait_deliver);
    } else if (_status == 2) {
      statusText = LanguageConfig.get(LanguageConfigKeys.Shop_order_wait_receipt);
    } else if (_status == 3) {
      statusText = LanguageConfig.get(LanguageConfigKeys.Shop_order_receive_finish);
    } else if (_status == 4) {
      statusText = LanguageConfig.get(LanguageConfigKeys.Shop_order_completed);
    } else if (_status == 5) {
      statusText = LanguageConfig.get(LanguageConfigKeys.Shop_order_canceled);
    }else {
      statusText = LanguageConfig.get(LanguageConfigKeys.Shop_activity_expired);
    }
    return statusText;
  }

  Future<void> confirmReceipt() async {
    String orderId = BaseModel.getString(_prize, "id");
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_PRIZE_CONFIRM_ORDER, {
      "orderId": orderId
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      EventBusUtil.getInstance().emit(GetPrizeEvent());
      finish();
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.Base_operation_successful));
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
     ViewUtils.dismiss();
  }

  void logisticsInfo() {
    if (logisticsList.isNotEmpty) {
      showPop(0.9 * Adapt.getWindowHeight(), LogisticsInfoPage(logisticsList));
    } else {
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_data));
    }
  }

  String getDeliveryType() {
    if (logisticsList.isNotEmpty) {
      dynamic logistics = BaseModel.getDynamic(logisticsList[0], "logistics");
      if(logistics != null) {
        return BaseModel.getString(logistics, "name");
      }else{
        return LanguageConfig.get(LanguageConfigKeys.Shop_address_default);
      }
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_address_default);
    }
  }

  String getLogisticsNo() {
    if (logisticsList.isNotEmpty) {
      return BaseModel.getString(logisticsList[0], "waybillNum");
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_mine_to_be_updated);
    }
  }

  String getCreateTime() {
    if (logisticsList.isNotEmpty) {
      return BaseModel.getString(logisticsList[0], "createTime");
    } else {
      return "-";
    }
  }

  String getDeliveryTime() {
    String receiveTime = BaseModel.getString(_prize, "receiveTime");
    if(receiveTime.isNotEmpty) {
      return BaseModel.getString(_prize, "receiveTime");
    }else {
      return "-";
    }
  }

}
