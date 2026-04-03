import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:mxcome/com/mxcome/app/utils/AppUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IURLConstant.dart';
import '../../../model/BaseRsp.dart';
import '../../../utils/HttpUtils.dart';
import '../detail/ProductDetailPage.dart';
import '../widget/LoadImageView.dart';

class SearchResultPage extends StatefulWidget {

  String query;

  SearchResultPage(this.query);

  @override
  State<StatefulWidget> createState() => SearchResultPageState();
}

class SearchResultPageState extends BaseKeepAliveState<SearchResultPage> {

  @override
  Future<void> loadContentDatas() async {
    isLoading = true;
    if (TextUtils.isEmpty(widget.query)) return;
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_PRODUCT_SEARCH, {
      "pageNum": "$page",
      "pageSize": "6",
      "keyword": widget.query
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        List<dynamic> list = BaseModel.isNotEmpty(rsp.data, "list") ? BaseModel.getDynamic(rsp.data, "list") : [];
        count = rsp.data["total"];
        if (page == 1) {
          datas = list;
        } else {
          datas.addAll(list);
        }
      });
      //保存搜索
      if (TextUtils.isNotEmpty(widget.query)) {
        await AppUtils.setSearchData(widget.query);
      }
    }
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildBody();
  }

  Widget buildBody() {
    return datas.isEmpty ? buildHeader() : GridView.builder(
      padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 240.w,
        mainAxisSpacing: 10.w, //item上下间隔
        crossAxisSpacing: 10.w, //item左右间隔
      ),
      itemCount: datas.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            nextPageState(ProductDetailPage(BaseModel.getString(datas[index],"id")), false);
          },
          child: Column(
            children: [
              Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(8.w)),
                  clipBehavior: Clip.antiAlias,
                  elevation: 1,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      LoadImageView(150.w, 150.w, datas[index]["pic"]),
                    ],
                  )),
              Text(datas[index]["name"],
                  style:
                      TextStyle(fontSize: 14.sp, color: IConstant.text_color),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              Padding(
                  padding: EdgeInsets.only(left: 5.w, top: 4.w, right: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PriceText(datas[index]["price"]),
                      Row(
                        children: [
                          Image.asset("assets/icons/small_heart.png", width: 12.h, height: 12.h),
                          SizedBox(width: 4.h),
                          Text("${datas[index]["collectionNum"]}",
                              style: TextStyle(fontSize: 12.sp, color: IConstant.grey_color)),
                        ],
                      )
                    ],
                  ))
            ],
          ),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadContentDatas();
  }
}
