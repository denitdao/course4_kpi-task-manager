part of 'task_list_cubit.dart';

@freezed
class TaskListState with _$TaskListState {
  const factory TaskListState({
    @Default(ExternalDataStatus.loading) ExternalDataStatus dataStatus,
    @Default([]) List<Task> tasks,
    @Default([]) List<Subject> subjects,
    int? range,
    String? subjectId,
    String? errorMessage,
  }) = _TaskListState;
}
