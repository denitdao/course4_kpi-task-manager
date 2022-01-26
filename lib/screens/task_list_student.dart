import 'package:flutter/material.dart';
import 'package:task_manager/core/auth/auth_required_state.dart';
import 'package:task_manager/widgets/drawer.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/widgets/task_preview_student.dart';

class TaskListStudent extends StatefulWidget {
  const TaskListStudent({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _TaskListStudentState createState() => _TaskListStudentState();
}

class _TaskListStudentState extends AuthRequiredState<TaskListStudent> {
  List<Task> tasks = [];

  @override
  void initState() {
    populateTasks();
    super.initState();
  }

  void populateTasks() {
    tasks = Iterable<int>.generate(16)
        .map((i) => Task(false, 'Task ' + (i + 1).toString(),
            'About this task', 'Today', 'Subject title'))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.separated(
        addAutomaticKeepAlives: false,
        itemCount: tasks.length,
        padding: const EdgeInsets.only(bottom: 80),
        itemBuilder: (context, index) {
          final item = tasks[index];
          return TaskPreviewStudent(task: item);
        },
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          thickness: 1,
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
