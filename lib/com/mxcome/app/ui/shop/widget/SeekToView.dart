import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
 
class SeekToView extends StatefulWidget {
  final Function(double value) onChange;
  double value;
 
  SeekToView(this.value, {required this.onChange});
 
  @override
  _VideoProgressBarState createState() {
    return _VideoProgressBarState();
  }
}
 
class _VideoProgressBarState extends State<SeekToView> {
  @override
  void initState() {
    super.initState();
  }
 
  @override
  void deactivate() {
    super.deactivate();
  }
 
  void seekToRelativePosition(Offset globalPosition) {
    final box = context.findRenderObject() as RenderBox;
    final Offset tapPos = box.globalToLocal(globalPosition);
    final double relative = tapPos.dx / box.size.width;
    if (relative >= 0 && relative <= 1) {
      widget.value = relative;
      if (widget.onChange != null) {
        widget.onChange(relative);
      }
      setState(() {});
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.transparent,
          child: CustomPaint(
            painter: _ProgressBarPainter(
              widget.value,
            ),
          ),
        ),
      ),
      onHorizontalDragStart: (DragStartDetails details) {
        // if (widget.onDragStart != null) {
        //   widget.onDragStart();
        // }
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        seekToRelativePosition(details.globalPosition);
        // if (widget.onDragUpdate != null) {
        //   widget.onDragUpdate();
        // }
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        // if (widget.onDragEnd != null) {
        //   widget.onDragEnd();
        // }
      },
      onTapDown: (TapDownDetails details) {
        seekToRelativePosition(details.globalPosition);
      },
    );
  }
}
 
class _ProgressBarPainter extends CustomPainter {
  _ProgressBarPainter(
    this.value,
  );
 
  double value;
 
  @override
  bool shouldRepaint(CustomPainter painter) {
    return true;
  }
 
  @override
  void paint(Canvas canvas, Size size) {
    final height = 3.w;
    Paint paint = Paint();
    paint.color = IConstant.green_color;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(0.0, size.height / 2),
          Offset(size.width, size.height / 2 + height),
        ),
        Radius.circular(4.w),
      ),
      paint,
    );
    paint.color = IConstant.main_color;
    final double playedPart = value > 1 ? size.width : value * size.width;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(0.0, size.height / 2),
          Offset(playedPart, size.height / 2 + height),
        ),
        Radius.circular(4.w),
      ),
      paint,
    );
    paint.color = IConstant.main_color;
    canvas.drawCircle(
      Offset(playedPart, size.height / 2 + height / 2),
      height * 3,
      paint,
    );
  }
}