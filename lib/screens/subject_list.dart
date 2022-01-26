import 'package:flutter/material.dart';
import 'package:task_manager/core/auth/auth_required_state.dart';
import 'package:task_manager/models/subject.dart';
import 'package:task_manager/widgets/drawer.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/widgets/subject_preview.dart';
import 'package:task_manager/widgets/task_preview_student.dart';

class SubjectList extends StatefulWidget {
  const SubjectList({Key? key, required this.groupId}) : super(key: key);

  final String groupId;

  @override
  _SubjectListState createState() => _SubjectListState();
}

class _SubjectListState extends AuthRequiredState<SubjectList> {
  List<Subject> subjects = [];

  @override
  void initState() {
    populateTasks();
    super.initState();
  }

  void populateTasks() {
    Task task = Task(false, 'Task', 'About this task', 'Today', 'Subject title');
    subjects = Iterable<int>.generate(12)
        .map((i) => Subject('Subject ' + (i + 1).toString(),
            widget.groupId, List.filled(i, task, growable: true)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subjects of ' + widget.groupId),
      ),
      body: ListView.separated(
        addAutomaticKeepAlives: false,
        itemCount: subjects.length,
        padding: const EdgeInsets.only(bottom: 80),
        itemBuilder: (context, index) {
          final item = subjects[index];
          return SubjectPreview(subject: item);
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
