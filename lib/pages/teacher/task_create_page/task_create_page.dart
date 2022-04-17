import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:task_manager/constants/supabase_constants.dart';
import 'package:task_manager/core/auth/teacher_auth_required_state.dart';
import 'package:task_manager/core/injection/injection.dart';
import 'package:task_manager/pages/teacher/task_create_page/task_create_cubit.dart';
import 'package:task_manager/widgets/date_picker.dart';


class TaskCreatePage extends StatefulWidget {
  const TaskCreatePage({Key? key, required this.subjectId}) : super(key: key);

  final String subjectId;

  @override
  _TaskCreatePageState createState() => _TaskCreatePageState();
}

class _TaskCreatePageState extends TeacherAuthRequiredState<TaskCreatePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TaskCreateCubit>()..loadSubject(widget.subjectId),
      child: _TaskCreateForm(),
    );
  }
}

class _TaskCreateForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskCreateCubit, TaskCreateState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          context.showErrorSnackBar(
              message: state.errorMessage ?? 'Could not save the task');
        } else if (state.status.isSubmissionSuccess) {
          Navigator.pop(context);
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            leading: _SaveTaskButton(),
            title: const Text('New Task'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TaskTitleInput(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
                  child: Text(
                    'Set Due Date',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                _TaskDueDateInput(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 24, 0, 12),
                  child: Text(
                    'Add Description',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: _TaskDescriptionInput(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SaveTaskButton extends StatelessWidget {
  void _saveTask(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<TaskCreateCubit>().createTask();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCreateCubit, TaskCreateState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () => _saveTask(context),
          icon: state.status.isValid && !state.status.isSubmissionInProgress
              ? const Icon(Icons.save)
              : const Opacity(opacity: 0.5, child: Icon(Icons.save)),
          tooltip: 'Save new task and navigate back',
        );
      },
    );
  }
}

class _TaskTitleInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCreateCubit, TaskCreateState>(
      buildWhen: (previous, current) => previous.taskTitle != current.taskTitle,
      builder: (context, state) {
        return TextFormField(
          onChanged: context.read<TaskCreateCubit>().onTaskTitleChange,
          keyboardType: TextInputType.text,
          style: Theme.of(context).textTheme.headline1,
          decoration: const InputDecoration.collapsed(
            hintText: 'Task title',
            border: UnderlineInputBorder(),
          ),
          maxLines: 3,
          minLines: 1,
        );
      },
    );
  }
}

class _TaskDescriptionInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCreateCubit, TaskCreateState>(
      buildWhen: (previous, current) =>
          previous.taskDescription != current.taskDescription,
      builder: (context, state) {
        return TextFormField(
          onChanged: context.read<TaskCreateCubit>().onTaskDescriptionChange,
          style: Theme.of(context).textTheme.bodyText1,
          decoration: InputDecoration(
            hintText: 'Description',
            filled: true,
            errorText: state.taskDescription.invalid ? 'empty description' : null,
            border: const OutlineInputBorder(),
          ),
          maxLines: 50,
          minLines: 5,
        );
      },
    );
  }
}

class _TaskDueDateInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCreateCubit, TaskCreateState>(
      buildWhen: (previous, current) => previous.dueDate != current.dueDate,
      builder: (context, state) {
        return FormDatePicker(
          date: state.dueDate.value,
          onChanged: context.read<TaskCreateCubit>().onTaskDueDateChange,
        );
      },
    );
  }
}
