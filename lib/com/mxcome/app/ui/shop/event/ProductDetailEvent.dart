class ProductDetailEvent {

  OptionStatus optionStatus;

  ProductDetailEvent(this.optionStatus);

}

enum OptionStatus{ spec, param, isTaskProd }