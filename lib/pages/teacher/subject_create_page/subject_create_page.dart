import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:task_manager/constants/supabase_constants.dart';
import 'package:task_manager/core/auth/auth_required_state.dart';
import 'package:task_manager/core/injection/injection.dart';
import 'package:task_manager/models/group.dart';
import 'package:task_manager/pages/teacher/subject_create_page/subject_create_cubit.dart';
import 'package:task_manager/theme/light_color.dart';

class SubjectCreatePage extends StatefulWidget {
  const SubjectCreatePage({Key? key}) : super(key: key);

  @override
  _SubjectCreatePageState createState() => _SubjectCreatePageState();
}

class _SubjectCreatePageState extends AuthRequiredState<SubjectCreatePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SubjectCreateCubit>()..loadGroups(),
      child: _SubjectCreateForm(),
    );
  }
}

class _SubjectCreateForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SubjectCreateCubit, SubjectCreateState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          context.showErrorSnackBar(
              message: state.errorMessage ?? 'Could not save the subject');
        } else if (state.status.isSubmissionSuccess) {
          Navigator.pop(context);
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            leading: _SaveSubjectButton(),
            title: const Text('New Subject'),
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
      ),
    );
  }
}

class _SaveSubjectButton extends StatelessWidget {
  void _saveSubject(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<SubjectCreateCubit>().createSubject();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectCreateCubit, SubjectCreateState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () => _saveSubject(context),
          icon: state.status.isValid && !state.status.isSubmissionInProgress
              ? const Icon(Icons.save)
              : const Opacity(opacity: 0.5, child: Icon(Icons.save)),
          tooltip: 'Save new subject and navigate back',
        );
      },
    );
  }
}

class _SubjectTitleInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectCreateCubit, SubjectCreateState>(
      buildWhen: (previous, current) =>
          previous.subjectTitle != current.subjectTitle,
      builder: (context, state) {
        return TextFormField(
          onChanged: context.read<SubjectCreateCubit>().onSubjectTitleChange,
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
    return BlocBuilder<SubjectCreateCubit, SubjectCreateState>(
      buildWhen: (previous, current) =>
          previous.groupIds != current.groupIds ||
          previous.groupId != current.groupId,
      builder: (context, state) {
        if (state.groupIds.isEmpty) {
          if (state.dataStatus == ExternalDataStatus.loading) {
            return const Center(child: Text('loading'));
          }
        }
        return DropdownButton<String>(
          hint: Text(
            'Choose group',
            style: state.groupId.valid
                ? const TextStyle()
                : const TextStyle(color: LightColor.warn),
          ),
          items: state.groupIds.map<DropdownMenuItem<String>>(
            (Group group) {
              return DropdownMenuItem<String>(
                value: group.id,
                child: Text(group.title),
              );
            },
          ).toList(),
          value: state.groupId.value,
          onChanged: context.read<SubjectCreateCubit>().onGroupChange,
        );
      },
    );
  }
}
