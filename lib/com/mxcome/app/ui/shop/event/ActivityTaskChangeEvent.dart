class ActivityTaskChangeEvent {

  ChangeType changeType;

  ActivityTaskChangeEvent({this.changeType = ChangeType.activity});

}

enum ChangeType{ activity, task }