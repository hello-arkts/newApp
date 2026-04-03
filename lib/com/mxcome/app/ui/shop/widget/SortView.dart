import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../IConstant.dart';

typedef OnSortStateChange = Function(SortState state);

enum SortState{ INIT, UP, DOWN }

class SortView extends StatefulWidget {

  String title;
  SortState sortState;
  OnSortStateChange onSortStateChange;

  SortView(this.title, this.sortState, this.onSortStateChange);

  @override
  _SortViewState createState() => _SortViewState();

}

class _SortViewState extends State<SortView> {

  late String _title;
  late SortState _sortState;

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _sortState = widget.sortState;
  }

  @override
  void didUpdateWidget(covariant SortView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _title = widget.title;
    _sortState = widget.sortState;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          if (_sortState == SortState.INIT) {
            _sortState = SortState.UP;
          } else  if (_sortState == SortState.DOWN) {
            _sortState = SortState.UP;
          } else {
            _sortState = SortState.DOWN;
          }
        });
        widget.onSortStateChange(_sortState);
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
        child: Row(
          children: [
            Text(_title,
                style: TextStyle(fontSize: 14.sp, color: _sortState == SortState.INIT ? IConstant.text_color : IConstant.main_color)),
            SizedBox(width: 4.w),
            buildSortIcon(),
          ],
        ),
      ),
    );
  }

  Widget buildSortIcon() {
    if (_sortState == SortState.UP) {
      return Image.asset('assets/icons/sort_up.png', height: 10.w,);
    } else if (_sortState == SortState.DOWN) {
      return Image.asset('assets/icons/sort_down.png', height: 10.w,);
    } else {
      return Image.asset('assets/icons/sort.png', height: 10.w,);
    }
  }

}
