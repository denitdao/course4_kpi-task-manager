import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/screens/task_edit.dart';

class TaskPreviewTeacher extends StatelessWidget {
  const TaskPreviewTeacher({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskEdit(id: task.title),
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
                    task.title,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    getVerboseDateTimeRepresentation(task.dueDate),
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
                  'Completed by ${task.completedBy}/${task.studentsOverall}',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 2, 4, 12),
              child: LinearProgressIndicator(
                value: findLinearProgress(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double findLinearProgress() {
    if (task.studentsOverall == 0) {
      return 1;
    }
    return task.completedBy / task.studentsOverall;
  }

  String getVerboseDateTimeRepresentation(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime justNow = now.subtract(Duration(minutes: 1));
    DateTime localDateTime = dateTime.toLocal();

    String roughTimeString = DateFormat('jm').format(dateTime);

    if (localDateTime.day == now.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return roughTimeString;
    }

    DateTime tomorrow = now.subtract(Duration(days: -1));

    if (localDateTime.day == tomorrow.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return 'Tomorrow';
    }

    DateTime yesterday = now.subtract(Duration(days: 1));

    if (localDateTime.day == yesterday.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return 'Yesterday';
    }

    if (-4 < now.difference(localDateTime).inDays && now.difference(localDateTime).inDays < 4) {
      String weekday = DateFormat('EEEE').format(localDateTime);

      return '$weekday';
      // return '$weekday, $roughTimeString';
    }

    return '${DateFormat('yMd').format(dateTime)}';
    // return '${DateFormat('yMd').format(dateTime)}, $roughTimeString';
  }
}
