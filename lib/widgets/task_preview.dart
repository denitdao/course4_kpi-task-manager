import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/screens/task_view.dart';

class TaskPreview extends StatefulWidget {
  final Task task;

  const TaskPreview({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskPreview> createState() => _TaskPreviewState(task);
}

class _TaskPreviewState extends State<TaskPreview> {
  final Task _task;

  _TaskPreviewState(this._task);

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
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.ideographic,
              children: [
                Checkbox(
                  value: _task.isCompleted,
                  onChanged: (bool? value) {
                    setState(() {
                      _task.isCompleted = value!;
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
                        ),
                      ),
                    ],
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
            Container(
              alignment: Alignment.centerRight,
              child: ActionChip(
                // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                tooltip: 'Navigate to the subject page',
                label: Text(
                  _task.subjectTitle,
                  style: Theme.of(context).textTheme.headline5,
                ),
                onPressed: () => {Navigator.pushNamed(context, "/subject")},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
