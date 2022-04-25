part of 'task_create_cubit.dart';

@freezed
class TaskCreateState with _$TaskCreateState {
  const factory TaskCreateState.loaded({
    @Default(ExternalDataStatus.loading) ExternalDataStatus dataStatus,
    Subject? subject,
    @Default(NonEmptyText.pure()) NonEmptyText taskTitle,
    @Default(NonEmptyText.pure()) NonEmptyText taskDescription,
    @Default(NonNullDate.pure()) NonNullDate dueDate,
    @Default(NonNullDate.pure()) NonNullDate startDate,
    @Default(FormzStatus.pure) FormzStatus status,
    String? errorMessage,
  }) = TaskState;
}
