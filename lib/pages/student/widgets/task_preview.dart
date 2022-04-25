import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/pages/student/task_view_page/task_view_page.dart';
import 'package:task_manager/pages/student/tasks_page/task_list_cubit.dart';
import 'package:task_manager/pages/student/tasks_page/task_list_page.dart';
import 'package:task_manager/theme/light_color.dart';
import 'package:task_manager/utils/mixins/verbose_date.dart';

class TaskPreviewStudent extends StatelessWidget with VerboseDate {
  const TaskPreviewStudent({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    var taskTile = Padding(
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
                  context
                      .read<TaskListCubit>()
                      .changeTaskStatus(task.id, status ?? !task.isDone);
                },
              ),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.ideographic,
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: task.isDone
                                  ? Theme.of(context)
                                      .textTheme
                                      .headline3!
                                      .copyWith(
                                        decoration: TextDecoration.lineThrough,
                                      )
                                  : Theme.of(context).textTheme.headline3,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
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
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          task.description,
                          style: Theme.of(context).textTheme.bodyText2,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
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
    );

    return InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskViewPage(id: task.id),
          ),
        )
      },
      child: (task.isDone)
          ? Opacity(
              opacity: 0.6,
              child: taskTile,
            )
          : taskTile,
    );
  }

  bool _isDateMissed() {
    DateTime now = DateTime.now();
    var taskDate = task.dueDate;

    if (task.isDone) return false;
    if (taskDate.difference(now).inDays == 0) return false;

    return taskDate.isBefore(now);
  }
}
