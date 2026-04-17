// 滚动方向枚举
enum ScrollDirection { up, down }

// 滚动事件
class ScrollEvent {
  final ScrollDirection scrollDirection;
  ScrollEvent(this.scrollDirection);
}
