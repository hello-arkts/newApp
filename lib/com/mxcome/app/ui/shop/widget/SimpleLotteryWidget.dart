import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/utils/Adapt.dart';

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
    assert(target >= 0 && target <= 8);
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

  final Function()? onPress;
  final SimpleLotteryController simpleLotteryController;
  final List commodityList;
  const SimpleLotteryWidget({
    super.key,
    required this.commodityList,
    required this.onPress,
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
        return SizedBox(
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
                if (index != 4) {
                  return commodity(index);
                }
                return GestureDetector(
                  onTap: widget.onPress,
                  child: lotteryButton,
                );
              }
          ),
        );
      },
    );
  }

  // 点击抽奖按钮
  Widget get lotteryButton{
    return GestureDetector(
      onTap: widget.onPress,
      child: const DecoratedBox(
        decoration: BoxDecoration(
            color: Colors.deepOrangeAccent,
            borderRadius: BorderRadius.all(Radius.circular(15))
        ),
        child:Center(
          child: Text(
            "点击\n抽奖",
            style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                height: 1.2
            ),
          ),
        ),
      ),
    );
  }

  // 商品列表
  Widget commodity(int index){
    final int toIndex;
    if(index > 4){
      toIndex = _deserializeMap[index];
    }else{
      toIndex = _deserializeMap[index];
    }
    final dataInfo = widget.commodityList[toIndex];
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15.w)),
              image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    dataInfo["prize"],
                    scale: 0.5,
                  ),
                  fit: BoxFit.cover
              )
          ),
          // child: Text(toIndex.toString()),
        ),
        Container(decoration: BoxDecoration(
          color:  index == _currentSelect
              ? Colors.yellow.withOpacity(0.5)
              : Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(15.w)),
        )),
      ],
    );
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
    3: 5,
    4: 8,
    5: 7,
    6: 6,
    7: 3
  };

  //反下标的映射
  final Map _deserializeMap = {
    0: 0,
    1: 1,
    2: 2,
    5: 3,
    8: 4,
    7: 5,
    6: 6,
    3: 7
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
      StepTween(begin: 0, end: repeatRound * 8 + target).animate(
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
      _currentSelect = _selectMap[_selectedIndexTween?.value % 8];

      if (_startAnimateController!.isCompleted) {
        widget.simpleLotteryController.finish();
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
