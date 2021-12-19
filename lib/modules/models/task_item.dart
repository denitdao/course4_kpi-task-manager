import 'package:flutter/material.dart';

class TaskItem {
  final bool isCompleted;
  final String title;
  final String description;
  final String date;
  final String subjectTitle;

  TaskItem(this.isCompleted, this.title, this.description, this.date, this.subjectTitle);

  Widget buildTitle(BuildContext context) {
    return Text(title);
  }

  Widget buildDescription(BuildContext context) {
    return Text(description);
  }

  Widget buildDate(BuildContext context) {
    return Text(date);
  }

  void Function() buildOnTap(BuildContext context) {
    return () => {Navigator.pushNamed(context, "/task")};
  }
}
