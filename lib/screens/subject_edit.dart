import 'package:flutter/material.dart';
import 'package:task_manager/constants/supabase_constants.dart';
import 'package:task_manager/core/auth/auth_required_state.dart';
import 'package:task_manager/models/subject.dart';
import 'package:task_manager/theme/light_color.dart';

class SubjectEdit extends StatefulWidget {
  SubjectEdit({Key? key, required this.id}) : super(key: key);

  String id;

  @override
  State<SubjectEdit> createState() => _SubjectEditState();
}

class _SubjectEditState extends AuthRequiredState<SubjectEdit> {
  bool _isLoading = false;
  Subject subject = Subject("Title for the subject (Math)", "TV-81", []);

  List<String> _groups = List.empty();
  String? _dropdownValue = "TV-81";

  Future _getGroups() async {
    setState(() {
      _isLoading = true;
    });

    final response = await supabase.from('groups').select('title').execute();
    final error = response.error;
    if (error != null && response.status != 406) {
      context.showErrorSnackBar(message: error.message);
    }
    final data = response.data;
    if (data != null) {
      setState(() {
        _groups = data.map<String>((i) {
          return i['title'] as String;
        }).toList();
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getGroups();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.save),
            tooltip: 'Update subject and navigate back',
          ),
          title: const Text('Edit Subject'),
        ),
        floatingActionButton: OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Delete',
            style: TextStyle(color: LightColor.warn),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(width: 1, color: LightColor.warn),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: subject.title,
                style: Theme.of(context).textTheme.headline1,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Subject title',
                  border: UnderlineInputBorder(),
                ),
                maxLines: 3,
                minLines: 1,
                onChanged: (value) {
                  setState(() {
                    subject.title = value;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                child: DropdownButton<String>(
                  value: _dropdownValue,
                  hint: const Text('Choose group'),
                  items: _groups.map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _dropdownValue = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
