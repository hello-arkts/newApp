import 'dart:async';
import 'package:event_bus/event_bus.dart';

typedef EventCallback<T> = void Function(T event);

class EventBusUtil {

  static final EventBus _eventBus = EventBus();

  static final EventBusUtil _instance = EventBusUtil();

  static EventBusUtil getInstance() {
    return _instance;
  }

  StreamSubscription on<T>(EventCallback<T> callback) {
    StreamSubscription stream = _eventBus.on<T>().listen((event) {
      callback(event);
    });
    return stream;
  }

  void emit(event) {
    _eventBus.fire(event);

  }

  void off(StreamSubscription steam) {
    steam.cancel();
  }

}

