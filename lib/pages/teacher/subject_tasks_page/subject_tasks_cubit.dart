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

part 'subject_tasks_cubit.freezed.dart';

part 'subject_tasks_state.dart';

@injectable
class SubjectTasksCubit extends Cubit<SubjectTasksState> {
  late TaskRepository _taskRepository;
  late SubjectRepository _subjectRepository;
  final String _subjectId;

  SubjectTasksCubit(this._subjectId) : super(const SubjectTasksState()) {
    _taskRepository = getIt<TaskRepository>();
    _subjectRepository = getIt<SubjectRepository>();
  }

  Future<void> loadData() async {
    final subjectResponse = await _subjectRepository.getSubjectById(_subjectId);
    if (subjectResponse.isRight) {
      emit(state.copyWith(
        subject: subjectResponse.right,
      ));
    } else {
      emit(state.copyWith(
        errorMessage: subjectResponse.left,
        dataStatus: ExternalDataStatus.fail,
      ));
      return;
    }

    final taskResponse = await _taskRepository.getAllTaskBySubject(_subjectId);
    if (subjectResponse.isRight) {
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
