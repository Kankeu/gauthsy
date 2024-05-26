library container;

part 'exceptions/not_found_exception.dart';

part 'interfaces/container_interface.dart';

class Container implements ContainerInterface {
  static final Container _singleton = new Container._internal();

  factory Container() => _singleton;

  Container._internal();

  Map<String, Object> _instances = new Map<String, Object>();

  E get<E>(String id, {Function defaultValue}) {
    if (!has(id))
      return defaultValue!=null ? defaultValue() : throw NotFoundException(id);

    return _instances[id];
  }

  bool has(String id) {
    return _instances.containsKey(id);
  }

  void set<E>(String id, Fun callback) {
    _instances[id] = callback();
  }
}
