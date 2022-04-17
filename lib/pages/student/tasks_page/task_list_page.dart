import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/auth/student_auth_required_state.dart';
import 'package:task_manager/models/enums/external_data_status.dart';
import 'package:task_manager/pages/student/tasks_page/task_list_cubit.dart';
import 'package:task_manager/pages/student/widgets/drawer.dart';
import 'package:task_manager/pages/student/widgets/task_preview.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key, this.range, this.subjectId, this.pageTitle})
      : super(key: key);

  final int? range;
  final String? subjectId;
  final String? pageTitle;

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends StudentAuthRequiredState<TaskListPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return TaskListCubit()..loadData(widget.range, widget.subjectId);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.pageTitle ?? 'Tasks'),
        ),
        body: const _TaskList(),
        drawer: const StudentDrawer(),
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskListCubit, TaskListState>(
      buildWhen: (prev, curr) =>
          prev.tasks != curr.tasks || prev.dataStatus != curr.dataStatus,
      builder: (context, state) {
        if (state.dataStatus == ExternalDataStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.tasks.isEmpty) {
          return LayoutBuilder(
            builder: (context, constraints) => RefreshIndicator(
              onRefresh: () => context
                  .read<TaskListCubit>()
                  .loadData(state.range, state.subjectId),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    minWidth: constraints.maxWidth,
                  ),
                  child: const Center(child: Text("Empty")),
                ),
              ),
            ),
          );
        }
        var tasks = context.read<TaskListCubit>().getOrderedTasks();
        return RefreshIndicator(
          onRefresh: () => context
              .read<TaskListCubit>()
              .loadData(state.range, state.subjectId),
          child: ListView.separated(
            addAutomaticKeepAlives: false,
            itemCount: tasks.length,
            padding: const EdgeInsets.only(bottom: 80),
            itemBuilder: (context, index) {
              final item = tasks[index];
              return TaskPreviewStudent(task: item);
            },
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              thickness: 1,
            ),
          ),
        );
      },
    );
  }
}
