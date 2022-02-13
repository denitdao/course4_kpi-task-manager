import 'package:flutter/material.dart';
import 'package:task_manager/core/auth/teacher_auth_required_state.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/theme/light_color.dart';
import 'package:task_manager/widgets/date_picker.dart';

class TaskEdit extends StatefulWidget {
  TaskEdit({Key? key, required this.id}) : super(key: key);

  String id;

  @override
  State<TaskEdit> createState() => _TaskEditState();
}

class _TaskEditState extends TeacherAuthRequiredState<TaskEdit> {
  bool _isLoading = false;
  Task task = Task(
      "",
      "Title of the task",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
      "",
      DateTime.now(),
      DateTime.now(),
      DateTime.now(),
      false
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
            tooltip: 'Save changes and navigate back',
          ),
          title: Text('Edit task'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/some");
              },
              icon: const Icon(Icons.bar_chart_rounded),
              tooltip: 'Go to task statistics',
            ),
          ],
        ),
        floatingActionButton: OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Delete',
            style: TextStyle(color: LightColor.warn),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(width: 1, color: LightColor.warn),
          ),
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
                    task.copyWith(dueDate: DateTime.now());
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
