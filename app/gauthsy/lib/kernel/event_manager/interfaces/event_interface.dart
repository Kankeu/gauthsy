part of events_manager;

// Representation of an event
abstract class EventInterface<E> {
  // Get event name
  String getName();

  // Get target/context from which event was triggered
  E getTarget();

  // Get parameters passed to the event
  Map<String, dynamic> getParams();

  // Get a single parameter by name
  String getParam(String name);

  // Set the event name
  void setName(String name);

  // Set the event target
  void setTarget(E target);

  // Set event parameters
  void setParams(Map<String, dynamic> $params);

  // Indicate whether or not to stop propagating this event
  void stopPropagation(bool flag);

  // Has this event indicated event propagation should stop?
  bool isPropagationStopped();
}
