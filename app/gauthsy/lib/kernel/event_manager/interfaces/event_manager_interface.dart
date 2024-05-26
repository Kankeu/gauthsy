part of events_manager;

// Interface for EventManager

abstract class EventManagerInterface {
  // Attaches a listener to an event
  bool attach<E>(String event, Function(E) callback, [int priority = 0]);

  // Detaches a listener from an event

  bool detach(String event, Function callback);

  // Clear all listeners for a given event

  void clearListeners<E>(String event);

  // check if listener is attached

  bool hasListener(String event);

  // Trigger an event

  // Can accept an String or will create one if not passed

  dynamic trigger(EventInterface event);

  dynamic signal<E>(String event, [E target]);
}
