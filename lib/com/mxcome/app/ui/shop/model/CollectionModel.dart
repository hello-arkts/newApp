import '../../../model/BaseModel.dart';

class CollectionModel {
  String productId;
  String productPic;
  String productName;
  double productPrice;
  String productSubTitle;
  bool isSelect;

  CollectionModel(this.productId, this.productPic, this.productName,
      this.productPrice, this.productSubTitle, this.isSelect);

  factory CollectionModel.fromJson(dynamic item) {
    String productId = BaseModel.getString(item, "productId");
    String productPic = BaseModel.getString(item, "productPic");
    String productName = BaseModel.getString(item, "productName");
    double productPrice = BaseModel.getDouble(item, "productPrice");
    String productSubTitle = BaseModel.getString(item, "productSubTitle");
    return CollectionModel(productId, productPic, productName, productPrice, productSubTitle, true
    );
  }
}
