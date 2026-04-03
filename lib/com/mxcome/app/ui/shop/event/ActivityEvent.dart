class ActivityEvent {

  ActivityType activityType;

  ActivityEvent({this.activityType = ActivityType.query});

}

enum ActivityType{ query, complete }