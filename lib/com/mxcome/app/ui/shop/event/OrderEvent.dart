class OrderEvent {

  OrderType orderType;

  OrderEvent({this.orderType = OrderType.query});

}

enum OrderType{ query, complete }

