import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/constants/supabase_constants.dart';
import 'package:task_manager/core/injection/injection.dart';
import 'package:task_manager/models/enums/external_data_status.dart';
import 'package:task_manager/models/group.dart';
import 'package:task_manager/models/subject.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/repositories/group_repository.dart';
import 'package:task_manager/repositories/subject_repository.dart';
import 'package:task_manager/repositories/task_repository.dart';

part 'task_list_cubit.freezed.dart';

part 'task_list_state.dart';

@injectable
class TaskListCubit extends Cubit<TaskListState> {
  late TaskRepository _taskRepository;
  late SubjectRepository _subjectRepository;

  TaskListCubit() : super(const TaskListState()) {
    _taskRepository = getIt<TaskRepository>();
    _subjectRepository = getIt<SubjectRepository>();
  }

  Future<void> loadData(int? range, String? subjectId) async {
    if (subjectId == null) {
      _loadAllData();
    } else {
      _loadDataForSubject(subjectId);
    }
  }

  Future<void> _loadDataForSubject(String groupId) async {
    final subjectResponse =
        await _subjectRepository.getAllSubjectsByGroup(groupId);
    if (subjectResponse.isRight) {
      emit(state.copyWith(
        subjects: subjectResponse.right,
      ));
    } else {
      emit(state.copyWith(
        errorMessage: subjectResponse.left,
        dataStatus: ExternalDataStatus.fail,
      ));
      return;
    }

    _loadAllTasks();
  }

  Future<void> _loadAllData() async {
    final studentId = supabase.auth.currentUser!.id;
    final subjectResponse =
        await _subjectRepository.getAllSubjectsByStudent(studentId);
    if (subjectResponse.isRight) {
      emit(state.copyWith(
        subjects: subjectResponse.right,
      ));
    } else {
      emit(state.copyWith(
        errorMessage: subjectResponse.left,
        dataStatus: ExternalDataStatus.fail,
      ));
      return;
    }

    _loadAllTasks();
  }

  Future<void> _loadAllTasks() async {
    final studentId = supabase.auth.currentUser!.id;
    final taskResponse = await _taskRepository.getAllTasksByStudent(studentId); // todo
    if (taskResponse.isRight) {
      emit(state.copyWith(
        tasks: taskResponse.right,
        dataStatus: ExternalDataStatus.success,
      ));
    } else {
      emit(state.copyWith(
        errorMessage: taskResponse.left,
        dataStatus: ExternalDataStatus.fail,
      ));
    }
  }
}
