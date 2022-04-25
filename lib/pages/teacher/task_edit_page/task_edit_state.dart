part of 'task_edit_cubit.dart';

@freezed
class TaskEditState with _$TaskEditState {
  const factory TaskEditState.loaded({
    @Default(ExternalDataStatus.loading) ExternalDataStatus dataStatus,
    Task? task,
    @Default(NonEmptyText.pure()) NonEmptyText taskTitle,
    @Default(NonEmptyText.pure()) NonEmptyText taskDescription,
    @Default(NonNullDate.pure()) NonNullDate dueDate,
    @Default(NonNullDate.pure()) NonNullDate startDate,
    @Default(FormzStatus.pure) FormzStatus status,
    String? errorMessage,
  }) = TaskState;
}
