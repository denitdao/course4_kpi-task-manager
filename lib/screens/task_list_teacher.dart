import 'package:flutter/material.dart';
import 'package:task_manager/core/auth/teacher_auth_required_state.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/widgets/task_preview_teacher.dart';

class TaskListTeacher extends StatefulWidget {
  const TaskListTeacher({Key? key, required this.subjectId}) : super(key: key);

  final String subjectId;

  @override
  _TaskListTeacherState createState() => _TaskListTeacherState();
}

class _TaskListTeacherState extends TeacherAuthRequiredState<TaskListTeacher> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    populateTasks();
  }

  void populateTasks() {
    tasks = Iterable<int>.generate(16)
        .map((i) => Task(false, 'Task ' + (i + 1).toString(), 'About this task',
            'Today', widget.subjectId))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subjectId),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/some");
            },
            icon: const Icon(Icons.bar_chart_rounded),
            tooltip: 'Go to subject statistics',
          ),
        ],
      ),
      body: ListView.separated(
        addAutomaticKeepAlives: false,
        itemCount: tasks.length,
        padding: const EdgeInsets.only(bottom: 80),
        itemBuilder: (context, index) {
          final item = tasks[index];
          return TaskPreviewTeacher(task: item);
        },
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          thickness: 1,
        ),
      ),
      // drawer: const AppDrawer(),
    );
  }
}
