class CartEvent {

  bool fromDetail = false;

  CartType cartType;

  CartEvent({this.fromDetail = true, this.cartType = CartType.query});

}

enum CartType{ query, delete, complete }