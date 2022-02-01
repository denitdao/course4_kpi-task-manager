part of 'register_teacher_cubit.dart';

@freezed
class RegisterTeacherState with _$RegisterTeacherState {

  const factory RegisterTeacherState.loaded({
    @Default(Name.pure()) Name firstName,
    @Default(Name.pure()) Name lastName,
    @Default(Email.pure()) Email email,
    @Default(Password.pure()) Password password,
    @Default(FormzStatus.pure) FormzStatus status,
    String? errorMessage,
  }) = TeacherState;
}
