
class KeyEvent {
  String key;

  KeyEvent(this.key);
 
  bool isDelete() => key == "del";

  bool isCommit() => key == "commit";

}