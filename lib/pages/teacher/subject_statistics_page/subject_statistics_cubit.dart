import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:task_manager/core/injection/injection.dart';
import 'package:task_manager/models/enums/external_data_status.dart';
import 'package:task_manager/models/subject.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/repositories/stats_repository.dart';
import 'package:task_manager/repositories/subject_repository.dart';
import 'package:task_manager/repositories/task_repository.dart';

part 'subject_statistics_cubit.freezed.dart';

part 'subject_statistics_state.dart';

@injectable
class SubjectStatisticsCubit extends Cubit<SubjectStatisticsState> {
  late TaskRepository _taskRepository;
  late SubjectRepository _subjectRepository;
  late StatsRepository _statsRepository;

  SubjectStatisticsCubit() : super(const SubjectStatisticsState.loaded()) {
    _taskRepository = getIt<TaskRepository>();
    _subjectRepository = getIt<SubjectRepository>();
    _statsRepository = getIt<StatsRepository>();
  }

  void loadData(String subjectId) async {
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

    final subjectCompletionRateResponse =
        await _statsRepository.getWeeklyCompletionRate(subjectId);
    if (subjectCompletionRateResponse.isRight) {
      _getWeeklyPerformance(subjectCompletionRateResponse.right);
    } else {
      emit(state.copyWith(
        errorMessage: subjectCompletionRateResponse.left,
        dataStatus: ExternalDataStatus.fail,
      ));
      return;
    }
    final tasksResponse = await _taskRepository.getAllTasksBySubject(subjectId);
    if (tasksResponse.isRight) {
      _getLastTaskPerformance(tasksResponse.right);
      emit(state.copyWith(
        dataStatus: ExternalDataStatus.success,
      ));
    } else {
      emit(state.copyWith(
        errorMessage: subjectCompletionRateResponse.left,
        dataStatus: ExternalDataStatus.fail,
      ));
      return;
    }
  }

  void _getWeeklyPerformance(List<dynamic> rawPerformance) {
    num totalCompleted = 0;
    rawPerformance.forEach((element) {
      totalCompleted += element['amount'] ?? 0;
    });

    List<dynamic> performanceList = [
      {'x': "Sun", 'y': 0},
      {'x': "Mon", 'y': 0},
      {'x': "Tue", 'y': 0},
      {'x': "Wed", 'y': 0},
      {'x': "Thu", 'y': 0},
      {'x': "Fri", 'y': 0},
      {'x': "Sat", 'y': 0},
    ];

    for (var item in rawPerformance) {
      performanceList[item['day_of_week']]['y'] =
          item['amount'] / totalCompleted;
    }

    emit(state.copyWith(weeklyPerformance: performanceList));
  }

  void _getLastTaskPerformance(List<Task> lastTasks) {
    lastTasks.sort((a, b) => b.dueDate.compareTo(a.dueDate));
    List<dynamic> taskList = lastTasks
        .take(4)
        .map((e) => {'x': e.title, 'y': e.completedBy / e.studentsOverall})
        .toList();

    emit(state.copyWith(lastTaskPerformance: taskList));
  }
}
