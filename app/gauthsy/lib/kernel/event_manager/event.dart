part of events_manager;

class Event<E> implements EventInterface<E> {
  String _name;
  Map _params = new Map<String, dynamic>();
  E _target;
  bool propagationStopped = false;

  Event(String name, [E target]) : _name = name,_target=target;

  @override
  String getName() {
    return _name;
  }

  @override
  getParam(String name) {
    return _params[name];
  }

  @override
  Map<String, dynamic> getParams() {
    return _params;
  }

  @override
  E getTarget() {
    return _target;
  }

  @override
  bool isPropagationStopped() {
    return propagationStopped;
  }

  @override
  void setName(String name) {
    _name = name;
  }

  @override
  void setParams(Map<String, dynamic> params) {
    _params = params;
  }

  @override
  void setTarget(E target) {
    _target = target;
  }

  @override
  void stopPropagation(bool flag) {
    propagationStopped = flag;
  }
}
