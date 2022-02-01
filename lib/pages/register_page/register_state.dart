part of 'register_cubit.dart';

enum RegisterTab { student, teacher }

@freezed
class RegisterState with _$RegisterState {

  const factory RegisterState.student({
    @Default(RegisterTab.student) RegisterTab tab,
  }) = StudentPage;

  const factory RegisterState.teacher({
    @Default(RegisterTab.teacher) RegisterTab tab,
  }) = TeacherPage;
}
