import 'package:flutter/material.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/pages/teacher/task_edit_page/task_edit_page.dart';
import 'package:task_manager/theme/light_color.dart';
import 'package:task_manager/utils/mixins/verbose_date.dart';

class TaskPreviewTeacher extends StatelessWidget with VerboseDate {
  const TaskPreviewTeacher({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskEditPage(id: task.id),
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
                    child: Text(
                      task.title,
                      style: Theme.of(context).textTheme.headline3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    getVerboseDateTime(task.dueDate),
                    style: !_isDateMissed()
                        ? Theme.of(context).textTheme.headline4
                        : Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(color: LightColor.warn),
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
                value: _findLinearProgress(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _findLinearProgress() {
    if (task.studentsOverall == 0) {
      return 1;
    }
    return task.completedBy / task.studentsOverall;
  }

  bool _isDateMissed() {
    DateTime now = DateTime.now();
    var taskDate = task.dueDate;

    if (taskDate.difference(now).inDays == 0) return false;

    return taskDate.isBefore(now);
  }
}
