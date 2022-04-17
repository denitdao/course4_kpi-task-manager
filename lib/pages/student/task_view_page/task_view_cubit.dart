import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:task_manager/constants/supabase_constants.dart';
import 'package:task_manager/core/injection/injection.dart';
import 'package:task_manager/models/enums/external_data_status.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/repositories/task_repository.dart';

part 'task_view_cubit.freezed.dart';
part 'task_view_state.dart';

@injectable
class TaskViewCubit extends Cubit<TaskViewState> {
  late TaskRepository _taskRepository;

  TaskViewCubit() : super(const TaskViewState()) {
    _taskRepository = getIt<TaskRepository>();
  }

  Future<void> loadData(String id) async {
    final taskResponse = await _taskRepository.getTaskById(id);

    taskResponse.either(
      (left) => emit(state.copyWith(
        errorMessage: left,
        dataStatus: ExternalDataStatus.fail,
        id: id,
      )),
      (right) => emit(state.copyWith(
        task: right,
        dataStatus: ExternalDataStatus.success,
        id: id,
      )),
    );
  }

  Future<void> changeTaskStatus(bool status) async {
    _emitTask(status);

    final studentId = supabase.auth.currentUser!.id;

    final taskResponse =
        await _taskRepository.updateTaskStatus(state.id!, studentId, status);
    taskResponse.either(
      (left) {
        emit(state.copyWith(errorMessage: left));
        _emitTask(!status);
      },
      (right) => null,
    );
  }

  void _emitTask(bool status) {
    var newTask = state.task!.copyWith(isDone: status);
    emit(state.copyWith(task: newTask));
  }
}
