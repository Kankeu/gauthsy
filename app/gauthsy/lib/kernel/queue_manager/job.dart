part of queue;

class Job implements JobInterface {
  final String _name;
  final int _priority;
  final Function callback;
  bool _isNameKey = false;

  Job(this.callback, {String name, int priority = 1})
      : _priority = priority,
        _name = name;

  @override
  String getName() {
    return _name;
  }

  @override
  int getPriority() {
    return _priority;
  }

  @override
  void handle() {
    callback();
  }

  @override
  bool isNameKey() {
    return _isNameKey;
  }

  @override
  void useNameKey(bool v) {
    _isNameKey = v;
  }
}
