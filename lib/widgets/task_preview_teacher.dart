import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/screens/task_edit.dart';
import 'package:task_manager/screens/task_view.dart';

class TaskPreviewTeacher extends StatefulWidget {
  final Task task;

  const TaskPreviewTeacher({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskPreviewTeacher> createState() => _TaskPreviewTeacherState();
}

class _TaskPreviewTeacherState extends State<TaskPreviewTeacher> {
  late final Task _task = widget.task;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskEdit(id: _task.title),
          ),
        )
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 4, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.ideographic,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
                  child: Text(
                    _task.title,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    _task.date,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
                child: Text(
                  'Completed by 8/25',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(4, 2, 4, 12),
              child: LinearProgressIndicator(
                value: 0.33,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
