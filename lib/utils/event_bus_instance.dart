import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class EventBusInstanceEvent {
  dynamic source;

  EventBusInstanceEvent({this.source});
}
