
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/SelectModel.dart';
import '../shop/widget/LoadImageView.dart';

class SelectAddressPage extends StatefulWidget {

  List<dynamic> walletList = [];

  Function(dynamic selectedCoinInfo, List<SelectModel> selectedList) callBack;

  SelectAddressPage(this.walletList, this.callBack);

  @override
  State<StatefulWidget> createState() => SelectAddressPageState();

}

class SelectAddressPageState extends BaseKeepAliveState<SelectAddressPage> {

  int _selectIndex = 0;
  dynamic _selectItem;
  dynamic _selectCoinInfo;
  List<dynamic> _walletList = [];
  List<SelectModel> _allSelectList = [];
  List<SelectModel> _selectList = [];
  bool _isExpand = false;

  @override
  void initState() {
    super.initState();
    _walletList = widget.walletList;
    setSelectIndex(_selectIndex);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 10.w),
                child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_web3_select_asset_type), style: TextStyle(fontSize: 14.sp, color: IConstant.text_color, fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  border: Border.all(color: IConstant.line_color2, width: 1.w),
                  borderRadius: BorderRadius.all(Radius.circular(12.w)),
                ),
                child: ListTile(
                  onTap: () {
                    setState(() {
                      _isExpand = !_isExpand;
                    });
                  },
                  title: Row(
                    children: [
                      Padding(padding: EdgeInsets.only(right: 10.w),
                          child: LoadImageView(30.w, 30.w, BaseModel.getString(_selectCoinInfo, "didCoin"))),
                      Text(BaseModel.getString(_selectCoinInfo, "didName"), style: TextStyle(fontSize: 15.sp, color: IConstant.text_color, fontWeight: FontWeight.bold))
                    ],
                  ),
                  trailing: Icon(Icons.keyboard_arrow_down, size: 24.w, color: IConstant.sub_text_color,),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
                child: Text("${LanguageConfig.get(LanguageConfigKeys.Shop_web3_select_assets)} (${_allSelectList.length})", style: TextStyle(fontSize: 14.sp, color: IConstant.text_color, fontWeight: FontWeight.bold)),
              ),
              Expanded(child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemCount: _allSelectList.length,
                  itemBuilder: (context, index) {
                    SelectModel item = _allSelectList[index];
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                          color: const Color(0xFFF6F6F6),
                          borderRadius: BorderRadius.circular(10.w)
                      ),
                      child: ListTile(
                        onTap: () {
                          setSelectSize(item);
                        },
                        contentPadding: EdgeInsets.only(left: 16.w, right: 10.w),
                        title: Text(item.name,
                            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color, fontWeight: FontWeight.bold)),
                        trailing: Checkbox(value: item.isSelect, fillColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return IConstant.main_color;  //选中时的背景颜色
                          }
                          return IConstant.white_color;  //未选中时的背景颜色
                        }), checkColor: IConstant.white_color, onChanged: (check) => {
                          setSelectSize(item)
                        }),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(height: 10.w);
                  }))
            ],
          ),
          Positioned(left: 16.w, right: 16.w, top: 115.w,
              child: buildSelectCoin())
        ],
      ),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  void setSelectIndex(int index) {
    _selectIndex = index;
    _selectItem = _walletList[_selectIndex];
    _selectCoinInfo = BaseModel.getDynamic(_selectItem, "coinInfo");
    _allSelectList = [];
    List<dynamic> coinAddressList = BaseModel.getDynamic(_selectItem, "coinAddressList");
    for (dynamic item in coinAddressList) {
      String didId = BaseModel.getString(item, "didId");
      String address = BaseModel.getString(item, "address");
      _allSelectList.add(SelectModel(didId, address, false));
    }
    _isExpand = false;
    setState((){});
  }

  void setSelectSize(SelectModel item) {
    _selectList = [];
    item.isSelect = !item.isSelect;
    for (SelectModel item in _allSelectList) {
      if (item.isSelect) {
        _selectList.add(item);
      }
    }
    setState((){});
  }

  Widget buildSelectCoin() {
    return _isExpand ? Container(
      height: 300.w,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x28000000),
            blurRadius: 12,
            offset: Offset(0, 2),
            spreadRadius: 0,
          )
        ],
      ),
      child: ListView.separated(
          padding: EdgeInsets.only(top: 15.w, bottom: 15.w),
          scrollDirection: Axis.vertical,
          itemCount: _walletList.length,
          itemBuilder: (context, index) {
            dynamic walletInfo = _walletList[index];
            dynamic item = BaseModel.getDynamic(walletInfo, "coinInfo");
            return Container(
              color: _selectIndex == index ? IConstant.line_color : Colors.transparent,
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              child: ListTile(
                onTap: () {
                  setSelectIndex(index);
                },
                title: Row(
                  children: [
                    Padding(padding: EdgeInsets.only(right: 10.w),
                        child: LoadImageView(30.w, 30.w, BaseModel.getString(item, "didCoin"))),
                    Text(BaseModel.getString(item, "didName"), style: TextStyle(fontSize: 15.sp, color: IConstant.text_color, fontWeight: FontWeight.bold))
                  ],
                ),
                trailing: Icon(Icons.chevron_right, size: 24.w, color: IConstant.sub_text_color,),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Container();
          }),
    ): Container();
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      height: 110.w,
      child: Container(
        padding: EdgeInsets.only(top: 16.w, left: 16.w, right: 16.w),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(LanguageConfig.get(LanguageConfigKeys.Shop_web3_selected), style: TextStyle(fontSize: 14.sp, color: IConstant.sub_text_color)),
                RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(
                            text: BaseModel.getString(_selectCoinInfo, "didName"),
                            style: TextStyle(fontSize: 14.sp, color: IConstant.title_color),
                          ),
                          TextSpan(
                            text: " ",
                            style: TextStyle(fontSize: 14.sp, color: IConstant.title_color),
                          ),
                          TextSpan(
                            text: "x${_selectList.length}", style: TextStyle(fontSize: 13.sp, color: IConstant.main_color),
                          ),
                        ]
                    ))
              ],
            ),
            expandeSpace,
            _selectList.isNotEmpty ? InkWell(
              onTap: () {
                widget.callBack(_selectCoinInfo, _selectList);
                finish();
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
                width: 120.w,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
                child: Text(LanguageConfig.get(LanguageConfigKeys.ViewUtils_confirm), textAlign: TextAlign.center,
                    style: TextStyle(color: IConstant.white_color, fontSize: 16.sp, fontWeight: FontWeight.bold)),
              ),
            ) : Container(
              decoration: BoxDecoration(
                color: IConstant.grey_bg_color,
                borderRadius: BorderRadius.all(Radius.circular(40.w)),
              ),
              width: 120.w,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
              child: Text(LanguageConfig.get(LanguageConfigKeys.ViewUtils_confirm), textAlign: TextAlign.center,
                  style: TextStyle(color: IConstant.sub_text_color, fontSize: 16.sp, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

}
