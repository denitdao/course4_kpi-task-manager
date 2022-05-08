part of 'subject_statistics_cubit.dart';

@freezed
class SubjectStatisticsState with _$SubjectStatisticsState {
  const factory SubjectStatisticsState.loaded({
    @Default(ExternalDataStatus.loading) ExternalDataStatus dataStatus,
    Subject? subject,
    @Default([]) List<dynamic> weeklyPerformance,
    @Default([]) List<dynamic> lastTaskPerformance,
    @Default(FormzStatus.pure) FormzStatus status,
    String? errorMessage,
  }) = SubjectStatistics;
}
