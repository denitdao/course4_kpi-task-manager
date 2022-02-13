import 'package:flutter/material.dart';
import 'package:task_manager/core/auth/student_auth_required_state.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/widgets/date_picker.dart';

class TaskView extends StatefulWidget {
  TaskView({Key? key, required this.id}) : super(key: key);

  String id;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends StudentAuthRequiredState<TaskView> {
  bool _isLoading = false;
  Task task = Task(
    false,
    "Title of the task",
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    "Today",
    "Subject",
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Task - ' + task.subjectTitle),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                task.title + ' (' + widget.id + ')',
                style: Theme.of(context).textTheme.headline1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 4),
                child: Text(
                  'Subtasks',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: task.isCompleted,
                    onChanged: (bool? value) {
                      setState(() {
                        task.copyWith(isCompleted: value!);
                      });
                    },
                  ),
                  Expanded(
                    child: Focus(
                      onFocusChange: (value) =>
                          print('focus change - ' + value.toString()),
                      child: TextFormField(
                        initialValue: task.title,
                        decoration: const InputDecoration.collapsed(
                            hintText: 'subtask title'),
                        onChanged: (value) {
                          setState(() {
                            task.copyWith(title: value);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
                child: Text(
                  'Deadline',
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
                  'Description',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: SelectableText(
                  task.description,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
