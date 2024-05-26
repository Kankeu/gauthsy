part of queue;

abstract class JobInterface{
  void handle();
  int getPriority();
  String getName();
  bool isNameKey();
  void useNameKey(bool v);
}