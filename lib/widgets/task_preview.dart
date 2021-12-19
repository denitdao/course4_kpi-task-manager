import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/modules/models/task_item.dart';

class TaskPreview extends StatefulWidget {
  final TaskItem taskItem;

  const TaskPreview({Key? key, required this.taskItem}) : super(key: key);

  @override
  State<TaskPreview> createState() => _TaskPreviewState(taskItem);
}

class _TaskPreviewState extends State<TaskPreview> {
  final TaskItem _taskItem;

  _TaskPreviewState(this._taskItem);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {Navigator.pushNamed(context, "/task")},
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.ideographic,
              children: [
                Checkbox(
                  activeColor: Colors.deepPurpleAccent,
                  value: _taskItem.isCompleted,
                  onChanged: (bool? value) {
                    setState(() {
                      _taskItem.isCompleted = value!;
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
                          _taskItem.title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                        child: Text(
                          _taskItem.description,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    _taskItem.date,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ActionChip(
                tooltip: 'Navigate to the subject page',
                label: Text(_taskItem.subjectTitle),
                onPressed: () => {Navigator.pushNamed(context, "/subject")},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
