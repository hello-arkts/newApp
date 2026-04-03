import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import '../../../BaseKeepAliveState.dart';

class ProductHtml extends StatefulWidget {
  dynamic product;

  ProductHtml(this.product, {super.key});

  @override
  State<ProductHtml> createState() => ProductHtmlState();
}

class ProductHtmlState extends BaseKeepAliveState<ProductHtml>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    String html = BaseModel.getString(widget.product, "detailHtml");
    return TextUtils.isNotEmpty(html) ? Html(data: html): Container();
  }
}
