part of 'subject_edit_cubit.dart';

@freezed
class SubjectEditState with _$SubjectEditState {
  const factory SubjectEditState.loaded({
    @Default(ExternalDataStatus.loading) ExternalDataStatus dataStatus,
    @Default([]) List<Group> groupIds,
    Subject? subject,
    @Default(NonEmptyText.pure()) NonEmptyText subjectTitle,
    @Default(FormzStatus.pure) FormzStatus status,
    String? errorMessage,
  }) = SubjectState;
}
