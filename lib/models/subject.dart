import 'package:task_manager/models/task.dart';

class Subject {
  String title;
  String groupId;
  List<Task> tasks;

  Subject(this.title, this.groupId, this.tasks);
}
