import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskView extends StatefulWidget {
  TaskView({Key? key, required this.id}) : super(key: key);

  String id;

  @override
  State<TaskView> createState() => _TaskEditState();
}

class _TaskEditState extends State<TaskView> {
  bool _isLoading = false;
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text('Task - Subject Title'),
        ),
        body: ListView(
          children: [
            Text('Title(' + widget.id + ')'),
            Text('description'),
          ],
        ),
      ),
    );
  }
}
