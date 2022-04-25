import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:task_manager/core/injection/injection.dart';
import 'package:task_manager/models/enums/external_data_status.dart';
import 'package:task_manager/models/forms/non_empty_date_input.dart';
import 'package:task_manager/models/forms/text_input.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/repositories/task_repository.dart';

part 'task_edit_cubit.freezed.dart';

part 'task_edit_state.dart';

@injectable
class TaskEditCubit extends Cubit<TaskEditState> {
  late TaskRepository _taskRepository;

  TaskEditCubit() : super(const TaskEditState.loaded()) {
    _taskRepository = getIt<TaskRepository>();
  }

  void loadData(String taskId) async {
    final taskResponse = await _taskRepository.getTaskById(taskId);
    if (taskResponse.isRight) {
      emit(state.copyWith(
        task: taskResponse.right,
        dataStatus: ExternalDataStatus.success,
      ));
      onTaskTitleChange(state.task!.title);
      onTaskDescriptionChange(state.task!.description);
      onTaskDateChange(state.task!.startDate, state.task!.dueDate);
    } else {
      emit(state.copyWith(
        errorMessage: taskResponse.left,
        dataStatus: ExternalDataStatus.fail,
      ));
      return;
    }
  }

  Future<void> updateTask() async {
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

    final updatedTask = state.task!.copyWith(
      title: taskTitle,
      description: state.taskDescription.value,
      dueDate: dueDate!,
      startDate: startDate!,
    );
    final response = _taskRepository.updateTask(updatedTask);

    response.either(
      (left) => emit(state.copyWith(
        errorMessage: left,
        status: FormzStatus.submissionFailure,
      )),
      (right) => emit(state.copyWith(status: FormzStatus.submissionSuccess)),
    );
  }

  Future<void> deleteTask() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    final response = _taskRepository.deleteTask(state.task!.id);

    response.either(
      (left) => emit(state.copyWith(
        errorMessage: left,
        // todo Replace in all places to the custom message
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
