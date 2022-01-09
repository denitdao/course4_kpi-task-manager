import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/models/task.dart';
import 'package:intl/intl.dart' as intl;

class TaskView extends StatefulWidget {
  TaskView({Key? key, required this.id}) : super(key: key);

  String id;

  @override
  State<TaskView> createState() => _TaskEditState();
}

class _TaskEditState extends State<TaskView> {
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
          backgroundColor: Colors.deepPurple,
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
                        task.isCompleted = value!;
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
                            task.title = value;
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
              _FormDatePicker(
                date: DateTime.now(),
                onChanged: (value) {
                  setState(() {
                    task.date = 'new';
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

class _FormDatePicker extends StatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const _FormDatePicker({
    required this.date,
    required this.onChanged,
  });

  @override
  _FormDatePickerState createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<_FormDatePicker> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Text(
        intl.DateFormat.yMd().format(widget.date),
        // style: Theme.of(context).textTheme.subtitle1,
      ),
      onPressed: () async {
        var now = DateTime.now();
        var newDate = await showDatePicker(
          context: context,
          initialDate: widget.date,
          firstDate: DateTime(now.year, now.month - 1, now.day),
          lastDate: DateTime(now.year + 1, now.month, now.day),
        );

        // Don't change the date if the date picker returns null.
        if (newDate == null) {
          return;
        }

        widget.onChanged(newDate);
      },
    );
  }
}
