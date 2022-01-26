import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/models/subject.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/screens/subject_edit.dart';
import 'package:task_manager/screens/task_list_teacher.dart';
import 'package:task_manager/screens/task_view.dart';
import 'package:task_manager/widgets/task_preview_teacher.dart';

class SubjectPreview extends StatefulWidget {
  final Subject subject;

  const SubjectPreview({Key? key, required this.subject}) : super(key: key);

  @override
  State<SubjectPreview> createState() => _SubjectPreviewState();
}

class _SubjectPreviewState extends State<SubjectPreview> {
  late final Subject _subject = widget.subject;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubjectEdit(id: _subject.title),
          ),
        )
      },
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskListTeacher(subjectId: _subject.title),
          ),
        )
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 4, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
              child: Text(
                _subject.title,
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              textBaseline: TextBaseline.ideographic,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    _subject.tasks.length.toString() + ' tasks',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                ActionChip(
                  tooltip: 'See subjects of the group',
                  label: Text(
                    _subject.groupId,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  onPressed: () =>
                      {Navigator.pushNamed(context, "/subjects")},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
