
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:sprintf/sprintf.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../config/LanguageConfig.dart';

class ProductParamPage extends StatefulWidget {

  List<dynamic> mProductAttributeList = [];

  List<dynamic> mProductAttributeValueList = [];

  ProductParamPage(this.mProductAttributeList, this.mProductAttributeValueList);

  @override
  State<StatefulWidget> createState() {
    return ProductParamPageState();
  }

}

class ProductParamPageState extends BaseKeepAliveState<ProductParamPage> {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.5.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_product_parameter),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: ListView.separated(
          scrollDirection: Axis.vertical,
          itemCount: widget.mProductAttributeList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {},
              child: buildListItem(index),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(height: 1.w);
          }),
    );
  }

  Widget buildListItem(int index) {
    dynamic prodAttr = widget.mProductAttributeList[index];
    String id = BaseModel.getString(prodAttr, "id");
    String name = BaseModel.getString(prodAttr, "name");
    String value = "";
    for (dynamic prodAttrValue in widget.mProductAttributeValueList) {
      if (BaseModel.getString(prodAttrValue, "productAttributeId") == id) {
        value = BaseModel.getString(prodAttrValue, "value");
        break;
      }
    }
    return ListTile(
      title: Text(name, style: TextStyle(fontSize: 14.sp, color: IConstant.text_color),),
      trailing: Text(value, style: TextStyle(fontSize: 14.sp, color: IConstant.text_color),),
    );
  }

}
