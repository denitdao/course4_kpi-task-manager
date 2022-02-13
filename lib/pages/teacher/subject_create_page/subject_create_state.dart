part of 'subject_create_cubit.dart';

@freezed
class SubjectCreateState with _$SubjectCreateState {

  const factory SubjectCreateState.loaded({
    @Default(ExternalDataStatus.loading) ExternalDataStatus dataStatus,
    @Default([]) List<Group> groupIds,
    @Default(NonNullText.pure()) NonNullText groupId,
    @Default(NonEmptyText.pure()) NonEmptyText subjectTitle,
    @Default(FormzStatus.pure) FormzStatus status,
    String? errorMessage,
  }) = SubjectState;
}
