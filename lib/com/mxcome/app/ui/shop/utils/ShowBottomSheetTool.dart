import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/picker.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';

typedef StringClickCallback = void Function(int selectIndex, Object selectStr);
typedef ArrayClickCallback = void Function(
    List<int> selecteds, List<dynamic> data);
typedef DateClickCallback = void Function(
    dynamic selectDateStr, dynamic selectDate);

class ShowBottomSheetTool {
  //选择器的高度
  double pickerHeight;

  //单行的高度
  double itemHeight;

  //按钮颜色
  Color btnColor;

  //文本颜色
  Color titleColor;

  //字体大小
  double textFontSize;

  ShowBottomSheetTool(
      {this.pickerHeight = 250.0,
      this.itemHeight = 45.0,
      this.btnColor = Colors.black,
      this.titleColor = const Color.fromRGBO(127, 127, 127, 1.0),
      this.textFontSize = 16.0});

  void showSingleRowPicker<T>(
    BuildContext context, {
    required List<T> data,
    required String title,
    required int normalIndex,
    PickerDataAdapter? adapter,
    required StringClickCallback clickCallBack,
  }) {
    openPicker(context,
        adapter: adapter ?? PickerDataAdapter(pickerData: data, isArray: false),
        clickCallBack: (Picker picker, List<int> selectIds) {
      clickCallBack(selectIds[0], data[selectIds[0]]!);
    }, selectIds: [normalIndex], title: title);
  }

  void showArrayPicker<T>(
    BuildContext context, {
    required List<T> data,
    required String title,
    required List<int> normalIndex,
    PickerDataAdapter? adapter,
    required ArrayClickCallback clickCallBack,
    PickerSelectedCallback? selectedCallback,
  }) {
    openPicker(context,
        adapter: adapter ?? PickerDataAdapter(pickerData: data, isArray: true),
        clickCallBack: (Picker picker, List<int> selectIds) {
      clickCallBack(selectIds, picker.getSelectedValues());
    },
        selectIds: normalIndex,
        title: title,
        selectedCallback: selectedCallback);
  }

  void openPicker(
    BuildContext context, {
    required PickerAdapter adapter,
    required String title,
    required List<int> selectIds,
    required PickerConfirmCallback clickCallBack,
    PickerSelectedCallback? selectedCallback,
  }) {
    Picker(
            adapter: adapter,
            title: Text(
              title = title,
              style: TextStyle(
                color: titleColor,
                fontSize: textFontSize,
              ),
            ),
            selecteds: selectIds,
            confirmText: LanguageConfig.get(LanguageConfigKeys.ViewUtils_confirm),
            cancelText: LanguageConfig.get(LanguageConfigKeys.ViewUtils_cancel),
            cancelTextStyle: TextStyle(
              color: btnColor,
              fontSize: textFontSize,
            ),
            confirmTextStyle: TextStyle(
              color: btnColor,
              fontSize: textFontSize,
            ),
            textAlign: TextAlign.right,
            itemExtent: itemHeight,
            height: pickerHeight,
            selectedTextStyle: const TextStyle(
              color: Colors.black,
            ),
            onConfirm: clickCallBack,
            onSelect: selectedCallback)
        .showModal(context);
  }
}
