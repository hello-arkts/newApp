import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewPage extends StatelessWidget {
  String bannerDetailUrl;
  String bannerName;

  WebViewPage(this.bannerDetailUrl, this.bannerName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(bannerName),
          centerTitle: true,
        ),
        body: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri(bannerDetailUrl),
          ),
        ),
    );
  }
}
