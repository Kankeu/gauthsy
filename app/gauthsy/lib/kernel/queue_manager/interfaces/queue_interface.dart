part of queue;

abstract class QueueInterface{
  bool dispatch(JobInterface job);
  bool remove(String jobName);
  bool process();
}