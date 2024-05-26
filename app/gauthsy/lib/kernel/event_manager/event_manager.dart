library events_manager;

part 'interfaces/event_interface.dart';

part 'interfaces/event_manager_interface.dart';

part 'interfaces/listener_interface.dart';

part 'event.dart';

part 'listener.dart';

class EventManager implements EventManagerInterface {
  Map<String, List<ListenerInterface>> _listener = new Map();

  @override
  bool attach<E>(String event, Function(E) callback, [int priority = 0]) {
    if (_listener[event] is List)
      _listener[event].add(new Listener<E>(callback, priority));
    else
      _listener[event] = [new Listener<E>(callback, priority)];
    if (priority != 0) _order(event);
    return true;
  }

  void _order(String event) {
    _listener[event].sort((a, b) => b.getPriority().compareTo(a.getPriority()));
  }

  @override
  void clearListeners<E>(String event) {
    if (E == dynamic) _listener.remove(event);
    else _listener[event].removeWhere((e)=>e.hasType<E>());
  }

  @override
  bool detach(String event, Function callback) {
    if (hasListener(event))
      _listener[event].removeWhere((e) => e.getCallback() == callback);
    return true;
  }

  @override
  bool hasListener(String event) {
    return _listener.containsKey(event);
  }

  @override
  trigger(EventInterface event) {
    if (hasListener(event.getName())) {
      for (var e in _listener[event.getName()]) {
        if (event.isPropagationStopped()) break;
        if (e.hasType(event)) e.call(event);
      }
    }
  }

  @override
  signal<E>(String event, [E target]) {
    if (hasListener(event)) {
      for (var e in _listener[event]) {
        e.call(target);
      }
    }
  }
}
