import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/SelectModel.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../widget/SmallTextButton.dart';

class SelectWherePage extends StatefulWidget {

  Function(BuildContext context, List<SelectModel> optionalList, List<SelectModel> priceList, List<SelectModel> profitList) callBack;

  List<SelectModel> optionalList;

  List<SelectModel> priceList;

  List<SelectModel> profitList;

  SelectWherePage(this.optionalList, this.priceList, this.profitList, this.callBack);


  @override
  State<SelectWherePage> createState() => _SelectWherePageState();
}

class _SelectWherePageState extends BaseKeepAliveState<SelectWherePage> {

  List<SelectModel> optionalList = [
    SelectModel(LanguageConfig.get(LanguageConfigKeys.Shop_order_all), "", true),
    // SelectModel(LanguageConfig.get(LanguageConfigKeys.Shop_brand_receive), "1", false),
    SelectModel(LanguageConfig.get(LanguageConfigKeys.Shop_product_mxget), "2", false),
    // SelectModel(LanguageConfig.get(LanguageConfigKeys.Shop_brand_family), "3", false),
    // SelectModel(LanguageConfig.get(LanguageConfigKeys.Shop_brand_period), "4", false),
    SelectModel(LanguageConfig.get(LanguageConfigKeys.Shop_brand_free_package), "5", false),
    // SelectModel(LanguageConfig.get(LanguageConfigKeys.Shop_brand_overtime_free), "6", false),
  ];

  List<SelectModel> priceList = [
    SelectModel(LanguageConfig.get(LanguageConfigKeys.Shop_brand_down_up), "1", false, icon: "arrow_up.png"),
    SelectModel(LanguageConfig.get(LanguageConfigKeys.Shop_brand_up_down), "2", false, icon: "arrow_down.png"),
  ];

  List<SelectModel> profitList = [
    SelectModel(LanguageConfig.get(LanguageConfigKeys.Shop_brand_up_down), "3", false, icon: "arrow_down.png"),
    SelectModel(LanguageConfig.get(LanguageConfigKeys.Shop_brand_down_up), "4", false, icon: "arrow_up.png"),
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      optionalList = widget.optionalList.isNotEmpty ? widget.optionalList : optionalList;
      priceList = widget.priceList.isNotEmpty ? widget.priceList : priceList;
      profitList = widget.profitList.isNotEmpty ? widget.profitList : profitList;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: IConstant.white_color,
        appBar: AppBar(
          elevation: 0.w,
          centerTitle: true,
          title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_brand_choose),
              style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
        ),
        body: ListView(
          children: [
            buildOptional(),
            buildPrice(),
            // buildProfit(),
          ],
        ),
        bottomNavigationBar: buildBottomBar());
  }

  Widget buildOptional() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 16.w, top: 16.w),
          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_brand_enable), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp, color: IConstant.text_color)),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(10.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisExtent: 36.w,
            mainAxisSpacing: 16.w, //item上下间隔
            crossAxisSpacing: 16.w, //item左右间隔
          ),
          itemCount: optionalList.length,
          itemBuilder: (BuildContext context, int index) {
            return buildOptionalItem(optionalList[index]);
          },
        ),
      ],
    );
  }

  Widget buildPrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 16.w, top: 16.w),
          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_brand_price), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp, color: IConstant.text_color)),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(10.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: 36.w,
            mainAxisSpacing: 16.w, //item上下间隔
            crossAxisSpacing: 16.w, //item左右间隔
          ),
          itemCount: priceList.length,
          itemBuilder: (BuildContext context, int index) {
            return buildPriceItem(priceList[index]);
          },
        ),
      ],
    );
  }

  Widget buildProfit() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 16.w, top: 16.w),
          child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_brand_period), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp, color: IConstant.text_color)),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(10.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: 36.w,
            mainAxisSpacing: 16.w, //item上下间隔
            crossAxisSpacing: 16.w, //item左右间隔
          ),
          itemCount: profitList.length,
          itemBuilder: (BuildContext context, int index) {
            return buildProfitItem(profitList[index]);
          },
        ),
      ],
    );
  }

  Widget buildOptionalItem(SelectModel model) {
    return InkWell(onTap: () {
      setState(() {
        model.isSelect = !model.isSelect;
      });
    }, child: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(8.w, 2.w, 8.w, 2.w),
      decoration: BoxDecoration(
          color: model.getBgColor(),
          border: Border.all(width: 1, color: model.getBorderColor()),
          borderRadius: BorderRadius.circular(30.w)),
      child: Text(model.name, textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)),
    ),);
  }

  Widget buildPriceItem(SelectModel model) {
    return InkWell(onTap: () {
      setState(() {
        for (SelectModel item in priceList) {
          if (item.value == model.value){
            model.isSelect = !model.isSelect;
          } else if (item.isSelect && item.value != model.value) {
            item.isSelect = false;
          }
        }
      });
    }, child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(8.w, 2.w, 8.w, 2.w),
        decoration: BoxDecoration(
            color: model.getBgColor(),
            border: Border.all(width: 1, color: model.getBorderColor()),
            borderRadius: BorderRadius.circular(30.w)),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/icons/${model.icon}", width: 18.w, height: 18.w, color: model.getIconColor()),
              Expanded(child: Text(model.name, textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)))
          ]
        )
    ),);
  }

  Widget buildProfitItem(SelectModel model) {
    return InkWell(onTap: () {
      setState(() {
        for (SelectModel item in profitList) {
          if (item.value == model.value){
            model.isSelect = !model.isSelect;
          } else if (item.isSelect && item.value != model.value) {
            item.isSelect = false;
          }
        }
      });
    }, child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(8.w, 2.w, 8.w, 2.w),
        decoration: BoxDecoration(
            color: model.getBgColor(),
            border: Border.all(width: 1, color: model.getBorderColor()),
            borderRadius: BorderRadius.circular(30.w)),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/icons/${model.icon}", width: 18.w, height: 18.w, color: model.getIconColor()),
              Expanded(child: Text(model.name, textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, color: IConstant.text_color)))
            ]
        )
    ),);
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
            widget.callBack(context, optionalList, priceList, profitList);
          }),
        ),
      ),
    );
  }

}
