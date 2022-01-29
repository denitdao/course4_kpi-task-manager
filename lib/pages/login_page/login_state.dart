part of 'login_cubit.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.loaded({
    @Default(Email.pure()) Email email,
    @Default(Password.pure()) Password password,
    @Default(FormzStatus.pure) FormzStatus status,
    String? errorMessage,
  }) = _LoginState;
}
