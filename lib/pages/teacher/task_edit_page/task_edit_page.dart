import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:task_manager/constants/supabase_constants.dart';
import 'package:task_manager/core/auth/teacher_auth_required_state.dart';
import 'package:task_manager/core/injection/injection.dart';
import 'package:task_manager/models/enums/external_data_status.dart';
import 'package:task_manager/pages/teacher/task_edit_page/task_edit_cubit.dart';
import 'package:task_manager/pages/teacher/task_statistics_page/task_statistics_page.dart';
import 'package:task_manager/theme/light_color.dart';
import 'package:task_manager/widgets/date_picker.dart';

class TaskEditPage extends StatefulWidget {
  const TaskEditPage({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  _TaskEditPageState createState() => _TaskEditPageState();
}

class _TaskEditPageState extends TeacherAuthRequiredState<TaskEditPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TaskEditCubit>()..loadData(widget.id),
      child: _TaskEditForm(),
    );
  }
}

class _TaskEditForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskEditCubit, TaskEditState>(
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
              leading: _SaveTaskButton(),
              title: const Text('Edit Task'),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskStatisticsPage(
                          id: state.task!.id,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.bar_chart_rounded),
                  tooltip: 'Go to task statistics',
                ),
              ],
            ),
            floatingActionButton: _DeleteTaskButton(),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TaskTitleInput(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
                    child: Text(
                      'Set Date Range',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  _TaskDateInput(),
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
        );
      },
    );
  }
}

class _SaveTaskButton extends StatelessWidget {
  void _saveTask(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<TaskEditCubit>().updateTask();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskEditCubit, TaskEditState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () => _saveTask(context),
          icon: state.status.isValid && !state.status.isSubmissionInProgress
              ? const Icon(Icons.save)
              : const Opacity(opacity: 0.5, child: Icon(Icons.save)),
          tooltip: 'Save the task and navigate back',
        );
      },
    );
  }
}

class _DeleteTaskButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: context.read<TaskEditCubit>().deleteTask,
      child: const Text(
        'Delete',
        style: TextStyle(color: LightColor.warn),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(width: 1, color: LightColor.warn),
      ),
    );
  }
}

class _TaskTitleInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskEditCubit, TaskEditState>(
      buildWhen: (previous, current) => previous.taskTitle != current.taskTitle,
      builder: (context, state) {
        return TextFormField(
          onChanged: context.read<TaskEditCubit>().onTaskTitleChange,
          keyboardType: TextInputType.text,
          initialValue: state.taskTitle.value,
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
    return BlocBuilder<TaskEditCubit, TaskEditState>(
      buildWhen: (previous, current) =>
          previous.taskDescription != current.taskDescription,
      builder: (context, state) {
        return TextFormField(
          onChanged: context.read<TaskEditCubit>().onTaskDescriptionChange,
          style: Theme.of(context).textTheme.bodyText1,
          initialValue: state.taskDescription.value,
          decoration: InputDecoration(
            hintText: 'Description',
            filled: true,
            errorText:
                state.taskDescription.invalid ? 'empty description' : null,
            border: const OutlineInputBorder(),
          ),
          maxLines: 50,
          minLines: 5,
        );
      },
    );
  }
}

class _TaskDateInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskEditCubit, TaskEditState>(
      buildWhen: (previous, current) =>
          previous.dueDate != current.dueDate ||
          previous.startDate != current.startDate,
      builder: (context, state) {
        return FormDateRangePicker(
          start: state.startDate.value,
          end: state.dueDate.value,
          onChanged: context.read<TaskEditCubit>().onTaskDateChange,
        );
      },
    );
  }
}
