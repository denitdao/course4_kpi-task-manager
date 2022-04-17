import 'package:flutter/material.dart';
import 'package:task_manager/models/subject.dart';
import 'package:task_manager/pages/teacher/subject_edit_page/subject_edit_page.dart';
import 'package:task_manager/pages/teacher/subject_tasks_page/subject_tasks_page.dart';
import 'package:task_manager/pages/teacher/subjects_page/subject_list_page.dart';

class SubjectPreview extends StatelessWidget {
  const SubjectPreview({Key? key, required this.subject}) : super(key: key);

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubjectEditPage(id: subject.id),
          ),
        )
      },
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubjectTasksPage(subjectId: subject.id),
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
                subject.title,
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
                    '${subject.taskAmount} tasks',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                ActionChip(
                  tooltip: 'See subjects of the group',
                  label: Text(
                    subject.group?.title ?? 'unknown',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubjectListPage(
                          groupId: subject.groupId,
                        ),
                      ),
                    ),
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
