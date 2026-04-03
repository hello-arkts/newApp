
import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/Logger.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/LevelGiftModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/BigTextButton.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/LoadImageView.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:mxcome/com/mxcome/app/utils/Adapt.dart';
import 'package:sprintf/sprintf.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../config/LanguageConfig.dart';
import '../../../model/BaseModel.dart';
import '../model/ActivityLevelModel.dart';

class TransformCard extends StatefulWidget {

  LevelGiftModel levelGiftModel;

  TransformCard(this.levelGiftModel);

  @override
  State<TransformCard> createState() => TransformCardState();

}

class TransformCardState extends BaseKeepAliveState<TransformCard> with SingleTickerProviderStateMixin{

  late LevelGiftModel _levelGiftModel;
  late FlipCardController _controller;

  @override
  void initState() {
   super.initState();
   _levelGiftModel = widget.levelGiftModel;
   _controller = FlipCardController();
  }

  @override
  void didUpdateWidget(covariant TransformCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _levelGiftModel = widget.levelGiftModel;
      if (_levelGiftModel.isWinning) {
        if (_controller.state!.isFront) {
          _controller.toggleCard();
        }
      } else if(!_levelGiftModel.isWinning && !_controller.state!.isFront){
        _controller.toggleCard();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FlipCard(
      flipOnTouch: false,
      controller: _controller,
      fill: Fill.fillBack, // Fill the back side of the card to make in the same size as the front.
      direction: FlipDirection.HORIZONTAL, // default
      side: CardSide.FRONT, // The side to initially display.
      front: Image.asset(
        width: 100.w,
        height: 150.w,
        "assets/icons/red_pocket.png",
      ),
      back: Container(
        width: 100.w,
        height: 150.w,
        decoration: BoxDecoration(
          color: IConstant.line_color,
          border: Border.all(width: 1.w, color: _levelGiftModel.isWinning ? IConstant.main_color: IConstant.line_color),
          borderRadius: BorderRadius.all(Radius.circular(10.w)),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.w)),
                  child: LoadImageView(100.w, 100.w, _levelGiftModel.productGiftPic),
                ),
                Padding(padding: EdgeInsets.fromLTRB(10.w, 4.w, 10.w, 0.w),
                  child: Text(_levelGiftModel.productGiftName,
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11.sp, color: IConstant.sub_text_color)),
                ),
                Padding(padding: EdgeInsets.fromLTRB(10.w, 2.w, 10.w, 0.w),
                  child: PriceText(_levelGiftModel.productGiftPrice, color: IConstant.text_color),
                ),
              ],
            ),
            _levelGiftModel.isWinning ? Center(child: Container(
              padding: EdgeInsets.fromLTRB(10.w, 2.w, 10.w, 2.w),
              decoration: BoxDecoration(
                color: IConstant.main_color,
                border: Border.all(width: 1.w, color: IConstant.white_color),
                borderRadius: BorderRadius.all(Radius.circular(10.w)),
              ),
              child: Text(LanguageConfig.get(LanguageConfigKeys.Shop_activity_selected), style: TextStyle(fontSize: 12.sp, color: IConstant.white_color)),
            )) : Container()
          ],
        ),
      ),
    );
  }

}
