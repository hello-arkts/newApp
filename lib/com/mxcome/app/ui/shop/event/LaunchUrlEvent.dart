class LaunchUrlEvent {

  String url;
  LaunchType launchType;

  LaunchUrlEvent(this.url, this.launchType);

}

enum LaunchType{ scbPay, paySuccess }