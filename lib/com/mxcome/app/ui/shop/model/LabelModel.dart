
import 'dart:ui';

import '../../../IConstant.dart';
import '../../../model/BaseModel.dart';

class LabelModel {
  String id;
  String name;
  String icon;
  bool isSelect;

  LabelModel(
      this.id,
      this.name,
      this.icon,
      this.isSelect);

  factory LabelModel.fromJson(dynamic model, bool isSelect) {
    String id = BaseModel.getString(model, "id");
    String name = BaseModel.getString(model, "name");
    String icon = BaseModel.getString(model, "icon");
    return LabelModel(id, name, icon, false);
  }

  Color getBorderColor() {
    return isSelect ? IConstant.main_color : IConstant.line_color;
  }

  Color getBgColor() {
    return isSelect ? IConstant.red_bg_color : const Color(0xFFF9F9F9);
  }

  Color getIconColor() {
    return isSelect ? IConstant.main_color : IConstant.text_color;
  }

}
