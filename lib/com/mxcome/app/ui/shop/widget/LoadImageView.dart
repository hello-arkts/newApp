import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';

class LoadImageView extends StatelessWidget {

  final double width;
  final double height;
  final String url;
  final Alignment alignment;
  final BoxFit fit;

  LoadImageView(this.width, this.height, this.url, {
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center
  });

  @override
  Widget build(BuildContext context) {
    String newUrl = url.replaceAll("from", "replace");
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: CachedNetworkImage(
        alignment: alignment,
        imageUrl: url,
        width: double.infinity,
        height: double.infinity,
        fit: fit,
        placeholder: (BuildContext context, String url) {
          return Container(
            color: IConstant.sub_text_color,
            alignment: Alignment.center,
            // child: Icon(Icons.insert_photo_outlined, size: double.infinity),
          );
        },
      ),
    );
  }
}
