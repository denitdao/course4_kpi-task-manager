import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:task_manager/constants/supabase_constants.dart';
import 'package:task_manager/core/auth/auth_required_state.dart';
import 'package:task_manager/core/injection/injection.dart';
import 'package:task_manager/models/group.dart';
import 'package:task_manager/pages/teacher/subject_edit_page/subject_edit_cubit.dart';
import 'package:task_manager/theme/light_color.dart';

class SubjectEditPage extends StatefulWidget {
  SubjectEditPage({Key? key, required this.id}) : super(key: key);

  String id;

  @override
  _SubjectEditPageState createState() => _SubjectEditPageState();
}

class _SubjectEditPageState extends AuthRequiredState<SubjectEditPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SubjectEditCubit>()..loadData(widget.id),
      child: _SubjectEditForm(),
    );
  }
}

class _SubjectEditForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubjectEditCubit, SubjectEditState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          context.showErrorSnackBar(
              message: state.errorMessage ?? 'Could not save the subject');
        } else if (state.status.isSubmissionSuccess) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state.dataStatus == ExternalDataStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              leading: _SaveSubjectButton(),
              title: const Text('Edit Subject'),
            ),
            floatingActionButton: OutlinedButton(
              onPressed: context.read<SubjectEditCubit>().deleteSubject,
              child: const Text(
                'Delete',
                style: TextStyle(color: LightColor.warn),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(width: 1, color: LightColor.warn),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SubjectTitleInput(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                    child: _GroupDropdownInput(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SaveSubjectButton extends StatelessWidget {
  void _saveSubject(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<SubjectEditCubit>().updateSubject();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectEditCubit, SubjectEditState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () => state.dataStatus == ExternalDataStatus.success
              ? _saveSubject(context)
              : null,
          icon: state.status.isValidated &&
                  !state.status.isSubmissionInProgress &&
                  state.dataStatus == ExternalDataStatus.success
              ? const Icon(Icons.save)
              : const Opacity(opacity: 0.5, child: Icon(Icons.save)),
          tooltip: 'Update subject and navigate back',
        );
      },
    );
  }
}

class _SubjectTitleInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectEditCubit, SubjectEditState>(
      buildWhen: (previous, current) =>
          previous.subjectTitle != current.subjectTitle,
      builder: (context, state) {
        return TextFormField(
          onChanged: context.read<SubjectEditCubit>().onSubjectTitleChange,
          initialValue: state.subjectTitle.value,
          keyboardType: TextInputType.text,
          style: Theme.of(context).textTheme.headline1,
          decoration: const InputDecoration.collapsed(
            hintText: 'Subject title',
            border: UnderlineInputBorder(),
          ),
          maxLines: 3,
          minLines: 1,
        );
      },
    );
  }
}

class _GroupDropdownInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectEditCubit, SubjectEditState>(
      buildWhen: (previous, current) => previous.groupIds != current.groupIds,
      builder: (context, state) {
        if (state.groupIds.isEmpty) {
          if (state.dataStatus == ExternalDataStatus.loading) {
            return const Center(child: Text('loading'));
          }
        }
        return DropdownButton<String>(
          hint: const Text('Choose group'),
          items: state.groupIds.map<DropdownMenuItem<String>>(
            (Group group) {
              return DropdownMenuItem<String>(
                value: group.id,
                child: Text(group.title),
              );
            },
          ).toList(),
          value: state.subject!.groupId,
          onChanged: null,
        );
      },
    );
  }
}
