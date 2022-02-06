part of 'subject_create_cubit.dart';

enum ExternalDataStatus { loading, success, fail }

@freezed
class SubjectCreateState with _$SubjectCreateState {

  const factory SubjectCreateState.loaded({
    @Default(ExternalDataStatus.loading) ExternalDataStatus dataStatus,
    @Default([]) List<Group> groupIds,
    @Default(NonEmptyText.pure()) NonEmptyText groupId,
    @Default(NonEmptyText.pure()) NonEmptyText subjectTitle,
    @Default(FormzStatus.pure) FormzStatus status,
    String? errorMessage,
  }) = SubjectState;
}
