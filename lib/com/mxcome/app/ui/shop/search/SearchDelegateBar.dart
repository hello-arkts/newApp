import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/SearchEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/search/SearchResultPage.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';

import 'SearchSuggestionsPage.dart';

class SearchDelegateBar extends SearchDelegate<String>{

  @override
  String get searchFieldLabel => LanguageConfig.get(LanguageConfigKeys.Shop_product_search);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear, size: 16.w),
        onPressed: () => {
          clearQuery(context)
        },
      ),
      IconButton(
        icon: Image.asset(
          'assets/icons/search.png',
          width: 16.w,
          height: 16.w,
        ),
        onPressed: () => {
          showResults(context)
        },
      ),
    ]; // 这里返回一个清理搜索词的Icon，目的是重置query内容为空
  }

  void clearQuery(BuildContext context) {
    print('-----------clearQuery');
    query = "";
    showSuggestions(context);
  }

  // buildLeading 返回一个Widget，定义搜索栏左边的按钮，一般为返回按钮
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation
        ),
        //点击时关闭整个搜索页面
        onPressed: () {
          if (query.isEmpty) {
            close(context, '');
          } else {
            clearQuery(context);
          }
        }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    print('-----------buildResults');
    EventBusUtil.getInstance().off(searchEvent);
    return SearchResultPage(query);
  }

  dynamic searchEvent;

  @override
  Widget buildSuggestions(BuildContext context) {
    print('-----------buildSuggestions');
    searchEvent = EventBusUtil.getInstance().on<SearchEvent>((event) {
      query = event.query;
      showResults(context);
    });
    return SearchSuggestionsPage();
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
        fontFamily: 'Roboto',
        appBarTheme: AppBarTheme(
          elevation: 0.5.w
        ),
        textSelectionTheme: const TextSelectionThemeData(selectionColor: Colors.black26, cursorColor: Colors.black26, selectionHandleColor: Colors.black26),
        colorScheme: const ColorScheme.light(
            primary: IConstant.white_color,
            onPrimary: IConstant.title_color,
            secondary: IConstant.main_color,
            onSecondary: IConstant.white_color));
  }

}


