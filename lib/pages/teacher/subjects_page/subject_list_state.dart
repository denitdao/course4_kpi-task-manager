part of 'subject_list_cubit.dart';

@freezed
class SubjectListState with _$SubjectListState {
  const factory SubjectListState({
    @Default(ExternalDataStatus.loading) ExternalDataStatus dataStatus,
    @Default([]) List<Group> groups,
    @Default([]) List<Subject> subjects,
    String? groupId,
    String? errorMessage,
  }) = _SubjectListState;
}
