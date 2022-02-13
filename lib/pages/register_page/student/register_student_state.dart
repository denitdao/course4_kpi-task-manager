part of 'register_student_cubit.dart';

@freezed
class RegisterStudentState with _$RegisterStudentState {

  const factory RegisterStudentState.loaded({
    @Default(ExternalDataStatus.loading) ExternalDataStatus dataStatus,
    @Default([]) List<Group> groupIds,
    @Default(NonNullText.pure()) NonNullText groupId,
    @Default(Name.pure()) Name firstName,
    @Default(Name.pure()) Name lastName,
    @Default(Email.pure()) Email email,
    @Default(Password.pure()) Password password,
    @Default(FormzStatus.pure) FormzStatus status,
    String? errorMessage,
  }) = StudentState;
}
