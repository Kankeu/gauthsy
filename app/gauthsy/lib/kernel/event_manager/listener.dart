part of events_manager;

class Listener<E> implements ListenerInterface<E> {
  final Function _callback;
  final int _priority;

  Listener(Function callback, [int priority = 0])
      : _callback = callback,
        _priority = priority;

  @override
  call(E args) {
    return _callback(args);
  }

  @override
  Function getCallback() {
    return _callback;
  }

  @override
  int getPriority() {
    return _priority;
  }

  @override
  bool hasType<T>([e]) {
    if (e == null) return T is E;
    return e is E;
  }
}
