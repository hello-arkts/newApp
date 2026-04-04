import 'package:flutter/material.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';

class CouponPage extends StatelessWidget {
  const CouponPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LanguageConfig.get(LanguageConfigKeys.Shop_coupon)),
      ),
      body: Center(child: Text('Coupon Page')),
    );
  }
}