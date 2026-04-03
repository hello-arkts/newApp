class UserInfoEvent {

  UserInfoStatus userInfoStatus;

  UserInfoEvent({this.userInfoStatus = UserInfoStatus.query});

}

enum UserInfoStatus{ query, complete }