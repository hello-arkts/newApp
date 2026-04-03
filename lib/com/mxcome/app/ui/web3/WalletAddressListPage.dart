
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/ClipboardUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/web3/AssetTransferPage.dart';

import '../../IURLConstant.dart';
import '../../model/BaseRsp.dart';
import '../../utils/HttpUtils.dart';
import '../../utils/ViewUtils.dart';
import 'AssetOutPage.dart';

class WalletAddressListPage extends StatefulWidget {

  String didName;
  List<dynamic> coinAddressList = [];

  WalletAddressListPage(this.didName, this.coinAddressList);

  @override
  State<StatefulWidget> createState() => WalletAddressListPageState();

}

class WalletAddressListPageState extends BaseKeepAliveState<WalletAddressListPage> {

  String _didName = "";
  List<dynamic> _coinAddressList = [];

  @override
  void initState() {
    super.initState();
    _didName = widget.didName;
    _coinAddressList = widget.coinAddressList;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.w,
        centerTitle: true,
        leading: Container(),
        title: Text(_didName,
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: ListView.separated(
          padding: EdgeInsets.only(top: 15.w, bottom: 15.w),
          scrollDirection: Axis.vertical,
          itemCount: _coinAddressList.length,
          itemBuilder: (context, index) {
            dynamic item = _coinAddressList[index];
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                  color: const Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.circular(10.w)
              ),
              child: ListTile(
                title: Text(BaseModel.getString(item, "didId"),
                    style: TextStyle(fontSize: 17.sp, color: IConstant.text_color, fontWeight: FontWeight.bold)),
                subtitle: Padding(padding: EdgeInsets.only(top: 4.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(BaseModel.getString(item, "address"),
                          style: TextStyle(fontSize: 12.sp, color: IConstant.blue_color)),
                      SizedBox(width: 10.w,),
                      InkWell(
                        onTap: () {
                          ClipboardUtil.setDataToast(BaseModel.getString(item, "address"));
                        },
                        child: Icon(Icons.copy_sharp, size: 20.w, color: IConstant.blue_color),
                      )
                    ],
                  ),),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Container(height: 10.w);
          }),
    );
  }

}
