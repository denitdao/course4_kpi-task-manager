import 'package:flutter/material.dart';
import 'package:task_manager/core/auth/auth_required_state.dart';
import 'package:task_manager/widgets/drawer.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/widgets/task_preview.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _TodayPageState createState() => _TodayPageState();
}

class _TodayPageState extends AuthRequiredState<TodayPage> {
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
          return TaskPreview(task: item);
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
