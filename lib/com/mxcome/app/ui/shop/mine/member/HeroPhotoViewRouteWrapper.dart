import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../IConstant.dart';

class HeroPhotoViewRouteWrapper extends StatelessWidget {
  const HeroPhotoViewRouteWrapper({
    required this.imageProvider,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
  });

  final ImageProvider imageProvider;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IConstant.white_color,
      appBar: AppBar(
        elevation: 0.5.w,
        centerTitle: true,
        leading: Container(),
        title: Text(LanguageConfig.get(LanguageConfigKeys.Base_view_image),
            style: TextStyle(fontSize: 17.sp, color: IConstant.text_color)),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SizedBox(
                width: 50.w,
                child: Icon(Icons.close, size: 18.w, color: IConstant.title_color)),
          )
        ],
      ),
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: PhotoView(
          imageProvider: imageProvider,
          backgroundDecoration: backgroundDecoration,
          minScale: minScale,
          maxScale: maxScale,
          heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
        ),
      ),
    );
  }
}