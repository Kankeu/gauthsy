part of container;

typedef Fun = Object Function();

abstract class ContainerInterface {
  E get<E>(String id);

  bool has(String id);

  void set<E>(String id, Fun callback);
}
