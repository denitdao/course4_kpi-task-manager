import 'package:flutter/material.dart';

class TaskItem {
  final String title;
  final String description;
  final String date;

  TaskItem(this.title, this.description, this.date);

  Widget buildTitle(BuildContext context) {
    return Text(title);
  }

  Widget buildDescription(BuildContext context) {
    return Text(description);
  }

  Widget buildDate(BuildContext context) {
    return Text(date);
  }

/*  DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
      ),
      child: Text('subject'),
    ) */

  void Function() buildOnTap(BuildContext context) {
    return () => {Navigator.pushNamed(context, "/task")};
  }
}
