import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/pages/student/task_view_page/task_view.dart';

class TaskPreviewStudent extends StatefulWidget {
  final Task task;

  const TaskPreviewStudent({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskPreviewStudent> createState() => _TaskPreviewStudentState();
}

class _TaskPreviewStudentState extends State<TaskPreviewStudent> {
  late final Task _task = widget.task;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskView(id: _task.title),
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
                  value: _task.isDeleted,
                  onChanged: (bool? value) {
                    setState(() {
                      _task.copyWith(isDeleted: value!);
                    });
                  },
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
                        child: Text(
                          _task.title,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          _task.description,
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
                    getVerboseDateTimeRepresentation(_task.dueDate),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.centerRight,
              child: ActionChip(
                // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                tooltip: 'Navigate to the tasks of this subject',
                label: Text(
                  _task.subjectTitle,
                  style: Theme.of(context).textTheme.headline4,
                ),
                onPressed: () => {Navigator.pushNamed(context, "/subject")},
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

    if (-4 < now.difference(localDateTime).inDays && now.difference(localDateTime).inDays < 4) {
      String weekday = DateFormat('EEEE').format(localDateTime);

      return '$weekday';
      // return '$weekday, $roughTimeString';
    }

    return '${DateFormat('yMd').format(dateTime)}';
    // return '${DateFormat('yMd').format(dateTime)}, $roughTimeString';
  }

}
