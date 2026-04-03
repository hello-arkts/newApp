class AddressEvent {

  dynamic address;

  OperateStatus operateStatus;

  AddressEvent({this.address, this.operateStatus = OperateStatus.select});

}

enum OperateStatus{ select, add, update, delete }