
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/utils/AppUtils.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../event/SearchEvent.dart';
import '../utils/EventBusUtil.dart';

class SearchSuggestionsPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return SearchSuggestionsStatePage();
  }
}

class SearchSuggestionsStatePage extends BaseKeepAliveState<SearchSuggestionsPage> {

  List<String> hotWordList = ["华为","小米"];

  List<dynamic> localWordList = [];

  @override
  void initState() {
    super.initState();
    loadContentDatas();
  }

  @override
  Future<void> loadContentDatas() async {
    List<dynamic> dataList = await AppUtils.getSearchData();
    setState(() {
      localWordList = dataList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Container(
          //   padding: EdgeInsets.only(top: 8.w),
          //   child: Text(
          //       LanguageConfig.get(LanguageConfigKeys.Shop_search_everyone),
          //       style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.text_color)
          //   ),
          // ),
          // Wrap(spacing: 20, children: hotWordList.map((item) => getChip(item)).toList()),
          buildHistory(),
        ],
      ),
    );
  }

  Widget getChip(String text) {
    return InkWell(onTap: () {
       EventBusUtil.getInstance().emit(SearchEvent(text));
    }, child: Chip(
        padding: EdgeInsets.fromLTRB(8.w, 2.w, 8.w, 2.w),
        label: Text(text,
            style: TextStyle(
                fontSize: 12.sp,
                color: IConstant.text_color)),
        deleteIcon: Icon(Icons.close, size: 14.w),
        deleteIconColor: IConstant.text_color,
        onDeleted: () {
          setState(() {
            localWordList.remove(text);
            AppUtils.setSearchDataList(localWordList);
          });
        },
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: IConstant.white_bg_color,
                width: 0.5.w),
            borderRadius: BorderRadius.all(Radius.circular(20.w)))
    ));
  }

  Widget buildHistory() {
    if (localWordList.isNotEmpty) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 8.w),
              child: Text(
                  LanguageConfig.get(LanguageConfigKeys.Shop_search_history),
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: IConstant.text_color)
              ),
            ),
            Wrap(spacing: 20, children: localWordList.map((item) => getChip(item)).toList())
      ]);
    } else {
      return Container();
    }
  }

  @override
  void dispose() {
    super.dispose();
    //AppUtils.setSearchDataList(localWordList);
  }

}