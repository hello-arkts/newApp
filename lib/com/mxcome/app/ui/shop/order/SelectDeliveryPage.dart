
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/LoadImageView.dart';
import 'package:mxcome/com/mxcome/app/utils/Adapt.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../IURLConstant.dart';
import '../../../Logger.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/HttpUtils.dart';
import '../../../utils/ViewUtils.dart';
import '../model/ConfirmModel.dart';
import '../model/ConfirmTitleModel.dart';
import '../model/DeliveryModel.dart';

class SelectDeliveryPage extends StatefulWidget {

  String shopId = '';

  List<ConfirmTitleModel> confirmTitleList = [];

  Function(BuildContext context, List<ConfirmTitleModel>) callBack;

  SelectDeliveryPage(this.shopId, this.confirmTitleList, this.callBack);

  @override
  State<StatefulWidget> createState() {
    return SelectDeliveryPageState();
  }
}

class SelectDeliveryPageState extends BaseKeepAliveState<SelectDeliveryPage> {

  List<ConfirmTitleModel> _confirmTitleList = [];

  int modeIndex = 0;

  int companyIndex = -1;

  List<DeliveryModel> modeList = [];

  List<dynamic> companyList = [];

  late ConfirmModel selectModel;

  @override
  void initState() {
    super.initState();
    modeList.add(DeliveryModel(2, LanguageConfig.get(LanguageConfigKeys.Shop_order_delivery2), false, []));
    modeList.add(DeliveryModel(1, LanguageConfig.get(LanguageConfigKeys.Shop_order_delivery1), false, []));
    modeList.add(DeliveryModel(3, LanguageConfig.get(LanguageConfigKeys.Shop_order_delivery3), false, []));
    _confirmTitleList = widget.confirmTitleList;
    for (ConfirmTitleModel titleModel in _confirmTitleList) {
      if (titleModel.shopId == widget.shopId) {
        if(titleModel.dataList.length > 1) {
          for(int i= 0; i < titleModel.dataList.length; i++) {
            if(titleModel.dataList[i].logisticsCode.isNotEmpty) {
              selectModel = titleModel.dataList[i];
              break;
            }
          }
        }else {
          selectModel = titleModel.dataList[0];
        }
        break;
      }
    }
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    BaseRsp rsp = await HttpUtils.postJSON(IURLConstant.MALL_GET_LOGISTICS, null);
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<dynamic> dataList = rsp.data;
      List<dynamic> tmpList1 = [];
      List<dynamic> tmpList2 = [];
      List<dynamic> tmpList3 = [];
      for (var item in dataList) {
        if (BaseModel.getInt(item, "transportType") == 1) {
          tmpList1.add(item);
        } else if (BaseModel.getInt(item, "transportType") == 2) {
          tmpList2.add(item);
        } else {
          tmpList3.add(item);
        }
      }
      setState(() {
        modeList[0].dataList = tmpList2;
        modeList[1].dataList = tmpList1;
        modeList[2].dataList = tmpList3;
        companyList = modeList[modeIndex].dataList;
        for (int i = 0; i < modeList.length; i++) {
          DeliveryModel model = modeList[i];
          if (model.type == selectModel.transportType) {
            modeIndex = i;
            companyList = modeList[modeIndex].dataList;
            break;
          }
        }
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar:AppBar(
        elevation: 0,
        leading: Container(),
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_select_logistics_company),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Row(
      children: [
        buildDeliveryMode(),
        buildDeliveryCompany()
      ],
    );
  }

  Widget buildDeliveryMode() {
    return SizedBox(width: 100.w, child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container(
        //   alignment: Alignment.center,
        //   padding: EdgeInsets.fromLTRB(16.w, 10.w, 0, 10.w),
        //   child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_delivery_type),
        //       style: TextStyle(fontSize: 14.w, color: IConstant.sub_text_color)),
        // ),
        Expanded(child: Container(
          padding: EdgeInsets.only(top: 10.w),
          child: ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: modeList.length,
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () {
                      setState(() {
                        modeIndex = index;
                        companyList = modeList[modeIndex].dataList;
                      });
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 24.w,
                          width: 3.w,
                          color: index == modeIndex ? IConstant.main_color : IConstant.white_color,
                        ),
                        Padding(padding: EdgeInsets.fromLTRB(14.w, 14.w, 14.w, 14.w),
                            child: Text(modeList[index].title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 14.sp,
                                    fontWeight: index == modeIndex ? FontWeight.bold : FontWeight.normal,
                                    color: index == modeIndex ? IConstant.main_color : IConstant.text_color))
                        ),
                      ],
                    ));
              },
              separatorBuilder: (BuildContext context, int index) {
                return Container(height: 10.w);
              }),
        ))
      ],
    ));
  }

  Widget buildDeliveryCompany() {
    return Expanded(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container(
        //   padding: EdgeInsets.fromLTRB(10.w, 10.w, 0, 10.w),
        //   child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_order_logistics_company),
        //       style: TextStyle(fontSize: 14.w, color: IConstant.sub_text_color)),
        // ),
        Expanded(child: Container(
          padding: EdgeInsets.only(top: 10.w),
          decoration: BoxDecoration(
              color: IConstant.white_color,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.w))),
          child: Wrap(
            spacing: 20.w,
            runSpacing: 20.w,
            children: buildDeliveryList(),
          ),
        ))
      ],
    ));
  }

  buildDeliveryList() {
    List<Widget> deliveryList = [];
    if(companyList.isNotEmpty) {
      for(int i=0; i < companyList.length; i++) {
        deliveryList.add(InkWell(
            onTap: () {
              setState(() {
                companyIndex = i;
              });
              setCompanyData();
            },
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: getBgColor(i), width: 1.w),
                    borderRadius: BorderRadius.circular(12.w)),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.w)),
                    child: LoadImageView(108.w, 53.w, BaseModel.getString(companyList[i], "logo"), fit: BoxFit.fill,))
            )));
      }
    }
    return deliveryList;
  }

  Color getBgColor(int index) {
    dynamic company = companyList[index];
    int transportType = BaseModel.getInt(company, "transportType");
    String code = BaseModel.getString(company, "code");
    if (selectModel.transportType == transportType && selectModel.logisticsCode == code) {
      return IConstant.main_color;
    } else {
      return IConstant.line_color;
    }
  }

  Color getTextColor(int index) {
    dynamic company = companyList[index];
    int transportType = BaseModel.getInt(company, "transportType");
    String code = BaseModel.getString(company, "code");
    if (selectModel.transportType == transportType && selectModel.logisticsCode == code) {
      return IConstant.main_color;
    } else {
      return IConstant.text_color;
    }
  }


  void setCompanyData() {
    dynamic company = companyList[companyIndex];
    int transportType = BaseModel.getInt(company, "transportType");
    String code = BaseModel.getString(company, "code");
    String name = BaseModel.getString(company, "name");
    for (ConfirmTitleModel titleModel in _confirmTitleList) {
      if (titleModel.shopId == widget.shopId) {
        for (ConfirmModel model in titleModel.dataList) {
          model.transportType = transportType;
          model.logisticsCode = code;
          model.logisticsName = name;
        }
      }
    }
    widget.callBack(context, _confirmTitleList);
  }


}
