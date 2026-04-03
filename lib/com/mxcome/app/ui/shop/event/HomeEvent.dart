class HomeEvent {

  HomeType homeType;

  HomeEvent({this.homeType = HomeType.query});

}

enum HomeType{ query, complete }