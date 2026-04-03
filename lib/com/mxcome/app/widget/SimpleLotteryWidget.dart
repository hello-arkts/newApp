
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/LoadImageView.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/PriceText.dart';
import 'package:mxcome/com/mxcome/app/utils/Adapt.dart';

import '../IConstant.dart';
import '../ui/shop/event/LotteryEvent.dart';

class SimpleLotteryValue {

  SimpleLotteryValue(
      {this.target = 0, this.isFinish = false, this.isPlaying = false});

  /// 中奖目标
  int target = 0;

  bool isPlaying = false;
  bool isFinish = false;

  SimpleLotteryValue copyWith({
    int target = 0,
    bool isPlaying = false,
    bool isFinish = false,
  }) {
    return SimpleLotteryValue(
        target: target, isFinish: isFinish, isPlaying: isPlaying);
  }

  @override
  String toString() {
    return "target : $target , isPlaying : $isPlaying , isFinish : $isFinish";
  }
}

class SimpleLotteryController extends ValueNotifier {
  SimpleLotteryController() : super(SimpleLotteryValue());

  /// 开启抽奖
  ///
  /// [target] 中奖目标
  void start(int target) {
    // 九宫格抽奖里范围为0~8
    assert(target >= 0 && target <= 9);
    if (value.isPlaying) {
      return;
    }
    value = value.copyWith(target: target, isPlaying: true);
  }

  void finish() {
    value = value.copyWith(isFinish: true);
  }

}

class SimpleLotteryWidget extends StatefulWidget {

  final SimpleLotteryController simpleLotteryController;
  final List commodityList;
  const SimpleLotteryWidget({
    super.key,
    required this.commodityList,
    required this.simpleLotteryController
  });

  @override
  State<SimpleLotteryWidget> createState() => _SimpleLotteryWidgetState();
}

class _SimpleLotteryWidgetState extends State<SimpleLotteryWidget> with TickerProviderStateMixin,AutomaticKeepAliveClientMixin{
  Future<int>? future; // 标识

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        return Column(
          children: [
            SizedBox(
              width: Adapt.getWindowWidth(),
              height: Adapt.getWindowWidth() + 18.w,
              child: GridView.builder(
                  padding: EdgeInsets.all(10.w),
                  physics: const BouncingScrollPhysics(),
                  itemCount: 9,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 6.w,
                      mainAxisSpacing: 6.w),
                  itemBuilder: (context, index) {
                    return commodity(index);
                  }
              ),
            ),
          ],
        );
      },
    );
  }

  // 商品列表
  Widget commodity(int index){
    final int toIndex = _deserializeMap[index];
    if (toIndex < widget.commodityList.length) {
      final item = widget.commodityList[toIndex];
      return InkWell(
        onTap: () {
          EventBusUtil.getInstance().emit(LotteryEvent(index: index));
        },
        child: Stack(
          children: [
            Positioned(left: 0, right: 0, top: 0, bottom: 0, child: Container(
              decoration: BoxDecoration(
                color: IConstant.white_color,
                borderRadius: BorderRadius.all(Radius.circular(10.w)),
              ),
              child: Column(
                children: [
                  SizedBox(height: 8.w,),
                  LoadImageView(50.w, 50.w, BaseModel.getString(item, "pic")),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.w), child: Text(BaseModel.getString(item, "name"), textAlign: TextAlign.center,
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: IConstant.title_color, fontWeight: FontWeight.bold, fontSize: 12.sp)),),
                  PriceText(BaseModel.getDouble(item, "price"),
                      fontSize: 12.sp, fontWeight: FontWeight.bold, color: IConstant.main_color)
                ],
              ),
            )),
            Container(decoration: BoxDecoration(
              color:  index == _currentSelect
                  ? Colors.yellow.withOpacity(0.5)
                  : Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(10.w)),
            )),
          ],
        ),
      );
    } else {
      return Stack(
        children: [
          Positioned(left: 0, right: 0, top: 0, bottom: 0, child: Container(
            decoration: BoxDecoration(
              color: IConstant.white_color,
              borderRadius: BorderRadius.all(Radius.circular(10.w)),
            ),
            alignment: Alignment.center,
            child: Text("", textAlign: TextAlign.center,
                style: TextStyle(color: IConstant.title_color, fontWeight: FontWeight.bold, fontSize: 12.sp)),
          )),
          Container(decoration: BoxDecoration(
            color:  index == _currentSelect
                ? Colors.yellow.withOpacity(0.5)
                : Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(10.w)),
          )),
        ],
      );
    }
  }

  Animation? _selectedIndexTween;
  AnimationController? _startAnimateController;
  int _currentSelect = -1;
  int _target = 0;

  /// 旋转的圈数
  final int repeatRound = 3;
  VoidCallback? _listener;

  // /// 选中下标的映射
  // final Map _selectMap = {
  //   0: 0,
  //   1: 3,
  //   2: 6,
  //   3: 7,
  //   4: 8,
  //   5: 5,
  //   6: 2,
  //   7: 1
  // };
  //
  // //反下标的映射
  // final Map _deserializeMap = {
  //   0: 0,
  //   3: 1,
  //   6: 2,
  //   7: 3,
  //   8: 4,
  //   5: 5,
  //   2: 6,
  //   1: 7
  // };

  /// 选中下标的映射
  final Map _selectMap = {
    0: 0,
    1: 1,
    2: 2,
    3: 3,
    4: 4,
    5: 5,
    6: 6,
    7: 7,
    8: 8
  };

  //反下标的映射
  final Map _deserializeMap = {
    0: 0,
    1: 1,
    2: 2,
    3: 3,
    4: 4,
    5: 5,
    6: 6,
    7: 7,
    8: 8
  };

  simpleLotteryWidgetState() {
    _listener = () {
      // 开启抽奖动画
      if (widget.simpleLotteryController.value.isPlaying) {
        _startAnimateController?.reset();
        _target = widget.simpleLotteryController.value.target;
        _selectedIndexTween = _initSelectIndexTween(_target);
        _startAnimateController?.forward();
      }
    };
  }

  /// 初始化tween
  ///
  /// [target] 中奖的目标
  Animation _initSelectIndexTween(int target) =>
      StepTween(begin: 0, end: repeatRound * 9 + target).animate(
          CurvedAnimation(
              parent: _startAnimateController!, curve: Curves.easeOutQuart));

  @override
  void initState() {
    super.initState();

    future = Future.value(42);

    _startAnimateController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    _selectedIndexTween = _initSelectIndexTween(_target);

    simpleLotteryWidgetState();

    // 控制监听
    widget.simpleLotteryController.addListener(_listener!);

    // 动画监听
    _startAnimateController?.addListener(() {
      // 更新选中的下标
      _currentSelect = _selectMap[_selectedIndexTween?.value % 9];

      if (_startAnimateController!.isCompleted) {
        widget.simpleLotteryController.finish();
        EventBusUtil.getInstance().emit(LotteryEvent(index: -1));
      }
      setState(() {});
    });

  }

  @override
  void deactivate() {
    widget.simpleLotteryController.removeListener(_listener!);
    super.deactivate();
  }

  @override
  void dispose() {
    _startAnimateController?.dispose();
    widget.simpleLotteryController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

}
