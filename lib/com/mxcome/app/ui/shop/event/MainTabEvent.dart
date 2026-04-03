class MainTabEvent {

  PageType pageType;

  MainTabEvent({this.pageType = PageType.main});

}

enum PageType{ main, pocket, pocketActivity, grow }
