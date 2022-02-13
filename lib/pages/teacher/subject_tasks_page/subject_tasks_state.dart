part of 'subject_tasks_cubit.dart';

@freezed
class SubjectTasksState with _$SubjectTasksState {
  const factory SubjectTasksState({
    @Default(ExternalDataStatus.loading) ExternalDataStatus dataStatus,
    @Default([]) List<Task> tasks,
    Subject? subject,
    String? errorMessage,
  }) = _SubjectTasksState;
}
