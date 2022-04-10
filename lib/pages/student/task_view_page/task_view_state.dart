part of 'task_view_cubit.dart';

@freezed
class TaskViewState with _$TaskViewState {
  const factory TaskViewState({
    @Default(ExternalDataStatus.loading) ExternalDataStatus dataStatus,
    Task? task,
    String? id,
    String? errorMessage,
  }) = _TaskViewState;
}
