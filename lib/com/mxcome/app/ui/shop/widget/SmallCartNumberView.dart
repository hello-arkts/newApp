import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/BaseKeepAliveState.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';

import '../../../IConstant.dart';

typedef OnNumberChange = Function(int number);

class SmallCartNumberView extends StatefulWidget {

  final OnNumberChange onNumberChange;

  final int _number;

  final int limitNum;

  const SmallCartNumberView(this._number, this.onNumberChange, {this.limitNum = 0});

  @override
  _SmallCartNumberViewState createState() => _SmallCartNumberViewState();

}

class _SmallCartNumberViewState extends BaseKeepAliveState<SmallCartNumberView> {

  late String _count;
  var _controller;

  @override
  void initState() {
    _count = "${widget._number}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      height: 30.w,
      child: Row(
        children: <Widget>[
          InkWell(
              onTap: () => _reduce(),
              child: Container(
                width: 40.w,
                height: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: IConstant.grey_bg_color,
                  borderRadius: BorderRadius.all(Radius.circular(20.w)),
                ),
                child: Icon(Icons.remove, color: IConstant.text_color,),
              )),
          InkWell(
            onTap: () {
              showDialog();
            },
            child: Container(
              alignment: Alignment.center,
              height: double.infinity,
              width: 45.w,
              child: Text('${widget._number}', style: TextStyle(fontSize: 15.sp, color: IConstant.text_color),),
            ),
          ),
          InkWell(
              onTap: () => _add(),
              child: Container(
                alignment: Alignment.center,
                width: 40.w,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: IConstant.grey_bg_color,
                  borderRadius: BorderRadius.all(Radius.circular(20.w)),
                ),
                child: Icon(Icons.add, color: IConstant.text_color),
              )),
        ],
      ),
    );
  }

  _reduce() {
    if (widget._number > 1) {
      widget.onNumberChange(widget._number - 1);
    }
  }

  _add() {
    String goodsLimit = LanguageConfig.get(LanguageConfigKeys.Shop_order_goods_limit);
    var goodsLimits = goodsLimit.split("|");
    if(widget.limitNum != -1 &&widget._number > widget.limitNum) {
      ViewUtils.displayToast('${goodsLimits[0]}${widget.limitNum}${goodsLimits[1]}');
    }else {
      widget.onNumberChange(widget._number + 1);
    }
  }

  void showDialog() {
    ViewUtils.showCustomDialog2(context,
        LanguageConfig.get(LanguageConfigKeys.Shop_modify_buy_quantity),
        buildCartNum(),
        LanguageConfig.get(LanguageConfigKeys.ViewUtils_cancel),
        LanguageConfig.get(LanguageConfigKeys.ViewUtils_confirm), (ctx, event) {
          if (event == DialogEvent.confirm) {
            int number = int.parse(_count);
            widget.onNumberChange(number);
            finishContext(ctx);
          } else {
            finishContext(ctx);
          }
        }
    );
  }

  Widget buildCartNum() {
    _count = "${widget._number}";
    _controller = TextEditingController(text: _count);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
            onTap: () => _addNum(),
            child: Container(
              width: 55.w,
              height: 40.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: IConstant.grey_bg_color,
                borderRadius: BorderRadius.all(Radius.circular(20.w)),
              ),
              child: Icon(Icons.remove, color: IConstant.text_color,),
            )),
        SizedBox(
          width: 100.w,
          child: TextField(
            autofocus: true,
            decoration: InputDecoration(
                labelStyle:
                TextStyle(color: IConstant.title_color, fontSize: 14.sp),
                hintStyle:
                TextStyle(color: IConstant.sub_text_color, fontSize: 14.sp),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                  BorderSide(color: IConstant.sub_text_color, width: 1.w),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                  BorderSide(color: IConstant.sub_text_color, width: 1.w),
                )),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.sp, color: IConstant.text_color),
            maxLines: 1,
            inputFormatters: [
              CounterTextInputFormatter(min: 1, max: widget.limitNum),
            ],
            controller: _controller,
            onChanged: (value) {
              int number = int.parse(value);
              if (number == 0) {
                _count = "$number";
                _controller.value = TextEditingValue(text: _count, selection: TextSelection.collapsed(offset: _count.length));
              } else if (widget.limitNum != -1 && number > widget.limitNum) {
                String goodsLimit = LanguageConfig.get(LanguageConfigKeys.Shop_order_goods_limit);
                var goodsLimits = goodsLimit.split("|");
                ViewUtils.displayToast('${goodsLimits[0]}${widget.limitNum}${goodsLimits[1]}');
                _count = "${widget.limitNum}";
                _controller.value = TextEditingValue(text: _count, selection: TextSelection.collapsed(offset: _count.length));
              } else {
                _count = "$number";
                _controller.value = TextEditingValue(text: _count, selection: TextSelection.collapsed(offset: _count.length));
              }
            },
          ),
        ),
        InkWell(
            onTap: () => _reduceNum(),
            child: Container(
              alignment: Alignment.center,
              width: 55.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: IConstant.grey_bg_color,
                borderRadius: BorderRadius.all(Radius.circular(20.w)),
              ),
              child: Icon(Icons.add, color: IConstant.text_color),
            )),
      ],
    );
  }

  _reduceNum() {
    int number = int.parse(_count);
    if (widget.limitNum != -1 && number > widget.limitNum) {
      String goodsLimit = LanguageConfig.get(LanguageConfigKeys.Shop_order_goods_limit);
      var goodsLimits = goodsLimit.split("|");
      ViewUtils.displayToast('${goodsLimits[0]}${widget.limitNum}${goodsLimits[1]}');
      _count = "${widget.limitNum}";
    } else {
      number++;
      _count = "$number";
    }
    _controller.value = TextEditingValue(text: _count, selection: TextSelection.collapsed(offset: _count.length));
  }

  _addNum() {
    int number = int.parse(_count);
    if (number > 1) {
      number = number - 1;
    }
    _count = "$number";
    _controller.value = TextEditingValue(text: _count, selection: TextSelection.collapsed(offset: _count.length));
  }

}

class CounterTextInputFormatter extends TextInputFormatter {
  final int min;
  final int max;

  CounterTextInputFormatter({required this.min, required this.max});

  int get maxLength => '$max'.length;
  late final regExp = RegExp("^\\d{0,$maxLength}?\$");

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue ) {
    String oldText = oldValue.text;
    String newText = newValue.text;

    if (newText.isEmpty) {
      String text =  '$min';
      return TextEditingValue(
        text: text,
        selection: TextSelection(baseOffset: 0, extentOffset: text.length),
      );
    }
    // 判定 新输入值符合输入预期
    bool isValid = (oldText.length > newText.length) ||
        regExp.hasMatch(newText);

    if (isValid) {
      // 如果以0开头、转换为有效数字
      if (newText.startsWith('0')) {
        String text =  int.parse(newText).toString();
        return TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      }
      return newValue;
    }

    return oldValue;
  }
}
