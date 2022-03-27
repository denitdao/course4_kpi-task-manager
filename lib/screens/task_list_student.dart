import 'package:flutter/material.dart';
import 'package:task_manager/core/auth/student_auth_required_state.dart';
import 'package:task_manager/widgets/drawer.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/widgets/task_preview_student.dart';

class TaskListStudent extends StatefulWidget {
  const TaskListStudent({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _TaskListStudentState createState() => _TaskListStudentState();
}

class _TaskListStudentState extends StudentAuthRequiredState<TaskListStudent> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    populateTasks();
  }

  void populateTasks() {
    tasks = Iterable<int>.generate(16)
        .map((i) => Task(
            "",
            "Title of the task " + i.toString(),
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            "",
            DateTime.now(),
            DateTime.now(),
            DateTime.now(),
            false,
            subjectTitle: "Subject"))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (!verifiedAccess) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
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
