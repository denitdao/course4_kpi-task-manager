import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/auth/auth_required_state.dart';
import 'package:task_manager/core/injection/injection.dart';
import 'package:task_manager/pages/teacher/subjects_page/subject_list_cubit.dart';
import 'package:task_manager/widgets/drawer.dart';
import 'package:task_manager/widgets/subject_preview.dart';

class SubjectListPage extends StatefulWidget {
  const SubjectListPage({Key? key, this.groupId}) : super(key: key);

  final String? groupId;

  @override
  _SubjectListState createState() => _SubjectListState();
}

class _SubjectListState extends AuthRequiredState<SubjectListPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final groupId = widget.groupId;
        if (groupId != null) {
          return getIt<SubjectListCubit>()..loadDataForGroup(groupId);
        } else {
          return getIt<SubjectListCubit>()..loadDataForAllGroups();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Subjects'),
        ),
        body: const _SubjectList(),
        drawer: const AppDrawer(), // todo pass set of groups with actions
      ),
    );
  }
}

class _SubjectList extends StatelessWidget {
  const _SubjectList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectListCubit, SubjectListState>(
      builder: (context, state) {
        if (state.dataStatus == ExternalDataStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return ListView.separated(
          addAutomaticKeepAlives: false,
          itemCount: state.subjects.length,
          padding: const EdgeInsets.only(bottom: 80),
          itemBuilder: (context, index) {
            final item = state.subjects[index];
            return SubjectPreview(subject: item);
          },
          separatorBuilder: (context, index) => const Divider(
            height: 1,
            thickness: 1,
          ),
        );
      },
    );
  }
}
