
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multiavatar/Multiavatar.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/LoadImageView.dart';

class GenAvatar extends StatefulWidget {

  String text = "";

  GenAvatar(this.text);

  @override
  State<StatefulWidget> createState() {
    return GenAvatarState();
  }
}

class GenAvatarState extends State<GenAvatar> {

  String rawSvg = '';

  GenAvatarState();
  
  @override
  void initState() {
    super.initState();
    loadGenImage();
  }

  loadGenImage() async {
    rawSvg = multiavatar(widget.text);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.text.startsWith("https://api.multiavatar.com")) {
      return SvgPicture.string(rawSvg);
    } else {
      return LoadImageView(double.infinity, double.infinity, widget.text);
    }
  }

}
