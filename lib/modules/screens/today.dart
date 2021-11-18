import 'package:flutter/material.dart';
import 'package:task_manager/widgets/drawer.dart';
import 'package:task_manager/modules/models/task_item.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _TodayPageState createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  List<TaskItem> tasks = [];

  @override
  void initState() {
    populateTasks();
    super.initState();
  }

  void populateTasks() {
    tasks = Iterable<int>.generate(16)
        .map(
            (i) => TaskItem('Task ' + (i + 1).toString(), 'About this task', 'today'))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        addAutomaticKeepAlives: false,
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final item = tasks[index];
          return ListTile(
            leading: const Icon(Icons.check_box_outline_blank),
            title: item.buildTitle(context),
            subtitle: item.buildDescription(context),
            trailing: item.buildDate(context),
            onTap: item.buildOnTap(context),
          );
        },
      ),
      drawer: const AppDrawer(),
    );
  }
}
