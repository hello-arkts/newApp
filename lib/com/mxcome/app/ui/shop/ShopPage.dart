import 'package:flutter/material.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/product/ProductSliver.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';

import 'event/OpenMenuEvent.dart';

class ShopPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => ShopPageState();

}

class ShopPageState extends BaseKeepAliveState<ShopPage> {

  dynamic openMenuEvent;

  @override
  void initState() {
    super.initState();
    openMenuEvent = EventBusUtil.getInstance().on<OpenMenuEvent>((event) {
      setState(() {
        Scaffold.of(context).openDrawer();
      });
    });
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(openMenuEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Scaffold(
      backgroundColor: IConstant.white_color,
      body: ProductSliver(),
    );
  }

}
