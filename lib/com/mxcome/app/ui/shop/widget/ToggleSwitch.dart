import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';

typedef OnToggle = void Function(int index);

class ToggleSwitch extends StatefulWidget {
  final Color activeBgColor;
  final Color activeTextColor;
  final Color inactiveBgColor;
  final Color inactiveTextColor;
  final List<String> labels;
  final double cornerRadius;
  final OnToggle onToggle;
  final int initialLabelIndex;
  final double minWidth;
  final double height;
  final BoxBorder? boxBorder;

  const ToggleSwitch({
    Key? key,
    this.activeBgColor = IConstant.main_color,
    this.activeTextColor = IConstant.white_color,
    this.inactiveBgColor = IConstant.white_bg_color,
    this.inactiveTextColor = IConstant.main_inactive_color,
    required this.labels,
    required this.onToggle,
    this.cornerRadius = 20.0,
    this.initialLabelIndex = 0,
    this.minWidth = 72,
    this.height = 30,
    this.boxBorder,
  }) : super(key: key);

  @override
  ToggleSwitchState createState() => ToggleSwitchState();
}

class ToggleSwitchState extends State<ToggleSwitch>
    with AutomaticKeepAliveClientMixin<ToggleSwitch> {
  int current = 0;

  @override
  void initState() {
    current = widget.initialLabelIndex;
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.cornerRadius.r),
      child: Container(
        height: widget.height,
        color: widget.inactiveBgColor,
        child: Row(
          children: List.generate(widget.labels.length * 2 - 1, (index) {
            final active = index ~/ 2 == current;
            final textColor =
            active ? widget.activeTextColor : widget.inactiveTextColor;
            var bgColor = Colors.transparent;
            if (active) {
              bgColor = widget.activeBgColor;
            }
            if (index % 2 == 1) {
              return Container();
            } else {
              return GestureDetector(
                onTap: () => _handleOnTap(index ~/ 2),
                child: Container(
                    height: widget.height,
                  constraints: BoxConstraints(minWidth: widget.minWidth),
                  decoration: BoxDecoration(
                    color: bgColor,
                    border: active ? widget.boxBorder : Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(widget.cornerRadius.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(widget.labels[index ~/ 2],
                      style: TextStyle(color: textColor, fontSize: 14.sp))
                ),
              );
            }
          }),
        ),
      ),
    );
  }

  void _handleOnTap(int index) async {
    setState(() => current = index);
    widget.onToggle(index);
  }
}