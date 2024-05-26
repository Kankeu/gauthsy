library queue;

import 'package:collection/collection.dart';

part 'interfaces/queue_interface.dart';

part 'interfaces/job_interface.dart';

part 'job.dart';

class Queue implements QueueInterface {
  final PriorityQueue<JobInterface> priorityQueue =
  PriorityQueue<JobInterface>((a, b) =>
  a.isNameKey() || b.isNameKey()
      ? a.getName() == b.getName()
      : a.getPriority().compareTo(b.getPriority()));

  @override
  bool dispatch(JobInterface job) {
    priorityQueue.add(job);
    return true;
  }

  @override
  bool process() {
    try {
        while (priorityQueue.isNotEmpty) priorityQueue.removeFirst().handle();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  bool remove(String jobName) {
    final job = priorityQueue
        .toList()
        .firstWhere((e) => e.getName() == jobName, orElse: () => null);
    if (job == null) return false;
    job.useNameKey(true);
    return priorityQueue.remove(job);
  }
}
