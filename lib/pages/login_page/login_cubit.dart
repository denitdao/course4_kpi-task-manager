import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:task_manager/core/injection/injection.dart';
import 'package:task_manager/models/forms/email_input.dart';
import 'package:task_manager/models/forms/password_input.dart';
import 'package:task_manager/repositories/auth_repository.dart';

part 'login_cubit.freezed.dart';
part 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  late AuthRepository _authRepository;

  LoginCubit() : super(const LoginState.loaded()) {
    _authRepository = getIt<AuthRepository>();
  }

  Future<void> signIn() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    final response =
        await _authRepository.signIn(state.email.value, state.password.value);

    response.either(
      (left) => emit(state.copyWith(
        errorMessage: left,
        status: FormzStatus.submissionFailure,
      )),
      (right) => emit(state.copyWith(status: FormzStatus.submissionSuccess)),
    );
  }

  void googleSignIn() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    await _authRepository.signInWithGoogle();
    emit(state.copyWith(status: FormzStatus.submissionSuccess));
  }

  void onEmailChange(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email, state.password]),
    ));
  }

  void onPasswordChange(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([state.email, password]),
    ));
  }
}
