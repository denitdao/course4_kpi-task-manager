import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:task_manager/core/injection/injection.dart';
import 'package:task_manager/models/enums/external_data_status.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/models/user_task_status.dart';
import 'package:task_manager/repositories/stats_repository.dart';
import 'package:task_manager/repositories/task_repository.dart';

part 'task_statistics_cubit.freezed.dart';

part 'task_statistics_state.dart';

@injectable
class TaskStatisticsCubit extends Cubit<TaskStatisticsState> {
  late TaskRepository _taskRepository;
  late StatsRepository _statsRepository;

  TaskStatisticsCubit() : super(const TaskStatisticsState.loaded()) {
    _taskRepository = getIt<TaskRepository>();
    _statsRepository = getIt<StatsRepository>();
  }

  void loadData(String taskId) async {
    final taskResponse = await _taskRepository.getTaskById(taskId);
    if (taskResponse.isRight) {
      emit(state.copyWith(
        task: taskResponse.right,
        dataStatus: ExternalDataStatus.success,
      ));
    } else {
      emit(state.copyWith(
        errorMessage: taskResponse.left,
        dataStatus: ExternalDataStatus.fail,
      ));
      return;
    }

    final studentTaskStatusResponse =
        await _statsRepository.getStudentsWithTaskStatus(taskId);
    if (studentTaskStatusResponse.isRight) {
      emit(state.copyWith(
        userTaskStatuses: studentTaskStatusResponse.right,
        dataStatus: ExternalDataStatus.success,
      ));
    } else {
      emit(state.copyWith(
        errorMessage: studentTaskStatusResponse.left,
        dataStatus: ExternalDataStatus.fail,
      ));
      return;
    }
    _getPerformanceDate();
  }

  void _getPerformanceDate() {
    int studentNumber = state.userTaskStatuses.length;

    var completionDates = state.userTaskStatuses
        .where((element) => element.isDone)
        .map((e) => e.updatedAt)
        .toList()
      ..sort();

    List<dynamic> completionMap = [];
    if (completionDates.isNotEmpty) {
      if (state.task!.startDate.isBefore(completionDates.first!)) {
        completionMap.add({
          'x': state.task!.startDate.toLocal(),
          'y': 0,
        });
      }
    } else {
      completionMap.add({
        'x': state.task!.startDate.toLocal(),
        'y': 0,
      });
    }
    completionDates.forEachIndexed((index, date) {
      completionMap.add({
        'x': date!.toLocal(),
        'y': (index + 1) / studentNumber,
      });
    });

    emit(state.copyWith(taskPerformance: completionMap));
  }
}
