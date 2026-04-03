class PocketEvent {

  PocketType pocketType;

  PocketEvent({this.pocketType = PocketType.query});

}

enum PocketType{ query, complete }