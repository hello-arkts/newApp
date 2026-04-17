import 'package:flutter/material.dart';

class CouponDrawerTabSwitcher extends StatelessWidget {
  final int index;
  final WidgetBuilder useCouponBuilder;
  final WidgetBuilder shopBuilder;

  const CouponDrawerTabSwitcher({
    super.key,
    required this.index,
    required this.useCouponBuilder,
    required this.shopBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (index == 0) {
      return useCouponBuilder(context);
    }
    return shopBuilder(context);
  }
}

