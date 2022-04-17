import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:task_manager/core/injection/injection.dart';
import 'package:task_manager/models/forms/email_input.dart';
import 'package:task_manager/models/forms/name_input.dart';
import 'package:task_manager/models/forms/password_input.dart';
import 'package:task_manager/repositories/auth_repository.dart';

part 'register_teacher_cubit.freezed.dart';
part 'register_teacher_state.dart';

@injectable
class RegisterTeacherCubit extends Cubit<RegisterTeacherState> {
  late AuthRepository _authRepository;

  RegisterTeacherCubit() : super(const RegisterTeacherState.loaded()) {
    _authRepository = getIt<AuthRepository>();
  }

  Future<void> signUp() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    final response = await _authRepository.signUpTeacher(
      state.email.value,
      state.password.value,
      state.firstName.value,
      state.lastName.value,
    );

    response.either(
      (left) => emit(state.copyWith(
        errorMessage: left,
        status: FormzStatus.submissionFailure,
      )),
      (right) => emit(state.copyWith(status: FormzStatus.submissionSuccess)),
    );
  }

  void onFirstNameChange(String value) {
    final firstName = Name.dirty(value);
    emit(state.copyWith(
      firstName: firstName,
      status: Formz.validate([
        firstName,
        state.lastName,
        state.email,
        state.password,
      ]),
    ));
  }

  void onLastNameChange(String value) {
    final lastName = Name.dirty(value);
    emit(state.copyWith(
      lastName: lastName,
      status: Formz.validate([
        state.firstName,
        lastName,
        state.email,
        state.password,
      ]),
    ));
  }

  void onEmailChange(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([
        state.firstName,
        state.lastName,
        email,
        state.password,
      ]),
    ));
  }

  void onPasswordChange(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([
        state.firstName,
        state.lastName,
        state.email,
        password,
      ]),
    ));
  }
}
