part of 'task_statistics_cubit.dart';

@freezed
class TaskStatisticsState with _$TaskStatisticsState {
  const factory TaskStatisticsState.loaded({
    @Default(ExternalDataStatus.loading) ExternalDataStatus dataStatus,
    Task? task,
    @Default([]) List<dynamic> taskPerformance,
    @Default([]) List<UserTaskStatus> userTaskStatuses,
    @Default(FormzStatus.pure) FormzStatus status,
    String? errorMessage,
  }) = TaskStatistics;
}
