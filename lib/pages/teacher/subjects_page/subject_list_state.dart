part of 'subject_list_cubit.dart';

enum ExternalDataStatus { loading, success, fail }

@freezed
class SubjectListState with _$SubjectListState {
  const factory SubjectListState({
    @Default(ExternalDataStatus.loading) ExternalDataStatus dataStatus,
    @Default([]) List<Group> groups,
    @Default([]) List<Subject> subjects,
    String? errorMessage,
  }) = _SubjectListState;
}
