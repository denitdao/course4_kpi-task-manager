import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/pages/student/task_view_page/task_view_page.dart';
import 'package:task_manager/pages/student/tasks_page/task_list_cubit.dart';
import 'package:task_manager/pages/student/tasks_page/task_list_page.dart';
import 'package:task_manager/utils/mixins/verbose_date.dart';

class TaskPreviewStudent extends StatelessWidget with VerboseDate {
  const TaskPreviewStudent({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskViewPage(id: task.id),
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
                    context
                        .read<TaskListCubit>()
                        .changeTaskStatus(task.id, status ?? !task.isDone);
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
}
