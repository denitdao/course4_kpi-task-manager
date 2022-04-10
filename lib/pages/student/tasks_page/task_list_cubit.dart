import 'package:bloc/bloc.dart';
import 'package:either_dart/src/either.dart';
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
    emit(state.copyWith(
      subjectId: subjectId,
      range: range,
    ));
    if (subjectId == null) {
      _loadAllTasks(range);
    } else {
      _loadTasksForSubject(subjectId);
    }
  }

  Future<void> _loadAllTasks(int? range) async {
    final studentId = supabase.auth.currentUser!.id;
    final Either<String, List<Task>> taskResponse;
    if (range == null) {
      taskResponse = await _taskRepository.getAllTasksByStudent(studentId);
    } else {
      taskResponse =
          await _taskRepository.getAllTasksByStudentInRange(studentId, range);
    }
    if (taskResponse.isRight) {
      emit(state.copyWith(
        tasks: taskResponse.right,
      ));
    } else {
      emit(state.copyWith(
        errorMessage: taskResponse.left,
        dataStatus: ExternalDataStatus.fail,
      ));
      return;
    }
    _loadSubjects();
  }

  Future<void> _loadTasksForSubject(String subjectId) async {
    final taskResponse = await _taskRepository.getAllTasksBySubject(subjectId);
    if (taskResponse.isRight) {
      emit(state.copyWith(
        tasks: taskResponse.right,
      ));
    } else {
      emit(state.copyWith(
        errorMessage: taskResponse.left,
        dataStatus: ExternalDataStatus.fail,
      ));
      return;
    }
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    final studentId = supabase.auth.currentUser!.id;
    final subjectResponse =
        await _subjectRepository.getAllSubjectsByStudent(studentId);
    if (subjectResponse.isRight) {
      emit(state.copyWith(
        subjects: subjectResponse.right,
        dataStatus: ExternalDataStatus.success,
      ));
    } else {
      emit(state.copyWith(
        errorMessage: subjectResponse.left,
        dataStatus: ExternalDataStatus.fail,
      ));
    }
  }
}
