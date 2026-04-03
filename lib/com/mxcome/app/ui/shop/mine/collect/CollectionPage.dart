import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';

import '../../../../BaseKeepAliveState.dart';
import '../../../../IURLConstant.dart';
import '../../../../model/BaseModel.dart';
import '../../../../model/BaseRsp.dart';
import '../../../../utils/HttpUtils.dart';
import '../../../../utils/ViewUtils.dart';
import '../../detail/ProductDetailPage.dart';
import '../../event/CollectEvent.dart';
import '../../model/CollectionModel.dart';
import '../../utils/EventBusUtil.dart';
import '../../widget/LoadImageView.dart';

class CollectionPage extends StatefulWidget {

  CollectionPage();

  @override
  State<StatefulWidget> createState() => CollectionPageState();
}

class CollectionPageState extends BaseKeepAliveState<CollectionPage> {

  bool isReloadCollect = false;

  dynamic collectEvent;


  @override
  void initState() {
    super.initState();
    collectEvent = EventBusUtil.getInstance().on<CollectEvent>((event) {
      if (event.collectType == CollectType.query) {
        loadContentDatas();
      }
    });
    loadContentDatas();
  }

  @override
  void dispose() {
    if (isReloadCollect) {
      EventBusUtil.getInstance().emit(CollectEvent());
    }
    EventBusUtil.getInstance().off(collectEvent);
    super.dispose();
  }

  @override
  Future<void> loadContentDatas() async {
    isLoading = true;
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_COLLECTION_LIST, {
      "pageNum": "$page",
      "pageSize": "10",
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      List<CollectionModel> list = [];
      List<dynamic> tempList = BaseModel.isNotEmpty(rsp.data, "list") ? BaseModel.getDynamic(rsp.data, "list") : [];
      for(var item in tempList) {
        list.add(CollectionModel.fromJson(item));
      }
      setState(() {
        count = rsp.data["total"];
        if (page == 1) {
          datas = list;
        } else {
          datas.addAll(list);
        }
      });
    }
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.5.w,
        centerTitle: true,
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_like),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
      ),
      body: buildBody()
    );
  }

  Widget buildBody() {
    return datas.isEmpty ? buildHeader() : EasyRefresh(
        header: const MaterialHeader(color: IConstant.main_color),
        footer: CupertinoFooter(emptyWidget: Container(
            padding: EdgeInsets.all(10.w),
            child: Text(LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_more), style: TextStyle(fontSize: 13.sp, color: IConstant.text_color)),
          )),
        onRefresh: ()=> onRefresh(),
        onLoad: ()=> onLoadMore(), child: ListView.separated(
        scrollDirection: Axis.vertical,
        itemCount: datas.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              nextPageState(ProductDetailPage(datas[index].productId), false);
            },
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 5.w, right: 5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadiusDirectional.circular(8)),
                            clipBehavior: Clip.antiAlias,
                            elevation: 1,
                            child: Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: [
                                LoadImageView(
                                    70, 70, datas[index].productPic),
                              ],
                            )),
                        SizedBox(width: 4.w),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 12.w),
                                  Text(datas[index].productName,
                                      style: TextStyle(
                                          fontSize: 15.sp, color: IConstant.text_color),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      PriceText(datas[index].productPrice, fontSize: 14.sp,),
                                      expandeSpace,
                                      buildHeart(datas[index]),
                                    ],
                                  )]))
                      ],
                    ))
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 10.w);
        }));
  }

  Widget buildHeart(CollectionModel collection) {
    return IconButton(icon: Image.asset(collection.isSelect ? "assets/icons/heart_red.png" : "assets/icons/heart_grey.png", width: 24.w, height: 24.w), onPressed: (){
      collection.isSelect ? delete(collection) : add(collection);
    },);
  }

  Future<void> add(CollectionModel collection) async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.postJSON(IURLConstant.MALL_COLLECTION_ADD,{
      "productId": collection.productId,
      "productName": collection.productName,
      "productPic": collection.productPic,
      "productPrice": collection.productPrice,
      "productSubTitle": collection.productSubTitle,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        collection.isSelect = true;
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    isReloadCollect = true;
    ViewUtils.dismiss();
  }

  Future<void> delete(CollectionModel collection) async {
    ViewUtils.show();
    BaseRsp rsp = await HttpUtils.post(IURLConstant.MALL_COLLECTION_DELETE, {
      "productId": collection.productId,
    });
    if (rsp.retCode == RspRetCode.SUCCESS) {
      setState(() {
        datas.remove(collection);
      });
    } else {
      ViewUtils.displayToast(rsp.msg);
    }
    isReloadCollect = true;
    ViewUtils.dismiss();
  }

}
