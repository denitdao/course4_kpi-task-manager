import 'package:flutter/material.dart';
import 'package:task_manager/constants/supabase_constants.dart';
import 'package:task_manager/core/auth/auth_required_state.dart';
import 'package:task_manager/models/subject.dart';

class SubjectCreate extends StatefulWidget {
  SubjectCreate({Key? key}) : super(key: key);

  @override
  State<SubjectCreate> createState() => _SubjectCreateState();
}

class _SubjectCreateState extends AuthRequiredState<SubjectCreate> {
  bool _isLoading = false;
  Subject subject = Subject("", "", []);

  List<String> _groups = List.empty();
  String? _dropdownValue;

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

  Future<void> _createSubject() async {
    setState(() {
      _isLoading = true;
    });

    final user = supabase.auth.currentUser;
    final newSubject = {
      'teacher_id': user!.id,
      'group_id': '3c8d32e4-9a6d-4000-a926-40de2c6c59f9',
      'title': subject.title,
      'description': _dropdownValue,
    };

    final response =
        await supabase.from('subjects').insert(newSubject).execute();
    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    } else {
      Navigator.pop(context);
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
            onPressed: _createSubject,
            icon: const Icon(Icons.save),
            tooltip: 'Save new subject and navigate back',
          ),
          title: const Text('New Subject'),
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
