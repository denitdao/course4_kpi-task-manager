import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:task_manager/core/injection/injection.dart';
import 'package:task_manager/models/enums/external_data_status.dart';
import 'package:task_manager/models/forms/non_empty_date_input.dart';
import 'package:task_manager/models/forms/text_input.dart';
import 'package:task_manager/models/subject.dart';
import 'package:task_manager/repositories/subject_repository.dart';
import 'package:task_manager/repositories/task_repository.dart';

part 'task_create_cubit.freezed.dart';

part 'task_create_state.dart';

@injectable
class TaskCreateCubit extends Cubit<TaskCreateState> {
  late SubjectRepository _subjectRepository;
  late TaskRepository _taskRepository;

  TaskCreateCubit() : super(const TaskCreateState.loaded()) {
    _subjectRepository = getIt<SubjectRepository>();
    _taskRepository = getIt<TaskRepository>();
  }

  void loadSubject(String subjectId) async {
    final subjectResponse = await _subjectRepository.getSubjectById(subjectId);
    if (subjectResponse.isRight) {
      emit(state.copyWith(
        subject: subjectResponse.right,
        dataStatus: ExternalDataStatus.success,
      ));
    } else {
      emit(state.copyWith(
        errorMessage: subjectResponse.left,
        dataStatus: ExternalDataStatus.fail,
      ));
      return;
    }
  }

  Future<void> createTask() async {
    final taskTitle = state.taskTitle.value;
    if (!state.taskTitle.valid) {
      emit(state.copyWith(
        errorMessage: 'Specify a task title!',
        status: FormzStatus.submissionFailure,
      ));
      return;
    }
    final startDate = state.startDate.value;
    if (!state.startDate.valid) {
      emit(state.copyWith(
        errorMessage: 'Specify a start date!',
        status: FormzStatus.submissionFailure,
      ));
      return;
    }
    final dueDate = state.dueDate.value;
    if (!state.dueDate.valid) {
      emit(state.copyWith(
        errorMessage: 'Specify a due date!',
        status: FormzStatus.submissionFailure,
      ));
      return;
    }
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    final response = _taskRepository.createTask(
      state.subject!.id,
      taskTitle,
      state.taskDescription.value,
      startDate!,
      dueDate!,
    );

    response.either(
      (left) => emit(state.copyWith(
        errorMessage: left,
        status: FormzStatus.submissionFailure,
      )),
      (right) => emit(state.copyWith(status: FormzStatus.submissionSuccess)),
    );
  }

  void onTaskTitleChange(String value) {
    final taskTitle = NonEmptyText.dirty(value);
    emit(state.copyWith(
      taskTitle: taskTitle,
      status: Formz.validate(
          [taskTitle, state.taskDescription, state.startDate, state.dueDate]),
    ));
  }

  void onTaskDescriptionChange(String value) {
    final taskDescription = NonEmptyText.dirty(value);
    emit(state.copyWith(
      taskDescription: taskDescription,
      status: Formz.validate(
          [state.taskTitle, taskDescription, state.startDate, state.dueDate]),
    ));
  }

  void onTaskDateChange(DateTime start, DateTime end) {
    final startDate = NonNullDate.dirty(start);
    final dueDate = NonNullDate.dirty(end);
    emit(state.copyWith(
      startDate: startDate,
      dueDate: dueDate,
      status: Formz.validate(
          [state.taskTitle, state.taskDescription, startDate, dueDate]),
    ));
  }
}
