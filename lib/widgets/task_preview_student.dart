import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/pages/student/task_view_page/task_view.dart';
import 'package:task_manager/pages/student/tasks_page/task_list_cubit.dart';
import 'package:task_manager/pages/student/tasks_page/task_list_page.dart';

class TaskPreviewStudent extends StatelessWidget {
  const TaskPreviewStudent({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskView(id: task.title),
          ),
        )
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.ideographic,
              children: [
                Checkbox(
                  value: task.isDone,
                  onChanged: (bool? status) {
                    context.read<TaskListCubit>().changeTaskStatus(task.id, status ?? !task.isDone);
                  },
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
                        child: Text(
                          task.title,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          task.description,
                          style: Theme.of(context).textTheme.bodyText2,
                          maxLines: 2,
                        ),
                      ),
                    ],
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
            Container(
              alignment: Alignment.centerRight,
              child: ActionChip(
                tooltip: 'Navigate to the tasks of this subject',
                label: Text(
                  task.subjectTitle,
                  style: Theme.of(context).textTheme.headline4,
                ),
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskListPage(
                        pageTitle: task.subjectTitle + ' Tasks',
                        subjectId: task.subjectId,
                      ),
                    ),
                  )
                },
              ),
            ),
          ],
        ),
      ),
    );
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

    if (-4 < now.difference(localDateTime).inDays &&
        now.difference(localDateTime).inDays < 4) {
      String weekday = DateFormat('EEEE').format(localDateTime);

      return '$weekday';
      // return '$weekday, $roughTimeString';
    }

    return '${DateFormat('yMd').format(dateTime)}';
    // return '${DateFormat('yMd').format(dateTime)}, $roughTimeString';
  }
}
