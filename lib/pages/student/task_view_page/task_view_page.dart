import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/auth/student_auth_required_state.dart';
import 'package:task_manager/models/enums/external_data_status.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/pages/student/task_view_page/task_view_cubit.dart';
import 'package:task_manager/theme/light_color.dart';

class TaskViewPage extends StatefulWidget {
  const TaskViewPage({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<TaskViewPage> createState() => _TaskViewPageState();
}

class _TaskViewPageState extends StudentAuthRequiredState<TaskViewPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return TaskViewCubit()..loadData(widget.id);
      },
      child: _TaskViewForm(),
    );
  }
}

class _TaskViewForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskViewCubit, TaskViewState>(
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
              title: Text('Task - ' + state.task!.subjectTitle),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: state.task!.isDone,
                        onChanged: (bool? status) {
                          context
                              .read<TaskViewCubit>()
                              .changeTaskStatus(status ?? !state.task!.isDone);
                        },
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            state.task!.title,
                            style: Theme.of(context).textTheme.headline1,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                          ),
                        ),
                      )
                    ],
                  ),
                  /*Padding(
                    padding: const EdgeInsets.fromLTRB(0, 24, 0, 4),
                    child: Text(
                      'Subtasks',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: state.task!.isDone,
                        onChanged: (bool? status) {
                          context
                              .read<TaskViewCubit>()
                              .changeTaskStatus(status ?? !state.task!.isDone);
                        },
                      ),
                      Expanded(
                        child: Focus(
                          onFocusChange: (value) =>
                              print('focus change - ' + value.toString()),
                          child: TextFormField(
                            initialValue: state.task!.title,
                            decoration: const InputDecoration.collapsed(
                                hintText: 'subtask title'),
                            onChanged: null,
                          ),
                        ),
                      ),
                    ],
                  ),*/
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
                    child: Text(
                      'Deadline',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  OutlinedButton(
                    child: Text(
                        DateFormat('EEEE d/MM/y').format(state.task!.dueDate)),
                    onPressed: () => null,
                    style: OutlinedButton.styleFrom(
                      side: _isDateMissed(state.task!)
                          ? const BorderSide(color: LightColor.warn, width: 2)
                          : const BorderSide(
                              color: LightColor.shadedPrimary, width: 2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 24, 0, 12),
                    child: Text(
                      'Description',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: SelectableText(
                      state.task!.description,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isDateMissed(Task task) {
    DateTime now = DateTime.now();
    var taskDate = task.dueDate;

    if (task.isDone) return false;
    if (taskDate.difference(now).inDays == 0) return false;

    return taskDate.isBefore(now);
  }
}
