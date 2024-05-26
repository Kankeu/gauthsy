part of events_manager;

abstract class ListenerInterface<E>{
  int getPriority();
  Function getCallback();
  dynamic call(E args);
  bool hasType<T>([dynamic]);
}