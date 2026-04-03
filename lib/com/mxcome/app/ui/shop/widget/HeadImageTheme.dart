import 'package:flutter/material.dart';

class HeadImageTheme extends StatelessWidget implements PreferredSizeWidget{

  final String headImageName;
  final double? headImageHeight;
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final bool resizeToAvoidBottomInset;
  final Color? backgroundColor;
  final double appBarHeight;
  final Widget? bottomNavigationBar;
  final BoxFit fit;
  final Widget? floatingActionButton;
  const HeadImageTheme(
      {Key? key,
      required this.headImageName,
      this.headImageHeight,
      this.appBar,
      this.body,
      this.resizeToAvoidBottomInset = false,
      this.backgroundColor,
        this.appBarHeight=56.0, this.bottomNavigationBar, this.fit=BoxFit.fill, this.floatingActionButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Stack(
        children: <Widget>[
          Image.asset(headImageName, width: double.infinity, height: headImageHeight, fit: fit),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: appBar,
            body: body,
            bottomNavigationBar: bottomNavigationBar,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            floatingActionButton: floatingActionButton,
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);
}
