import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/auth/teacher_auth_required_state.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/widgets/date_picker.dart';

class TaskCreate extends StatefulWidget {
  TaskCreate({Key? key, required this.subjectId}) : super(key: key);

  String subjectId;

  @override
  State<TaskCreate> createState() => _TaskCreateState();
}

class _TaskCreateState extends TeacherAuthRequiredState<TaskCreate> {
  Task task = Task(
    false,
    "",
    "",
    "Today",
    "Subject",
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.save),
            tooltip: 'Save new task and navigate back',
          ),
          title: Text('New Task'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: task.title,
                style: Theme.of(context).textTheme.headline1,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Task title',
                  border: UnderlineInputBorder(),
                ),
                maxLines: 3,
                minLines: 1,
                onChanged: (value) {
                  setState(() {
                    task.copyWith(title: value);
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
                child: Text(
                  'Set Deadline',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              FormDatePicker(
                date: DateTime.now(),
                onChanged: (value) {
                  setState(() {
                    task.copyWith(date: 'new');
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 12),
                child: Text(
                  'Add Description',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: TextFormField(
                  initialValue: task.description,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: const InputDecoration(
                    hintText: 'Description',
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                  minLines: 5,
                  maxLines: 50,
                  onChanged: (value) {
                    setState(() {
                      task.copyWith(description: value);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
