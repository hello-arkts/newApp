import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartBadge extends StatelessWidget {

  int cartNumber;
  bool showBadge;

  CartBadge({this.cartNumber = 0,this.showBadge = false}) {
    if (cartNumber > 0) {
      showBadge = true;
    } else {
      showBadge = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: 40.w,
        height: 40.w,
        child: badges.Badge(
          showBadge: showBadge,
          badgeContent: Text("$cartNumber", style: TextStyle(fontSize: 12.sp, color: Colors.white)),
          child: Image.asset("assets/icons/cart.png", width: 24.w, height: 24.w),
        ));
  }
}
