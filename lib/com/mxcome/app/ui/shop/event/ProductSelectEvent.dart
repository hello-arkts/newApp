
import 'package:mxcome/com/mxcome/app/ui/shop/model/SkuModel.dart';

class ProductSelectEvent {

  dynamic mProduct;

  List<SkuModel> selectList;

  ProductSelectEvent({required this.mProduct, required this.selectList});

}