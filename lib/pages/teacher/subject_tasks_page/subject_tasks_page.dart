import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/auth/teacher_auth_required_state.dart';
import 'package:task_manager/models/enums/external_data_status.dart';
import 'package:task_manager/pages/teacher/subject_statistics_page/subject_statistics_page.dart';
import 'package:task_manager/pages/teacher/subject_tasks_page/subject_tasks_cubit.dart';
import 'package:task_manager/pages/teacher/task_create_page/task_create_page.dart';
import 'package:task_manager/pages/teacher/widgets/task_preview.dart';

class SubjectTasksPage extends StatefulWidget {
  const SubjectTasksPage({Key? key, required this.subjectId}) : super(key: key);

  final String subjectId;

  @override
  _SubjectTasksPageState createState() => _SubjectTasksPageState();
}

class _SubjectTasksPageState
    extends TeacherAuthRequiredState<SubjectTasksPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return SubjectTasksCubit(widget.subjectId)..loadData();
      },
      child: const _SubjectTasksPage(),
    );
  }
}

class _SubjectTasksPage extends StatelessWidget {
  const _SubjectTasksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectTasksCubit, SubjectTasksState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: state.subject == null
                ? const Text('Loading')
                : Text('${state.subject!.title} Tasks'),
            actions: [
              IconButton(
                onPressed: state.subject == null ? null : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubjectStatisticsPage(
                        id: state.subject!.id,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.bar_chart_rounded),
                tooltip: 'Go to subject statistics',
              ),
            ],
          ),
          body: const _TaskList(),
          floatingActionButton: const _TaskAddButton(),
        );
      },
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectTasksCubit, SubjectTasksState>(
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
              onRefresh: context.read<SubjectTasksCubit>().loadData,
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
        return RefreshIndicator(
          onRefresh: context.read<SubjectTasksCubit>().loadData,
          child: ListView.separated(
            addAutomaticKeepAlives: false,
            itemCount: state.tasks.length,
            padding: const EdgeInsets.only(bottom: 80),
            itemBuilder: (context, index) {
              final item = state.tasks[index];
              return TaskPreviewTeacher(task: item);
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

class _TaskAddButton extends StatelessWidget {
  const _TaskAddButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectTasksCubit, SubjectTasksState>(
      builder: (context, state) {
        return FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TaskCreatePage(subjectId: state.subject!.id),
              ),
            );
          },
          child: const Icon(Icons.add),
        );
      },
    );
  }
}
