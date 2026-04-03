class CollectEvent {

  CollectType collectType;

  CollectEvent({this.collectType = CollectType.query});

}

enum CollectType{query, complete }